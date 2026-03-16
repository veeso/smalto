//// Regex-based tokenizer engine for syntax highlighting.
////
//// Implements a tokenization algorithm faithful to Prism.js: for each rule
//// in grammar order, scan all untokenized text fragments for matches. Greedy
//// rules match against the original full source text to prevent false matches
//// inside strings or comments. Supports nested tokenization via inline
//// grammars or language references.

import gleam/list
import gleam/option.{type Option, None, Some}
import smalto/grammar.{type Inside, type Rule, InlineGrammar, LanguageRef}
import smalto/internal/regex
import smalto/token.{type Token}

/// A compiled rule with its regex pre-compiled.
type CompiledRule {
  CompiledRule(
    token: String,
    regex: regex.Regex,
    greedy: Bool,
    inside: Option(Inside),
  )
}

/// A node in the tokenization fragment list.
type Node {
  /// Untokenized text with its byte position in the original source.
  TextNode(text: String, byte_start: Int, byte_len: Int)
  /// Already-tokenized content resolved to final tokens.
  TokenNode(List(Token))
}

/// Tokenize source code using pre-resolved rules and a language lookup
/// for cross-language nested tokenization.
///
/// The `lookup` function is called when a rule has a `LanguageRef` inside
/// field, returning the grammar for the referenced language.
pub fn tokenize(
  source: String,
  rules: List(Rule),
  lookup: fn(String) -> List(Rule),
) -> List(Token) {
  let compiled = compile_rules(rules)
  let source_len = regex.byte_length(source)
  let nodes = [TextNode(source, 0, source_len)]
  let final_nodes = match_grammar(source, nodes, compiled, lookup)
  flatten_nodes(final_nodes)
  |> collapse_adjacent
}

/// Map a token name string to the corresponding Token variant.
pub fn map_token_name(name: String, value: String) -> Token {
  case name {
    "keyword" -> token.Keyword(value)
    "string" -> token.String(value)
    "number" -> token.Number(value)
    "comment" -> token.Comment(value)
    "function" -> token.Function(value)
    "operator" -> token.Operator(value)
    "punctuation" -> token.Punctuation(value)
    "type" -> token.Type(value)
    "module" -> token.Module(value)
    "variable" -> token.Variable(value)
    "constant" -> token.Constant(value)
    "builtin" -> token.Builtin(value)
    "tag" -> token.Tag(value)
    "attribute" -> token.Attribute(value)
    "selector" -> token.Selector(value)
    "property" -> token.Property(value)
    "regex" -> token.Regex(value)
    unknown -> token.Custom(unknown, value)
  }
}

// -- Rule compilation --

/// Compile grammar rules into regex patterns, silently skipping
/// rules whose patterns fail to compile.
fn compile_rules(rules: List(Rule)) -> List(CompiledRule) {
  list.filter_map(rules, fn(r) {
    case regex.compile(r.pattern) {
      Ok(compiled) ->
        Ok(CompiledRule(
          token: r.token,
          regex: compiled,
          greedy: r.greedy,
          inside: r.inside,
        ))
      Error(_) -> Error(Nil)
    }
  })
}

// -- Core algorithm --

/// Apply all rules in order to the node list (Prism.js algorithm).
/// Each rule scans all text nodes for matches.
fn match_grammar(
  original: String,
  nodes: List(Node),
  rules: List(CompiledRule),
  lookup: fn(String) -> List(Rule),
) -> List(Node) {
  list.fold(rules, nodes, fn(current_nodes, rule) {
    apply_rule(original, current_nodes, rule, lookup)
  })
}

/// Apply a single rule to all text nodes in the fragment list.
fn apply_rule(
  original: String,
  nodes: List(Node),
  rule: CompiledRule,
  lookup: fn(String) -> List(Rule),
) -> List(Node) {
  apply_rule_loop(original, nodes, rule, lookup, [])
}

fn apply_rule_loop(
  original: String,
  nodes: List(Node),
  rule: CompiledRule,
  lookup: fn(String) -> List(Rule),
  acc: List(Node),
) -> List(Node) {
  case nodes {
    [] -> list.reverse(acc)
    [TokenNode(_) as node, ..rest] ->
      apply_rule_loop(original, rest, rule, lookup, [node, ..acc])
    [TextNode(text, start, len), ..rest] ->
      case rule.greedy {
        True ->
          apply_greedy(original, text, start, len, rest, rule, lookup, acc)
        False ->
          apply_non_greedy(original, text, start, len, rest, rule, lookup, acc)
      }
  }
}

// -- Non-greedy matching --

/// Try to match a non-greedy rule against a single text node.
fn apply_non_greedy(
  original: String,
  text: String,
  start: Int,
  len: Int,
  rest: List(Node),
  rule: CompiledRule,
  lookup: fn(String) -> List(Rule),
  acc: List(Node),
) -> List(Node) {
  case regex.find(rule.regex, text, 0) {
    Error(_) ->
      apply_rule_loop(original, rest, rule, lookup, [
        TextNode(text, start, len),
        ..acc
      ])
    Ok(#(rel_start, matched)) -> {
      let match_byte_len = regex.byte_length(matched)
      // Guard against empty matches to prevent infinite loops
      case match_byte_len {
        0 ->
          apply_rule_loop(original, rest, rule, lookup, [
            TextNode(text, start, len),
            ..acc
          ])
        _ -> {
          // Build before node
          let acc = case rel_start > 0 {
            True -> {
              let before_text = regex.byte_slice(text, 0, rel_start)
              [TextNode(before_text, start, rel_start), ..acc]
            }
            False -> acc
          }

          // Build token node
          let inner_tokens =
            resolve_inside(matched, rule.token, rule.inside, lookup)
          let acc = [TokenNode(inner_tokens), ..acc]

          // Build after node and continue processing it
          let after_rel_start = rel_start + match_byte_len
          let after_len = len - after_rel_start
          let remaining = case after_len > 0 {
            True -> {
              let after_text =
                regex.byte_slice(text, after_rel_start, after_len)
              [TextNode(after_text, start + after_rel_start, after_len), ..rest]
            }
            False -> rest
          }
          apply_rule_loop(original, remaining, rule, lookup, acc)
        }
      }
    }
  }
}

// -- Greedy matching --

/// Try to match a greedy rule against the original text at the current
/// text node's position.
fn apply_greedy(
  original: String,
  text: String,
  start: Int,
  len: Int,
  rest: List(Node),
  rule: CompiledRule,
  lookup: fn(String) -> List(Rule),
  acc: List(Node),
) -> List(Node) {
  case regex.find(rule.regex, original, start) {
    Error(_) ->
      // No match in remaining text - done with this rule for all remaining nodes
      list.append(list.reverse([TextNode(text, start, len), ..acc]), rest)
    Ok(#(match_start, matched)) -> {
      let match_byte_len = regex.byte_length(matched)
      let match_end = match_start + match_byte_len
      let node_end = start + len

      case match_byte_len == 0 {
        // Skip empty matches
        True ->
          apply_rule_loop(original, rest, rule, lookup, [
            TextNode(text, start, len),
            ..acc
          ])
        False ->
          case match_start >= node_end {
            // Match is beyond this text node - skip to next node
            True ->
              apply_rule_loop(original, rest, rule, lookup, [
                TextNode(text, start, len),
                ..acc
              ])
            False -> {
              // Match starts within this text node
              // Build before node
              let new_acc = case match_start > start {
                True -> {
                  let before_len = match_start - start
                  let before_text =
                    regex.byte_slice(original, start, before_len)
                  [TextNode(before_text, start, before_len), ..acc]
                }
                False -> acc
              }

              case match_end <= node_end {
                // Match fits within this text node
                True -> {
                  let inner_tokens =
                    resolve_inside(matched, rule.token, rule.inside, lookup)
                  let new_acc = [TokenNode(inner_tokens), ..new_acc]

                  let after_len = node_end - match_end
                  let remaining = case after_len > 0 {
                    True -> {
                      let after_text =
                        regex.byte_slice(original, match_end, after_len)
                      [TextNode(after_text, match_end, after_len), ..rest]
                    }
                    False -> rest
                  }
                  apply_rule_loop(original, remaining, rule, lookup, new_acc)
                }
                // Match spans beyond this text node into subsequent nodes
                False -> {
                  let #(ok, after_nodes) = walk_greedy_span(rest, match_end)
                  case ok {
                    True -> {
                      let inner_tokens =
                        resolve_inside(matched, rule.token, rule.inside, lookup)
                      let new_acc = [TokenNode(inner_tokens), ..new_acc]
                      apply_rule_loop(
                        original,
                        after_nodes,
                        rule,
                        lookup,
                        new_acc,
                      )
                    }
                    // Match spans into an already-tokenized node at start - skip
                    False ->
                      apply_rule_loop(original, rest, rule, lookup, [
                        TextNode(text, start, len),
                        ..acc
                      ])
                  }
                }
              }
            }
          }
      }
    }
  }
}

/// Walk forward through nodes to find where a greedy match ends.
/// Returns `#(True, remaining_nodes)` if the span is valid (no token
/// node at the match start boundary), or `#(False, original_nodes)` if
/// the match should be skipped.
fn walk_greedy_span(nodes: List(Node), match_end: Int) -> #(Bool, List(Node)) {
  case nodes {
    [] -> #(True, [])
    [TokenNode(_), ..rest] ->
      // Greedy match spans through a token node — overwrite it.
      // In Prism.js this triggers a rematch; we accept the overwrite.
      walk_greedy_span(rest, match_end)
    [TextNode(text, node_start, node_len), ..rest] -> {
      let node_end = node_start + node_len
      case match_end <= node_start {
        // Match ended before this text node (within a skipped TokenNode).
        // Keep this text node intact as remaining content.
        True -> #(True, [TextNode(text, node_start, node_len), ..rest])
        False ->
          case match_end <= node_end {
            True -> {
              // Match ends within this text node
              let after_len = node_end - match_end
              let after_nodes = case after_len > 0 {
                True -> {
                  let after_text =
                    regex.byte_slice(text, match_end - node_start, after_len)
                  [TextNode(after_text, match_end, after_len), ..rest]
                }
                False -> rest
              }
              #(True, after_nodes)
            }
            False ->
              // Match spans past this text node
              walk_greedy_span(rest, match_end)
          }
      }
    }
  }
}

// -- Inside resolution --

/// Resolve the `inside` field of a matched rule to produce tokens.
fn resolve_inside(
  matched_text: String,
  token_name: String,
  inside: Option(Inside),
  lookup: fn(String) -> List(Rule),
) -> List(Token) {
  case inside {
    None -> [map_token_name(token_name, matched_text)]
    Some(InlineGrammar(rules)) -> tokenize(matched_text, rules, lookup)
    Some(LanguageRef(lang)) -> {
      let lang_rules = lookup(lang)
      tokenize(matched_text, lang_rules, lookup)
    }
  }
}

// -- Output flattening --

/// Convert the fragment list into a flat list of tokens.
fn flatten_nodes(nodes: List(Node)) -> List(Token) {
  list.flat_map(nodes, fn(node) {
    case node {
      TextNode(text, _, _) ->
        case text {
          "" -> []
          _ -> [token.Other(text)]
        }
      TokenNode(tokens) -> tokens
    }
  })
}

/// Collapse consecutive Other tokens and consecutive Whitespace tokens.
fn collapse_adjacent(tokens: List(Token)) -> List(Token) {
  collapse_loop(tokens, [])
  |> list.reverse
}

fn collapse_loop(tokens: List(Token), acc: List(Token)) -> List(Token) {
  case tokens {
    [] -> acc
    [tok, ..rest] ->
      case tok, acc {
        token.Other(v), [token.Other(prev), ..acc_rest] ->
          collapse_loop(rest, [token.Other(prev <> v), ..acc_rest])
        token.Whitespace(v), [token.Whitespace(prev), ..acc_rest] ->
          collapse_loop(rest, [token.Whitespace(prev <> v), ..acc_rest])
        _, _ -> collapse_loop(rest, [tok, ..acc])
      }
  }
}

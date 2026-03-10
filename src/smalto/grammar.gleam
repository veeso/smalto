//// Grammar and rule types for defining syntax highlighting grammars.
////
//// A `Grammar` describes how to tokenize a particular language using an
//// ordered list of regex-based `Rule` values. Grammars can extend other
//// grammars via single inheritance, where child rules take priority over
//// parent rules.
////
//// Rules may contain nested grammars via the `Inside` type, either as
//// inline sub-grammars or references to other languages. This follows
//// the Prism.js grammar model where `inside` is used for recursive
//// tokenization of matched regions.

import gleam/list
import gleam/option.{type Option, None, Some}

/// Specifies how a rule's matched text should be recursively tokenized.
pub type Inside {
  /// An inline grammar: a list of rules applied directly to the matched text.
  /// This is the most common form in Prism.js grammars.
  InlineGrammar(List(Rule))
  /// A reference to another language's grammar, resolved at tokenization
  /// time via a lookup function.
  LanguageRef(String)
}

/// A single pattern rule within a grammar.
///
/// - `token`: the token name (e.g. `"keyword"`, `"string"`), mapped to a
///   `Token` variant by the engine.
/// - `pattern`: a PCRE regex pattern string.
/// - `greedy`: when `True`, the pattern matches against the original full
///   source text rather than individual text fragments, preventing false
///   matches inside strings or comments.
/// - `inside`: optional nested grammar for recursive tokenization of the
///   matched text.
pub type Rule {
  Rule(token: String, pattern: String, greedy: Bool, inside: Option(Inside))
}

/// A language grammar definition.
///
/// - `name`: the language name (e.g. `"python"`, `"javascript"`).
/// - `extends`: optional parent language name; child rules override parent
///   rules with the same token name.
/// - `rules`: ordered list of rules, tried first-to-last during tokenization.
pub type Grammar {
  Grammar(name: String, extends: Option(String), rules: List(Rule))
}

/// Resolve a grammar's inheritance chain into a flat list of rules.
///
/// If the grammar extends a parent, the parent is resolved recursively via
/// `lookup`, and the two rule lists are merged: child rules come first, and
/// any parent rule whose token name matches a child rule is removed.
pub fn resolve(grammar: Grammar, lookup: fn(String) -> Grammar) -> List(Rule) {
  case grammar.extends {
    None -> grammar.rules
    Some(parent_name) -> {
      let parent = lookup(parent_name)
      let parent_rules = resolve(parent, lookup)
      let child_tokens = list.map(grammar.rules, fn(r) { r.token })
      let filtered_parent_rules =
        list.filter(parent_rules, fn(r) {
          !list.contains(child_tokens, r.token)
        })
      list.append(grammar.rules, filtered_parent_rules)
    }
  }
}

/// Create a rule with `greedy` set to `False` and no nested tokenization.
pub fn rule(token: String, pattern: String) -> Rule {
  Rule(token: token, pattern: pattern, greedy: False, inside: None)
}

/// Create a greedy rule with no nested tokenization.
///
/// Greedy rules match against the original full source text rather than
/// individual text fragments, preventing false matches inside previously
/// matched regions such as strings or comments.
pub fn greedy_rule(token: String, pattern: String) -> Rule {
  Rule(token: token, pattern: pattern, greedy: True, inside: None)
}

/// Create a rule with an inline grammar for recursive tokenization.
///
/// The matched text is re-tokenized using the provided rules.
pub fn rule_with_inside(
  token: String,
  pattern: String,
  inside: List(Rule),
) -> Rule {
  Rule(
    token: token,
    pattern: pattern,
    greedy: False,
    inside: Some(InlineGrammar(inside)),
  )
}

/// Create a greedy rule with an inline grammar for recursive tokenization.
pub fn greedy_rule_with_inside(
  token: String,
  pattern: String,
  inside: List(Rule),
) -> Rule {
  Rule(
    token: token,
    pattern: pattern,
    greedy: True,
    inside: Some(InlineGrammar(inside)),
  )
}

/// Create a rule with a language reference for cross-language tokenization.
///
/// The matched text is re-tokenized using the grammar identified by the
/// language name, resolved via the engine's lookup function.
pub fn nested_rule(token: String, pattern: String, language: String) -> Rule {
  Rule(
    token: token,
    pattern: pattern,
    greedy: False,
    inside: Some(LanguageRef(language)),
  )
}

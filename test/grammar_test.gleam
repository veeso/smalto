import gleam/option.{None, Some}
import gleeunit/should
import smalto/grammar.{InlineGrammar, LanguageRef}

pub fn rule_creates_non_greedy_rule_test() {
  let r = grammar.rule("keyword", "\\bif\\b")

  r
  |> should.equal(grammar.Rule(
    token: "keyword",
    pattern: "\\bif\\b",
    greedy: False,
    inside: None,
  ))
}

pub fn greedy_rule_creates_greedy_rule_test() {
  let r = grammar.greedy_rule("string", "\"[^\"]*\"")

  r
  |> should.equal(grammar.Rule(
    token: "string",
    pattern: "\"[^\"]*\"",
    greedy: True,
    inside: None,
  ))
}

pub fn nested_rule_creates_rule_with_inside_test() {
  let r = grammar.nested_rule("markup", "<[^>]+>", "html")

  r
  |> should.equal(grammar.Rule(
    token: "markup",
    pattern: "<[^>]+>",
    greedy: False,
    inside: Some(LanguageRef("html")),
  ))
}

pub fn rule_with_inside_creates_non_greedy_rule_with_inline_grammar_test() {
  let inner = [grammar.rule("variable", "\\$\\w+")]
  let r = grammar.rule_with_inside("string", "\"[^\"]*\"", inner)

  r
  |> should.equal(grammar.Rule(
    token: "string",
    pattern: "\"[^\"]*\"",
    greedy: False,
    inside: Some(InlineGrammar(inner)),
  ))
}

pub fn greedy_rule_with_inside_creates_greedy_rule_with_inline_grammar_test() {
  let inner = [grammar.rule("variable", "\\$\\w+")]
  let r = grammar.greedy_rule_with_inside("string", "\"[^\"]*\"", inner)

  r
  |> should.equal(grammar.Rule(
    token: "string",
    pattern: "\"[^\"]*\"",
    greedy: True,
    inside: Some(InlineGrammar(inner)),
  ))
}

pub fn resolve_returns_own_rules_when_no_extends_test() {
  let rules = [
    grammar.rule("keyword", "\\bif\\b"),
    grammar.rule("number", "\\d+"),
  ]
  let g = grammar.Grammar("test", None, rules)
  let lookup = fn(_name) { grammar.Grammar("unused", None, []) }

  grammar.resolve(g, lookup)
  |> should.equal(rules)
}

pub fn resolve_merges_parent_rules_test() {
  let parent_rules = [
    grammar.rule("keyword", "\\bif\\b"),
    grammar.rule("number", "\\d+"),
  ]
  let parent = grammar.Grammar("parent", None, parent_rules)

  let child_rules = [grammar.rule("string", "\"[^\"]*\"")]
  let child = grammar.Grammar("child", Some("parent"), child_rules)

  let lookup = fn(_name) { parent }

  grammar.resolve(child, lookup)
  |> should.equal([
    grammar.rule("string", "\"[^\"]*\""),
    grammar.rule("keyword", "\\bif\\b"),
    grammar.rule("number", "\\d+"),
  ])
}

pub fn resolve_child_overrides_parent_same_token_test() {
  let parent_rules = [
    grammar.rule("keyword", "\\bif\\b"),
    grammar.rule("number", "\\d+"),
  ]
  let parent = grammar.Grammar("parent", None, parent_rules)

  let child_rules = [grammar.rule("keyword", "\\bif\\b|\\belse\\b")]
  let child = grammar.Grammar("child", Some("parent"), child_rules)

  let lookup = fn(_name) { parent }

  grammar.resolve(child, lookup)
  |> should.equal([
    grammar.rule("keyword", "\\bif\\b|\\belse\\b"),
    grammar.rule("number", "\\d+"),
  ])
}

pub fn resolve_recursive_inheritance_test() {
  let grandparent_rules = [
    grammar.rule("comment", "//.*"),
    grammar.rule("number", "\\d+"),
  ]
  let grandparent = grammar.Grammar("grandparent", None, grandparent_rules)

  let parent_rules = [grammar.rule("keyword", "\\bif\\b")]
  let parent = grammar.Grammar("parent", Some("grandparent"), parent_rules)

  let child_rules = [grammar.rule("string", "\"[^\"]*\"")]
  let child = grammar.Grammar("child", Some("parent"), child_rules)

  let lookup = fn(name) {
    case name {
      "grandparent" -> grandparent
      "parent" -> parent
      _ -> grammar.Grammar("unknown", None, [])
    }
  }

  grammar.resolve(child, lookup)
  |> should.equal([
    grammar.rule("string", "\"[^\"]*\""),
    grammar.rule("keyword", "\\bif\\b"),
    grammar.rule("comment", "//.*"),
    grammar.rule("number", "\\d+"),
  ])
}

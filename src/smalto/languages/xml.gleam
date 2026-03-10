import gleam/option
import smalto/grammar.{type Grammar, type Rule, Grammar}

pub fn grammar() -> Grammar {
  Grammar(name: "xml", extends: option.None, rules: rules())
}

fn rules() -> List(Rule) {
  [
    grammar.greedy_rule("comment", "<!--(?:(?!<!--)[\\s\\S])*?-->"),
    grammar.greedy_rule("prolog", "<\\?[\\s\\S]+?\\?>"),
    grammar.greedy_rule_with_inside(
      "doctype",
      "(?i)<!DOCTYPE(?:[^>\"'[\\]]|\"[^\"]*\"|'[^']*')+(?:\\[(?:[^<\"'\\]]|\"[^\"]*\"|'[^']*'|<(?!!--)|<!--(?:[^-]|-(?!->))*-->)*\\]\\s*)?>",
      [
        grammar.greedy_rule_with_inside(
          "internal-subset",
          "(?<=^[^\\[]*\\[)[\\s\\S]+(?=\\]>$)",
          [
            grammar.greedy_rule("cdata", "(?i)<!\\[CDATA\\[[\\s\\S]*?\\]\\]>"),
            grammar.greedy_rule_with_inside(
              "tag",
              "<\\/?(?!\\d)[^\\s>\\/=$<%]+(?:\\s(?:\\s*[^\\s>\\/=]+(?:\\s*=\\s*(?:\"[^\"]*\"|'[^']*'|[^\\s'\">=]+(?=[\\s>]))|(?=[\\s/>])))+)?\\s*\\/?>",
              [
                grammar.rule_with_inside("tag", "^<\\/?[^\\s>\\/]+", [
                  grammar.rule("punctuation", "^<\\/?"),
                  grammar.rule("namespace", "^[^\\s>\\/:]+:"),
                ]),
                grammar.rule_with_inside(
                  "attr-value",
                  "=\\s*(?:\"[^\"]*\"|'[^']*'|[^\\s'\">=]+)",
                  [
                    grammar.rule("attr-equals", "^="),
                    grammar.rule("punctuation", "^(?<=\\s*)[\"']|[\"']$"),
                    grammar.rule("named-entity", "(?i)&[\\da-z]{1,8};"),
                    grammar.rule("entity", "(?i)&#x?[\\da-f]{1,8};"),
                  ],
                ),
                grammar.rule("punctuation", "\\/?>"),
                grammar.rule_with_inside("attr-name", "[^\\s>\\/]+", [
                  grammar.rule("namespace", "^[^\\s>\\/:]+:"),
                ]),
              ],
            ),
            grammar.rule("entity", "(?i)&#x?[\\da-f]{1,8};"),
          ],
        ),
        grammar.greedy_rule("string", "\"[^\"]*\"|'[^']*'"),
        grammar.rule("punctuation", "^<!|>$|[[\\]]"),
        grammar.rule("doctype-tag", "(?i)^DOCTYPE"),
        grammar.rule("name", "[^\\s<>'\"]+"),
      ],
    ),
    grammar.rule("entity", "(?i)&#x?[\\da-f]{1,8};"),
  ]
}

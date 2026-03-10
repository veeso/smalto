import gleam/string
import gleeunit
import gleeunit/should
import lustre/attribute
import lustre/element
import lustre/element/html
import smalto/lustre as smalto_lustre
import smalto/token

pub fn main() {
  gleeunit.main()
}

pub fn to_lustre_whitespace_renders_as_text_test() {
  let tokens = [token.Whitespace(" "), token.Whitespace("\n")]
  let result = smalto_lustre.to_lustre(tokens, smalto_lustre.default_config())
  result
  |> elements_to_string
  |> should.equal(" \n")
}

pub fn to_lustre_other_renders_as_text_test() {
  let tokens = [token.Other("hello")]
  let result = smalto_lustre.to_lustre(tokens, smalto_lustre.default_config())
  result
  |> elements_to_string
  |> should.equal("hello")
}

pub fn to_lustre_keyword_default_config_test() {
  let tokens = [token.Keyword("let")]
  let result = smalto_lustre.to_lustre(tokens, smalto_lustre.default_config())
  result
  |> elements_to_string
  |> should.equal("<span style=\"color:#b8860b;\">let</span>")
}

pub fn to_lustre_string_default_config_test() {
  let tokens = [token.String("\"hello\"")]
  let result = smalto_lustre.to_lustre(tokens, smalto_lustre.default_config())
  result
  |> elements_to_string
  |> should.equal(
    "<span style=\"color:#008000;\">&quot;hello&quot;</span>",
  )
}

pub fn to_lustre_number_default_config_test() {
  let tokens = [token.Number("42")]
  let result = smalto_lustre.to_lustre(tokens, smalto_lustre.default_config())
  result
  |> elements_to_string
  |> should.equal("<span style=\"color:#008000;\">42</span>")
}

pub fn to_lustre_comment_default_config_test() {
  let tokens = [token.Comment("// note")]
  let result = smalto_lustre.to_lustre(tokens, smalto_lustre.default_config())
  result
  |> elements_to_string
  |> should.equal(
    "<span style=\"color:#808080;;font-style:italic;\">// note</span>",
  )
}

pub fn to_lustre_function_default_config_test() {
  let tokens = [token.Function("main")]
  let result = smalto_lustre.to_lustre(tokens, smalto_lustre.default_config())
  result
  |> elements_to_string
  |> should.equal("<span style=\"color:#0000ff;\">main</span>")
}

pub fn to_lustre_operator_default_config_test() {
  let tokens = [token.Operator("+")]
  let result = smalto_lustre.to_lustre(tokens, smalto_lustre.default_config())
  result
  |> elements_to_string
  |> should.equal("<span style=\"color:#800080;\">+</span>")
}

pub fn to_lustre_punctuation_default_config_test() {
  let tokens = [token.Punctuation("(")]
  let result = smalto_lustre.to_lustre(tokens, smalto_lustre.default_config())
  result
  |> elements_to_string
  |> should.equal("(")
}

pub fn to_lustre_type_default_config_test() {
  let tokens = [token.Type("Int")]
  let result = smalto_lustre.to_lustre(tokens, smalto_lustre.default_config())
  result
  |> elements_to_string
  |> should.equal("<span style=\"color:#008b8b;\">Int</span>")
}

pub fn to_lustre_module_default_config_test() {
  let tokens = [token.Module("gleam")]
  let result = smalto_lustre.to_lustre(tokens, smalto_lustre.default_config())
  result
  |> elements_to_string
  |> should.equal("<span style=\"color:#008b8b;\">gleam</span>")
}

pub fn to_lustre_variable_default_config_test() {
  let tokens = [token.Variable("x")]
  let result = smalto_lustre.to_lustre(tokens, smalto_lustre.default_config())
  result
  |> elements_to_string
  |> should.equal("<span style=\"color:#ffd700;\">x</span>")
}

pub fn to_lustre_constant_default_config_test() {
  let tokens = [token.Constant("TRUE")]
  let result = smalto_lustre.to_lustre(tokens, smalto_lustre.default_config())
  result
  |> elements_to_string
  |> should.equal("<span style=\"color:#ff00ff;\">TRUE</span>")
}

pub fn to_lustre_builtin_default_config_test() {
  let tokens = [token.Builtin("print")]
  let result = smalto_lustre.to_lustre(tokens, smalto_lustre.default_config())
  result
  |> elements_to_string
  |> should.equal("<span style=\"color:#1e90ff;\">print</span>")
}

pub fn to_lustre_tag_default_config_test() {
  let tokens = [token.Tag("div")]
  let result = smalto_lustre.to_lustre(tokens, smalto_lustre.default_config())
  result
  |> elements_to_string
  |> should.equal("<span style=\"color:#ff0000;\">div</span>")
}

pub fn to_lustre_attribute_default_config_test() {
  let tokens = [token.Attribute("class")]
  let result = smalto_lustre.to_lustre(tokens, smalto_lustre.default_config())
  result
  |> elements_to_string
  |> should.equal("<span style=\"color:#b8860b;\">class</span>")
}

pub fn to_lustre_selector_default_config_test() {
  let tokens = [token.Selector(".foo")]
  let result = smalto_lustre.to_lustre(tokens, smalto_lustre.default_config())
  result
  |> elements_to_string
  |> should.equal("<span style=\"color:#008b8b;\">.foo</span>")
}

pub fn to_lustre_property_default_config_test() {
  let tokens = [token.Property("color")]
  let result = smalto_lustre.to_lustre(tokens, smalto_lustre.default_config())
  result
  |> elements_to_string
  |> should.equal("<span style=\"color:#b8860b;\">color</span>")
}

pub fn to_lustre_regex_default_config_test() {
  let tokens = [token.Regex("/abc/")]
  let result = smalto_lustre.to_lustre(tokens, smalto_lustre.default_config())
  result
  |> elements_to_string
  |> should.equal("<span style=\"color:#008000;\">/abc/</span>")
}

pub fn to_lustre_custom_default_config_test() {
  let tokens = [token.Custom("special", "val")]
  let result = smalto_lustre.to_lustre(tokens, smalto_lustre.default_config())
  result
  |> elements_to_string
  |> should.equal("val")
}

pub fn to_lustre_mixed_tokens_test() {
  let tokens = [
    token.Keyword("let"),
    token.Whitespace(" "),
    token.Variable("x"),
    token.Whitespace(" "),
    token.Operator("="),
    token.Whitespace(" "),
    token.Number("42"),
  ]
  let result = smalto_lustre.to_lustre(tokens, smalto_lustre.default_config())
  result
  |> elements_to_string
  |> should.equal(
    "<span style=\"color:#b8860b;\">let</span>"
    <> " "
    <> "<span style=\"color:#ffd700;\">x</span>"
    <> " "
    <> "<span style=\"color:#800080;\">=</span>"
    <> " "
    <> "<span style=\"color:#008000;\">42</span>",
  )
}

pub fn to_lustre_empty_tokens_test() {
  let result = smalto_lustre.to_lustre([], smalto_lustre.default_config())
  result
  |> should.equal([])
}

pub fn with_keyword_overrides_config_test() {
  let config =
    smalto_lustre.default_config()
    |> smalto_lustre.keyword(fn(value) {
      html.strong([], [element.text(value)])
    })
  let tokens = [token.Keyword("let")]
  let result = smalto_lustre.to_lustre(tokens, config)
  result
  |> elements_to_string
  |> should.equal("<strong>let</strong>")
}

pub fn with_string_overrides_config_test() {
  let config =
    smalto_lustre.default_config()
    |> smalto_lustre.string(fn(value) {
      html.em([], [element.text(value)])
    })
  let tokens = [token.String("hi")]
  let result = smalto_lustre.to_lustre(tokens, config)
  result
  |> elements_to_string
  |> should.equal("<em>hi</em>")
}

pub fn with_custom_overrides_config_test() {
  let config =
    smalto_lustre.default_config()
    |> smalto_lustre.custom(fn(name, value) {
      html.span([attribute.class("custom-" <> name)], [element.text(value)])
    })
  let tokens = [token.Custom("decorator", "@app")]
  let result = smalto_lustre.to_lustre(tokens, config)
  result
  |> elements_to_string
  |> should.equal("<span class=\"custom-decorator\">@app</span>")
}

pub fn with_type_overrides_config_test() {
  let config =
    smalto_lustre.default_config()
    |> smalto_lustre.type_(fn(value) {
      html.span([attribute.class("type")], [element.text(value)])
    })
  let tokens = [token.Type("String")]
  let result = smalto_lustre.to_lustre(tokens, config)
  result
  |> elements_to_string
  |> should.equal("<span class=\"type\">String</span>")
}

pub fn with_comment_overrides_config_test() {
  let config =
    smalto_lustre.default_config()
    |> smalto_lustre.comment(fn(value) {
      html.span([attribute.class("comment")], [element.text(value)])
    })
  let tokens = [token.Comment("// hi")]
  let result = smalto_lustre.to_lustre(tokens, config)
  result
  |> elements_to_string
  |> should.equal("<span class=\"comment\">// hi</span>")
}

pub fn chained_with_builders_test() {
  let config =
    smalto_lustre.default_config()
    |> smalto_lustre.keyword(fn(v) {
      html.span([attribute.class("kw")], [element.text(v)])
    })
    |> smalto_lustre.number(fn(v) {
      html.span([attribute.class("num")], [element.text(v)])
    })
  let tokens = [token.Keyword("fn"), token.Whitespace(" "), token.Number("1")]
  let result = smalto_lustre.to_lustre(tokens, config)
  result
  |> elements_to_string
  |> should.equal(
    "<span class=\"kw\">fn</span> <span class=\"num\">1</span>",
  )
}

/// Convert a list of Lustre elements to an HTML string, stripping the
/// `<!-- lustre:fragment -->` wrapper that `element.to_string` adds.
fn elements_to_string(elements: List(element.Element(msg))) -> String {
  elements
  |> element.fragment
  |> element.to_string
  |> string.replace("<!-- lustre:fragment -->", "")
  |> string.replace("<!-- /lustre:fragment -->", "")
}

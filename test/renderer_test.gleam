import gleam/string as gleam_string
import gleeunit/should
import smalto/internal/renderer
import smalto/token.{
  Attribute, Builtin, Comment, Constant, Custom, Function, Keyword, Module,
  Number, Operator, Other, Property, Punctuation, Regex, Selector, String, Tag,
  Type, Variable, Whitespace,
}

// --- HTML renderer tests ---

pub fn html_keyword_wrapped_in_span_test() {
  renderer.to_html([Keyword("if")])
  |> should.equal("<span class=\"hl-keyword\">if</span>")
}

pub fn html_whitespace_not_wrapped_test() {
  renderer.to_html([Whitespace(" ")])
  |> should.equal(" ")
}

pub fn html_other_not_wrapped_test() {
  renderer.to_html([Other("xyz")])
  |> should.equal("xyz")
}

pub fn html_escapes_special_chars_test() {
  renderer.to_html([Other("<script>")])
  |> should.equal("&lt;script&gt;")
}

pub fn html_escapes_inside_spans_test() {
  renderer.to_html([Keyword("<if>")])
  |> should.equal("<span class=\"hl-keyword\">&lt;if&gt;</span>")
}

pub fn html_custom_token_uses_name_test() {
  renderer.to_html([Custom("decorator", "@app")])
  |> should.equal("<span class=\"hl-decorator\">@app</span>")
}

pub fn html_multiple_tokens_test() {
  renderer.to_html([Keyword("if"), Whitespace(" "), String("\"hello\"")])
  |> should.equal(
    "<span class=\"hl-keyword\">if</span> <span class=\"hl-string\">&quot;hello&quot;</span>",
  )
}

pub fn html_empty_tokens_test() {
  renderer.to_html([])
  |> should.equal("")
}

// --- ANSI renderer tests ---

pub fn ansi_whitespace_no_color_test() {
  renderer.to_ansi([Whitespace(" ")])
  |> should.equal(" ")
}

pub fn ansi_other_no_color_test() {
  renderer.to_ansi([Other("xyz")])
  |> should.equal("xyz")
}

pub fn ansi_keyword_has_color_test() {
  let result = renderer.to_ansi([Keyword("if")])
  // Keyword should have ANSI color codes, so it must NOT equal plain "if"
  case result == "if" {
    True -> should.fail()
    False -> Nil
  }
}

pub fn ansi_empty_tokens_test() {
  renderer.to_ansi([])
  |> should.equal("")
}

pub fn ansi_string_has_color_test() {
  let result = renderer.to_ansi([String("hello")])
  { result != "hello" }
  |> should.be_true
}

pub fn ansi_number_has_color_test() {
  let result = renderer.to_ansi([Number("42")])
  { result != "42" }
  |> should.be_true
}

pub fn ansi_function_has_color_test() {
  let result = renderer.to_ansi([Function("main")])
  { result != "main" }
  |> should.be_true
}

pub fn ansi_comment_has_color_test() {
  let result = renderer.to_ansi([Comment("// x")])
  { result != "// x" }
  |> should.be_true
}

pub fn ansi_operator_has_color_test() {
  let result = renderer.to_ansi([Operator("+")])
  { result != "+" }
  |> should.be_true
}

pub fn ansi_type_has_color_test() {
  let result = renderer.to_ansi([Type("Int")])
  { result != "Int" }
  |> should.be_true
}

pub fn ansi_module_has_color_test() {
  let result = renderer.to_ansi([Module("gleam")])
  { result != "gleam" }
  |> should.be_true
}

pub fn ansi_tag_has_color_test() {
  let result = renderer.to_ansi([Tag("div")])
  { result != "div" }
  |> should.be_true
}

pub fn ansi_builtin_has_color_test() {
  let result = renderer.to_ansi([Builtin("print")])
  { result != "print" }
  |> should.be_true
}

pub fn ansi_attribute_has_color_test() {
  let result = renderer.to_ansi([Attribute("id")])
  { result != "id" }
  |> should.be_true
}

pub fn ansi_property_has_color_test() {
  let result = renderer.to_ansi([Property("color")])
  { result != "color" }
  |> should.be_true
}

pub fn ansi_selector_has_color_test() {
  let result = renderer.to_ansi([Selector(".btn")])
  { result != ".btn" }
  |> should.be_true
}

pub fn ansi_regex_has_color_test() {
  let result = renderer.to_ansi([Regex("/x/")])
  { result != "/x/" }
  |> should.be_true
}

pub fn ansi_constant_has_color_test() {
  let result = renderer.to_ansi([Constant("PI")])
  { result != "PI" }
  |> should.be_true
}

pub fn ansi_variable_has_color_test() {
  let result = renderer.to_ansi([Variable("x")])
  { result != "x" }
  |> should.be_true
}

pub fn ansi_punctuation_no_color_test() {
  renderer.to_ansi([Punctuation(";")])
  |> should.equal(";")
}

pub fn ansi_custom_no_color_test() {
  renderer.to_ansi([Custom("deco", "@x")])
  |> should.equal("@x")
}

pub fn ansi_multiple_tokens_test() {
  let result = renderer.to_ansi([Keyword("if"), Other(" "), Number("42")])
  // Should contain the text fragments with ANSI codes mixed in
  { gleam_string.contains(result, "if") }
  |> should.be_true
  { gleam_string.contains(result, "42") }
  |> should.be_true
}

// --- HTML renderer: all token types ---

pub fn html_string_wrapped_test() {
  renderer.to_html([String("hi")])
  |> should.equal("<span class=\"hl-string\">hi</span>")
}

pub fn html_number_wrapped_test() {
  renderer.to_html([Number("42")])
  |> should.equal("<span class=\"hl-number\">42</span>")
}

pub fn html_comment_wrapped_test() {
  renderer.to_html([Comment("// x")])
  |> should.equal("<span class=\"hl-comment\">// x</span>")
}

pub fn html_function_wrapped_test() {
  renderer.to_html([Function("main")])
  |> should.equal("<span class=\"hl-function\">main</span>")
}

pub fn html_operator_wrapped_test() {
  renderer.to_html([Operator("+")])
  |> should.equal("<span class=\"hl-operator\">+</span>")
}

pub fn html_punctuation_wrapped_test() {
  renderer.to_html([Punctuation(";")])
  |> should.equal("<span class=\"hl-punctuation\">;</span>")
}

pub fn html_type_wrapped_test() {
  renderer.to_html([Type("Int")])
  |> should.equal("<span class=\"hl-type\">Int</span>")
}

pub fn html_module_wrapped_test() {
  renderer.to_html([Module("gleam")])
  |> should.equal("<span class=\"hl-module\">gleam</span>")
}

pub fn html_variable_wrapped_test() {
  renderer.to_html([Variable("x")])
  |> should.equal("<span class=\"hl-variable\">x</span>")
}

pub fn html_constant_wrapped_test() {
  renderer.to_html([Constant("PI")])
  |> should.equal("<span class=\"hl-constant\">PI</span>")
}

pub fn html_builtin_wrapped_test() {
  renderer.to_html([Builtin("print")])
  |> should.equal("<span class=\"hl-builtin\">print</span>")
}

pub fn html_tag_wrapped_test() {
  renderer.to_html([Tag("div")])
  |> should.equal("<span class=\"hl-tag\">div</span>")
}

pub fn html_attribute_wrapped_test() {
  renderer.to_html([Attribute("id")])
  |> should.equal("<span class=\"hl-attribute\">id</span>")
}

pub fn html_selector_wrapped_test() {
  renderer.to_html([Selector(".btn")])
  |> should.equal("<span class=\"hl-selector\">.btn</span>")
}

pub fn html_property_wrapped_test() {
  renderer.to_html([Property("color")])
  |> should.equal("<span class=\"hl-property\">color</span>")
}

pub fn html_regex_wrapped_test() {
  renderer.to_html([Regex("/x/")])
  |> should.equal("<span class=\"hl-regex\">/x/</span>")
}

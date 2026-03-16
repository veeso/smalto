import gleam/list
import gleam/string
import gleeunit
import gleeunit/should
import lustre/element
import smalto/lustre as smalto_lustre
import smalto/lustre/themes
import smalto/token.{Comment, Keyword, Number, Other, Whitespace}

pub fn main() {
  gleeunit.main()
}

fn test_tokens() -> List(token.Token) {
  [
    Keyword("let"),
    Whitespace(" "),
    Other("x"),
    Whitespace(" "),
    token.Operator("="),
    Whitespace(" "),
    Number("42"),
    Whitespace(" "),
    Comment("// hello"),
  ]
}

fn elements_to_string(elements) -> String {
  element.fragment(elements)
  |> element.to_string()
  |> string.replace("<!-- lustre:fragment -->", "")
  |> string.replace("<!-- /lustre:fragment -->", "")
}

fn assert_theme_renders(config) {
  let elements = smalto_lustre.to_lustre(test_tokens(), config)
  let html = elements_to_string(elements)
  // Should produce non-empty HTML
  should.be_true(string.length(html) > 0)
  // Should contain styled spans
  should.be_true(string.contains(html, "<span"))
  // Should contain the literal values
  should.be_true(string.contains(html, "let"))
  should.be_true(string.contains(html, "42"))
}

pub fn dracula_theme_test() {
  themes.dracula() |> assert_theme_renders()
}

pub fn nord_theme_test() {
  themes.nord() |> assert_theme_renders()
}

pub fn default_theme_test() {
  themes.default() |> assert_theme_renders()
}

pub fn one_dark_theme_test() {
  themes.one_dark() |> assert_theme_renders()
}

pub fn gruvbox_dark_theme_test() {
  themes.gruvbox_dark() |> assert_theme_renders()
}

pub fn all_themes_compile_test() {
  // Call every theme function to verify they all return valid configs
  let configs = [
    themes.a11y_dark(),
    themes.atom_dark(),
    themes.base16_ateliersulphurpool_light(),
    themes.cb(),
    themes.coldark_cold(),
    themes.coldark_dark(),
    themes.coy(),
    themes.coy_without_shadows(),
    themes.darcula(),
    themes.dark(),
    themes.default(),
    themes.dracula(),
    themes.duotone_dark(),
    themes.duotone_earth(),
    themes.duotone_forest(),
    themes.duotone_light(),
    themes.duotone_sea(),
    themes.duotone_space(),
    themes.funky(),
    themes.ghcolors(),
    themes.gruvbox_dark(),
    themes.gruvbox_light(),
    themes.holi_theme(),
    themes.hopscotch(),
    themes.laserwave(),
    themes.lucario(),
    themes.material_dark(),
    themes.material_light(),
    themes.material_oceanic(),
    themes.night_owl(),
    themes.nord(),
    themes.okaidia(),
    themes.one_dark(),
    themes.one_light(),
    themes.pojoaque(),
    themes.shades_of_purple(),
    themes.solarized_dark_atom(),
    themes.solarizedlight(),
    themes.synthwave84(),
    themes.tomorrow(),
    themes.twilight(),
    themes.vs(),
    themes.vsc_dark_plus(),
    themes.xonokai(),
    themes.z_touch(),
  ]

  // Render tokens with each theme to verify no crashes
  list.each(configs, fn(config) {
    let elements = smalto_lustre.to_lustre(test_tokens(), config)
    should.be_true(elements != [])
  })
}

pub fn dracula_keyword_color_test() {
  let config = themes.dracula()
  let elements = smalto_lustre.to_lustre([Keyword("fn")], config)
  let html = elements_to_string(elements)
  // Dracula keyword color is #8be9fd
  should.be_true(string.contains(html, "#8be9fd"))
}

pub fn dracula_comment_no_italic_test() {
  // Dracula CSS does NOT set font-style on comments
  let config = themes.dracula()
  let elements = smalto_lustre.to_lustre([Comment("// note")], config)
  let html = elements_to_string(elements)
  should.be_true(string.contains(html, "#6272a4"))
  should.be_false(string.contains(html, "italic"))
}

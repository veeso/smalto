//// Example: render syntax-highlighted source code to an HTML file using Lustre
//// elements and a pre-built theme from smalto_lustre_themes.
////
//// Usage: gleam run -m lustre_html_render -- <source_file> <theme> <output_file>
////
//// Reads the given source file, detects the language from its extension,
//// tokenizes it with Smalto, converts tokens to Lustre elements using the
//// chosen theme, and writes a self-contained HTML document via
//// `lustre/element.to_document_string`.
////
//// The corresponding CSS theme from `../themes/` is embedded in the page to
//// provide the base text color, background, and font styling. Lustre inline
//// styles from `smalto_lustre_themes` override per-token colors on top.

import argv
import gleam/dict
import gleam/io
import gleam/list
import gleam/result
import gleam/string
import lustre/attribute
import lustre/element
import lustre/element/html
import simplifile
import smalto
import smalto/grammar.{type Grammar}
import smalto/languages/bash
import smalto/languages/c
import smalto/languages/cpp
import smalto/languages/css
import smalto/languages/dart
import smalto/languages/dockerfile
import smalto/languages/elixir
import smalto/languages/erlang
import smalto/languages/gleam
import smalto/languages/go
import smalto/languages/haskell
import smalto/languages/html as html_lang
import smalto/languages/java
import smalto/languages/javascript
import smalto/languages/json
import smalto/languages/kotlin
import smalto/languages/lua
import smalto/languages/markdown
import smalto/languages/php
import smalto/languages/python
import smalto/languages/ruby
import smalto/languages/rust
import smalto/languages/scala
import smalto/languages/sql
import smalto/languages/swift
import smalto/languages/toml
import smalto/languages/typescript
import smalto/languages/xml
import smalto/languages/yaml
import smalto/languages/zig
import smalto/lustre as smalto_lustre
import smalto/lustre/themes

pub fn main() -> Nil {
  let args = argv.load()
  case args.arguments {
    [source_path, theme_name, output_path] ->
      render(source_path, theme_name, output_path)
    _ ->
      io.println(
        "Usage: gleam run -m lustre_html_render -- <source_file> <theme> <output_file>"
        <> "\n\nAvailable themes: "
        <> available_themes(),
      )
  }
}

fn render(source_path: String, theme_name: String, output_path: String) -> Nil {
  let extension = get_extension(source_path)
  case dict.get(extension_map(), extension) {
    Error(_) ->
      io.println(
        "Unsupported file extension: ."
        <> extension
        <> "\nSupported: "
        <> supported_extensions(),
      )
    Ok(grammar) ->
      case dict.get(theme_map(), theme_name) {
        Error(_) ->
          io.println(
            "Unknown theme: '"
            <> theme_name
            <> "'\nAvailable: "
            <> available_themes(),
          )
        Ok(config) -> {
          // Load the matching CSS theme for base styling (text color,
          // background, font). The Lustre inline styles override per-token.
          let theme_css_path =
            "../themes/smalto-" <> theme_name <> ".css"
          let theme_css =
            simplifile.read(theme_css_path)
            |> result.unwrap("")
          case simplifile.read(source_path) {
            Error(_) ->
              io.println("Error: could not read file " <> source_path)
            Ok(source) -> {
              let tokens = smalto.to_tokens(source, grammar)
              let elements = smalto_lustre.to_lustre(tokens, config)
              let document =
                build_document(source_path, theme_css, elements)
              let html_string = element.to_document_string(document)
              case simplifile.write(output_path, html_string) {
                Ok(_) -> io.println("Written HTML to " <> output_path)
                Error(_) ->
                  io.println("Error: could not write to " <> output_path)
              }
            }
          }
        }
      }
  }
}

fn build_document(
  title: String,
  theme_css: String,
  highlighted: List(element.Element(msg)),
) -> element.Element(msg) {
  html.html([attribute.lang("en")], [
    html.head([], [
      html.meta([attribute.charset("UTF-8")]),
      html.meta([
        attribute.name("viewport"),
        attribute.content("width=device-width, initial-scale=1.0"),
      ]),
      html.title([], title <> " — Smalto"),
      // Embed the CSS theme for base text color, background, and font
      html.style([], theme_css),
      html.style([], layout_css()),
    ]),
    html.body([], [
      html.pre([attribute.class("smalto")], [html.code([], highlighted)]),
    ]),
  ])
}

fn layout_css() -> String {
  string.join(
    [
      "body {",
      "  margin: 0;",
      "  padding: 1rem;",
      "}",
    ],
    "\n",
  )
}

fn get_extension(path: String) -> String {
  path
  |> string.split(".")
  |> list.last
  |> fn(result) {
    case result {
      Ok(extension) -> extension
      Error(_) -> ""
    }
  }
}

fn supported_extensions() -> String {
  extension_map()
  |> dict.keys
  |> list.sort(string.compare)
  |> string.join(", ")
}

fn available_themes() -> String {
  theme_map()
  |> dict.keys
  |> list.sort(string.compare)
  |> string.join(", ")
}

fn theme_map() -> dict.Dict(String, smalto_lustre.Config(msg)) {
  dict.from_list([
    #("a11y-dark", themes.a11y_dark()),
    #("atom-dark", themes.atom_dark()),
    #("base16-ateliersulphurpool-light", themes.base16_ateliersulphurpool_light()),
    #("cb", themes.cb()),
    #("coldark-cold", themes.coldark_cold()),
    #("coldark-dark", themes.coldark_dark()),
    #("coy", themes.coy()),
    #("coy-without-shadows", themes.coy_without_shadows()),
    #("darcula", themes.darcula()),
    #("dark", themes.dark()),
    #("default", themes.default()),
    #("dracula", themes.dracula()),
    #("duotone-dark", themes.duotone_dark()),
    #("duotone-earth", themes.duotone_earth()),
    #("duotone-forest", themes.duotone_forest()),
    #("duotone-light", themes.duotone_light()),
    #("duotone-sea", themes.duotone_sea()),
    #("duotone-space", themes.duotone_space()),
    #("funky", themes.funky()),
    #("ghcolors", themes.ghcolors()),
    #("gruvbox-dark", themes.gruvbox_dark()),
    #("gruvbox-light", themes.gruvbox_light()),
    #("holi-theme", themes.holi_theme()),
    #("hopscotch", themes.hopscotch()),
    #("laserwave", themes.laserwave()),
    #("lucario", themes.lucario()),
    #("material-dark", themes.material_dark()),
    #("material-light", themes.material_light()),
    #("material-oceanic", themes.material_oceanic()),
    #("night-owl", themes.night_owl()),
    #("nord", themes.nord()),
    #("okaidia", themes.okaidia()),
    #("one-dark", themes.one_dark()),
    #("one-light", themes.one_light()),
    #("pojoaque", themes.pojoaque()),
    #("shades-of-purple", themes.shades_of_purple()),
    #("solarized-dark-atom", themes.solarized_dark_atom()),
    #("solarizedlight", themes.solarizedlight()),
    #("synthwave84", themes.synthwave84()),
    #("tomorrow", themes.tomorrow()),
    #("twilight", themes.twilight()),
    #("vs", themes.vs()),
    #("vsc-dark-plus", themes.vsc_dark_plus()),
    #("xonokai", themes.xonokai()),
    #("z-touch", themes.z_touch()),
  ])
}

fn extension_map() -> dict.Dict(String, Grammar) {
  dict.from_list([
    #("bash", bash.grammar()),
    #("c", c.grammar()),
    #("cc", cpp.grammar()),
    #("cjs", javascript.grammar()),
    #("cpp", cpp.grammar()),
    #("css", css.grammar()),
    #("cxx", cpp.grammar()),
    #("dart", dart.grammar()),
    #("dockerfile", dockerfile.grammar()),
    #("erl", erlang.grammar()),
    #("ex", elixir.grammar()),
    #("exs", elixir.grammar()),
    #("gleam", gleam.grammar()),
    #("go", go.grammar()),
    #("h", c.grammar()),
    #("hpp", cpp.grammar()),
    #("hrl", erlang.grammar()),
    #("hs", haskell.grammar()),
    #("htm", html_lang.grammar()),
    #("html", html_lang.grammar()),
    #("java", java.grammar()),
    #("js", javascript.grammar()),
    #("json", json.grammar()),
    #("kt", kotlin.grammar()),
    #("kts", kotlin.grammar()),
    #("lua", lua.grammar()),
    #("md", markdown.grammar()),
    #("mjs", javascript.grammar()),
    #("php", php.grammar()),
    #("py", python.grammar()),
    #("pyw", python.grammar()),
    #("rb", ruby.grammar()),
    #("rs", rust.grammar()),
    #("sc", scala.grammar()),
    #("scala", scala.grammar()),
    #("sh", bash.grammar()),
    #("sql", sql.grammar()),
    #("svg", xml.grammar()),
    #("swift", swift.grammar()),
    #("toml", toml.grammar()),
    #("ts", typescript.grammar()),
    #("tsx", typescript.grammar()),
    #("xml", xml.grammar()),
    #("yaml", yaml.grammar()),
    #("yml", yaml.grammar()),
    #("zig", zig.grammar()),
  ])
}

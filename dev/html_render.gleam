//// Example: render syntax-highlighted source code to a standalone HTML file.
////
//// Usage: gleam run -m html_render -- <source_file> <theme> <output_file>
////
//// Reads the given source file, detects the language from its extension,
//// applies the specified CSS theme, and writes a self-contained HTML file
//// with the theme embedded in the `<head>` and highlighted code in the `<body>`.

import argv
import gleam/dict
import gleam/io
import gleam/list
import gleam/string
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
import smalto/languages/html
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

pub fn main() -> Nil {
  let args = argv.load()
  case args.arguments {
    [source_path, theme, output_path] ->
      render_html(source_path, theme, output_path)
    _ ->
      io.println(
        "Usage: gleam run -m html_render -- <source_file> <theme> <output_file>"
        <> "\n\nAvailable themes: "
        <> available_themes_hint(),
      )
  }
}

fn render_html(source_path: String, theme: String, output_path: String) -> Nil {
  let ext = get_extension(source_path)
  case dict.get(extension_map(), ext) {
    Ok(grammar) -> {
      let theme_path = "themes/smalto-" <> theme <> ".css"
      case simplifile.read(theme_path) {
        Ok(theme_css) -> {
          case simplifile.read(source_path) {
            Ok(source) -> {
              let highlighted = smalto.to_html(source, grammar)
              let html_doc = build_html(source_path, theme_css, highlighted)
              case simplifile.write(output_path, html_doc) {
                Ok(_) -> io.println("Written HTML to " <> output_path)
                Error(_) ->
                  io.println("Error: could not write to " <> output_path)
              }
            }
            Error(_) ->
              io.println("Error: could not read source file " <> source_path)
          }
        }
        Error(_) ->
          io.println(
            "Error: unknown theme '"
            <> theme
            <> "'. Theme file not found at "
            <> theme_path,
          )
      }
    }
    Error(_) ->
      io.println(
        "Unsupported file extension: ."
        <> ext
        <> "\nSupported: "
        <> supported_extensions(),
      )
  }
}

fn build_html(
  source_path: String,
  theme_css: String,
  highlighted: String,
) -> String {
  string.join(
    [
      "<!DOCTYPE html>",
      "<html lang=\"en\">",
      "<head>",
      "  <meta charset=\"UTF-8\">",
      "  <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">",
      "  <title>" <> source_path <> " — Smalto</title>",
      "  <style>",
      theme_css,
      "  </style>",
      "</head>",
      "<body>",
      "  <pre class=\"smalto\"><code>" <> highlighted <> "</code></pre>",
      "</body>",
      "</html>",
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
      Ok(ext) -> ext
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

fn available_themes_hint() -> String {
  "default, dracula, nord, gruvbox-dark, etc. (see themes/ directory)"
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
    #("htm", html.grammar()),
    #("html", html.grammar()),
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

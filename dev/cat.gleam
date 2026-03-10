//// Example: syntax-highlighted cat using ANSI terminal colors.
////
//// Usage: gleam run -m cat -- <file_path>
////
//// Reads the given file, detects the language from its extension,
//// and prints syntax-highlighted output to stdout.

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
    [file_path] -> highlight_file(file_path)
    _ -> io.println("Usage: gleam run -m cat -- <file_path>")
  }
}

fn highlight_file(path: String) -> Nil {
  let ext = get_extension(path)
  case dict.get(extension_map(), ext) {
    Ok(grammar) -> {
      let assert Ok(content) = simplifile.read(path)
      smalto.to_ansi(content, grammar)
      |> io.println
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

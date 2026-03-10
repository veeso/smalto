import gleam/dict.{type Dict}
import smalto/grammar.{type Grammar}
import smalto/languages/bash
import smalto/languages/c
import smalto/languages/clike
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

pub fn languages() -> Dict(String, Grammar) {
  dict.from_list([
    #("bash", bash.grammar()),
    #("c", c.grammar()),
    #("clike", clike.grammar()),
    #("cpp", cpp.grammar()),
    #("css", css.grammar()),
    #("dart", dart.grammar()),
    #("dockerfile", dockerfile.grammar()),
    #("elixir", elixir.grammar()),
    #("erlang", erlang.grammar()),
    #("gleam", gleam.grammar()),
    #("go", go.grammar()),
    #("haskell", haskell.grammar()),
    #("html", html.grammar()),
    #("java", java.grammar()),
    #("javascript", javascript.grammar()),
    #("json", json.grammar()),
    #("kotlin", kotlin.grammar()),
    #("lua", lua.grammar()),
    #("markdown", markdown.grammar()),
    #("php", php.grammar()),
    #("python", python.grammar()),
    #("ruby", ruby.grammar()),
    #("rust", rust.grammar()),
    #("scala", scala.grammar()),
    #("sql", sql.grammar()),
    #("swift", swift.grammar()),
    #("toml", toml.grammar()),
    #("typescript", typescript.grammar()),
    #("xml", xml.grammar()),
    #("yaml", yaml.grammar()),
    #("zig", zig.grammar()),
  ])
}

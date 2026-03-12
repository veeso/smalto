import birdie
import smalto
import smalto/languages/bash
import smalto/languages/c
import smalto/languages/cpp
import smalto/languages/csharp
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

pub fn bash_highlighting_test() {
  "#!/bin/bash
# Comment
name=\"world\"
echo \"Hello $name\"
if [ -f file.txt ]; then
  cat file.txt
fi"
  |> smalto.to_html(bash.grammar())
  |> birdie.snap(title: "bash highlighting")
}

pub fn c_highlighting_test() {
  "#include <stdio.h>
// Comment
int main() {
    char *msg = \"hello\";
    printf(\"%s\\n\", msg);
    return 0;
}"
  |> smalto.to_html(c.grammar())
  |> birdie.snap(title: "c highlighting")
}

pub fn csharp_highlighting_test() {
  "// Comment
  using System;

  public class Program
  {
      public static void Main()
      {
          var name = \"Lucy\";
		Console.WriteLine($\"Hello {name}\");
      }
  }"
  |> smalto.to_html(csharp.grammar())
  |> birdie.snap(title: "csharp highlighting")
}

pub fn cpp_highlighting_test() {
  "#include <iostream>
// Comment
class Greeter {
public:
    void greet(const std::string& name) {
        std::cout << \"Hello \" << name << std::endl;
    }
};"
  |> smalto.to_html(cpp.grammar())
  |> birdie.snap(title: "cpp highlighting")
}

pub fn css_highlighting_test() {
  "/* Comment */
body {
  color: #333;
  font-size: 16px;
  background: rgb(255, 255, 255);
}
.container > .item:hover {
  opacity: 0.8;
}"
  |> smalto.to_html(css.grammar())
  |> birdie.snap(title: "css highlighting")
}

pub fn dart_highlighting_test() {
  "// Comment
class Person {
  final String name;
  Person(this.name);
  void greet() {
    print('Hello');
  }
}"
  |> smalto.to_html(dart.grammar())
  |> birdie.snap(title: "dart highlighting")
}

pub fn dockerfile_highlighting_test() {
  "# Comment
FROM node:18-alpine
WORKDIR /app
COPY package.json .
RUN npm install
EXPOSE 3000
CMD [\"node\", \"server.js\"]"
  |> smalto.to_html(dockerfile.grammar())
  |> birdie.snap(title: "dockerfile highlighting")
}

pub fn elixir_highlighting_test() {
  "# Comment
defmodule Greeter do
  def hello(name) do
    \"Hello\"
  end
end"
  |> smalto.to_html(elixir.grammar())
  |> birdie.snap(title: "elixir highlighting")
}

pub fn erlang_highlighting_test() {
  "% Comment
-module(greeter).
-export([hello/1]).
hello(Name) ->
    io:format(\"Hello ~s~n\", [Name])."
  |> smalto.to_html(erlang.grammar())
  |> birdie.snap(title: "erlang highlighting")
}

pub fn gleam_highlighting_test() {
  "// A module comment
import gleam/io
import gleam/list

/// Documentation comment
pub type User {
  User(name: String, age: Int)
}

pub fn main() {
  let user = User(\"Lucy\", 30)
  let x = 0xFF_FF
  let bits = <<1, 2, 3>>
  list.map([1, 2, 3], fn(n) { n * 2 })
  |> io.debug
  case user.age > 18 {
    True -> io.println(\"Hello\")
    False -> panic as \"too young\"
  }
}"
  |> smalto.to_html(gleam.grammar())
  |> birdie.snap(title: "gleam highlighting")
}

pub fn go_highlighting_test() {
  "package main
// Comment
import \"fmt\"
func main() {
    name := \"world\"
    fmt.Println(\"Hello\", name)
}"
  |> smalto.to_html(go.grammar())
  |> birdie.snap(title: "go highlighting")
}

pub fn haskell_highlighting_test() {
  "-- Comment
module Main where
greet :: String -> String
greet name = \"Hello\"
main :: IO ()
main = putStrLn (greet \"world\")"
  |> smalto.to_html(haskell.grammar())
  |> birdie.snap(title: "haskell highlighting")
}

pub fn html_highlighting_test() {
  "<!-- Comment -->
<!DOCTYPE html>
<html lang=\"en\">
<head><title>Test</title></head>
<body>
  <h1 class=\"title\">Hello</h1>
</body>
</html>"
  |> smalto.to_html(html.grammar())
  |> birdie.snap(title: "html highlighting")
}

pub fn java_highlighting_test() {
  "// Comment
public class Main {
    public static void main(String[] args) {
        String name = \"world\";
        System.out.println(\"Hello\");
    }
}"
  |> smalto.to_html(java.grammar())
  |> birdie.snap(title: "java highlighting")
}

pub fn javascript_highlighting_test() {
  "// Comment
const greet = (name) => {
  return 'Hello';
};
console.log(greet('world'));"
  |> smalto.to_html(javascript.grammar())
  |> birdie.snap(title: "javascript highlighting")
}

pub fn json_highlighting_test() {
  "{
  \"name\": \"smalto\",
  \"version\": 1,
  \"enabled\": true,
  \"tags\": [\"gleam\", \"syntax\"],
  \"config\": null
}"
  |> smalto.to_html(json.grammar())
  |> birdie.snap(title: "json highlighting")
}

pub fn kotlin_highlighting_test() {
  "// Comment
fun greet(name: String): String {
    return \"Hello\"
}
fun main() {
    println(greet(\"world\"))
}"
  |> smalto.to_html(kotlin.grammar())
  |> birdie.snap(title: "kotlin highlighting")
}

pub fn lua_highlighting_test() {
  "-- Comment
function greet(name)
    print(\"Hello \" .. name)
end
local x = 42
greet(\"world\")"
  |> smalto.to_html(lua.grammar())
  |> birdie.snap(title: "lua highlighting")
}

pub fn markdown_highlighting_test() {
  "# Heading
## Subheading
This is **bold** and *italic*.
- List item
- Another item"
  |> smalto.to_html(markdown.grammar())
  |> birdie.snap(title: "markdown highlighting")
}

pub fn php_highlighting_test() {
  "<?php
// Comment
function greet($name) {
    return \"Hello\";
}
echo greet('world');
?>"
  |> smalto.to_html(php.grammar())
  |> birdie.snap(title: "php highlighting")
}

pub fn python_highlighting_test() {
  "# Comment
def greet(name):
    return \"Hello\"
x = 42
print(greet('world'))"
  |> smalto.to_html(python.grammar())
  |> birdie.snap(title: "python highlighting")
}

pub fn ruby_highlighting_test() {
  "# Comment
class Greeter
  def greet(name)
    \"Hello\"
  end
end
puts Greeter.new.greet('world')"
  |> smalto.to_html(ruby.grammar())
  |> birdie.snap(title: "ruby highlighting")
}

pub fn rust_highlighting_test() {
  "// Comment
fn greet(name: &str) -> String {
    format!(\"Hello {}\", name)
}
fn main() {
    let x: i32 = 42;
    println!(\"{}\", greet(\"world\"));
}"
  |> smalto.to_html(rust.grammar())
  |> birdie.snap(title: "rust highlighting")
}

pub fn scala_highlighting_test() {
  "// Comment
object Main {
  def greet(name: String): String = {
    \"Hello\"
  }
  def main(args: Array[String]): Unit = {
    println(greet(\"world\"))
  }
}"
  |> smalto.to_html(scala.grammar())
  |> birdie.snap(title: "scala highlighting")
}

pub fn sql_highlighting_test() {
  "-- Comment
SELECT name, age
FROM users
WHERE age > 18
ORDER BY name ASC
LIMIT 10;"
  |> smalto.to_html(sql.grammar())
  |> birdie.snap(title: "sql highlighting")
}

pub fn swift_highlighting_test() {
  "// Comment
func greet(_ name: String) -> String {
    return \"Hello\"
}
let x: Int = 42
print(greet(\"world\"))"
  |> smalto.to_html(swift.grammar())
  |> birdie.snap(title: "swift highlighting")
}

pub fn toml_highlighting_test() {
  "# Comment
[package]
name = \"smalto\"
version = \"1.0.0\"
[dependencies]
gleam_stdlib = \">= 0.44.0\""
  |> smalto.to_html(toml.grammar())
  |> birdie.snap(title: "toml highlighting")
}

pub fn typescript_highlighting_test() {
  "// Comment
interface Person {
  name: string;
  age: number;
}
const greet = (p: Person): string => {
  return 'Hello';
};"
  |> smalto.to_html(typescript.grammar())
  |> birdie.snap(title: "typescript highlighting")
}

pub fn xml_highlighting_test() {
  "<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<!-- Comment -->
<root>
  <item id=\"1\">Hello</item>
</root>"
  |> smalto.to_html(xml.grammar())
  |> birdie.snap(title: "xml highlighting")
}

pub fn yaml_highlighting_test() {
  "# Comment
name: smalto
version: 1.0.0
enabled: true
tags:
  - gleam
  - syntax"
  |> smalto.to_html(yaml.grammar())
  |> birdie.snap(title: "yaml highlighting")
}

pub fn zig_highlighting_test() {
  "// Comment
const std = @import(\"std\");
fn add(a: i32, b: i32) i32 {
    return a + b;
}
pub fn main() void {
    std.debug.print(\"Result: {}\\n\", .{add(1, 2)});
}"
  |> smalto.to_html(zig.grammar())
  |> birdie.snap(title: "zig highlighting")
}

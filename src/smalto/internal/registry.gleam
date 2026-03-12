import gleam/dict.{type Dict}
import smalto/grammar.{type Grammar}
import smalto/languages/csharp
import smalto/languages/fsharp
import smalto/languages/gleam
import smalto/languages/nginx
import smalto/languages/razor
import smalto/languages/reactjsx
import smalto/languages/reacttsx

pub fn languages() -> Dict(String, Grammar) {
  dict.from_list([
    #("csharp", csharp.grammar()),
    #("fsharp", fsharp.grammar()),
    #("gleam", gleam.grammar()),
    #("nginx", nginx.grammar()),
    #("razor", razor.grammar()),
    #("reactjsx", reactjsx.grammar()),
    #("reacttsx", reacttsx.grammar()),
  ])
}

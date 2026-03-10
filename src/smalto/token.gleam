//// Token types for syntax-highlighted source code.
////
//// Each token wraps a string value representing the matched source text.
//// Well-known semantic variants cover common cases, while `Custom` handles
//// language-specific token categories.

/// A single token produced by the syntax highlighting engine.
pub type Token {
  Keyword(String)
  String(String)
  Number(String)
  Comment(String)
  Function(String)
  Operator(String)
  Punctuation(String)
  Type(String)
  Module(String)
  Variable(String)
  Constant(String)
  Builtin(String)
  Tag(String)
  Attribute(String)
  Selector(String)
  Property(String)
  Regex(String)
  Whitespace(String)
  Other(String)
  Custom(name: String, value: String)
}

/// Returns the token category name as a lowercase string.
///
/// For built-in variants, this is the variant name in lowercase
/// (e.g., `Keyword(_)` returns `"keyword"`).
/// For `Custom`, this returns the user-provided name.
pub fn name(token: Token) -> String {
  case token {
    Keyword(_) -> "keyword"
    String(_) -> "string"
    Number(_) -> "number"
    Comment(_) -> "comment"
    Function(_) -> "function"
    Operator(_) -> "operator"
    Punctuation(_) -> "punctuation"
    Type(_) -> "type"
    Module(_) -> "module"
    Variable(_) -> "variable"
    Constant(_) -> "constant"
    Builtin(_) -> "builtin"
    Tag(_) -> "tag"
    Attribute(_) -> "attribute"
    Selector(_) -> "selector"
    Property(_) -> "property"
    Regex(_) -> "regex"
    Whitespace(_) -> "whitespace"
    Other(_) -> "other"
    Custom(n, _) -> n
  }
}

/// Extracts the source text content from a token.
pub fn value(token: Token) -> String {
  case token {
    Keyword(v)
    | String(v)
    | Number(v)
    | Comment(v)
    | Function(v)
    | Operator(v)
    | Punctuation(v)
    | Type(v)
    | Module(v)
    | Variable(v)
    | Constant(v)
    | Builtin(v)
    | Tag(v)
    | Attribute(v)
    | Selector(v)
    | Property(v)
    | Regex(v)
    | Whitespace(v)
    | Other(v)
    | Custom(_, v) -> v
  }
}

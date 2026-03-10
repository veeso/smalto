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

/// A token type identifier without the associated source text.
///
/// Used as a key in `AnsiTheme` to map token categories to styling functions.
pub type AnsiToken {
  AnsiKeyword
  AnsiString
  AnsiNumber
  AnsiComment
  AnsiFunction
  AnsiOperator
  AnsiPunctuation
  AnsiType
  AnsiModule
  AnsiVariable
  AnsiConstant
  AnsiBuiltin
  AnsiTag
  AnsiAttribute
  AnsiSelector
  AnsiProperty
  AnsiRegex
  AnsiWhitespace
  AnsiOther
  AnsiCustom(name: String)
}

/// Convert a token to its corresponding `AnsiToken` key.
pub fn to_ansi_token(token: Token) -> AnsiToken {
  case token {
    Keyword(_) -> AnsiKeyword
    String(_) -> AnsiString
    Number(_) -> AnsiNumber
    Comment(_) -> AnsiComment
    Function(_) -> AnsiFunction
    Operator(_) -> AnsiOperator
    Punctuation(_) -> AnsiPunctuation
    Type(_) -> AnsiType
    Module(_) -> AnsiModule
    Variable(_) -> AnsiVariable
    Constant(_) -> AnsiConstant
    Builtin(_) -> AnsiBuiltin
    Tag(_) -> AnsiTag
    Attribute(_) -> AnsiAttribute
    Selector(_) -> AnsiSelector
    Property(_) -> AnsiProperty
    Regex(_) -> AnsiRegex
    Whitespace(_) -> AnsiWhitespace
    Other(_) -> AnsiOther
    Custom(n, _) -> AnsiCustom(n)
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

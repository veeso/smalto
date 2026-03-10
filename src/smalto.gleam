//// A general-purpose syntax highlighting library for Gleam.
////
//// Smalto uses regex-based grammars inspired by Prism.js to tokenize source
//// code for ~30 programming languages, with output to structured tokens,
//// ANSI terminal colors, or HTML.
////
//// ## Usage
////
//// ```gleam
//// import smalto
//// import smalto/languages/python
////
//// let html = smalto.to_html("print('hello')", python.grammar())
//// let ansi = smalto.to_ansi("print('hello')", python.grammar())
//// let tokens = smalto.to_tokens("print('hello')", python.grammar())
//// ```
////
//// Each language module exports a single `grammar()` function that returns
//// the language's `Grammar` definition. Pass it directly to `to_tokens`,
//// `to_html`, or `to_ansi` along with the source code to highlight.


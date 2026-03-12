//// Internal regex operations with byte-level position tracking.
////
//// Wraps Erlang's `re` module via FFI to provide regex matching with
//// byte offset information, which `gleam_regexp` does not expose.
//// All positions are byte offsets into UTF-8 binary strings.

/// A compiled PCRE regex pattern.
pub type Regex

/// Compile a PCRE pattern string with unicode support.
///
/// Returns `Ok(Regex)` on success, or `Error(Nil)` if the pattern is invalid.
@external(erlang, "regex_ffi", "compile")
@external(javascript, "../../regex_ffi.mjs", "compile")
pub fn compile(pattern: String) -> Result(Regex, Nil)

/// Find the first match starting from the given byte offset.
///
/// Returns `Ok(#(byte_start, matched_text))` where `byte_start` is the
/// absolute byte position of the match in the input string.
/// Returns `Error(Nil)` if no match is found.
@external(erlang, "regex_ffi", "find")
@external(javascript, "../../regex_ffi.mjs", "find")
pub fn find(
  regex: Regex,
  text: String,
  byte_offset: Int,
) -> Result(#(Int, String), Nil)

/// Slice a string by byte offsets.
///
/// The caller must ensure that `start` and `start + length` fall on
/// valid UTF-8 character boundaries.
@external(erlang, "regex_ffi", "byte_slice")
@external(javascript, "../../regex_ffi.mjs", "byte_slice")
pub fn byte_slice(text: String, start: Int, length: Int) -> String

/// Get the byte length of a UTF-8 string.
@external(erlang, "regex_ffi", "byte_length")
@external(javascript, "../../regex_ffi.mjs", "byte_length")
pub fn byte_length(text: String) -> Int

/// Check if a pattern is already in the compiled regex cache.
@external(erlang, "regex_ffi", "is_cached")
@external(javascript, "../../regex_ffi.mjs", "is_cached")
pub fn is_cached(pattern: String) -> Bool

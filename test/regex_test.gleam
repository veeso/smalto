import gleeunit/should
import smalto/internal/regex

// -- compile tests --

pub fn compile_valid_pattern_test() {
  let result = regex.compile("\\d+")
  should.be_ok(result)
}

pub fn compile_invalid_pattern_returns_error_test() {
  let result = regex.compile("[invalid(")
  should.be_error(result)
}

pub fn compile_empty_pattern_succeeds_test() {
  let result = regex.compile("")
  should.be_ok(result)
}

pub fn compile_unicode_pattern_test() {
  let result = regex.compile("café")
  should.be_ok(result)
}

// -- find tests --

pub fn find_simple_match_test() {
  let assert Ok(re) = regex.compile("\\d+")
  regex.find(re, "abc 42 def", 0)
  |> should.equal(Ok(#(4, "42")))
}

pub fn find_no_match_returns_error_test() {
  let assert Ok(re) = regex.compile("\\d+")
  regex.find(re, "no digits", 0)
  |> should.be_error
}

pub fn find_with_byte_offset_test() {
  let assert Ok(re) = regex.compile("\\d+")
  // "abc 42 78" — skip past "42" by starting at offset 6
  regex.find(re, "abc 42 78", 6)
  |> should.equal(Ok(#(7, "78")))
}

pub fn find_at_start_of_string_test() {
  let assert Ok(re) = regex.compile("hello")
  regex.find(re, "hello world", 0)
  |> should.equal(Ok(#(0, "hello")))
}

pub fn find_unicode_content_test() {
  let assert Ok(re) = regex.compile("café")
  regex.find(re, "at the café today", 0)
  |> should.equal(Ok(#(7, "café")))
}

// Note: find with offset past end causes an Erlang badarg crash,
// so we don't test that — callers must ensure valid offsets.

pub fn find_match_at_exact_offset_test() {
  let assert Ok(re) = regex.compile("\\d+")
  regex.find(re, "42", 0)
  |> should.equal(Ok(#(0, "42")))
}

pub fn find_captures_only_full_match_test() {
  let assert Ok(re) = regex.compile("(\\d+)-(\\d+)")
  // find should return the full match, not individual groups
  regex.find(re, "12-34", 0)
  |> should.equal(Ok(#(0, "12-34")))
}

// -- byte_slice tests --

pub fn byte_slice_ascii_test() {
  regex.byte_slice("hello world", 6, 5)
  |> should.equal("world")
}

pub fn byte_slice_from_start_test() {
  regex.byte_slice("hello", 0, 3)
  |> should.equal("hel")
}

pub fn byte_slice_empty_result_test() {
  regex.byte_slice("hello", 0, 0)
  |> should.equal("")
}

pub fn byte_slice_full_string_test() {
  regex.byte_slice("abc", 0, 3)
  |> should.equal("abc")
}

pub fn byte_slice_unicode_test() {
  // "café" in UTF-8: c(1) a(1) f(1) é(2) = 5 bytes
  // Slicing bytes 0..3 gives "caf"
  regex.byte_slice("café", 0, 3)
  |> should.equal("caf")
}

pub fn byte_slice_unicode_multibyte_char_test() {
  // "café" in UTF-8: c(1) a(1) f(1) é(2) = 5 bytes
  // Slicing bytes 3..5 gives "é"
  regex.byte_slice("café", 3, 2)
  |> should.equal("é")
}

// -- byte_length tests --

pub fn byte_length_empty_string_test() {
  regex.byte_length("")
  |> should.equal(0)
}

pub fn byte_length_ascii_test() {
  regex.byte_length("hello")
  |> should.equal(5)
}

pub fn byte_length_unicode_test() {
  // "café" = 5 bytes in UTF-8 (é is 2 bytes)
  regex.byte_length("café")
  |> should.equal(5)
}

pub fn byte_length_emoji_test() {
  // A basic emoji like "😀" is 4 bytes in UTF-8
  regex.byte_length("😀")
  |> should.equal(4)
}

pub fn byte_length_mixed_test() {
  // "a😀b" = 1 + 4 + 1 = 6 bytes
  regex.byte_length("a😀b")
  |> should.equal(6)
}

// -- cache tests --

pub fn compile_caches_regex_test() {
  // Use a unique pattern unlikely to be compiled by other tests
  let pattern = "^CACHE_TEST_UNIQUE_42$"

  // Pattern should not be cached before first compile
  regex.is_cached(pattern)
  |> should.equal(False)

  // Compile the pattern
  let assert Ok(_) = regex.compile(pattern)

  // Pattern should now be cached
  regex.is_cached(pattern)
  |> should.equal(True)
}

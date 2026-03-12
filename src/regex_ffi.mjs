import { Result$Ok, Result$Error } from "./gleam.mjs";

const Nil = undefined;
const encoder = new TextEncoder();
const decoder = new TextDecoder();

// Strip PCRE inline flags (?i), (?m), (?s), (?im), etc. from pattern start.
// Returns [strippedPattern, extractedFlags].
function stripInlineFlags(pattern) {
  const match = pattern.match(/^\(\?([ims]+)\)/);
  if (match) {
    return [pattern.slice(match[0].length), match[1]];
  }
  return [pattern, ""];
}

// Convert PCRE extended hex escapes \x{HHHH} to JS unicode escapes \u{HHHH}.
function convertHexEscapes(pattern) {
  return pattern.replace(/\\x\{/g, "\\u{");
}

// Convert PCRE \K (match-reset) to JavaScript lookbehind (?<=...).
// Scans the pattern respecting character classes and escape sequences.
// If \K is found, everything before it becomes a lookbehind assertion.
function convertBackslashK(pattern) {
  let inCharClass = false;
  let i = 0;
  let lastKPos = -1;

  while (i < pattern.length) {
    const ch = pattern[i];
    if (ch === "\\") {
      if (i + 1 < pattern.length) {
        if (!inCharClass && pattern[i + 1] === "K") {
          lastKPos = i;
        }
        i += 2;
        continue;
      }
    }
    if (ch === "[" && !inCharClass) {
      inCharClass = true;
    } else if (ch === "]" && inCharClass) {
      inCharClass = false;
    }
    i += 1;
  }

  if (lastKPos === -1) {
    return pattern;
  }
  const prefix = pattern.slice(0, lastKPos);
  const rest = pattern.slice(lastKPos + 2);
  return `(?<=${prefix})${rest}`;
}

// Cache for compiled regex patterns, keyed by original pattern string.
const regexCache = new Map();

// Compile a regex pattern with unicode support.
// Applies PCRE-to-JS transformations: inline flags, hex escapes, \K.
// Caches compiled regexes for reuse.
// Returns Ok(regex) or Error(Nil).
export function compile(pattern) {
  const cached = regexCache.get(pattern);
  if (cached !== undefined) {
    return Result$Ok(cached);
  }
  try {
    const [stripped, inlineFlags] = stripInlineFlags(pattern);
    const converted = convertBackslashK(convertHexEscapes(stripped));
    const flags = `gu${inlineFlags}`;
    const regex = new RegExp(converted, flags);
    regexCache.set(pattern, regex);
    return Result$Ok(regex);
  } catch {
    return Result$Error(Nil);
  }
}

// Check if a pattern is in the regex cache.
export function is_cached(pattern) {
  return regexCache.has(pattern);
}

// Convert a byte offset to a character index in a string.
function byteOffsetToCharIndex(text, byteOffset) {
  const bytes = encoder.encode(text);
  const slice = bytes.slice(0, byteOffset);
  return decoder.decode(slice).length;
}

// Convert a character index to a byte offset in a string.
function charIndexToByteOffset(text, charIndex) {
  const prefix = text.slice(0, charIndex);
  return encoder.encode(prefix).length;
}

// Find the first match starting from the given byte offset.
// Returns Ok([byteStart, matchedText]) or Error(Nil).
export function find(regex, text, byteOffset) {
  const charIndex = byteOffsetToCharIndex(text, byteOffset);
  const cloned = new RegExp(regex.source, regex.flags);
  cloned.lastIndex = charIndex;

  const match = cloned.exec(text);
  if (match === null) {
    return Result$Error(Nil);
  }

  const matchCharIndex = match.index;
  const matchByteStart = charIndexToByteOffset(text, matchCharIndex);
  return Result$Ok([matchByteStart, match[0]]);
}

// Slice a string by byte offsets.
export function byte_slice(text, start, length) {
  const bytes = encoder.encode(text);
  const sliced = bytes.slice(start, start + length);
  return decoder.decode(sliced);
}

// Get the byte length of a UTF-8 string.
export function byte_length(text) {
  return encoder.encode(text).length;
}

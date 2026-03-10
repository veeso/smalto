// Parser module — transforms Prism grammar objects into normalized IR
// AIRBNB-2.1: const by default

/**
 * Convert a JS RegExp to a PCRE-compatible pattern string.
 * Strips delimiters and converts JS flags to inline PCRE flags.
 *
 * @param {RegExp} regex
 * @returns {string}
 */
function regexToString(regex) {
  let source = regex.source;
  const { flags } = regex;

  // Convert JS unicode escapes \u{XXXX} to PCRE \x{XXXX}
  source = source.replace(/\\u\{([0-9a-fA-F]+)\}/g, '\\x{$1}');
  source = source.replace(/\\u([0-9a-fA-F]{4})/g, '\\x{$1}');

  // Convert named groups (?<name>...) to (?P<name>...) for PCRE
  // Must not match lookbehinds (?<=...) or (?<!...)
  source = source.replace(/\(\?<(?![=!])([a-zA-Z_]\w*)>/g, '(?P<$1>');

  // Prepend inline flags for PCRE
  let flagStr = '';
  if (flags.includes('i')) flagStr += 'i';
  if (flags.includes('m')) flagStr += 'm';
  if (flags.includes('s')) flagStr += 's';

  if (flagStr) {
    source = `(?${flagStr})${source}`;
  }

  return source;
}

/**
 * Check if a regex pattern has fixed length for PCRE lookbehind.
 *
 * PCRE lookbehinds require all alternatives to have the same fixed length.
 * Returns false if the pattern contains quantifiers (*, +, ?, {n,m}),
 * alternation with different-length branches, or other variable-length constructs.
 *
 * @param {string} content - The lookbehind content to check
 * @returns {boolean}
 */
function isFixedLengthLookbehind(content) {
  // Quick heuristics: variable-length quantifiers make it non-fixed
  // AIRBNB-2.1: const for regex patterns
  const variableLengthPattern = /(?<!\\)[*+?]|\{[\d]+,[\d]*\}/;
  if (variableLengthPattern.test(content)) return false;

  // Alternation with ^ anchor (common in Prism: ^|[^.]) is variable-length in PCRE
  if (/\^/.test(content) && /\|/.test(content)) return false;

  return true;
}

/**
 * Convert a Prism lookbehind pattern to PCRE lookbehind.
 *
 * Prism's lookbehind: true means the first capture group is consumed
 * but excluded from the token. We convert it to (?<=...) for PCRE.
 *
 * When the lookbehind content is variable-length (not supported by PCRE),
 * we use \K (match reset) as a fallback: the lookbehind group is converted
 * to a non-capturing group followed by \K.
 *
 * @param {string} pattern
 * @returns {string}
 */
function convertLookbehind(pattern) {
  // Find the first top-level capture group
  // We need to handle nested parens correctly
  let depth = 0;
  let groupStart = -1;
  let groupEnd = -1;

  for (let i = 0; i < pattern.length; i += 1) {
    const ch = pattern[i];
    if (ch === '\\') {
      i += 1; // skip escaped char
      continue;
    }
    if (ch === '[') {
      // Skip character class
      i += 1;
      while (i < pattern.length && pattern[i] !== ']') {
        if (pattern[i] === '\\') i += 1;
        i += 1;
      }
      continue;
    }
    if (ch === '(') {
      if (depth === 0) {
        // Check if this is a non-capturing group (?:...) or other special group
        if (pattern[i + 1] === '?') {
          // This is (?:...), (?=...), (?!...), (?<=...), (?<!...), etc.
          // Not a capturing group — skip
          depth += 1;
          continue;
        }
        if (groupStart === -1) {
          groupStart = i;
        }
      }
      depth += 1;
    } else if (ch === ')') {
      depth -= 1;
      if (depth === 0 && groupStart !== -1 && groupEnd === -1) {
        groupEnd = i;
        break;
      }
    }
  }

  if (groupStart === -1 || groupEnd === -1) {
    return pattern;
  }

  const lookbehindContent = pattern.slice(groupStart + 1, groupEnd);
  const rest = pattern.slice(groupEnd + 1);
  const prefix = pattern.slice(0, groupStart);

  // Use (?<=...) for fixed-length lookbehinds, \K for variable-length
  if (isFixedLengthLookbehind(lookbehindContent)) {
    return `${prefix}(?<=${lookbehindContent})${rest}`;
  }
  return `${prefix}(?:${lookbehindContent})\\K${rest}`;
}

/**
 * Parse a Prism `inside` object into an IR inside reference.
 *
 * @param {object} insideObj
 * @param {Map} grammarLookup - Map from Prism grammar objects to language names
 * @param {Set} visited - Set of already-seen objects (cycle detection)
 * @returns {{ type: 'inline', rules: Array } | { type: 'ref', language: string } | null}
 */
function parseInside(insideObj, grammarLookup, visited) {
  if (!insideObj || typeof insideObj !== 'object') return null;

  // Cycle detection: if we've already visited this object, skip it
  if (visited.has(insideObj)) return null;
  visited.add(insideObj);

  // If it has a `rest` key, it's a language/self reference
  if (insideObj.rest) {
    const restGrammar = insideObj.rest;
    if (grammarLookup && grammarLookup.has(restGrammar)) {
      return { type: 'ref', language: grammarLookup.get(restGrammar) };
    }
    // Can't resolve — skip inside
    return null;
  }

  // Otherwise it's an inline grammar — recursively parse entries
  const rules = [];
  for (const key of Object.keys(insideObj)) {
    rules.push(...parseEntry(key, insideObj[key], grammarLookup, visited));
  }

  if (rules.length === 0) return null;
  return { type: 'inline', rules };
}

/**
 * Parse a single Prism rule entry into normalized rule objects.
 *
 * @param {string} token - token name (key from grammar object)
 * @param {*} entry - the grammar entry value
 * @param {Map} grammarLookup
 * @param {Set} visited - Set of already-seen objects (cycle detection)
 * @returns {Array<{ token: string, pattern: string, greedy: boolean, inside: object|null }>}
 */
function parseEntry(token, entry, grammarLookup, visited = new Set()) {
  // Skip non-pattern entries (functions, strings used as metadata)
  if (typeof entry === 'function' || typeof entry === 'string' || typeof entry === 'boolean') {
    return [];
  }

  // Null/undefined
  if (entry == null) return [];

  // Cycle detection for container objects only (not pattern leaf nodes)
  // AIRBNB-2.1: pattern objects (with entry.pattern) are leaf nodes shared across
  // grammar locations (e.g., parameter.inside.keyword === top-level keyword) and
  // must not be skipped via cycle detection
  if (
    typeof entry === 'object' &&
    !Array.isArray(entry) &&
    !(entry instanceof RegExp) &&
    !(entry.pattern instanceof RegExp)
  ) {
    if (visited.has(entry)) return [];
    visited.add(entry);
  }

  // Array of patterns — flatten
  if (Array.isArray(entry)) {
    return entry.flatMap((e) => parseEntry(token, e, grammarLookup, visited));
  }

  // Bare RegExp
  if (entry instanceof RegExp) {
    return [{ token, pattern: regexToString(entry), greedy: false, inside: null }];
  }

  // Object with pattern property
  if (entry.pattern instanceof RegExp) {
    let pattern = regexToString(entry.pattern);

    // Handle lookbehind conversion
    if (entry.lookbehind) {
      pattern = convertLookbehind(pattern);
    }

    // Resolve token name from alias (use alias instead of original key)
    let resolvedToken = token;
    if (entry.alias) {
      resolvedToken = Array.isArray(entry.alias) ? entry.alias[0] : entry.alias;
    }

    // Handle inside
    const inside = entry.inside ? parseInside(entry.inside, grammarLookup, visited) : null;

    return [
      {
        token: resolvedToken,
        pattern,
        greedy: Boolean(entry.greedy),
        inside,
      },
    ];
  }

  return [];
}

/**
 * Parse a Prism grammar object into the normalized IR.
 *
 * @param {string} name - Language name
 * @param {object} grammar - Prism.languages[lang] object
 * @param {string|null} extendsLang - Parent language name if extends
 * @param {Map|null} grammarLookup - Map from grammar objects to language names
 * @returns {{ name: string, extends: string|null, rules: Array }}
 */
function parseGrammar(name, grammar, extendsLang, grammarLookup = null) {
  const rules = [];
  const visited = new Set();

  for (const key of Object.keys(grammar)) {
    // Skip non-grammar entries
    if (key === 'rest') continue;
    rules.push(...parseEntry(key, grammar[key], grammarLookup, visited));
  }

  return {
    name,
    extends: extendsLang || null,
    rules,
  };
}

export { parseGrammar, regexToString, convertLookbehind };

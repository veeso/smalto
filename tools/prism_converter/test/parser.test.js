import { describe, it } from 'node:test';
import assert from 'node:assert/strict';
import { parseGrammar, regexToString, convertLookbehind } from '../src/parser.js';

describe('regexToString', () => {
  it('should convert a simple regex', () => {
    assert.equal(regexToString(/\bfoo\b/), '\\bfoo\\b');
  });

  it('should convert regex with case-insensitive flag', () => {
    assert.equal(regexToString(/pattern/i), '(?i)pattern');
  });

  it('should convert regex with multiline flag', () => {
    assert.equal(regexToString(/^line$/m), '(?m)^line$');
  });

  it('should convert regex with dotall flag', () => {
    assert.equal(regexToString(/a.b/s), '(?s)a.b');
  });

  it('should convert regex with multiple flags', () => {
    const result = regexToString(/pattern/ims);
    assert.ok(result.startsWith('(?'), 'Should start with inline flags');
    assert.ok(result.includes('i'), 'Should have i flag');
    assert.ok(result.includes('m'), 'Should have m flag');
    assert.ok(result.includes('s'), 'Should have s flag');
  });

  it('should convert unicode escapes', () => {
    // Need RegExp constructor to avoid JS parsing \u{} at compile time
    // eslint-disable-next-line prefer-regex-literals
    const regex = new RegExp('\\u{1F600}', 'u');
    const result = regexToString(regex);
    assert.ok(result.includes('\\x{1F600}'), `Expected \\x{1F600} in: ${result}`);
  });
});

describe('convertLookbehind', () => {
  it('should convert first capture group to lookbehind', () => {
    // (^|[^.]) is variable-length (has ^ and |), so \K fallback is used
    const result = convertLookbehind('(^|[^.])\\bfoo\\b');
    assert.equal(result, '(?:^|[^.])\\K\\bfoo\\b');
  });

  it('should return unchanged if no capture group found', () => {
    const result = convertLookbehind('\\bfoo\\b');
    assert.equal(result, '\\bfoo\\b');
  });

  it('should skip non-capturing groups', () => {
    const result = convertLookbehind('(?:foo)(bar)baz');
    assert.equal(result, '(?:foo)(?<=bar)baz');
  });
});

describe('parseGrammar', () => {
  it('should parse a bare regex entry', () => {
    const grammar = { keyword: /\bif\b/ };
    const result = parseGrammar('test', grammar, null);
    assert.equal(result.name, 'test');
    assert.equal(result.extends, null);
    assert.equal(result.rules.length, 1);
    assert.equal(result.rules[0].token, 'keyword');
    assert.equal(result.rules[0].pattern, '\\bif\\b');
    assert.equal(result.rules[0].greedy, false);
    assert.equal(result.rules[0].inside, null);
  });

  it('should parse an object entry with greedy', () => {
    const grammar = { string: { pattern: /"[^"]*"/, greedy: true } };
    const result = parseGrammar('test', grammar, null);
    assert.equal(result.rules[0].greedy, true);
    assert.equal(result.rules[0].pattern, '"[^"]*"');
  });

  it('should parse an array entry into multiple rules', () => {
    const grammar = {
      string: [
        { pattern: /"[^"]*"/, greedy: true },
        { pattern: /'[^']*'/, greedy: true },
      ],
    };
    const result = parseGrammar('test', grammar, null);
    assert.equal(result.rules.length, 2);
    assert.equal(result.rules[0].token, 'string');
    assert.equal(result.rules[1].token, 'string');
  });

  it('should use alias as token name when present', () => {
    const grammar = { 'class-name': { pattern: /\bFoo\b/, alias: 'keyword' } };
    const result = parseGrammar('test', grammar, null);
    assert.equal(result.rules[0].token, 'keyword');
  });

  it('should handle alias as array (use first alias)', () => {
    const grammar = {
      'class-name': { pattern: /\bFoo\b/, alias: ['type', 'important'] },
    };
    const result = parseGrammar('test', grammar, null);
    assert.equal(result.rules[0].token, 'type');
  });

  it('should handle inside with inline rules', () => {
    const grammar = {
      string: {
        pattern: /"[^"]*"/,
        inside: { variable: /\$\w+/ },
      },
    };
    const result = parseGrammar('test', grammar, null);
    assert.ok(result.rules[0].inside, 'Should have inside');
    assert.equal(result.rules[0].inside.type, 'inline');
    assert.equal(result.rules[0].inside.rules.length, 1);
    assert.equal(result.rules[0].inside.rules[0].token, 'variable');
  });

  it('should handle inside with rest reference', () => {
    const jsGrammar = { keyword: /\bvar\b/ };
    const grammar = {
      string: { pattern: /"[^"]*"/, inside: { rest: jsGrammar } },
    };
    const grammarLookup = new Map([[jsGrammar, 'javascript']]);
    const result = parseGrammar('test', grammar, null, grammarLookup);
    assert.ok(result.rules[0].inside, 'Should have inside');
    assert.equal(result.rules[0].inside.type, 'ref');
    assert.equal(result.rules[0].inside.language, 'javascript');
  });

  it('should preserve key order', () => {
    const grammar = { comment: /\/\/.*/, keyword: /\bif\b/, number: /\d+/ };
    const result = parseGrammar('test', grammar, null);
    assert.equal(result.rules[0].token, 'comment');
    assert.equal(result.rules[1].token, 'keyword');
    assert.equal(result.rules[2].token, 'number');
  });

  it('should set extends when provided', () => {
    const grammar = { keyword: /\bclass\b/ };
    const result = parseGrammar('typescript', grammar, 'javascript');
    assert.equal(result.extends, 'javascript');
  });

  it('should skip non-pattern entries (functions)', () => {
    const grammar = { keyword: /\bif\b/, tokenize: () => {} };
    const result = parseGrammar('test', grammar, null);
    assert.equal(result.rules.length, 1);
  });

  it('should skip boolean entries', () => {
    const grammar = { keyword: /\bif\b/, someflag: true };
    const result = parseGrammar('test', grammar, null);
    assert.equal(result.rules.length, 1);
  });

  it('should handle lookbehind by converting first capture group', () => {
    const grammar = {
      function: { pattern: /(^|[^.])\b\w+(?=\()/, lookbehind: true },
    };
    const result = parseGrammar('test', grammar, null);
    // Pattern (^|[^.]) is variable-length, so \K fallback is used
    assert.ok(
      result.rules[0].pattern.includes('\\K'),
      `Should convert to \\K fallback: ${result.rules[0].pattern}`,
    );
  });
});

import { describe, it } from 'node:test';
import assert from 'node:assert/strict';
import { fetchGrammar, fetchAllGrammars, ALL_LANGUAGES, COMPONENT_MAP } from '../src/fetcher.js';

describe('fetcher', () => {
  it('should export ALL_LANGUAGES with 29 entries', () => {
    assert.equal(ALL_LANGUAGES.length, 29);
  });

  it('should have a component mapping for every language', () => {
    for (const lang of ALL_LANGUAGES) {
      assert.ok(COMPONENT_MAP[lang], `Missing component mapping for ${lang}`);
    }
  });

  it('should fetch a simple language grammar (json)', () => {
    const result = fetchGrammar('json');
    assert.ok(result.grammar, 'Grammar should exist');
    assert.ok(Object.keys(result.grammar).length > 0, 'Grammar should have rules');
    assert.equal(result.extends, null, 'JSON should not extend anything');
  });

  it('should fetch a language with extends (typescript)', () => {
    const result = fetchGrammar('typescript');
    assert.ok(result.grammar, 'Grammar should exist');
    assert.equal(result.extends, 'javascript', 'TypeScript should extend javascript');
  });

  it('should fetch a language with extends (cpp)', () => {
    const result = fetchGrammar('cpp');
    assert.ok(result.grammar, 'Grammar should exist');
    assert.equal(result.extends, 'c', 'C++ should extend c');
  });

  it('should fetch all grammars without errors', () => {
    const results = fetchAllGrammars();
    assert.equal(Object.keys(results).length, ALL_LANGUAGES.length);
    for (const lang of ALL_LANGUAGES) {
      assert.ok(results[lang], `Missing grammar for ${lang}`);
      assert.ok(results[lang].grammar, `Grammar for ${lang} should exist`);
    }
  });

  it('should throw for unknown language', () => {
    assert.throws(() => fetchGrammar('nonexistent'), /Unknown language/);
  });
});

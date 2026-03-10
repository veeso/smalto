import { describe, it } from 'node:test';
import assert from 'node:assert/strict';
import { renderGrammar, escapeGleamString } from '../src/renderer.js';

describe('escapeGleamString', () => {
  it('should escape backslashes', () => {
    assert.equal(escapeGleamString('\\b'), '\\\\b');
  });

  it('should escape double quotes', () => {
    assert.equal(escapeGleamString('"hello"'), '\\"hello\\"');
  });

  it('should handle mixed escapes', () => {
    assert.equal(escapeGleamString('\\d+"'), '\\\\d+\\"');
  });
});

describe('renderGrammar', () => {
  it('should render a simple grammar with one rule', () => {
    const ir = {
      name: 'test',
      extends: null,
      rules: [{ token: 'keyword', pattern: '\\bif\\b', greedy: false, inside: null }],
    };
    const output = renderGrammar(ir);
    assert.ok(output.includes('pub fn grammar() -> Grammar'));
    assert.ok(output.includes('name: "test"'));
    assert.ok(output.includes('extends: option.None'));
    assert.ok(output.includes('grammar.rule("keyword"'));
    assert.ok(output.includes('\\\\bif\\\\b'));
  });

  it('should render a greedy rule', () => {
    const ir = {
      name: 'test',
      extends: null,
      rules: [{ token: 'string', pattern: '"[^"]*"', greedy: true, inside: null }],
    };
    const output = renderGrammar(ir);
    assert.ok(output.includes('grammar.greedy_rule("string"'));
  });

  it('should render extends', () => {
    const ir = {
      name: 'typescript',
      extends: 'javascript',
      rules: [{ token: 'keyword', pattern: '\\binterface\\b', greedy: false, inside: null }],
    };
    const output = renderGrammar(ir);
    assert.ok(output.includes('extends: option.Some("javascript")'));
  });

  it('should render rule with inline inside', () => {
    const ir = {
      name: 'test',
      extends: null,
      rules: [
        {
          token: 'string',
          pattern: '"[^"]*"',
          greedy: false,
          inside: {
            type: 'inline',
            rules: [{ token: 'variable', pattern: '\\$\\w+', greedy: false, inside: null }],
          },
        },
      ],
    };
    const output = renderGrammar(ir);
    assert.ok(output.includes('grammar.rule_with_inside('));
    assert.ok(output.includes('grammar.rule("variable"'));
  });

  it('should render rule with language ref inside', () => {
    const ir = {
      name: 'test',
      extends: null,
      rules: [
        {
          token: 'code',
          pattern: '<code>.*?</code>',
          greedy: false,
          inside: { type: 'ref', language: 'javascript' },
        },
      ],
    };
    const output = renderGrammar(ir);
    assert.ok(output.includes('grammar.nested_rule('));
    assert.ok(output.includes('"javascript"'));
  });

  it('should render greedy rule with inline inside', () => {
    const ir = {
      name: 'test',
      extends: null,
      rules: [
        {
          token: 'string',
          pattern: '"[^"]*"',
          greedy: true,
          inside: {
            type: 'inline',
            rules: [{ token: 'escape', pattern: '\\\\.', greedy: false, inside: null }],
          },
        },
      ],
    };
    const output = renderGrammar(ir);
    assert.ok(output.includes('grammar.greedy_rule_with_inside('));
  });

  it('should produce empty list for no rules', () => {
    const ir = { name: 'test', extends: null, rules: [] };
    const output = renderGrammar(ir);
    assert.ok(output.includes('[]'));
  });
});

import { describe, it } from 'node:test';
import assert from 'node:assert/strict';
import { renderRegistry } from '../src/registry_writer.js';

describe('renderRegistry', () => {
  it('should render a registry with one language', () => {
    const output = renderRegistry(['python']);
    assert.ok(output.includes('import smalto/languages/python'));
    assert.ok(output.includes('#("python", python.grammar())'));
    assert.ok(output.includes('Dict(String, Grammar)'));
  });

  it('should render a registry with multiple languages sorted alphabetically', () => {
    const output = renderRegistry(['rust', 'python', 'go']);
    const lines = output.split('\n');
    const importLines = lines.filter((l) => l.startsWith('import smalto/languages/'));
    assert.equal(importLines[0], 'import smalto/languages/go');
    assert.equal(importLines[1], 'import smalto/languages/python');
    assert.equal(importLines[2], 'import smalto/languages/rust');
  });

  it('should handle cpp module name', () => {
    const output = renderRegistry(['cpp']);
    assert.ok(output.includes('import smalto/languages/cpp'));
    assert.ok(output.includes('#("cpp", cpp.grammar())'));
  });

  it('should render empty registry', () => {
    const output = renderRegistry([]);
    assert.ok(output.includes('dict.new()'));
  });
});

import { describe, it } from 'node:test';
import assert from 'node:assert/strict';
import {
  extractProp,
  extractTokenName,
  parseCssTheme,
  cssNameToGleamName,
  extractDescription,
  generateStylesList,
  generateThemeFunction,
  generateModule,
} from '../src/converter.js';

// --- extractProp ---

describe('extractProp', () => {
  it('extracts a simple property value', () => {
    const block = 'color: #ff0000; font-weight: bold;';
    assert.equal(extractProp(block, 'color'), '#ff0000');
    assert.equal(extractProp(block, 'font-weight'), 'bold');
  });

  it('returns null for missing property', () => {
    assert.equal(extractProp('color: red;', 'font-weight'), null);
  });

  it('handles extra whitespace around colon', () => {
    assert.equal(extractProp('color :  #abc ;', 'color'), '#abc');
  });
});

// --- extractTokenName ---

describe('extractTokenName', () => {
  it('extracts smalto-prefixed class names', () => {
    assert.equal(extractTokenName('.smalto-keyword'), 'keyword');
    assert.equal(extractTokenName('.smalto-class-name'), 'class-name');
  });

  it('extracts .namespace selector', () => {
    assert.equal(extractTokenName('.namespace'), 'namespace');
  });

  it('returns null for attribute selectors', () => {
    assert.equal(extractTokenName('.smalto-keyword[data-x]'), null);
  });

  it('returns null for pseudo selectors', () => {
    assert.equal(extractTokenName('.smalto-keyword:hover'), null);
  });

  it('returns null for @media queries', () => {
    assert.equal(extractTokenName('@media screen'), null);
  });

  it('returns null for language-scoped selectors', () => {
    assert.equal(extractTokenName('.language-css .smalto-string'), null);
  });

  it('returns null for .style-scoped selectors', () => {
    assert.equal(extractTokenName('.style .smalto-string'), null);
  });

  it('returns null for unrecognized selectors', () => {
    assert.equal(extractTokenName('.some-other-class'), null);
  });
});

// --- cssNameToGleamName ---

describe('cssNameToGleamName', () => {
  it('strips smalto- prefix and .css suffix', () => {
    assert.equal(cssNameToGleamName('smalto-dracula.css'), 'dracula');
  });

  it('converts hyphens to underscores', () => {
    assert.equal(cssNameToGleamName('smalto-gruvbox-dark.css'), 'gruvbox_dark');
  });

  it('converts dots in name to underscores', () => {
    assert.equal(
      cssNameToGleamName('smalto-base16-ateliersulphurpool.light.css'),
      'base16_ateliersulphurpool_light',
    );
  });
});

// --- parseCssTheme ---

describe('parseCssTheme', () => {
  it('extracts base text color', () => {
    const css = '.smalto, .smalto code { color: #f8f8f2; }';
    const result = parseCssTheme(css);
    assert.equal(result.baseColor, '#f8f8f2');
  });

  it('extracts token styles from .smalto-* selectors', () => {
    const css = '.smalto-keyword { color: #ff79c6; font-weight: bold; }';
    const result = parseCssTheme(css);
    assert.deepEqual(result.tokens.keyword, {
      color: '#ff79c6',
      'font-weight': 'bold',
    });
  });

  it('maps aliased CSS classes to canonical fields', () => {
    const css = `.smalto-char { color: #aaa; }
.smalto-prolog { color: #bbb; }
.smalto-symbol { color: #ccc; }`;
    const result = parseCssTheme(css);
    // char → string, prolog → comment, symbol → constant
    assert.equal(result.tokens.string.color, '#aaa');
    assert.equal(result.tokens.comment.color, '#bbb');
    assert.equal(result.tokens.constant.color, '#ccc');
  });

  it('handles grouped selectors', () => {
    const css = '.smalto-keyword, .smalto-operator { color: #ff0000; }';
    const result = parseCssTheme(css);
    assert.equal(result.tokens.keyword.color, '#ff0000');
    assert.equal(result.tokens.operator.color, '#ff0000');
  });

  it('last matching rule wins (CSS cascade)', () => {
    const css = `
.smalto-keyword { color: #aaa; }
.smalto-keyword { color: #bbb; }`;
    const result = parseCssTheme(css);
    assert.equal(result.tokens.keyword.color, '#bbb');
  });

  it('ignores rules with no relevant properties', () => {
    const css = '.smalto-keyword { background: #000; }';
    const result = parseCssTheme(css);
    assert.equal(result.tokens.keyword, undefined);
  });

  it('strips @media blocks', () => {
    const css = `
.smalto, .smalto code { color: #f8f8f2; }
.smalto-keyword { color: #ff79c6; }
@media screen and (-ms-high-contrast: active) {
  .smalto-keyword { color: highlight; }
  .smalto-string { color: window; }
}`;
    const result = parseCssTheme(css);
    assert.equal(result.tokens.keyword.color, '#ff79c6');
    // String should not exist from @media block
    assert.equal(result.tokens.string, undefined);
  });

  it('returns null baseColor when no base rule exists', () => {
    const css = '.smalto-keyword { color: red; }';
    const result = parseCssTheme(css);
    assert.equal(result.baseColor, null);
  });

  it('handles font-style and text-decoration properties', () => {
    const css = '.smalto-comment { color: #999; font-style: italic; text-decoration: underline; }';
    const result = parseCssTheme(css);
    assert.deepEqual(result.tokens.comment, {
      color: '#999',
      'font-style': 'italic',
      'text-decoration': 'underline',
    });
  });
});

// --- extractDescription ---

describe('extractDescription', () => {
  it('extracts description from second comment block', () => {
    const css = `/** Smalto header */
/** Dracula Theme by Zeno Rocha */
.smalto-keyword { color: red; }`;
    const result = extractDescription(css, 'smalto-dracula.css');
    assert.equal(result, 'Dracula Theme by Zeno Rocha');
  });

  it('falls back to filename when only one comment block exists', () => {
    const css = `/** Smalto header */
.smalto-keyword { color: red; }`;
    const result = extractDescription(css, 'smalto-gruvbox-dark.css');
    assert.equal(result, 'gruvbox dark theme');
  });

  it('falls back to filename when no comments exist', () => {
    const css = '.smalto-keyword { color: red; }';
    const result = extractDescription(css, 'smalto-one-light.css');
    assert.equal(result, 'one light theme');
  });

  it('skips asterisk separator blocks', () => {
    const css = `/** Smalto header */
/************************************************************/
.smalto-keyword { color: red; }`;
    const result = extractDescription(css, 'smalto-vsc-dark-plus.css');
    assert.equal(result, 'vsc dark plus theme');
  });

  it('skips asterisk blocks with trailing word', () => {
    const css = `/** Smalto header */
/** ******* Tokens */
.smalto-keyword { color: red; }`;
    const result = extractDescription(css, 'smalto-test.css');
    assert.equal(result, 'test theme');
  });

  it('truncates long descriptions to 120 characters', () => {
    const longDesc = 'A'.repeat(200);
    const css = `/** Smalto header */
/** ${longDesc} */
.smalto-keyword { color: red; }`;
    const result = extractDescription(css, 'smalto-test.css');
    assert.ok(result.length <= 120);
  });
});

// --- generateStylesList ---

describe('generateStylesList', () => {
  it('generates style pairs for a token with color', () => {
    const parsed = { baseColor: null, tokens: { keyword: { color: '#ff0000' } } };
    const pairs = generateStylesList(parsed, 'keyword');
    assert.deepEqual(pairs, ['#("color", "#ff0000")']);
  });

  it('includes font-weight when not normal', () => {
    const parsed = {
      baseColor: null,
      tokens: { keyword: { color: '#ff0000', 'font-weight': 'bold' } },
    };
    const pairs = generateStylesList(parsed, 'keyword');
    assert.deepEqual(pairs, ['#("color", "#ff0000")', '#("font-weight", "bold")']);
  });

  it('excludes font-weight when normal', () => {
    const parsed = {
      baseColor: null,
      tokens: { keyword: { color: '#ff0000', 'font-weight': 'normal' } },
    };
    const pairs = generateStylesList(parsed, 'keyword');
    assert.deepEqual(pairs, ['#("color", "#ff0000")']);
  });

  it('includes font-style when not normal', () => {
    const parsed = {
      baseColor: null,
      tokens: { comment: { color: '#999', 'font-style': 'italic' } },
    };
    const pairs = generateStylesList(parsed, 'comment');
    assert.deepEqual(pairs, ['#("color", "#999")', '#("font-style", "italic")']);
  });

  it('uses fallback chain for type_ (falls back to function)', () => {
    const parsed = {
      baseColor: null,
      tokens: { function: { color: '#50fa7b' } },
    };
    const pairs = generateStylesList(parsed, 'type_');
    assert.deepEqual(pairs, ['#("color", "#50fa7b")']);
  });

  it('uses fallback chain for constant (falls back to number)', () => {
    const parsed = {
      baseColor: null,
      tokens: { number: { color: '#bd93f9' } },
    };
    const pairs = generateStylesList(parsed, 'constant');
    assert.deepEqual(pairs, ['#("color", "#bd93f9")']);
  });

  it('uses base color as last resort', () => {
    const parsed = { baseColor: '#f8f8f2', tokens: {} };
    const pairs = generateStylesList(parsed, 'keyword');
    assert.deepEqual(pairs, ['#("color", "#f8f8f2")']);
  });

  it('returns null when no color available', () => {
    const parsed = { baseColor: null, tokens: {} };
    const pairs = generateStylesList(parsed, 'keyword');
    assert.equal(pairs, null);
  });
});

// --- generateThemeFunction ---

describe('generateThemeFunction', () => {
  it('generates a valid Gleam function', () => {
    const parsed = {
      baseColor: '#f8f8f2',
      tokens: {
        keyword: { color: '#ff79c6' },
      },
    };
    const output = generateThemeFunction('dracula', parsed, 'Dracula theme');
    assert.ok(output.startsWith('/// Dracula theme'));
    assert.ok(output.includes('pub fn dracula() -> Config(msg) {'));
    assert.ok(output.includes('smalto_lustre.default_config()'));
    assert.ok(output.includes('smalto_lustre.keyword(styled_span('));
    assert.ok(output.includes('#("color", "#ff79c6")'));
    assert.ok(output.endsWith('}'));
  });

  it('omits doc comment when description is null', () => {
    const parsed = { baseColor: '#fff', tokens: {} };
    const output = generateThemeFunction('test', parsed, null);
    assert.ok(output.startsWith('pub fn test()'));
  });

  it('generates custom renderer with important and url styles', () => {
    const parsed = {
      baseColor: '#fff',
      tokens: {
        important: { color: '#e90' },
        url: { color: '#00e' },
      },
    };
    const output = generateThemeFunction('test', parsed, null);
    assert.ok(output.includes('important_styles:'));
    assert.ok(output.includes('#("color", "#e90")'));
    assert.ok(output.includes('url_styles:'));
    assert.ok(output.includes('#("color", "#00e")'));
  });

  it('defaults important font-weight to bold when not specified', () => {
    const parsed = {
      baseColor: '#fff',
      tokens: { important: { color: '#e90' } },
    };
    const output = generateThemeFunction('test', parsed, null);
    assert.ok(output.includes('#("font-weight", "bold")'));
  });

  it('uses fallback code color #008000 when no code token exists', () => {
    const parsed = { baseColor: '#fff', tokens: {} };
    const output = generateThemeFunction('test', parsed, null);
    assert.ok(output.includes('code_color: "#008000"'));
  });

  it('uses explicit code token color when available', () => {
    const parsed = {
      baseColor: '#fff',
      tokens: { code_token: { color: '#abc' } },
    };
    const output = generateThemeFunction('test', parsed, null);
    assert.ok(output.includes('code_color: "#abc"'));
  });
});

// --- generateModule ---

describe('generateModule', () => {
  const minimalThemes = [
    {
      name: 'beta',
      parsed: { baseColor: '#fff', tokens: { keyword: { color: '#f00' } } },
      description: 'Beta theme',
    },
    {
      name: 'alpha',
      parsed: { baseColor: '#000', tokens: { keyword: { color: '#0f0' } } },
      description: 'Alpha theme',
    },
  ];

  it('generates module header with theme count', () => {
    const output = generateModule(minimalThemes);
    assert.ok(output.includes('## Available themes (2)'));
  });

  it('generates module header with sorted theme list', () => {
    const output = generateModule(minimalThemes);
    const alphaIdx = output.indexOf('`alpha()`');
    const betaIdx = output.indexOf('`beta()`');
    assert.ok(alphaIdx < betaIdx, 'alpha should appear before beta');
  });

  it('includes Gleam imports', () => {
    const output = generateModule(minimalThemes);
    assert.ok(output.includes('import gleam/list'));
    assert.ok(output.includes('import lustre/attribute'));
    assert.ok(output.includes('import smalto/lustre.{type Config} as smalto_lustre'));
  });

  it('includes helper functions', () => {
    const output = generateModule(minimalThemes);
    assert.ok(output.includes('fn styled_span('));
    assert.ok(output.includes('fn custom_renderer('));
  });

  it('generates functions in sorted order', () => {
    const output = generateModule(minimalThemes);
    const alphaFn = output.indexOf('pub fn alpha()');
    const betaFn = output.indexOf('pub fn beta()');
    assert.ok(alphaFn < betaFn, 'alpha function should appear before beta');
  });

  it('includes usage example in header', () => {
    const output = generateModule(minimalThemes);
    assert.ok(output.includes('themes.dracula()'));
  });
});

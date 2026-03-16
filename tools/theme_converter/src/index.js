#!/usr/bin/env node

import fs from 'fs';
import path from 'path';

const THEMES_DIR = path.resolve(import.meta.dirname, '../../../themes');
const OUTPUT_FILE = path.resolve(
  import.meta.dirname,
  '../../../smalto_lustre_themes/src/smalto/lustre/themes.gleam',
);

// CSS class → Config field mapping
// Order matters: more specific mappings checked first
const CLASS_TO_FIELD = {
  keyword: 'keyword',
  string: 'string',
  char: 'string',
  number: 'number',
  comment: 'comment',
  prolog: 'comment',
  doctype: 'comment',
  cdata: 'comment',
  function: 'function',
  'class-name': 'type_',
  operator: 'operator',
  punctuation: 'punctuation',
  namespace: 'module',
  variable: 'variable',
  constant: 'constant',
  symbol: 'constant',
  builtin: 'builtin',
  tag: 'tag',
  'attr-name': 'attribute',
  selector: 'selector',
  property: 'property',
  regex: 'regex',
  // Custom/markup tokens
  important: 'important',
  bold: 'bold',
  italic: 'italic',
  strike: 'strike',
  code: 'code_token',
  url: 'url',
  entity: 'url',
};

// CSS properties we care about for inline styles
const RELEVANT_PROPS = ['color', 'font-weight', 'font-style', 'text-decoration'];

/**
 * Extract CSS property value from a block of CSS property declarations.
 */
function extractProp(propsBlock, prop) {
  const propRegex = new RegExp(`${prop}\\s*:\\s*([^;]+);`);
  const propMatch = propsBlock.match(propRegex);
  return propMatch ? propMatch[1].trim() : null;
}

/**
 * Parse a CSS rule selector to extract a smalto token name.
 * Returns the token name string, or null if no match.
 */
function extractTokenName(selector) {
  // Skip complex selectors (descendant, attribute, pseudo, media queries)
  if (selector.includes('[') || selector.includes(':') || selector.includes('@')) {
    return null;
  }
  // Skip context-dependent selectors like `.language-css .smalto-string`
  if (selector.includes('.language-') || selector.includes('.style ')) {
    return null;
  }

  // Match .smalto-<token> or .namespace
  const smaltoMatch = selector.match(/\.smalto-([a-z-]+)$/);
  if (smaltoMatch) {
    return smaltoMatch[1];
  }
  if (selector.match(/\.namespace$/)) {
    return 'namespace';
  }
  return null;
}

/**
 * Process a single CSS rule block and update token styles in the result.
 */
function processRule(result, selectorBlock, propsBlock) {
  // Parse properties
  const styles = RELEVANT_PROPS.reduce((acc, prop) => {
    const val = extractProp(propsBlock, prop);
    if (val !== null) {
      return { ...acc, [prop]: val };
    }
    return acc;
  }, {});

  // Skip rules with no relevant properties
  if (Object.keys(styles).length === 0) {
    return;
  }

  // Split grouped selectors and extract smalto-* classes
  const selectors = selectorBlock.split(',').map((s) => s.trim());

  selectors.forEach((selector) => {
    const tokenName = extractTokenName(selector);
    if (!tokenName) {
      return;
    }

    const field = CLASS_TO_FIELD[tokenName];
    if (!field) {
      return;
    }

    // Last matching rule wins (CSS cascade order)
    if (!result.tokens[field]) {
      // eslint-disable-next-line no-param-reassign
      result.tokens[field] = {};
    }
    Object.assign(result.tokens[field], styles);
  });
}

/**
 * Parse a CSS file and extract per-token styles.
 * Returns { baseColor, tokens: { field: { color, fontWeight, ... } } }
 */
function parseCssTheme(cssContent) {
  const result = {
    baseColor: null,
    tokens: {},
  };

  // Extract base text color from `.smalto, .smalto code { color: ... }`
  const baseMatch = cssContent.match(/\.smalto\s*,\s*\.smalto\s+code\s*\{[^}]*color:\s*([^;]+);/);
  if (baseMatch) {
    result.baseColor = baseMatch[1].trim();
  }

  // Match all CSS rule blocks: selectors { properties }
  const ruleRegex = /([^{}]+)\{([^}]*)\}/g;
  let match;

  // eslint-disable-next-line no-cond-assign
  while ((match = ruleRegex.exec(cssContent)) !== null) {
    processRule(result, match[1].trim(), match[2].trim());
  }

  return result;
}

/**
 * Convert CSS filename to Gleam function name.
 * smalto-dracula.css → dracula
 * smalto-gruvbox-dark.css → gruvbox_dark
 */
function cssNameToGleamName(filename) {
  return filename
    .replace(/^smalto-/, '')
    .replace(/\.css$/, '')
    .replace(/[-\\.]/g, '_');
}

/**
 * Extract a short description from the CSS file's comment header.
 */
function extractDescription(cssContent) {
  // Look for the second comment block (theme-specific description)
  const comments = cssContent.match(/\/\*\*([\s\S]*?)\*\//g);
  if (comments && comments.length >= 2) {
    // Clean up the comment: remove /**, */, leading *, and trim
    return comments[1]
      .replace(/\/\*\*?|\*\//g, '')
      .split('\n')
      .map((line) => line.replace(/^\s*\*\s?/, '').trim())
      .filter((line) => line.length > 0)
      .join(' ')
      .substring(0, 120);
  }
  return null;
}

// Config fields in the order they appear in Config type
const CONFIG_FIELDS = [
  'keyword',
  'string',
  'number',
  'comment',
  'function',
  'operator',
  'punctuation',
  'type_',
  'module',
  'variable',
  'constant',
  'builtin',
  'tag',
  'attribute',
  'selector',
  'property',
  'regex',
];

// Fallback chain: if a field has no style, try these related fields
const FALLBACKS = {
  type_: ['function'],
  module: [],
  attribute: ['selector'],
  selector: ['attribute'],
  constant: ['number'],
  builtin: ['string'],
};

/**
 * Generate the styles list for a token field.
 * Returns list of #("prop", "value") tuples as a Gleam string, or null if using base color only.
 */
function generateStylesList(parsed, field) {
  let styles = parsed.tokens[field];

  // Try fallbacks if no direct style
  if (!styles || !styles.color) {
    const chain = FALLBACKS[field] || [];
    const fallbackStyles = chain.reduce((found, fallback) => {
      if (found) {
        return found;
      }
      return parsed.tokens[fallback]?.color ? { ...parsed.tokens[fallback] } : null;
    }, null);
    if (fallbackStyles) {
      styles = fallbackStyles;
    }
  }

  // Use base color as last resort
  if (!styles || !styles.color) {
    if (parsed.baseColor) {
      styles = { color: parsed.baseColor };
    } else {
      return null;
    }
  }

  const pairs = [];
  if (styles.color) {
    pairs.push(`#("color", "${styles.color}")`);
  }
  if (styles['font-weight'] && styles['font-weight'] !== 'normal') {
    pairs.push(`#("font-weight", "${styles['font-weight']}")`);
  }
  if (styles['font-style'] && styles['font-style'] !== 'normal') {
    pairs.push(`#("font-style", "${styles['font-style']}")`);
  }
  if (styles['text-decoration'] && styles['text-decoration'] !== 'none') {
    pairs.push(`#("text-decoration", "${styles['text-decoration']}")`);
  }

  return pairs;
}

/**
 * Generate a single theme function as Gleam source code.
 */
function generateThemeFunction(name, parsed, description) {
  const lines = [];

  // Doc comment
  if (description) {
    lines.push(`/// ${description}`);
  }
  lines.push(`pub fn ${name}() -> Config(msg) {`);
  lines.push('  smalto_lustre.default_config()');

  // Generate each config field override
  CONFIG_FIELDS.forEach((field) => {
    const pairs = generateStylesList(parsed, field);
    if (!pairs || pairs.length === 0) {
      return;
    }

    const builderName = field === 'type_' ? 'type_' : field;
    if (pairs.length === 1) {
      lines.push(`  |> smalto_lustre.${builderName}(styled_span([${pairs[0]}]))`);
    } else {
      lines.push(`  |> smalto_lustre.${builderName}(styled_span([${pairs.join(', ')}]))`);
    }
  });

  // Generate custom renderer
  const importantStyles = parsed.tokens.important || {};
  const urlStyles = parsed.tokens.url || {};

  const importantPairs = [];
  if (importantStyles.color) {
    importantPairs.push(`#("color", "${importantStyles.color}")`);
  }
  if (importantStyles['font-weight'] && importantStyles['font-weight'] !== 'normal') {
    importantPairs.push(`#("font-weight", "${importantStyles['font-weight']}")`);
  }
  // If no explicit font-weight but important exists, default to bold
  if (importantStyles.color && !importantStyles['font-weight']) {
    // eslint-disable-next-line quotes
    importantPairs.push(`#("font-weight", "bold")`);
  }

  const urlPairs = [];
  if (urlStyles.color) {
    // eslint-disable-next-line quotes
    urlPairs.push(`#("text-decoration", "underline")`);
    urlPairs.push(`#("color", "${urlStyles.color}")`);
  } else if (parsed.baseColor) {
    // eslint-disable-next-line quotes
    urlPairs.push(`#("text-decoration", "underline")`);
    urlPairs.push(`#("color", "${parsed.baseColor}")`);
  }

  // Extract code token color if available, fallback to #008000
  const codeStyles = parsed.tokens.code_token || {};
  const codeColor = codeStyles.color || '#008000';

  lines.push(
    `  |> smalto_lustre.custom(custom_renderer(important_styles: [${importantPairs.join(', ')}], url_styles: [${urlPairs.join(', ')}], code_color: "${codeColor}"))`,
  );
  lines.push('}');

  return lines.join('\n');
}

/**
 * Generate the full themes.gleam module source.
 */
function generateModule(themes) {
  const header = `////  Pre-built theme configurations for smalto_lustre.
////
////  Each function returns a \`Config(msg)\` with inline-styled \`<span>\` elements
////  matching the corresponding CSS theme from the smalto themes collection.
////
////  ## Usage
////
////  \`\`\`gleam
////  import smalto
////  import smalto/languages/python
////  import smalto/lustre as smalto_lustre
////  import smalto/lustre/themes
////
////  let tokens = smalto.to_tokens("print('hello')", python.grammar())
////  let elements = smalto_lustre.to_lustre(tokens, themes.dracula())
////  \`\`\`

import gleam/list
import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import smalto/lustre as smalto_lustre.{type Config}

`;

  const helpers = `
// --- Private helpers ---

fn styled_span(
  styles: List(#(String, String)),
) -> fn(String) -> Element(msg) {
  fn(value) {
    html.span(
      list.map(styles, fn(s) {
        let #(k, v) = s
        attribute.style(k, v)
      }),
      [element.text(value)],
    )
  }
}

fn custom_renderer(
  important_styles important_styles: List(#(String, String)),
  url_styles url_styles: List(#(String, String)),
  code_color code_color: String,
) -> fn(String, String) -> Element(msg) {
  fn(name, value) {
    case name {
      "important" -> styled_span(important_styles)(value)
      "bold" ->
        html.span(
          [attribute.style("font-weight", "bold")],
          [element.text(value)],
        )
      "italic" ->
        html.span(
          [attribute.style("font-style", "italic")],
          [element.text(value)],
        )
      "strike" ->
        html.span(
          [attribute.style("text-decoration", "line-through")],
          [element.text(value)],
        )
      "code" ->
        html.span(
          [attribute.style("color", code_color)],
          [element.text(value)],
        )
      "url" -> styled_span(url_styles)(value)
      _ -> element.text(value)
    }
  }
}
`;

  const functions = themes
    .sort((a, b) => a.name.localeCompare(b.name))
    .map((t) => generateThemeFunction(t.name, t.parsed, t.description))
    .join('\n\n');

  return `${header}${functions}\n${helpers}`;
}

// --- Main ---

function main() {
  const cssFiles = fs
    .readdirSync(THEMES_DIR)
    .filter((f) => f.startsWith('smalto-') && f.endsWith('.css'))
    .sort();

  console.log(`Found ${cssFiles.length} theme files`);

  const themes = cssFiles.map((file) => {
    const cssContent = fs.readFileSync(path.join(THEMES_DIR, file), 'utf-8');
    const name = cssNameToGleamName(file);
    const parsed = parseCssTheme(cssContent);
    const description = extractDescription(cssContent);

    console.log(`  Parsed: ${file} → ${name}()`);
    return { name, parsed, description };
  });

  const gleamSource = generateModule(themes);

  // Ensure output directory exists
  const outputDir = path.dirname(OUTPUT_FILE);
  fs.mkdirSync(outputDir, { recursive: true });

  fs.writeFileSync(OUTPUT_FILE, gleamSource, 'utf-8');
  console.log(`\nGenerated: ${OUTPUT_FILE}`);
  console.log(`  ${themes.length} theme functions`);
}

main();

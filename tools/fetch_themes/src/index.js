#!/usr/bin/env node

/**
 * Fetches all Prism.js themes and adapts them for Smalto's class prefix.
 *
 * Prism uses: .token.keyword, .token.string, etc.
 * Smalto uses: .smalto-keyword, .smalto-string, etc.
 *
 * This script:
 * 1. Fetches CSS from PrismJS/prism (bundled) and PrismJS/prism-themes (community)
 * 2. Rewrites selectors from .token.X to .smalto-X
 * 3. Keeps code block styling with a .smalto wrapper class
 * 4. Writes adapted CSS files to themes/
 */

import fs from 'node:fs';
import path from 'node:path';
import https from 'node:https';
import { fileURLToPath } from 'node:url';

const currentFile = fileURLToPath(import.meta.url);
const currentDir = path.dirname(currentFile);

const THEMES_DIR = path.join(currentDir, '..', '..', '..', 'themes');

// Bundled themes from PrismJS/prism
const BUNDLED_BASE = 'https://raw.githubusercontent.com/PrismJS/prism/master/themes';
const BUNDLED_THEMES = [
  'prism.css',
  'prism-coy.css',
  'prism-dark.css',
  'prism-funky.css',
  'prism-okaidia.css',
  'prism-solarizedlight.css',
  'prism-tomorrow.css',
  'prism-twilight.css',
];

// Community themes from PrismJS/prism-themes
const COMMUNITY_BASE = 'https://raw.githubusercontent.com/PrismJS/prism-themes/master/themes';
const COMMUNITY_THEMES = [
  'prism-a11y-dark.css',
  'prism-atom-dark.css',
  'prism-base16-ateliersulphurpool.light.css',
  'prism-cb.css',
  'prism-coldark-cold.css',
  'prism-coldark-dark.css',
  'prism-coy-without-shadows.css',
  'prism-darcula.css',
  'prism-dracula.css',
  'prism-duotone-dark.css',
  'prism-duotone-earth.css',
  'prism-duotone-forest.css',
  'prism-duotone-light.css',
  'prism-duotone-sea.css',
  'prism-duotone-space.css',
  'prism-ghcolors.css',
  'prism-gruvbox-dark.css',
  'prism-gruvbox-light.css',
  'prism-holi-theme.css',
  'prism-hopscotch.css',
  'prism-laserwave.css',
  'prism-lucario.css',
  'prism-material-dark.css',
  'prism-material-light.css',
  'prism-material-oceanic.css',
  'prism-night-owl.css',
  'prism-nord.css',
  'prism-one-dark.css',
  'prism-one-light.css',
  'prism-pojoaque.css',
  'prism-shades-of-purple.css',
  'prism-solarized-dark-atom.css',
  'prism-synthwave84.css',
  'prism-vs.css',
  'prism-vsc-dark-plus.css',
  'prism-xonokai.css',
  'prism-z-touch.css',
];

function fetchUrl(url) {
  return new Promise((resolve, reject) => {
    const doRequest = (requestUrl) => {
      https
        .get(requestUrl, (res) => {
          if (res.statusCode >= 300 && res.statusCode < 400 && res.headers.location) {
            doRequest(res.headers.location);
            return;
          }
          if (res.statusCode !== 200) {
            reject(new Error(`HTTP ${res.statusCode} for ${url}`));
            return;
          }
          let data = '';
          res.on('data', (chunk) => {
            data += chunk;
          });
          res.on('end', () => resolve(data));
        })
        .on('error', reject);
    };
    doRequest(url);
  });
}

/**
 * Convert Prism CSS to Smalto CSS.
 *
 * Transformations:
 * - code[class*="language-"], pre[class*="language-"] -> .smalto, .smalto code
 * - .token.X -> .smalto-X
 * - .token (bare) is removed (smalto doesn't use a wrapper .token class)
 * - :not(pre) > code[class*="language-"] -> .smalto-inline
 * - pre[class*="language-"] -> .smalto
 * - Namespace opacity rules are adapted
 */
function convertCss(css, filename) {
  let result = css;

  // Remove .token bare class rules (just font/styling on generic .token)
  // but keep compound .token.X rules
  result = result.replace(/^\.token\s*\{[^}]*\}/gm, '');

  // Replace .token.X with .smalto-X (handle multi-class like .token.important.bold)
  result = result.replace(/\.token\.([a-z][a-z0-9-]*)/g, '.smalto-$1');

  // Replace remaining bare .token references in selectors
  result = result.replace(/\.token(?=[,\s{])/g, "[class^='smalto-']");

  // Replace code/pre language selectors with .smalto
  // :not(pre) > code[class*="language-"] -> .smalto-inline
  result = result.replace(/:not\(pre\)\s*>\s*code\[class\*=["']language-["']\]/g, '.smalto-inline');

  // pre[class*="language-"] > code -> .smalto code
  result = result.replace(/pre\[class\*=["']language-["']\]\s*>\s*code/g, '.smalto code');

  // code[class*="language-"], pre[class*="language-"] combined
  result = result.replace(
    /code\[class\*=["']language-["']\]\s*,\s*pre\[class\*=["']language-["']\]/g,
    '.smalto, .smalto code',
  );

  // Standalone pre[class*="language-"]
  result = result.replace(/pre\[class\*=["']language-["']\]/g, '.smalto');

  // Standalone code[class*="language-"]
  result = result.replace(/code\[class\*=["']language-["']\]/g, '.smalto code');

  // Also handle pre.language-xxx patterns
  result = result.replace(/pre\.language-\w+/g, '.smalto');

  // Handle div.code-toolbar patterns from some themes
  result = result.replace(/div\.code-toolbar\s*>\s*\.toolbar/g, '.smalto > .toolbar');

  // Add smalto header
  const themeName =
    filename
      .replace(/^prism-?/, '')
      .replace(/\.css$/, '')
      .replace(/-/g, ' ')
      .replace(/\b\w/g, (c) => c.toUpperCase()) || 'Default';

  const header = `/**
 * Smalto Theme: ${themeName}
 * Adapted from Prism.js (MIT License)
 *
 * Original: https://prismjs.com
 * License: MIT — Copyright (c) 2012 Lea Verou
 *
 * Usage:
 *   <pre class="smalto"><code>...highlighted HTML from smalto.to_html()...</code></pre>
 *
 * Token classes use the "smalto-" prefix (e.g., .smalto-keyword, .smalto-string).
 */

`;

  return `${header}${result.trim()}\n`;
}

async function main() {
  fs.mkdirSync(THEMES_DIR, { recursive: true });

  const allThemes = [
    ...BUNDLED_THEMES.map((f) => ({ file: f, base: BUNDLED_BASE })),
    ...COMMUNITY_THEMES.map((f) => ({ file: f, base: COMMUNITY_BASE })),
  ];

  // Process in batches of 8 to avoid overwhelming the network
  const BATCH_SIZE = 8;
  const batches = [];
  for (let i = 0; i < allThemes.length; i += BATCH_SIZE) {
    batches.push(allThemes.slice(i, i + BATCH_SIZE));
  }

  const batchResults = await batches.reduce(
    (chain, batch) =>
      chain.then(async (prev) => {
        const results = await Promise.allSettled(
          batch.map(async ({ file, base }) => {
            const url = `${base}/${file}`;
            console.log(`Fetching ${file}...`);
            const css = await fetchUrl(url);
            const converted = convertCss(css, file);
            const outName = file
              .replace(/^prism-?/, 'smalto-')
              .replace(/^smalto-\.css$/, 'smalto-default.css');
            const outPath = path.join(THEMES_DIR, outName);
            fs.writeFileSync(outPath, converted);
            console.log(`  -> ${outName}`);
            return outName;
          }),
        );
        return [...prev, ...results];
      }),
    Promise.resolve([]),
  );

  const succeeded = batchResults.filter((r) => r.status === 'fulfilled').length;
  const failed = batchResults.filter((r) => r.status === 'rejected').length;

  batchResults
    .filter((r) => r.status === 'rejected')
    .forEach((r) => console.error(`  FAILED: ${r.reason.message}`));

  console.log(`\nDone: ${succeeded} themes converted, ${failed} failed.`);
}

main().catch((err) => {
  console.error(err);
  process.exit(1);
});

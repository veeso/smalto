#!/usr/bin/env node

import fs from 'fs';
import path from 'path';
import {
  parseCssTheme,
  cssNameToGleamName,
  extractDescription,
  generateModule,
} from './converter.js';

const THEMES_DIR = path.resolve(import.meta.dirname, '../../../themes');
const OUTPUT_FILE = path.resolve(
  import.meta.dirname,
  '../../../smalto_lustre_themes/src/smalto/lustre/themes.gleam',
);

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
    const description = extractDescription(cssContent, file);

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

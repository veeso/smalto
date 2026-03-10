import meow from 'meow';
import pino from 'pino';
import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';
import { fetchGrammar, fetchAllGrammars, ALL_LANGUAGES, grammarToName } from './fetcher.js';
import { parseGrammar } from './parser.js';
import { renderGrammar } from './renderer.js';
import { renderRegistry } from './registry_writer.js';

const __dirname = path.dirname(fileURLToPath(import.meta.url));

const cli = meow(
  `
  Usage
    $ prism-converter <languages...>

  Options
    --all, -a          Convert all supported languages
    --output-dir, -o   Output directory (default: ../../src/smalto/languages/)
    --registry, -r     Registry file path (default: ../../src/smalto/internal/registry.gleam)
    --log-level, -l    Log level: trace, debug, info, warn, error, fatal (default: info)

  Examples
    $ prism-converter python rust
    $ prism-converter --all
    $ prism-converter --all --output-dir ./output
`,
  {
    importMeta: import.meta,
    flags: {
      all: {
        type: 'boolean',
        shortFlag: 'a',
        default: false,
      },
      outputDir: {
        type: 'string',
        shortFlag: 'o',
        default: path.resolve(__dirname, '../../../src/smalto/languages/'),
      },
      registry: {
        type: 'string',
        shortFlag: 'r',
        default: path.resolve(__dirname, '../../../src/smalto/internal/registry.gleam'),
      },
      logLevel: {
        type: 'string',
        shortFlag: 'l',
        default: 'info',
      },
    },
  },
);

const logger = pino({ level: cli.flags.logLevel });

const { input: requestedLanguages, flags } = cli;

if (!flags.all && requestedLanguages.length === 0) {
  cli.showHelp();
} else {
  // Determine languages to process
  const languages = flags.all ? ALL_LANGUAGES : requestedLanguages;

  // Ensure output directory exists
  fs.mkdirSync(flags.outputDir, { recursive: true });

  // Process each language
  const processedLanguages = [];
  for (const lang of languages) {
    logger.info(`Processing ${lang}...`);

    const { grammar, extends: extendsLang } = fetchGrammar(lang);

    const ir = parseGrammar(lang, grammar, extendsLang, grammarToName);
    const gleamSource = renderGrammar(ir);
    const outputPath = path.join(flags.outputDir, `${lang}.gleam`);

    fs.writeFileSync(outputPath, gleamSource);
    logger.info(`Wrote ${outputPath} (${ir.rules.length} rules)`);
    processedLanguages.push(lang);
  }

  // Write registry
  const registrySource = renderRegistry(processedLanguages);
  fs.writeFileSync(flags.registry, registrySource);
  logger.info(`Wrote registry: ${flags.registry} (${processedLanguages.length} languages)`);

  logger.info('Done!');
}

export { cli, flags };

import meow from 'meow';
import pino from 'pino';

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
        default: '../../src/smalto/languages/',
      },
      registry: {
        type: 'string',
        shortFlag: 'r',
        default: '../../src/smalto/internal/registry.gleam',
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

const { input: languages, flags } = cli;

if (!flags.all && languages.length === 0) {
  cli.showHelp();
}

export { cli, flags, languages, logger };

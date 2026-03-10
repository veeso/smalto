import { describe, it } from 'node:test';
import assert from 'node:assert/strict';
import { execFile } from 'node:child_process';
import { fileURLToPath } from 'node:url';
import path from 'node:path';

const DIRNAME = path.dirname(fileURLToPath(import.meta.url));
const ENTRY_POINT = path.join(DIRNAME, '..', 'src', 'index.js');

const run = (args = []) =>
  new Promise((resolve) => {
    execFile('node', [ENTRY_POINT, ...args], (error, stdout, stderr) => {
      resolve({ exitCode: error?.code ?? 0, stdout, stderr });
    });
  });

describe('CLI', () => {
  it('should show help and exit when no arguments are provided', async () => {
    const { exitCode, stdout } = await run();

    assert.notEqual(exitCode, 0);
    assert.ok(stdout.includes('Usage'));
    assert.ok(stdout.includes('prism-converter'));
  });

  it('should show help with --help flag', async () => {
    const { exitCode, stdout } = await run(['--help']);

    assert.equal(exitCode, 0);
    assert.ok(stdout.includes('Usage'));
    assert.ok(stdout.includes('--all'));
    assert.ok(stdout.includes('--output-dir'));
    assert.ok(stdout.includes('--log-level'));
  });

  it('should accept language names as positional arguments', async () => {
    const { exitCode } = await run(['python', 'rust']);

    assert.equal(exitCode, 0);
  });

  it('should accept --all flag', async () => {
    const { exitCode } = await run(['--all']);

    assert.equal(exitCode, 0);
  });

  it('should accept short flags -a, -o, -l', async () => {
    const { exitCode } = await run(['-a', '-o', './out', '-l', 'debug']);

    assert.equal(exitCode, 0);
  });

  it('should accept --log-level flag', async () => {
    const { exitCode } = await run(['--all', '--log-level', 'warn']);

    assert.equal(exitCode, 0);
  });

  it('should accept --output-dir flag', async () => {
    const { exitCode } = await run(['--all', '--output-dir', '/tmp/out']);

    assert.equal(exitCode, 0);
  });

  it('should show version with --version flag', async () => {
    const { exitCode, stdout } = await run(['--version']);

    assert.equal(exitCode, 0);
    assert.ok(stdout.trim().length > 0);
  });
});

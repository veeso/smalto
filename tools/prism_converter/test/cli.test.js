import { describe, it, before, after } from 'node:test';
import assert from 'node:assert/strict';
import { execFile } from 'node:child_process';
import { fileURLToPath } from 'node:url';
import fs from 'node:fs';
import os from 'node:os';
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
  let tmpDir;

  before(() => {
    tmpDir = fs.mkdtempSync(path.join(os.tmpdir(), 'prism-converter-test-'));
  });

  after(() => {
    fs.rmSync(tmpDir, { recursive: true, force: true });
  });

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
    const outDir = path.join(tmpDir, 'langs1');
    const registry = path.join(tmpDir, 'registry1.gleam');
    const { exitCode } = await run([
      'json', '-o', outDir, '-r', registry, '-l', 'warn',
    ]);

    assert.equal(exitCode, 0);
  });

  it('should accept --all flag', async () => {
    const outDir = path.join(tmpDir, 'langs2');
    const registry = path.join(tmpDir, 'registry2.gleam');
    const { exitCode } = await run([
      '--all', '-o', outDir, '-r', registry, '-l', 'warn',
    ]);

    assert.equal(exitCode, 0);
  });

  it('should accept short flags -a, -o, -l', async () => {
    const outDir = path.join(tmpDir, 'langs3');
    const registry = path.join(tmpDir, 'registry3.gleam');
    const { exitCode } = await run([
      '-a', '-o', outDir, '-r', registry, '-l', 'warn',
    ]);

    assert.equal(exitCode, 0);
  });

  it('should accept --log-level flag', async () => {
    const outDir = path.join(tmpDir, 'langs4');
    const registry = path.join(tmpDir, 'registry4.gleam');
    const { exitCode } = await run([
      '--all', '--log-level', 'warn', '-o', outDir, '-r', registry,
    ]);

    assert.equal(exitCode, 0);
  });

  it('should accept --output-dir flag', async () => {
    const outDir = path.join(tmpDir, 'langs5');
    const registry = path.join(tmpDir, 'registry5.gleam');
    const { exitCode } = await run([
      '--all', '--output-dir', outDir, '-r', registry, '-l', 'warn',
    ]);

    assert.equal(exitCode, 0);
  });

  it('should show version with --version flag', async () => {
    const { exitCode, stdout } = await run(['--version']);

    assert.equal(exitCode, 0);
    assert.ok(stdout.trim().length > 0);
  });
});

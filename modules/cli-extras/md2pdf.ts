#!/usr/bin/env nix
/*
#!nix shell nixpkgs#bun nixpkgs#pandoc --impure --command bun
*/

import { execFile } from 'node:child_process'
import { dirname } from 'node:path'
import { promisify } from 'node:util'
import { Command } from 'commander'

import fs from 'fs-extra'

const execFileAsync = promisify(execFile)

const PANDOC_OPTIONS = [
  '-V', 'CJKmainfont=Noto Serif CJK HK',
  '-V', 'papersize:a4',
  '-V', 'geometry:margin=1in',
]

async function processFile(inputFile: string): Promise<void> {
  const outputFile = inputFile.replace(/\.md$/, '.pdf')
  const outputDir = dirname(outputFile)

  try {
    // Ensure output directory exists
    await fs.ensureDir(outputDir)

    await execFileAsync('pandoc', ['-s', '-o', outputFile, '--pdf-engine=xelatex', ...PANDOC_OPTIONS, inputFile])
    console.log(`Converted ${inputFile} to ${outputFile}`)
  }
  catch (error) {
    throw new Error(`Failed to convert ${inputFile}: ${error instanceof Error ? error.message : String(error)}`)
  }
}

const program = new Command()

program
  .name('md2pdf')
  .description('Convert markdown files to PDF using Pandoc with specified options.')
  .version('1.0.0')
  .argument('<files...>', 'Markdown files to convert')
  .action(async (files: string[]) => {
    const nonMdFiles = files.filter(file => !file.endsWith('.md'))

    if (nonMdFiles.length > 0) {
      console.error(`The following files are not markdown (.md) files: ${nonMdFiles.join(', ')}`)
      process.exit(1)
    }

    const nonExistentFiles = files.filter(file => !fs.existsSync(file))

    if (nonExistentFiles.length > 0) {
      console.error(`The following files do not exist: ${nonExistentFiles.join(', ')}`)
      process.exit(1)
    }

    for (const file of files) {
      await processFile(file)
    }
  })

program.parse()

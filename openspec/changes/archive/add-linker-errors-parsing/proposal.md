# Change: Add Linker Errors Parsing

## Why
Currently xcsift only parses compiler errors. Linker errors have a completely different format and are not captured, leaving AI agents without critical information about undefined symbols, missing frameworks, and architecture mismatches.

## What Changes
- Add regex patterns for linker error detection
- Parse "Undefined symbols for architecture" errors
- Extract symbol names, referenced files, and architecture info
- Add `LinkerError` data structure to BuildResult

## Impact
- Affected specs: output-parsing
- Affected code: OutputParser.swift, main.swift
- New data structure: `LinkerError`

# Change: Add Fix-it Suggestions Extraction

## Why
Swift compiler provides fix-it suggestions that can automatically resolve many errors and warnings. AI agents can use these suggestions to auto-apply fixes, significantly reducing iteration time.

## What Changes
- Extract fix-it suggestions from compiler output
- Add `fixit` field to BuildError and BuildWarning structures
- Parse both inline fix-its and multi-line fix-it suggestions

## Impact
- Affected specs: output-parsing
- Affected code: OutputParser.swift
- Modified structures: `BuildError`, `BuildWarning`

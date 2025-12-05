# Change: Add Duplicate Symbol Errors Parsing

## Why
Duplicate symbol errors are a common linker issue that occurs when the same symbol is defined in multiple object files. This is distinct from undefined symbol errors and requires separate parsing logic.

## What Changes
- Add regex patterns for duplicate symbol detection
- Parse conflicting file locations
- Add structured output for duplicate symbols

## Impact
- Affected specs: output-parsing
- Affected code: OutputParser.swift
- Related to: add-linker-errors-parsing (can share LinkerError structure)

# Change: Add Build Phases Parsing

## Why
Understanding which build phases take the longest helps AI agents suggest optimizations. Build phases include compiling, linking, copying resources, running scripts, etc.

## What Changes
- Parse build phase markers from xcodebuild output
- Track phase timing and file counts
- Add `phases` section to BuildResult

## Impact
- Affected specs: output-parsing
- Affected code: OutputParser.swift
- New data structure: `BuildPhase`

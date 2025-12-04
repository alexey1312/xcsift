# Change: Add Dependency Graph Extraction

## Why
Understanding module dependencies helps AI agents reason about build order, identify circular dependencies, and suggest modularization improvements. This is especially valuable for large projects.

## What Changes
- Parse target dependencies from xcodebuild output
- Extract import statements from compilation logs
- Build dependency graph representation
- Add `dependencies` section to BuildResult

## Impact
- Affected specs: output-parsing
- Affected code: OutputParser.swift
- New data structure: `DependencyGraph`

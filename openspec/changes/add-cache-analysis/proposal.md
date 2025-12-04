# Change: Add Cache Hit/Miss Analysis

## Why
Build cache effectiveness significantly impacts build times. AI agents can use cache analysis data to suggest build configuration improvements and identify cache invalidation issues.

## What Changes
- Parse cache hit/miss statistics from xcodebuild output
- Calculate cache hit rate
- Add `cache` section to BuildResult

## Impact
- Affected specs: output-parsing
- Affected code: OutputParser.swift
- New data structure: `CacheStats`

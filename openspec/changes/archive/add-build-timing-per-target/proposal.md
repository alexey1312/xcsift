# Change: Add Build Timing Per Target

## Why
AI agents need detailed timing information to identify build bottlenecks and optimize build times. Currently xcsift only captures total build time, missing valuable per-target timing data.

## What Changes
- Parse build timing for individual targets
- Extract compile, link, and total times per target
- Add `timing` section to BuildResult with per-target breakdown

## Impact
- Affected specs: output-parsing
- Affected code: OutputParser.swift
- New data structure: `TargetTiming`

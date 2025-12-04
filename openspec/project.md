# Project Context

## Purpose
xcsift is a Swift command-line tool that parses and formats xcodebuild/SPM output for coding agents. It transforms verbose Xcode build output into token-efficient JSON/TOON format optimized for machine readability rather than human consumption.

## Tech Stack
- Swift 6.0+
- Swift ArgumentParser for CLI
- TOONEncoder for token-efficient output
- Foundation for regex, JSON encoding
- XCTest for testing

## Project Conventions

### Code Style
- Swift standard style with 4-space indentation
- Data structures defined in OutputParser.swift
- CodingKeys for JSON field naming (snake_case)

### Architecture Patterns
- Two-component architecture: main.swift (entry point) + OutputParser.swift (core logic)
- Regex-based line parsing for all output formats
- Data flow: stdin → parse → BuildResult → JSON/TOON output

### Testing Strategy
- TDD approach: write tests first, then implementation
- XCTest framework in Tests/OutputParserTests.swift
- Cover: parsing, encoding, edge cases
- Run: `swift test`

### Git Workflow
- Feature branches from master
- PRs with clear descriptions
- CI runs on macOS and Linux

## Domain Context
- xcodebuild outputs errors/warnings to stderr
- SPM uses different output formats than xcodebuild
- Code coverage: SPM uses .profraw, xcodebuild uses .xcresult
- Target audience: AI/LLM agents parsing build output

## Important Constraints
- macOS 15+ required for full functionality
- Linux support: build/test parsing works, coverage tools are macOS-only
- Token efficiency is key: minimize output size for LLM consumption

## External Dependencies
- llvm-profdata, llvm-cov: SPM coverage conversion
- xcrun xccov: xcodebuild coverage conversion

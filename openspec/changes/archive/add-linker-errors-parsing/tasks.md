# Tasks: Add Linker Errors Parsing

**STATUS: COMPLETED** - Implemented in branch `alexey1312/add-linker-errors-parsing`

## 1. Test First (TDD)
- [x] 1.1 Add test for basic undefined symbol linker error
- [x] 1.2 Add test for multiple undefined symbols
- [x] 1.3 Add test for architecture mismatch errors
- [x] 1.4 Add test for "symbol(s) not found" summary line
- [x] 1.5 Add test for JSON encoding of LinkerError

## 2. Implementation
- [x] 2.1 Define `LinkerError` struct with symbol, architecture, referencedFrom, message, conflictingFiles fields
- [x] 2.2 Add linker error regex patterns to OutputParser
- [x] 2.3 Implement multi-line parsing for linker errors (undefined symbols)
- [x] 2.4 Add `linker_errors` field to BuildResult
- [x] 2.5 Update summary to include linker_errors count

## 3. Integration
- [x] 3.1 Update TOON encoder support
- [x] 3.2 Update GitHub Actions annotations
- [x] 3.3 Update CLAUDE.md documentation
- [x] 3.4 Update README.md documentation

## Additional Features Implemented
- [x] Framework not found parsing (`ld: framework not found`)
- [x] Library not found parsing (`ld: library not found for -l`)
- [x] Architecture mismatch parsing (`building for iOS Simulator, but linking in dylib built for iOS`)
- [x] Real-world fixture-based test (linker-error-output.txt)
- [x] Swift mangled symbol parsing

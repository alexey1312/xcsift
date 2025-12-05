# Tasks: Add Linker Errors Parsing

## 1. Test First (TDD)
- [ ] 1.1 Add test for basic undefined symbol linker error
- [ ] 1.2 Add test for multiple undefined symbols
- [ ] 1.3 Add test for architecture mismatch errors
- [ ] 1.4 Add test for "symbol(s) not found" summary line
- [ ] 1.5 Add test for JSON encoding of LinkerError

## 2. Implementation
- [ ] 2.1 Define `LinkerError` struct with symbol, architecture, referencedFrom fields
- [ ] 2.2 Add linker error regex patterns to OutputParser
- [ ] 2.3 Implement multi-line parsing for linker errors
- [ ] 2.4 Add `linker_errors` field to BuildResult
- [ ] 2.5 Update summary to include linker_errors count

## 3. Integration
- [ ] 3.1 Update TOON encoder support
- [ ] 3.2 Update GitHub Actions annotations
- [ ] 3.3 Update CLAUDE.md documentation

# Tasks: Add Duplicate Symbol Errors Parsing

## 1. Test First (TDD)
- [ ] 1.1 Add test for basic duplicate symbol error
- [ ] 1.2 Add test for duplicate symbol in multiple files
- [ ] 1.3 Add test for duplicate _main symbol
- [ ] 1.4 Add test for JSON encoding of duplicate symbols

## 2. Implementation
- [ ] 2.1 Add regex pattern for "duplicate symbol" detection
- [ ] 2.2 Parse conflicting file paths
- [ ] 2.3 Store as LinkerError with type: "duplicate"
- [ ] 2.4 Handle multi-line duplicate symbol output

## 3. Integration
- [ ] 3.1 Update TOON encoder support
- [ ] 3.2 Update GitHub Actions annotations
- [ ] 3.3 Update CLAUDE.md documentation

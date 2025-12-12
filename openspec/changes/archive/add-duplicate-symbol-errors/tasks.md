# Tasks: Add Duplicate Symbol Errors Parsing

**STATUS: COMPLETED** - Implemented in branch `alexey1312/add-linker-errors-parsing`

## 1. Test First (TDD)
- [x] 1.1 Add test for basic duplicate symbol error (`testParseDuplicateSymbol`)
- [x] 1.2 Add test for duplicate symbol with double quotes (`testParseDuplicateSymbolWithDoubleQuotes`)
- [x] 1.3 Add test for JSON encoding of duplicate symbols (`testParseDuplicateSymbolJSONEncoding`)

## 2. Implementation
- [x] 2.1 Add regex pattern for "duplicate symbol" detection (single and double quotes)
- [x] 2.2 Parse conflicting file paths into `conflictingFiles` array
- [x] 2.3 Store as LinkerError with structured fields (symbol, architecture, conflictingFiles)
- [x] 2.4 Handle multi-line duplicate symbol output (symbol line + file paths + summary line)

## 3. Integration
- [x] 3.1 Update TOON encoder support (works automatically with LinkerError)
- [x] 3.2 Update GitHub Actions annotations (works automatically)
- [x] 3.3 Update CLAUDE.md documentation
- [x] 3.4 Update README.md documentation with JSON example

## Notes
- Merged with `add-linker-errors-parsing` proposal since duplicate symbols are a type of linker error
- Uses `conflictingFiles` array instead of `referencedFrom` to show which object files contain the duplicate
- Architecture extracted from `ld: N duplicate symbol(s) for architecture X` summary line

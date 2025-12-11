# Tasks: Add Fix-it Suggestions Extraction

## 1. Test First (TDD)
- [ ] 1.1 Add test for error with single fix-it suggestion
- [ ] 1.2 Add test for warning with fix-it suggestion
- [ ] 1.3 Add test for "did you mean" suggestions
- [ ] 1.4 Add test for multiple fix-it suggestions on one error
- [ ] 1.5 Add test for fix-it with code replacement

## 2. Implementation
- [ ] 2.1 Add `fixit` optional field to BuildError struct
- [ ] 2.2 Add `fixit` optional field to BuildWarning struct
- [ ] 2.3 Add regex pattern for fix-it line detection
- [ ] 2.4 Link fix-it to preceding error/warning
- [ ] 2.5 Handle multi-line fix-it suggestions

## 3. Integration
- [ ] 3.1 Update JSON encoding
- [ ] 3.2 Update TOON encoder support
- [ ] 3.3 Update CLAUDE.md documentation

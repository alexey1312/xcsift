# Tasks: Add Build Phases Parsing

## 1. Test First (TDD)
- [ ] 1.1 Add test for "Compile Swift source files" phase
- [ ] 1.2 Add test for "Link" phase
- [ ] 1.3 Add test for "Copy resources" phase
- [ ] 1.4 Add test for "Run script" phase
- [ ] 1.5 Add test for JSON encoding of phases

## 2. Implementation
- [ ] 2.1 Define `BuildPhase` struct with name, duration, fileCount fields
- [ ] 2.2 Add regex for phase start/end markers
- [ ] 2.3 Track file counts per phase
- [ ] 2.4 Calculate phase durations
- [ ] 2.5 Add `phases` section to BuildResult

## 3. Integration
- [ ] 3.1 Add `--phases` flag to show phase breakdown (optional)
- [ ] 3.2 Update TOON encoder support
- [ ] 3.3 Update CLAUDE.md documentation

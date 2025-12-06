# Tasks: Add Build Timing Per Target

## 1. Test First (TDD)
- [ ] 1.1 Add test for single target timing extraction
- [ ] 1.2 Add test for multiple targets timing
- [ ] 1.3 Add test for SPM target timing format
- [ ] 1.4 Add test for xcodebuild target timing format
- [ ] 1.5 Add test for JSON encoding of timing data

## 2. Implementation
- [ ] 2.1 Define `TargetTiming` struct with name, duration fields
- [ ] 2.2 Add regex for "Build target X completed" patterns
- [ ] 2.3 Add regex for SPM timing patterns
- [ ] 2.4 Track target start/end times
- [ ] 2.5 Add `timing` section to BuildResult

## 3. Integration
- [ ] 3.1 Add `--timing` flag to show detailed timing (optional)
- [ ] 3.2 Update TOON encoder support
- [ ] 3.3 Update CLAUDE.md documentation

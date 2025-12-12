# Tasks: Add Dependency Graph Extraction

## 1. Test First (TDD)
- [ ] 1.1 Add test for target dependency detection
- [ ] 1.2 Add test for multiple dependencies
- [ ] 1.3 Add test for circular dependency detection
- [ ] 1.4 Add test for JSON encoding of dependency graph

## 2. Implementation
- [ ] 2.1 Define `DependencyNode` struct with target, dependencies fields
- [ ] 2.2 Add regex for dependency markers in xcodebuild output
- [ ] 2.3 Parse target build order
- [ ] 2.4 Build adjacency list representation
- [ ] 2.5 Add `dependencies` section to BuildResult

## 3. Integration
- [ ] 3.1 Add `--dependencies` flag to show graph (optional)
- [ ] 3.2 Update TOON encoder support
- [ ] 3.3 Update CLAUDE.md documentation

# Tasks: Add Cache Hit/Miss Analysis

## 1. Test First (TDD)
- [ ] 1.1 Add test for cache hit detection
- [ ] 1.2 Add test for cache miss detection
- [ ] 1.3 Add test for cache hit rate calculation
- [ ] 1.4 Add test for JSON encoding of cache stats

## 2. Implementation
- [ ] 2.1 Define `CacheStats` struct with hits, misses, hitRate fields
- [ ] 2.2 Add regex for "Using cached" patterns
- [ ] 2.3 Add regex for compilation (cache miss) patterns
- [ ] 2.4 Calculate hit rate percentage
- [ ] 2.5 Add `cache` section to BuildResult

## 3. Integration
- [ ] 3.1 Add `--cache` flag to show cache stats (optional)
- [ ] 3.2 Update TOON encoder support
- [ ] 3.3 Update CLAUDE.md documentation

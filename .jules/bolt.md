## 2024-05-23 - Substring Optimization in Parsers
**Learning:** In Swift text processing, passing `Substring` (String.SubSequence) instead of `String` to parsing functions can significantly reduce memory allocation overhead, especially in hot loops processing large inputs.
**Action:** When refactoring parsers, ensure internal methods accept `Substring` and only convert to `String` when interacting with legacy APIs or when ownership is required. Use `String(line)` lazily or cache it if used multiple times in a conditional block.

## ADDED Requirements

### Requirement: Cache Hit/Miss Analysis
The system SHALL parse build cache statistics and calculate cache effectiveness metrics.

#### Scenario: Cache hit detection
- **GIVEN** xcodebuild output containing cached task markers
- **WHEN** the output is parsed
- **THEN** cache hits SHALL be counted

#### Scenario: Cache miss detection
- **GIVEN** xcodebuild output containing compilation tasks
- **WHEN** the output is parsed
- **THEN** cache misses SHALL be counted for compiled files

#### Scenario: Cache hit rate calculation
- **GIVEN** a build with 145 cache hits and 23 cache misses
- **WHEN** the output is parsed
- **THEN** cache stats SHALL include:
  - hits: 145
  - misses: 23
  - hitRate: "86.3%"

#### Scenario: JSON output with cache stats
- **GIVEN** a build with cache statistics
- **WHEN** JSON output is generated with `--cache` flag
- **THEN** the output SHALL include:
  ```json
  {
    "cache": {
      "hits": 145,
      "misses": 23,
      "hit_rate": "86.3%"
    }
  }
  ```

#### Scenario: Cache stats omitted by default
- **GIVEN** a build with cache statistics
- **WHEN** JSON output is generated without `--cache` flag
- **THEN** the cache section SHALL be omitted to reduce token usage

#### Scenario: Summary includes cache hit rate
- **GIVEN** a build with cache statistics and `--cache` flag
- **WHEN** JSON output is generated
- **THEN** summary MAY include `"cache_hit_rate": "86.3%"`

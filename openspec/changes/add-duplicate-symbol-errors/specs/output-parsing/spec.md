## ADDED Requirements

### Requirement: Duplicate Symbol Error Parsing
The system SHALL parse duplicate symbol linker errors and extract the symbol name and conflicting file locations.

#### Scenario: Basic duplicate symbol error
- **GIVEN** xcodebuild output containing:
  ```
  duplicate symbol '_main' in:
      /path/to/file1.o
      /path/to/file2.o
  ld: 1 duplicate symbol for architecture arm64
  ```
- **WHEN** the output is parsed
- **THEN** a LinkerError SHALL be created with:
  - type: "duplicate"
  - symbol: "_main"
  - conflictingFiles: ["/path/to/file1.o", "/path/to/file2.o"]
  - architecture: "arm64"

#### Scenario: Multiple duplicate symbols
- **GIVEN** output with multiple duplicate symbol errors
- **WHEN** the output is parsed
- **THEN** each duplicate symbol SHALL be captured separately

#### Scenario: JSON output includes duplicate symbols
- **GIVEN** a build with duplicate symbol errors
- **WHEN** JSON output is generated
- **THEN** the output SHALL include:
  ```json
  {
    "linker_errors": [
      {
        "type": "duplicate",
        "symbol": "_main",
        "conflicting_files": [
          "/path/to/file1.o",
          "/path/to/file2.o"
        ],
        "architecture": "arm64"
      }
    ]
  }
  ```

#### Scenario: Summary includes duplicate count
- **GIVEN** a build with 3 duplicate symbol errors
- **WHEN** JSON output is generated
- **THEN** summary SHALL include `"duplicate_symbols": 3`

## ADDED Requirements

### Requirement: Build Phases Parsing
The system SHALL parse build phase information from xcodebuild output, including phase names, durations, and file counts.

#### Scenario: Compile phase detection
- **GIVEN** xcodebuild output containing:
  ```
  CompileSwiftSources normal arm64 (in target 'MyApp' from project 'MyApp')
      Compiling 42 swift files
  ```
- **WHEN** the output is parsed
- **THEN** a BuildPhase SHALL be created with:
  - name: "CompileSwiftSources"
  - target: "MyApp"
  - files: 42

#### Scenario: Link phase detection
- **GIVEN** xcodebuild output containing:
  ```
  Ld /path/to/MyApp.app/MyApp normal arm64 (in target 'MyApp')
  ```
- **WHEN** the output is parsed
- **THEN** a BuildPhase SHALL be created with:
  - name: "Link"
  - target: "MyApp"

#### Scenario: Multiple phases captured
- **GIVEN** a complete xcodebuild output
- **WHEN** the output is parsed
- **THEN** all major phases SHALL be captured in order

#### Scenario: JSON output with phases
- **GIVEN** a build with phase information
- **WHEN** JSON output is generated with `--phases` flag
- **THEN** the output SHALL include:
  ```json
  {
    "phases": [
      {
        "name": "CompileSwiftSources",
        "target": "MyApp",
        "files": 42,
        "duration": "12.3s"
      },
      {
        "name": "Link",
        "target": "MyApp",
        "duration": "3.2s"
      }
    ]
  }
  ```

#### Scenario: Phases omitted by default
- **GIVEN** a build with phase information
- **WHEN** JSON output is generated without `--phases` flag
- **THEN** the phases section SHALL be omitted to reduce token usage

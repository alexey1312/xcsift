## ADDED Requirements

### Requirement: Build Timing Per Target
The system SHALL parse and report build timing information for each target in the build.

#### Scenario: Single target timing
- **GIVEN** xcodebuild output containing:
  ```
  Build target MyApp completed in 23.1s
  ** BUILD SUCCEEDED ** [45.2s]
  ```
- **WHEN** the output is parsed
- **THEN** timing data SHALL include:
  - total: "45.2s"
  - targets: [{name: "MyApp", duration: "23.1s"}]

#### Scenario: Multiple targets timing
- **GIVEN** xcodebuild output with multiple targets
- **WHEN** the output is parsed
- **THEN** each target's timing SHALL be captured separately

#### Scenario: SPM build timing
- **GIVEN** SPM output containing:
  ```
  Building for debugging...
  [42/42] Linking xcsift
  Build complete! (12.34s)
  ```
- **WHEN** the output is parsed
- **THEN** total build time SHALL be captured as "12.34s"

#### Scenario: JSON output with timing
- **GIVEN** a build with timing information
- **WHEN** JSON output is generated
- **THEN** the output SHALL include:
  ```json
  {
    "timing": {
      "total": "45.2s",
      "targets": [
        {"name": "MyFramework", "duration": "12.4s"},
        {"name": "MyApp", "duration": "23.1s"}
      ]
    }
  }
  ```

#### Scenario: Summary includes build time
- **GIVEN** a successful build with timing data
- **WHEN** JSON output is generated
- **THEN** summary SHALL include `"build_time": "45.2s"`

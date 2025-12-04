## ADDED Requirements

### Requirement: Dependency Graph Extraction
The system SHALL parse target dependencies from xcodebuild output and represent them as a dependency graph.

#### Scenario: Single dependency detection
- **GIVEN** xcodebuild output showing target "MyApp" depends on "MyFramework"
- **WHEN** the output is parsed
- **THEN** a dependency edge SHALL be created from MyApp to MyFramework

#### Scenario: Multiple dependencies
- **GIVEN** xcodebuild output with complex target relationships
- **WHEN** the output is parsed
- **THEN** all dependencies SHALL be captured as a graph

#### Scenario: Build order extraction
- **GIVEN** xcodebuild output showing build order
- **WHEN** the output is parsed
- **THEN** targets SHALL be ordered by their build sequence

#### Scenario: JSON output with dependencies
- **GIVEN** a build with dependency information
- **WHEN** JSON output is generated with `--dependencies` flag
- **THEN** the output SHALL include:
  ```json
  {
    "dependencies": {
      "targets": [
        {
          "name": "MyFramework",
          "depends_on": []
        },
        {
          "name": "MyApp",
          "depends_on": ["MyFramework"]
        }
      ]
    }
  }
  ```

#### Scenario: Dependencies omitted by default
- **GIVEN** a build with dependency information
- **WHEN** JSON output is generated without `--dependencies` flag
- **THEN** the dependencies section SHALL be omitted to reduce token usage

#### Scenario: Root targets identification
- **GIVEN** a dependency graph
- **WHEN** JSON output is generated
- **THEN** targets with no dependents MAY be marked as "root" targets

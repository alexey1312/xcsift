## ADDED Requirements

### Requirement: Linker Error Parsing
The system SHALL parse linker errors from xcodebuild output and extract structured information about undefined symbols.

#### Scenario: Basic undefined symbol error
- **GIVEN** xcodebuild output containing:
  ```
  Undefined symbols for architecture arm64:
    "_OBJC_CLASS_$_SomeClass", referenced from:
        objc-class-ref in ViewController.o
  ld: symbol(s) not found for architecture arm64
  ```
- **WHEN** the output is parsed
- **THEN** a LinkerError SHALL be created with:
  - symbol: "_OBJC_CLASS_$_SomeClass"
  - architecture: "arm64"
  - referencedFrom: "ViewController.o"

#### Scenario: Multiple undefined symbols
- **GIVEN** xcodebuild output with multiple undefined symbols
- **WHEN** the output is parsed
- **THEN** each symbol SHALL be captured as a separate LinkerError

#### Scenario: JSON output includes linker errors
- **GIVEN** a build with linker errors
- **WHEN** JSON output is generated
- **THEN** the output SHALL include:
  ```json
  {
    "linker_errors": [
      {
        "symbol": "_OBJC_CLASS_$_SomeClass",
        "architecture": "arm64",
        "referenced_from": "ViewController.o"
      }
    ],
    "summary": {
      "linker_errors": 1
    }
  }
  ```

#### Scenario: Architecture mismatch error
- **GIVEN** output containing "building for iOS Simulator, but linking in dylib built for iOS"
- **WHEN** the output is parsed
- **THEN** a LinkerError SHALL capture the architecture mismatch details

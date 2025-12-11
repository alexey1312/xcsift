## ADDED Requirements

### Requirement: Fix-it Suggestions Extraction
The system SHALL extract fix-it suggestions from compiler output and associate them with the corresponding error or warning.

#### Scenario: Error with fix-it suggestion
- **GIVEN** compiler output containing:
  ```
  main.swift:15:5: error: use of undeclared identifier 'foo'
  main.swift:15:5: note: did you mean 'for'?
  ```
- **WHEN** the output is parsed
- **THEN** the BuildError SHALL include:
  - message: "use of undeclared identifier 'foo'"
  - fixit: "did you mean 'for'?"

#### Scenario: Warning with replacement fix-it
- **GIVEN** compiler output containing:
  ```
  Parser.swift:20:10: warning: variable 'result' was never mutated
  Parser.swift:20:10: note: change 'var' to 'let' to make it constant
      var result = compute()
      ~~~
      let
  ```
- **WHEN** the output is parsed
- **THEN** the BuildWarning SHALL include:
  - message: "variable 'result' was never mutated"
  - fixit: "change 'var' to 'let' to make it constant"

#### Scenario: Error without fix-it
- **GIVEN** a compiler error without a fix-it suggestion
- **WHEN** the output is parsed
- **THEN** the BuildError fixit field SHALL be null/omitted

#### Scenario: JSON output with fix-it
- **GIVEN** errors with fix-it suggestions
- **WHEN** JSON output is generated
- **THEN** the output SHALL include:
  ```json
  {
    "errors": [
      {
        "file": "main.swift",
        "line": 15,
        "message": "use of undeclared identifier 'foo'",
        "fixit": "did you mean 'for'?"
      }
    ]
  }
  ```

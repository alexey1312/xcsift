# Specification: halp CLI

## ADDED Requirements

### Requirement: Command Explanation
The system SHALL explain CLI commands in plain language when invoked with a command name.

#### Scenario: Basic command explanation
- **GIVEN** halp is installed and a provider is available
- **WHEN** user runs `halp git rebase`
- **THEN** system outputs a plain-language explanation of `git rebase`
- **AND** includes common use cases and gotchas

#### Scenario: Complex command with arguments
- **GIVEN** halp is installed and a provider is available
- **WHEN** user runs `halp --explain "find . -name '*.swift' -exec rm {} \;"`
- **THEN** system breaks down each argument and explains its purpose
- **AND** warns about destructive operations if applicable

### Requirement: Command Suggestion
The system SHALL suggest appropriate CLI commands based on natural language descriptions.

#### Scenario: Simple task suggestion
- **GIVEN** halp is installed and a provider is available
- **WHEN** user runs `halp --suggest "find large files in current directory"`
- **THEN** system outputs one or more commands that accomplish the task
- **AND** explains what each suggested command does

#### Scenario: No suitable command found
- **GIVEN** halp is installed and a provider is available
- **WHEN** user runs `halp --suggest "impossible task that no CLI can do"`
- **THEN** system indicates no direct CLI solution exists
- **AND** may suggest alternative approaches

### Requirement: Usage Examples
The system SHALL provide practical usage examples for CLI commands.

#### Scenario: Command examples
- **GIVEN** halp is installed and a provider is available
- **WHEN** user runs `halp --examples tar`
- **THEN** system outputs common tar usage patterns
- **AND** examples are copy-pasteable with realistic arguments

### Requirement: Man Page Summarization
The system SHALL summarize man pages in plain language.

#### Scenario: Summarize man page
- **GIVEN** halp is installed and a provider is available
- **GIVEN** man page exists for the command
- **WHEN** user runs `halp --man rsync`
- **THEN** system outputs a concise summary of rsync's purpose and key options
- **AND** highlights the most commonly used flags

#### Scenario: Man page not found
- **GIVEN** halp is installed
- **WHEN** user runs `halp --man nonexistent-command`
- **THEN** system indicates man page not found
- **AND** falls back to LLM knowledge if available

### Requirement: Provider Fallback Chain
The system SHALL automatically fall back through configured providers when the primary is unavailable.

#### Scenario: FoundationModel available
- **GIVEN** macOS 26+ with FoundationModel enabled
- **WHEN** user runs any halp command without `--provider` flag
- **THEN** system uses FoundationModel for inference
- **AND** no network requests are made

#### Scenario: FoundationModel unavailable, Ollama available
- **GIVEN** macOS < 26 or FoundationModel disabled
- **GIVEN** Ollama is running locally
- **WHEN** user runs any halp command
- **THEN** system falls back to Ollama
- **AND** displays message about using Ollama

#### Scenario: Local providers unavailable, cloud configured
- **GIVEN** FoundationModel and Ollama unavailable
- **GIVEN** ANTHROPIC_API_KEY environment variable is set
- **WHEN** user runs any halp command
- **THEN** system uses Anthropic API
- **AND** displays message about using cloud provider

#### Scenario: No providers available
- **GIVEN** no providers are available or configured
- **WHEN** user runs any halp command
- **THEN** system exits with error code 1
- **AND** displays setup instructions for available providers

### Requirement: Provider Selection Override
The system SHALL allow explicit provider selection via CLI flag.

#### Scenario: Force specific provider
- **GIVEN** halp is installed
- **WHEN** user runs `halp --provider ollama git status`
- **THEN** system uses Ollama regardless of fallback chain
- **AND** fails if Ollama is unavailable (no fallback)

### Requirement: JSON Output
The system SHALL support JSON output for scripting integration.

#### Scenario: JSON output mode
- **GIVEN** halp is installed and a provider is available
- **WHEN** user runs `halp git commit --json`
- **THEN** system outputs valid JSON with structured response
- **AND** JSON includes fields: command, explanation, examples (if applicable)

### Requirement: Configuration File
The system SHALL support optional configuration via ~/.config/halp/config.toml.

#### Scenario: Custom default provider
- **GIVEN** ~/.config/halp/config.toml exists with `default = "ollama"`
- **WHEN** user runs halp without `--provider` flag
- **THEN** system uses Ollama as first choice instead of FoundationModel

#### Scenario: No configuration file
- **GIVEN** ~/.config/halp/config.toml does not exist
- **WHEN** user runs halp
- **THEN** system uses built-in defaults (FoundationModel → Ollama → Cloud)

### Requirement: Context Gathering
The system SHALL gather context from multiple sources to improve LLM responses.

#### Scenario: Include help output in context
- **GIVEN** target command supports `--help`
- **WHEN** halp explains the command
- **THEN** system captures `--help` output
- **AND** includes it in the LLM prompt for accuracy

#### Scenario: Include man page in context
- **GIVEN** man page exists for target command
- **WHEN** halp explains or summarizes the command
- **THEN** system extracts man page content
- **AND** includes relevant sections in the LLM prompt

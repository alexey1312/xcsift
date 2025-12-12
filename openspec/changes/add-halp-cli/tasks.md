# Tasks: halp CLI Implementation

## 1. Project Setup
- [ ] 1.1 Create Package.swift with dependencies (ArgumentParser, AnyLanguageModel, Noora)
- [ ] 1.2 Configure trait-based imports for AnyLanguageModel providers
- [ ] 1.3 Set up CI workflow (macOS + Linux)
- [ ] 1.4 Add README.md with installation instructions

## 2. Core CLI Structure
- [ ] 2.1 Implement main.swift with ArgumentParser command structure
- [ ] 2.2 Define subcommands: `explain`, `suggest`, `examples`, `man`
- [ ] 2.3 Add flags: `--provider`, `--json`, `--verbose`, `--no-cache`
- [ ] 2.4 Implement `--version` and `--help`

## 3. Context Gathering
- [ ] 3.1 Implement `--help` output capture for target commands
- [ ] 3.2 Implement `man` page extraction
- [ ] 3.3 Implement `tldr` page lookup (optional)
- [ ] 3.4 Create ContextGatherer protocol for testability

## 4. Provider Management
- [ ] 4.1 Implement ProviderManager with fallback chain
- [ ] 4.2 Add FoundationModel provider (macOS 26+)
- [ ] 4.3 Add Ollama provider with configurable host/model
- [ ] 4.4 Add Anthropic provider with API key from env
- [ ] 4.5 Add OpenAI provider with API key from env
- [ ] 4.6 Implement provider availability detection

## 5. HalpEngine Core
- [ ] 5.1 Implement prompt templates for each mode (explain, suggest, examples, man)
- [ ] 5.2 Build context injection into prompts
- [ ] 5.3 Implement response parsing and formatting
- [ ] 5.4 Add JSON output mode

## 6. Configuration
- [ ] 6.1 Define Config struct with Codable
- [ ] 6.2 Implement TOML parsing for ~/.config/halp/config.toml
- [ ] 6.3 Add environment variable overrides
- [ ] 6.4 Implement config validation

## 7. Terminal UI (Noora)
- [ ] 7.1 Create UI.swift wrapper for Noora components
- [ ] 7.2 Implement progress spinner for LLM inference
- [ ] 7.3 Add success/warning/error alerts for provider status
- [ ] 7.4 Implement styled text output for explanations and examples
- [ ] 7.5 Add interactive prompts for provider selection (when multiple available)
- [ ] 7.6 Implement step indicators for multi-stage operations
- [ ] 7.7 Add response caching (SQLite or file-based)
- [ ] 7.8 Implement streaming output with Noora progress (optional)

## 8. Testing
- [ ] 8.1 Unit tests for ContextGatherer
- [ ] 8.2 Unit tests for prompt construction
- [ ] 8.3 Integration tests with mock LLM responses
- [ ] 8.4 End-to-end tests with real providers (manual/CI)

## 9. Documentation
- [ ] 9.1 Write comprehensive README
- [ ] 9.2 Add man page for halp itself
- [ ] 9.3 Create example usage guide
- [ ] 9.4 Document configuration options

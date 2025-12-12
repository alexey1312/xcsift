# Design: halp CLI Architecture

## Context

Creating an LLM-powered CLI help assistant that provides intelligent explanations for command-line tools. Must work offline by default (FoundationModel) with graceful fallback to cloud providers.

## Goals / Non-Goals

### Goals
- Zero-config experience on macOS 26+ (FoundationModel just works)
- Sub-second response for simple queries (local inference)
- Privacy-first: no data leaves device by default
- Extensible provider system via AnyLanguageModel

### Non-Goals
- Not a general-purpose LLM chat interface
- Not a shell replacement or command executor
- Not supporting Windows (Swift/FoundationModel limitation)

## Decisions

### D1: Use AnyLanguageModel for provider abstraction

**Decision**: Depend on `mattt/anylanguagemodel` package

**Rationale**:
- Unified API across FoundationModel, Ollama, Anthropic, OpenAI
- Trait-based dependencies keep binary size minimal
- Active maintenance, Swift 6 compatible
- `@Generable` macro simplifies structured output

**Alternatives considered**:
- Direct FoundationModel API: Locks to Apple only, no fallback
- Manual multi-provider: Duplicates AnyLanguageModel's work

### D2: Provider priority chain

**Decision**: FoundationModel → Ollama → Anthropic → OpenAI

**Rationale**:
- FoundationModel: Free, offline, private (best UX)
- Ollama: Free, offline, user-controlled models
- Anthropic/OpenAI: Paid fallback for complex queries

**Configuration**:
```swift
enum Provider: String, CaseIterable {
    case foundation  // Default on macOS 26+
    case ollama      // Local fallback
    case anthropic   // Cloud fallback
    case openai      // Cloud fallback
}
```

### D3: Command information sources

**Decision**: Multi-source context gathering

**Sources** (in order):
1. `--help` / `-h` output from the command itself
2. `man` page content (if available)
3. `tldr` pages (if installed)
4. Built-in knowledge from LLM

**Rationale**: Combining sources gives LLM accurate, command-specific context.

### D4: Output format

**Decision**: Plain text by default, optional JSON for scripting

```bash
halp git rebase
# Plain explanation

halp git rebase --json
# {"command": "git rebase", "explanation": "...", "examples": [...]}
```

### D5: Configuration file

**Decision**: Optional `~/.config/halp/config.toml`

```toml
[provider]
default = "foundation"
fallback = ["ollama", "anthropic"]

[ollama]
model = "llama3.2"
host = "http://localhost:11434"

[anthropic]
api_key_env = "ANTHROPIC_API_KEY"
model = "claude-sonnet-4-20250514"

[openai]
api_key_env = "OPENAI_API_KEY"
model = "gpt-4o"
```

## Architecture

```
┌─────────────────────────────────────────────────────────┐
│                      halp CLI                           │
│  (Swift ArgumentParser)                                 │
├─────────────────────────────────────────────────────────┤
│                   HalpEngine                            │
│  - Context gathering (help, man, tldr)                  │
│  - Prompt construction                                  │
│  - Response formatting                                  │
├─────────────────────────────────────────────────────────┤
│                 AnyLanguageModel                        │
│  ┌──────────┬──────────┬───────────┬─────────┐         │
│  │Foundation│  Ollama  │ Anthropic │ OpenAI  │         │
│  │  Model   │          │           │         │         │
│  └──────────┴──────────┴───────────┴─────────┘         │
└─────────────────────────────────────────────────────────┘
```

### Key Components

1. **main.swift** - CLI entry point with ArgumentParser
2. **HalpEngine.swift** - Core logic, context gathering, prompt building
3. **ContextGatherer.swift** - Extracts help/man/tldr content
4. **ProviderManager.swift** - Handles fallback chain
5. **Config.swift** - Configuration file parsing

## Risks / Trade-offs

| Risk | Mitigation |
|------|------------|
| FoundationModel unavailable (pre-macOS 26) | Graceful fallback to Ollama/cloud with clear message |
| Ollama not installed | Skip in chain, try next provider |
| No API keys configured | Error with setup instructions |
| LLM hallucination | Include actual `--help` output in response for verification |
| Slow cloud responses | Show spinner, cache common queries |

## Migration Plan

N/A - New project, no migration needed.

## Open Questions

1. **Monorepo or separate repo?** - Could live alongside xcsift or standalone
2. **Cache strategy?** - Cache LLM responses for identical queries?
3. **Shell integration?** - `eval $(halp --suggest "...")` safe to support?
4. **Streaming?** - Show LLM response as it generates?

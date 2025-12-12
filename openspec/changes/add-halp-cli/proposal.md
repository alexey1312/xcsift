# Change: Add halp - LLM-powered CLI help assistant

## Why

Command-line tools have inconsistent help interfaces (`-h`, `--help`, `-H`, `help`), and man pages are often cryptic for newcomers. With macOS 26+ introducing free, on-device FoundationModel (Apple Intelligence), there's an opportunity to create an intelligent CLI assistant that explains commands in plain language.

Inspired by [orhun/halp](https://github.com/orhun/halp) (Rust), but reimagined with LLM capabilities instead of simple flag enumeration.

## What Changes

- **NEW PROJECT**: Create `halp` - a Swift CLI tool for intelligent command-line help
- Uses [AnyLanguageModel](https://github.com/mattt/anylanguagemodel) for unified LLM access
- **Default provider**: FoundationModel (free, offline, private on macOS 26+)
- **Fallback chain**: FoundationModel → Ollama → Cloud APIs (Anthropic/OpenAI)
- Built with Swift ArgumentParser (same stack as xcsift)

### Core Features

1. **Command explanation** - `halp git rebase` → plain language explanation
2. **Argument breakdown** - `halp --explain "find . -name '*.swift' -exec rm {} \;"` → what each part does
3. **Command suggestion** - `halp --suggest "find large files"` → suggests `du -sh * | sort -rh`
4. **Examples** - `halp --examples git` → practical usage examples
5. **Man page summarization** - `halp --man tar` → LLM-summarized man page

## Impact

- **New project**: Standalone Swift package, potentially in same repo or separate
- **Shared infrastructure**: Reuses xcsift patterns (ArgumentParser, CI workflow)
- **Target audience**: Developers, DevOps, anyone learning CLI tools
- **Platform**: macOS 26+ (full features), macOS 15+ / Linux (cloud-only mode)

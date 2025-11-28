# Neovim Configuration - Agent Guidelines

## Build/Lint/Test Commands
- **Format Lua**: `stylua %` (format specific file) or `stylua .` (format all)
- **Check Lua**: `lua -c %` (syntax check specific file)
- **Test Config**: Restart Neovim to test configuration changes

## Code Style Guidelines
- **Indentation**: 2 spaces for Lua files (per .stylua.toml)
- **Line Width**: 160 characters max
- **Quotes**: Single quotes preferred, auto-detect
- **Function Style**: Use `local function name()` format, return module table `M`
- **Imports**: Use `require()` with relative paths for modules
- **Naming**: snake_case for variables/functions, PascalCase for modules
- **Error Handling**: Check file existence with `io.open()`, return empty string on failure
- **Vim API**: Use `vim.keymap.set()` for mappings, `vim.api.nvim_create_autocmd()` for events
- **Comments**: Inline comments with `--` after code, keep minimal
- **Structure**: Separate concerns into core/ and plugins/ directories
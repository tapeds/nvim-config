# Adding Language Support

Language support lives in `lua/config/languages.lua`.

The goal is to add a language once, then let the plugin configs consume that shared registry:

- Treesitter parsers are used by `lua/plugins/treesitter.lua`.
- Formatter mappings are used by `lua/plugins/formatting.lua`.
- Mason LSP servers and tools are used by `lua/plugins/lsp.lua`.
- LSP server options are returned from `M.lsp_servers(...)`.

## Quick Checklist

1. Add the Treesitter parser name to `M.treesitter`.
2. Add formatter mappings to `M.formatters_by_ft`.
3. Add formatter packages to `M.mason_tools` when Mason can install them.
4. Add the LSP server name to `M.mason_lsp_servers`.
5. Add or update the server config inside `M.lsp_servers(...)`.
6. Add root marker lists if the server should only start inside matching projects.

## Root Helpers

`M.lsp_servers(root_pattern, root_pattern_or_file)` receives two helpers from `lua/plugins/lsp.lua`.

Use `root_pattern(...)` when a server should only attach inside a project that has a matching root file:

```lua
my_lsp = {
  root_dir = root_pattern("myconfig.json", ".git"),
}
```

Use `root_pattern_or_file(...)` when a server should prefer a project root but still attach to standalone files:

```lua
my_lsp = {
  root_dir = root_pattern_or_file("package.json", "tsconfig.json"),
}
```

TypeScript uses `root_pattern_or_file` so completion still works in standalone `.ts` and `.tsx` files.

## Example: Add a Simple LSP

For a language with an LSP and no special settings:

```lua
M.treesitter = {
  -- ...
  "ruby",
}

M.mason_lsp_servers = {
  -- ...
  "ruby_lsp",
}

function M.lsp_servers(root_pattern, root_pattern_or_file)
  return {
    -- ...
    ruby_lsp = {},
  }
end
```

## Example: Add Formatting

Conform uses filetypes as keys:

```lua
M.formatters_by_ft = {
  -- ...
  ruby = { "rubocop" },
}

M.mason_tools = {
  -- ...
  "rubocop",
}
```

Use `stop_after_first = true` for fallback chains:

```lua
M.formatters_by_ft = {
  javascript = { "biome", "prettierd", "prettier", stop_after_first = true },
}
```

## Example: Add Project Root Markers

If multiple configs need the same root markers, define a named list near the top of `languages.lua`:

```lua
M.ruby_root_files = {
  "Gemfile",
  ".ruby-version",
}
```

Then use it in the LSP config:

```lua
ruby_lsp = {
  root_dir = root_pattern(unpack(M.ruby_root_files)),
}
```

## Existing Patterns

TypeScript:

- Treesitter: `javascript`, `typescript`, `tsx`
- LSP: `vtsls`
- Formatters: `biome`, `prettierd`, `prettier`
- Root behavior: project root if found, file directory fallback otherwise

PHP:

- Treesitter: `php`
- LSP: `intelephense`
- Formatter: `php_cs_fixer`
- Mason tool: `php-cs-fixer`

Lua:

- Treesitter: `lua`
- LSP: `lua_ls`
- Formatter: `stylua`

## Naming Notes

Names are not always identical across tools:

- Mason LSP server names usually match `nvim-lspconfig` server names, such as `vtsls` or `lua_ls`.
- Mason tool names can differ from Conform formatter names. Example: Mason installs `php-cs-fixer`, while Conform uses `php_cs_fixer`.
- Treesitter parser names can differ from filetypes. Example: TSX uses the `tsx` parser and `typescriptreact` filetype.

When in doubt, check inside Neovim:

```vim
:Mason
```

Or inspect available Conform formatters:

```vim
:ConformInfo
```

# Neovim Config

Personal Neovim configuration built around `lazy.nvim`, Mason, native Neovim LSP, `nvim-cmp`, Treesitter, and Conform.

The config is organized so language support is added in one place, while plugin files stay small and predictable.

## Layout

```text
.
├── init.lua
├── lazy-lock.json
├── lua
│   ├── config
│   │   ├── languages.lua
│   │   └── lazy.lua
│   └── plugins
│       ├── completion.lua
│       ├── formatting.lua
│       ├── lsp.lua
│       ├── treesitter.lua
│       └── ...
└── docs
    └── languages.md
```

## Important Files

`init.lua`

Loads the config entrypoint.

`lua/config/lazy.lua`

Bootstraps `lazy.nvim`, defines general editor options, and imports every plugin spec from `lua/plugins`.

`lua/config/languages.lua`

The central language registry. This is where Treesitter parsers, formatter mappings, Mason tools, Mason LSP servers, root markers, and LSP server options live.

`lua/plugins/lsp.lua`

Wires Mason, `mason-lspconfig`, `mason-tool-installer`, and native Neovim LSP to the shared language registry.

`lua/plugins/formatting.lua`

Configures Conform and reads formatter mappings from `lua/config/languages.lua`.

`lua/plugins/treesitter.lua`

Configures Treesitter and reads parser names from `lua/config/languages.lua`.

`docs/languages.md`

Detailed guide for adding new language support.

## Core Ideas

Language support should be centralized.

Add languages in `lua/config/languages.lua` first. Avoid scattering the same language across `lsp.lua`, `formatting.lua`, and `treesitter.lua` unless there is a strong reason.

Plugin specs should stay thin.

Simple plugins use `opts`. Plugins that need extra glue use `config = function(_, opts) ... end`. This keeps the plugin folder easy to scan.

Project-aware tools should use root markers.

Formatters like Prettier and Biome only run when their project config exists. LSP servers can either require a project root or fall back to the current file directory.

## Language Registry

Most language changes happen here:

```lua
-- lua/config/languages.lua
M.treesitter = {}
M.formatters_by_ft = {}
M.mason_lsp_servers = {}
M.mason_tools = {}

function M.lsp_servers(root_pattern, root_pattern_or_file)
  return {}
end
```

Use `root_pattern(...)` for servers that should only attach when a project config exists.

Use `root_pattern_or_file(...)` for servers that should still work in standalone files. TypeScript uses this so completion works in loose `.ts` and `.tsx` files.

See [docs/languages.md](docs/languages.md) for examples.

## Current Language Support

TypeScript and JavaScript:

- LSP: `vtsls`
- Optional lint/fix: `eslint`
- Formatters: `biome`, `prettierd`, `prettier`
- Treesitter: `javascript`, `typescript`, `tsx`

PHP:

- LSP: `intelephense`
- Formatter: `php_cs_fixer`
- Mason tool: `php-cs-fixer`
- Treesitter: `php`

Lua:

- LSP: `lua_ls`
- Formatter: `stylua`
- Treesitter: `lua`

Go:

- LSP: `gopls`
- Treesitter: `go`

Also configured: CSS, HTML, Tailwind, Svelte, Terraform, Swift, C#, Markdown, JSON, YAML, SQL, GraphQL, and related parsers/tools.

## Completion

Completion is configured in `lua/plugins/completion.lua`.

Sources:

- `nvim_lsp`
- `luasnip`
- `buffer`

Relevant plugins:

- `hrsh7th/nvim-cmp`
- `hrsh7th/cmp-nvim-lsp`
- `hrsh7th/cmp-buffer`
- `L3MON4D3/LuaSnip`
- `saadparwaiz1/cmp_luasnip`

If completion is missing for a language, first check whether the LSP client attached:

```vim
:lua vim.print(vim.lsp.get_clients({ bufnr = 0 }))
```

## Formatting

Formatting is handled by Conform in `lua/plugins/formatting.lua`.

Format-on-save skips files in `node_modules` and uses external formatters only:

```lua
return { timeout_ms = 1000, lsp_format = "never" }
```

Formatter mappings are defined in `lua/config/languages.lua`.

For JavaScript and TypeScript, the formatter order is:

```lua
{ "biome", "prettierd", "prettier", stop_after_first = true }
```

That means Biome wins when configured, then Prettierd, then Prettier.

## LSP

LSP is configured with Neovim's native `vim.lsp.config` API.

Mason installs configured language servers from:

```lua
M.mason_lsp_servers
```

Extra CLI tools come from:

```lua
M.mason_tools
```

Useful LSP commands:

```vim
:LspInfo
:lua vim.print(vim.lsp.get_clients({ bufnr = 0 }))
```

## Treesitter

Treesitter parser installation is driven by:

```lua
M.treesitter
```

Treesitter auto-install is enabled, so opening a file can trigger parser installation when needed.

## Git Tools

Git signs and blame are handled by `gitsigns.nvim`.

Mappings:

```text
<leader>gb  blame current line
<leader>gB  blame current line with full details
```

LazyGit is available with:

```text
;c
```

## File Tree

`nvim-tree` is configured on the right side.

Mapping:

```text
<leader>t  toggle file tree
```

Inside the tree:

```text
t  open node in a tab
```

## Terminal

`toggleterm.nvim` is configured as a floating terminal.

Mappings:

```text
<C-\>  toggle default terminal
;t     toggle terminal 1
;g     toggle terminal 2
```

## Search

File search and live grep use `fff.nvim`.

Mappings:

```text
;f  find files
;r  live grep
;w  search current word
```

## Useful Commands

Open Mason:

```vim
:Mason
```

Open Conform info:

```vim
:ConformInfo
```

Inspect attached LSP clients:

```vim
:lua vim.print(vim.lsp.get_clients({ bufnr = 0 }))
```

Format Lua files:

```sh
/Users/farrell/.local/share/nvim/mason/bin/stylua lua
```

Check Lua formatting:

```sh
/Users/farrell/.local/share/nvim/mason/bin/stylua --check lua
```

## Adding A Language

Start with [docs/languages.md](docs/languages.md).

Short version:

1. Add Treesitter parser names to `M.treesitter`.
2. Add formatter mappings to `M.formatters_by_ft`.
3. Add CLI formatter tools to `M.mason_tools`.
4. Add LSP server names to `M.mason_lsp_servers`.
5. Add LSP config entries inside `M.lsp_servers(...)`.
6. Add root marker lists when project detection matters.

## Troubleshooting

Completion does not work:

1. Check the buffer filetype with `:set filetype?`.
2. Check attached clients with `:lua vim.print(vim.lsp.get_clients({ bufnr = 0 }))`.
3. Check that the LSP server exists in `M.mason_lsp_servers`.
4. Check that the server config exists in `M.lsp_servers(...)`.
5. Check that `cmp-nvim-lsp` is installed and listed in `completion.lua`.

Formatter does not run:

1. Run `:ConformInfo`.
2. Check the filetype key in `M.formatters_by_ft`.
3. Check that the formatter binary exists or is in `M.mason_tools`.
4. Check project root files for tools like Prettier or Biome.

LSP does not attach:

1. Confirm the filetype matches the server's configured filetypes.
2. Inspect root markers in `lua/config/languages.lua`.
3. Use `root_pattern_or_file(...)` if the server should work in standalone files.
4. Use `root_pattern(...)` if the server should require a project config.

Mason did not install a tool:

1. Open `:Mason`.
2. Confirm the Mason package name is correct.
3. Remember that Mason names and Conform names can differ, such as `php-cs-fixer` vs `php_cs_fixer`.

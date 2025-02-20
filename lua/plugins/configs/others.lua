local M = {}
local utils = require "core.utils"

M.blankline = {
  indentLine_enabled = 1,
  filetype_exclude = {
    "help",
    "terminal",
    "lazy",
    "lspinfo",
    "TelescopePrompt",
    "TelescopeResults",
    "mason",
    "nvdash",
    "nvcheatsheet",
    "",
  },
  buftype_exclude = { "terminal" },
  show_trailing_blankline_indent = false,
  show_first_indent_level = false,
  show_current_context = true,
  show_current_context_start = true,
}

M.luasnip = function(opts)
  require("luasnip").config.set_config(opts)

  -- vscode format
  require("luasnip.loaders.from_vscode").lazy_load()
  require("luasnip.loaders.from_vscode").lazy_load { paths = vim.g.vscode_snippets_path or "" }

  -- snipmate format
  require("luasnip.loaders.from_snipmate").load()
  require("luasnip.loaders.from_snipmate").lazy_load { paths = vim.g.snipmate_snippets_path or "" }

  -- lua format
  require("luasnip.loaders.from_lua").load()
  require("luasnip.loaders.from_lua").lazy_load { paths = vim.g.lua_snippets_path or "" }

  vim.api.nvim_create_autocmd("InsertLeave", {
    callback = function()
      if
        require("luasnip").session.current_nodes[vim.api.nvim_get_current_buf()]
        and not require("luasnip").session.jump_active
      then
        require("luasnip").unlink_current()
      end
    end,
  })
end

M.gitsigns = {
  signs = {
    add = { text = "│" },
    change = { text = "│" },
    delete = { text = "󰍵" },
    topdelete = { text = "‾" },
    changedelete = { text = "~" },
    untracked = { text = "│" },
  },
  on_attach = function(bufnr)
    utils.load_mappings("gitsigns", { buffer = bufnr })
  end,
}

M.setup_formatting = function()
  local conform = require "conform"

  conform.setup {
    formatters_by_ft = {
      javascript = { utils.load_formatter() },
      typescript = { utils.load_formatter() },
      javascriptreact = { utils.load_formatter() },
      typescriptreact = { utils.load_formatter() },
      svelte = { utils.load_formatter() },
      vue = { utils.load_formatter() },
      css = { utils.load_formatter() },
      html = { utils.load_formatter() },
      json = { utils.load_formatter() },
      yaml = { utils.load_formatter() },
      graphql = { utils.load_formatter() },
      markdown = { "prettier" },
      lua = { "stylua" },
      python = { "black" },
      rust = { "rustfmt" },
      ruby = { "rubyfmt" },
      go = { "gofumpt", "goimports" },
      php = { "php_cs_fixer" },
    },
    format_on_save = {
      lsp_fallback = true,
      async = false,
      timeout_ms = 1000,
    },
  }

  vim.keymap.set({ "n", "v" }, "<leader>mp", function()
    conform.format {
      lsp_fallback = true,
      async = false,
      timeout_ms = 1000,
    }
  end, { desc = "Format file or range (in visual mode)" })
end

M.setup_linting = function()
  local lint = require "lint"

  lint.linters_by_ft = {
    javascript = { utils.load_linter() },
    typescript = { utils.load_linter() },
    javascriptreact = { utils.load_linter() },
    typescriptreact = { utils.load_linter() },
    svelte = { utils.load_linter() },
    vue = { utils.load_linter() },
    yaml = { utils.load_linter() },
    json = { "jsonlint" },
    lua = { "luacheck" },
    python = { "flake8" },
    terraform = { "tflint" },
    php = { "phpcs", "phpstan" },
  }

  local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

  vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
    group = lint_augroup,
    callback = function()
      lint.try_lint()
    end,
  })

  vim.keymap.set("n", "<leader>l", function()
    lint.try_lint()
  end, { desc = "Trigger linting for current file" })
end

return M

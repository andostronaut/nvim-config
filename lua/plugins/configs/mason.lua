local options = {
  mason = {
    ensure_installed = {},
    PATH = "skip",
    ui = {
      icons = {
        package_pending = " ",
        package_installed = "󰄳 ",
        package_uninstalled = " 󰚌",
      },
      keymaps = {
        toggle_server_expand = "<CR>",
        install_server = "i",
        update_server = "u",
        check_server_version = "c",
        update_all_servers = "U",
        check_outdated_servers = "C",
        uninstall_server = "X",
        cancel_installation = "<C-c>",
      },
    },
    max_concurrent_installers = 10,
  },

  lspconfig = {
    ensure_installed = {
      "lua_ls",
      "tailwindcss",
      "svelte",
      "graphql",
      "emmet_ls",
      "denols",
      "ts_ls",
      "eslint",
      "pyright",
      "solargraph",
      "rust_analyzer",
      "terraformls",
      "bashls",
      "sqlls",
      "gopls",
      "intelephense",
      "html",
      "cssls",
      "angularls",
      "astro",
      "dockerls",
      "yamlls",
      "jsonls",
      "prismals",
      "zls",
    },
    -- auto-install configured servers (with lspconfig)
    automatic_installation = true, -- not the same as ensure_installed
  },

  tool = {
    ensure_installed = {
      -- Linters --
      "eslint",
      "flake8",
      "phpcs",
      "phpstan",
      "tflint",
      "jsonlint",

      -- Formatters --
      "prettier",
      "stylua",
      "black",
      "isort",
      "rustfmt",
      "rubyfmt",
      "gofumpt",
      "goimports",
      "php-cs-fixer",
      "zigfmt",
    },
    integrations = {
      ["mason-lspconfig"] = true,
    },
  },
}

return options

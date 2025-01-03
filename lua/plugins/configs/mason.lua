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
      "ts_ls",
      "html",
      "cssls",
      "tailwindcss",
      "svelte",
      "lua_ls",
      "graphql",
      "emmet_ls",
      "prismals",
      "pyright",
      "angularls",
      "astro",
      "dockerls",
      "helm_ls",
      "jsonls",
      "pyright",
      "rust_analyzer",
      "terraformls",
      "volar",
      "bashls",
      "sqlls",
      "gopls",
      "yamlls",
      "templ",
      "intelephense",
      "solargraph",
      "denols",
    },
    -- auto-install configured servers (with lspconfig)
    automatic_installation = true, -- not the same as ensure_installed
  },

  tool = {
    ensure_installed = {
      "prettier",
      "stylua",
      "isort",
      "black",
      "flake8",
      "eslint",
      "rustfmt",
      "rubyfmt",
      "gofumpt",
      "goimports",
      "jsonlint",
      "tflint",
      "php-cs-fixer",
      "phpcs",
      "phpstan",
    },
    integrations = {
      ["mason-lspconfig"] = true,
    },
  },
}

return options

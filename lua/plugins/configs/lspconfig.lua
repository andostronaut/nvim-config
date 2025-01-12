dofile(vim.g.base46_cache .. "lsp")
require "nvchad.lsp"

local M = {}
local utils = require "core.utils"
local vue_language_server_path = require("mason-registry").get_package("vue-language-server"):get_install_path()
  .. "/node_modules/@vue/language-server"

-- export on_attach & capabilities for custom lspconfigs
M.on_attach = function(client, bufnr)
  client.server_capabilities.documentFormattingProvider = false
  client.server_capabilities.documentRangeFormattingProvider = false

  utils.load_mappings("lspconfig", { buffer = bufnr })

  if client.server_capabilities.signatureHelpProvider then
    require("nvchad.signature").setup(client)
  end

  if not utils.load_config().ui.lsp_semantic_tokens and client.supports_method "textDocument/semanticTokens" then
    client.server_capabilities.semanticTokensProvider = nil
  end
end

M.capabilities = vim.lsp.protocol.make_client_capabilities()

M.capabilities.textDocument.completion.completionItem = {
  documentationFormat = { "markdown", "plaintext" },
  snippetSupport = true,
  preselectSupport = true,
  insertReplaceSupport = true,
  labelDetailsSupport = true,
  deprecatedSupport = true,
  commitCharactersSupport = true,
  tagSupport = { valueSet = { 1 } },
  resolveSupport = {
    properties = {
      "documentation",
      "detail",
      "additionalTextEdits",
    },
  },
}

require("lspconfig").lua_ls.setup {
  on_attach = M.on_attach,
  capabilities = M.capabilities,

  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" },
      },
      workspace = {
        library = {
          [vim.fn.expand "$VIMRUNTIME/lua"] = true,
          [vim.fn.expand "$VIMRUNTIME/lua/vim/lsp"] = true,
          [vim.fn.stdpath "data" .. "/lazy/ui/nvchad_types"] = true,
          [vim.fn.stdpath "data" .. "/lazy/lazy.nvim/lua/lazy"] = true,
        },
        maxPreload = 100000,
        preloadFileSize = 10000,
      },
    },
  },
}

require("lspconfig").tailwindcss.setup {
  on_attach = M.on_attach,
  capabilities = M.capabilities,
  root_dir = require("lspconfig").util.root_pattern(
    "tailwind.config.cjs",
    "tailwind.config.js",
    "tailwind.config.ts",
    "postcss.config.cjs",
    "postcss.config.js",
    "postcss.config.ts"
  ),
}

require("lspconfig").svelte.setup {
  capabilities = M.capabilities,
  on_attach = function(client, bufnr)
    vim.api.nvim_create_autocmd("BufWritePost", {
      pattern = { "*.js", "*.ts" },
      callback = function(ctx)
        if client.name == "svelte" then
          client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.file })
        end
      end,
    })
  end,
}

require("lspconfig").graphql.setup {
  on_attach = M.on_attach,
  capabilities = M.capabilities,
  filetypes = { "graphql", "gql", "svelte", "typescriptreact", "javascriptreact" },
}

require("lspconfig").emmet_ls.setup {
  on_attach = M.on_attach,
  capabilities = M.capabilities,
  filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "svelte" },
}

require("lspconfig").denols.setup {
  root_dir = require("lspconfig").util.root_pattern("deno.json", "deno.jsonc"),
  filetypes = {
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescriptreact",
    "typescript.tsx",
    "markdown",
  },
  init_options = {
    config = "./deno.json",
    unstable = true,
    suggest = {
      imports = {
        hosts = {
          ["https://deno.land"] = true,
          ["https://cdn.nest.land"] = true,
          ["https://crux.land"] = true,
        },
      },
    },
  },

  on_attach = M.on_attach,
}

require("lspconfig").ts_ls.setup {
  on_attach = function(client, bufnr)
    M.on_attach(client, bufnr)
    vim.keymap.set("n", "<leader>ro", function()
      vim.lsp.buf.execute_command {
        command = "_typescript.organizeImports",
        arguments = { vim.fn.expand "%:p" },
      }
    end, { buffer = bufnr, remap = false })
  end,
  root_dir = function(filename, bufnr)
    local denoRootDir = require("lspconfig").util.root_pattern("deno.json", "deno.jsonc")(filename)
    if denoRootDir then
      -- print('this seems to be a deno project; returning nil so that tsserver does not attach');
      return nil
      -- else
      -- print('this seems to be a ts project; return root dir based on package.json')
    end

    return require("lspconfig").util.root_pattern "package.json"(filename)
  end,
  init_options = {
    plugins = {
      {
        name = "@vue/typescript-plugin",
        location = vue_language_server_path,
        languages = { "vue" },
      },
    },
  },

  filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
  single_file_support = false,
}

require("lspconfig").eslint.setup {
  on_attach = M.on_attach,
  capabilities = M.capabilities,
  root_dir = require("lspconfig").util.root_pattern "package.json",
  filetypes = {
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescriptreact",
    "typescript.tsx",
    "vue",
    "svelte",
    "astro",
  },
}

require("lspconfig").pyright.setup {
  on_attach = M.on_attach,
  capabilities = M.capabilities,
  single_file_support = true,
  settings = {
    pyright = {
      disableLanguageServices = false,
      disableOrganizeImports = false,
    },
    python = {
      analysis = {
        autoImportCompletions = true,
        autoSearchPaths = true,
        diagnosticMode = "workspace", -- openFilesOnly, workspace
        typeCheckingMode = "basic", -- off, basic, strict
        useLibraryCodeForTypes = true,
      },
    },
  },
}

require("lspconfig").solargraph.setup {
  on_attach = M.on_attach,
  capabilities = M.capabilities,
  settings = {
    solargraph = {
      diagnostics = true,
      completion = true,
      flags = {
        debounce_text_changes = 150,
      },
      initializationOptions = {
        formatting = true,
      },
    },
  },
}

require("lspconfig").rust_analyzer.setup {
  on_attach = M.on_attach,
  capabilities = M.capabilities,
  settings = {
    ["rust-analyzer"] = {
      check = {
        command = "clippy",
      },
      diagnostics = {
        enable = true,
      },
    },
  },
}

require("lspconfig").terraformls.setup {
  on_attach = M.on_attach,
  capabilities = M.capabilities,
}

require("lspconfig").volar.setup {
  on_attach = M.on_attach,
  capabilities = M.capabilities,
}

require("lspconfig").bashls.setup {
  on_attach = M.on_attach,
  capabilities = M.capabilities,
}

require("lspconfig").sqlls.setup {
  on_attach = M.on_attach,
  capabilities = M.capabilities,
}

require("lspconfig").gopls.setup {
  on_attach = M.on_attach,
  capabilities = M.capabilities,
}

require("lspconfig").intelephense.setup {
  on_attach = M.on_attach,
  capabilities = M.capabilities,
}

require("lspconfig").html.setup {
  on_attach = M.on_attach,
  capabilities = M.capabilities,
}

require("lspconfig").cssls.setup {
  on_attach = M.on_attach,
  capabilities = M.capabilities,
}

require("lspconfig").angularls.setup {
  on_attach = M.on_attach,
  capabilities = M.capabilities,
}

require("lspconfig").astro.setup {
  on_attach = M.on_attach,
  capabilities = M.capabilities,
}

require("lspconfig").dockerls.setup {
  on_attach = M.on_attach,
  capabilities = M.capabilities,
}

require("lspconfig").yamlls.setup {
  on_attach = M.on_attach,
  capabilities = M.capabilities,
}

require("lspconfig").templ.setup {
  on_attach = M.on_attach,
  capabilities = M.capabilities,
}

require("lspconfig").jsonls.setup {
  on_attach = M.on_attach,
  capabilities = M.capabilities,
}

require("lspconfig").prismals.setup {
  on_attach = M.on_attach,
  capabilities = M.capabilities,
}

return M

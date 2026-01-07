return {
  {
    "mason-org/mason.nvim",
    opts = {},
    config = function()
      require("mason").setup()
    end,
  },
  {
    "mason-org/mason-lspconfig.nvim",
    opts = {},
    dependencies = {
      { "mason-org/mason.nvim", opts = {} },
      "neovim/nvim-lspconfig",
    },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls",
          "pyright",
          "vtsls",
          "html",
          "cssls",
          "jsonls",
          "yamlls",
          "marksman",
          "sqlls",
          "dockerls",
          "eslint",
          "gopls",
          "tinymist",
          "bashls",
        },
      })
      vim.keymap.set("n", "<leader>m", ":Mason<CR>", {})
    end,
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- Lua
      vim.lsp.enable("lua_ls")
      vim.lsp.config("lua_ls", {
        capabilities = capabilities,
      })

      -- Python using pyright
      vim.lsp.enable("pyright")
      vim.lsp.config("pyright", {
        capabilities = capabilities,
        settings = {
          python = {
            analysis = {
              typeCheckingMode = "basic", -- or "strict" for more checking
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
              diagnosticMode = "workspace",
              autoImportCompletions = true,
            },
          },
        },
      })

      -- Web/JS/TS
      vim.lsp.enable("vtsls")
      vim.lsp.config("vtsls", { capabilities = capabilities })

      vim.lsp.enable("html")
      vim.lsp.config("html", { capabilities = capabilities })

      vim.lsp.enable("cssls")
      vim.lsp.config("cssls", { capabilities = capabilities })

      vim.lsp.enable("jsonls")
      vim.lsp.config("jsonls", { capabilities = capabilities })

      vim.lsp.enable("eslint")
      vim.lsp.config("eslint", { capabilities = capabilities })

      -- Go
      vim.lsp.enable("gopls")
      vim.lsp.config("gopls", {
        capabilities = capabilities,
        settings = {
          gopls = {
            gofumpt = true,
            analyses = {
              unusedparams = true,
            },
            staticcheck = true,
          },
        },
      })

      -- YAML / SQL / Docker / Markdown
      vim.lsp.enable("yamlls")
      vim.lsp.config("yamlls", { capabilities = capabilities })

      vim.lsp.enable("sqlls")
      vim.lsp.config("sqlls", { capabilities = capabilities })

      vim.lsp.enable("dockerls")
      vim.lsp.config("dockerls", { capabilities = capabilities })

      vim.lsp.enable("marksman")
      vim.lsp.config("marksman", { capabilities = capabilities })

      -- Typst
      vim.lsp.enable("tinymist")
      vim.lsp.config("tinymist", {
        capabilities = capabilities,
        settings = {
          exportPdf = "onSave",
          formatterMode = "typstyle",
        },
        filetypes = { "typst" },
      })

      -- Bash
      vim.lsp.enable("bashls")
      vim.lsp.config("bashls", { capabilities = capabilities })

      -- Diagnostics UI
      vim.diagnostic.config({
        virtual_text = true,
        signs = true,
        update_in_insert = false,
        severity_sort = true,
      })
    end,
  },
}

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
          "pyrefly",
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
      local lspconfig = require("lspconfig")
      local configs = require("lspconfig.configs")
      local util = require("lspconfig.util")
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- Register pyrefly manually if needed
      if not configs.pyrefly then
        configs.pyrefly = {
          default_config = {
            cmd = { "pyrefly", "lsp" },
            filetypes = { "python" },
            root_dir = util.root_pattern("pyproject.toml", ".git"),
            settings = {},
          },
        }
      end

      -- Lua
      lspconfig.lua_ls.setup({ capabilities = capabilities })

      -- Python using pyrefly
      lspconfig.pyrefly.setup({
        capabilities = capabilities,
        settings = {
          python = {
            checkOnType = true,
            diagnostics = true,
            inlayHints = true,
            smartCompletion = true,
          },
        },
      })

      -- Web/JS/TS
      lspconfig.vtsls.setup({ capabilities = capabilities })
      lspconfig.html.setup({ capabilities = capabilities })
      lspconfig.cssls.setup({ capabilities = capabilities })
      lspconfig.jsonls.setup({ capabilities = capabilities })
      lspconfig.eslint.setup({ capabilities = capabilities })

      -- Go
      lspconfig.gopls.setup({
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
      lspconfig.yamlls.setup({ capabilities = capabilities })
      lspconfig.sqlls.setup({ capabilities = capabilities })
      lspconfig.dockerls.setup({ capabilities = capabilities })
      lspconfig.marksman.setup({ capabilities = capabilities })

      -- Typst
      lspconfig.tinymist.setup({
        capabilities = capabilities,
        settings = {
          exportPdf = "onSave",
          formatterMode = "typstyle",
        },
        filetypes = { "typst" },
      })

      -- Bash
      lspconfig.bashls.setup({ capabilities = capabilities })

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

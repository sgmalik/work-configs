return {
  {
    "jay-babu/mason-null-ls.nvim",
    dependencies = {
      "mason-org/mason.nvim",
      "nvimtools/none-ls.nvim",
    },
    config = function()
      require("mason-null-ls").setup({
        ensure_installed = {
          "stylua",
          "black",
          "isort",
          "prettier",
          "goimports",
          "shellcheck",
        },
        automatic_installation = true,
      })
    end,
  },
  {
    "nvimtools/none-ls.nvim",
    config = function()
      local null_ls = require("null-ls")

      null_ls.setup({
        sources = {
          -- Lua
          null_ls.builtins.formatting.stylua,

          -- Python
          null_ls.builtins.formatting.black.with({ extra_args = { "--fast" } }),
          null_ls.builtins.formatting.isort,

          -- JS/TS/web
          null_ls.builtins.formatting.prettier.with({
            filetypes = {
              "javascript",
              "javascriptreact",
              "typescript",
              "typescriptreact",
              "json",
              "html",
              "css",
              "yaml",
              "markdown",
            },
          }),

          -- Go
          null_ls.builtins.formatting.gofmt,
          null_ls.builtins.formatting.goimports,

          -- Bash
          null_ls.builtins.diagnostics.shellcheck,
        },
      })
    end,
  },
}

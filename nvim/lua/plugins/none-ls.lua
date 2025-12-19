return {
  {
    "nvimtools/none-ls.nvim",
    config = function()
      local null_ls = require("null-ls")

      null_ls.setup({
        sources = {
          -- Lua
          null_ls.builtins.formatting.stylua,

          -- Python (formatter only — diagnostics via LSP)
          null_ls.builtins.formatting.black.with({ extra_args = { "--fast" } }),

          -- JS/TS/React formatting (diagnostics via eslint LSP)
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
        },
      })

      vim.keymap.set("n", "<leader>cf", function()
        vim.lsp.buf.format({ async = true })
      end, { desc = "Format current buffer" })
    end,
  },
}

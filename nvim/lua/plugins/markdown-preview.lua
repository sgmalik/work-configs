return {
  "iamcco/markdown-preview.nvim",
  build = "cd app && npm install",
  ft = { "markdown" },
  config = function()
    -- Plugin settings
    vim.g.mkdp_auto_start = 0          -- Don't auto-start preview
    vim.g.mkdp_auto_close = 1          -- Auto-close preview when leaving buffer
    vim.g.mkdp_refresh_slow = 0        -- Refresh on text change
    vim.g.mkdp_command_for_global = 0  -- Only available in markdown files
    vim.g.mkdp_browser = ""            -- Use system default browser

  end,
}

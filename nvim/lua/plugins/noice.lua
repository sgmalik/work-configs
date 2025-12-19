return {
  "folke/noice.nvim",
  event = "VeryLazy",
  dependencies = {
    "MunifTanjim/nui.nvim",
    "rcarriga/nvim-notify",
  },
  config = function()
    require("noice").setup({
      cmdline = {
        enabled = true,
        view = "cmdline_popup", -- This makes it appear in center as popup
        opts = {
          position = {
            row = "50%", -- center vertically
            col = "50%", -- center horizontally
          },
          size = {
            min_width = 60,
            width = "auto",
            height = "auto",
          },
        },
      },
      -- Added: Message routing configuration
      messages = {
        enabled = true,
        view = "notify",         -- default view for messages
        view_error = "notify",   -- view for errors
        view_warn = "notify",    -- view for warnings
        view_history = "messages", -- view for :messages
        view_search = "virtualtext", -- view for search count messages
      },
      popupmenu = {
        enabled = true,
        backend = "nui",
        kind_icons = {}, -- set to `false` to disable icons
      },
      -- Added: Notification configuration
      notify = {
        enabled = true,
        view = "notify",
      },
      presets = {
        bottom_search = false, -- use a classic bottom cmdline for search
        command_palette = true, -- position the cmdline and popupmenu together
        long_message_to_split = true,
        inc_rename = false,
        lsp_doc_border = false,
      },
    })
  end,
}

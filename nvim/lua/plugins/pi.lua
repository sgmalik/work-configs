return {
  "alex35mil/pi.nvim",

  -- Optional: only needed for :PiPasteImage (clipboard image paste)
  dependencies = { "HakonHarnes/img-clip.nvim" },

  opts = {
    layout = {
      default = "side",
      side = {
        position = "right",
        width = 80,
      },
    },
  },

  config = function(_, opts)
    local pi = require("pi")
    pi.setup(opts)

    -- Buffer-local keymaps inside π windows
    local group = vim.api.nvim_create_augroup("pi-keymaps", { clear = true })

    local function map(buf, key, action, modes)
      vim.keymap.set(modes or { "n", "i", "v" }, key, action, { buffer = buf })
    end

    -- Shared across all π windows
    vim.api.nvim_create_autocmd("FileType", {
      group = group,
      pattern = { "pi-chat-history", "pi-chat-prompt", "pi-chat-attachments" },
      callback = function(event)
        map(event.buf, "<C-q>", "<Cmd>PiToggleChat<CR>")
        map(event.buf, "<M-c>", "<Cmd>PiAbort<CR>")
        map(event.buf, "<C-c>", "<Cmd>PiAbort<CR>")
      end,
    })

    -- History window: jump to prompt
    vim.api.nvim_create_autocmd("FileType", {
      group = group,
      pattern = "pi-chat-history",
      callback = function(event)
        map(event.buf, "<S-Down>", pi.focus_chat_prompt)
      end,
    })

    -- Prompt window: navigation, scrolling, model & thinking, sessions, attachments
    vim.api.nvim_create_autocmd("FileType", {
      group = group,
      pattern = "pi-chat-prompt",
      callback = function(event)
        map(event.buf, "<S-Up>",   pi.focus_chat_history)
        map(event.buf, "<S-Down>", pi.focus_chat_attachments)
        map(event.buf, "<C-Up>",   function() pi.scroll_chat_history("up", 2) end)
        map(event.buf, "<C-Down>", function() pi.scroll_chat_history("down", 2) end)
        map(event.buf, "<M-m>",    pi.cycle_model)
        map(event.buf, "<M-M>",    pi.select_model)
        map(event.buf, "<M-t>",    pi.cycle_thinking_level)
        map(event.buf, "<M-T>",    pi.select_thinking_level)
        map(event.buf, "<M-n>",    pi.new_session)
        map(event.buf, "<M-x>",    pi.compact)
        map(event.buf, "<C-v>",    pi.paste_image)
      end,
    })

    -- Attachments window: jump back to prompt, paste image
    vim.api.nvim_create_autocmd("FileType", {
      group = group,
      pattern = "pi-chat-attachments",
      callback = function(event)
        map(event.buf, "<S-Up>", pi.focus_chat_prompt)
        map(event.buf, "<C-v>", pi.paste_image)
      end,
    })
  end,
}

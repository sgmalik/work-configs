return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	opts = {},
	keys = {
		{
			"<leader>?",
			"<cmd>Telescope keymaps<cr>",
			desc = "Browse All Keymaps",
		},
	},
	config = function()
		local wk = require("which-key")
		vim.opt.spelllang = { "en_us" }

		wk.setup({
			preset = "modern", -- or "classic" or "helix"
			delay = 300, -- delay before showing the popup (ms)
			expand = 1, -- expand groups when <= n mappings
			notify = true, -- show a notification when there are no mappings
			triggers = {
				{ "<auto>", mode = "nxsot" },
			},
		})

		-- Register your key groups and mappings
		wk.add({

			-- Find Files and Grep
			{ "<leader>f", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
			{ "<leader>/", "<cmd>Telescope live_grep<cr>", desc = "Live Grep" },

			-- Code group
			{ "<leader>c", group = "Code" },
			{ "<leader>ch", vim.lsp.buf.hover, desc = "Hover Documentation" },
			{ "<leader>cd", vim.lsp.buf.definition, desc = "Go to Definition" },
			{
				"<leader>ca",
				vim.lsp.buf.code_action,
				desc = "Code Action",
				mode = { "n", "v" },
			},
			{ "<leader>cs", ":set spell!<cr>", desc = "Toggle Spell Check" },
			{ "<leader>cr", vim.lsp.buf.rename, desc = "Rename" },
			{ "<leader>cf", vim.lsp.buf.format, desc = "Format" },
			{ "<leader>ci", vim.lsp.buf.implementation, desc = "Go to Implementation" },
			{ "<leader>ct", vim.lsp.buf.type_definition, desc = "Type Definition" },
			-- { "<leader>cs", vim.lsp.buf.signature_help, desc = "Signature Help" },
			{ "<leader>cp", "<cmd>MarkdownPreviewToggle<cr>", desc = "Markdown Preview" },

      -- Quarto
      { "<leader>q", group = "Quarto" },
      { "<leader>qp", "<cmd>QuartoPreview<cr>", desc = "Preview Quarto" },
      { "<leader>qs", "<cmd>QuartoStop<cr>", desc = "Stop Preview" },
      { "<leader>qe", "<cmd>QuartoSendAbove<cr>", desc = "Execute Above" },
      { "<leader>qc", "<cmd>QuartoSendCode<cr>", desc = "Execute Chunk" },
      { "<leader>qa", "<cmd>QuartoSendAll<cr>", desc = "Execute All" },

			-- Buffer management
			{ "<leader>b", group = "Buffer" },
			{ "<leader>bd", ":bdelete<cr>", desc = "Delete Buffer" },
			{ "<leader>bD", ":bdelete!<cr>", desc = "Delete Buffer (Force)" },
			{ "<leader>bb", ":bnext<cr>", desc = "Next Buffer" },
			{ "<leader>bp", ":bprevious<cr>", desc = "Previous Buffer" },
			{ "<leader>bf", ":bfirst<cr>", desc = "First Buffer" },
			{ "<leader>bl", ":blast<cr>", desc = "Last Buffer" },
			{ "<leader>bo", ":%bdelete|edit#|bdelete#<cr>", desc = "Close Other Buffers" },
			{ "<leader>ba", ":buffers<cr>", desc = "List All Buffers" },
			{ "<leader>by", ":%y+<cr>", desc = "Yank Entire Buffer" },

			-- Window management
			{ "<leader>w", group = "Window" },
			{ "<leader>ww", "<C-W>p", desc = "Other Window" },
			{ "<leader>wd", "<C-W>c", desc = "Delete Window" },
			{ "<leader>ws", "<C-W>s", desc = "Split Window Below" },
			{ "<leader>wv", "<C-W>v", desc = "Split Window Right" },
			{ "<leader>wh", "<C-W>h", desc = "Go to Left Window" },
			{ "<leader>wj", "<C-W>j", desc = "Go to Lower Window" },
			{ "<leader>wk", "<C-W>k", desc = "Go to Upper Window" },
			{ "<leader>wl", "<C-W>l", desc = "Go to Right Window" },
			{ "<leader>wH", "<C-W>H", desc = "Move Window Far Left" },
			{ "<leader>wJ", "<C-W>J", desc = "Move Window Very Bottom" },
			{ "<leader>wK", "<C-W>K", desc = "Move Window Very Top" },
			{ "<leader>wL", "<C-W>L", desc = "Move Window Far Right" },
			{ "<leader>w=", "<C-W>=", desc = "Equally Size Windows" },
			{ "<leader>wo", "<C-W>o", desc = "Close Other Windows" },
			{ "<leader>wq", "<C-W>q", desc = "Quit Window" },
			{ "<leader>wr", "<C-W>r", desc = "Rotate Windows" },
			{ "<leader>wR", "<C-W>R", desc = "Rotate Windows Backwards" },
			{ "<leader>wx", "<C-W>x", desc = "Exchange Windows" },
			{ "<leader>w+", "<C-W>+", desc = "Increase Height" },
			{ "<leader>w-", "<C-W>-", desc = "Decrease Height" },
			{ "<leader>w>", "<C-W>>", desc = "Increase Width" },
			{ "<leader>w<", "<C-W><", desc = "Decrease Width" },

			-- Update your git group in which-key config
			{ "<leader>g", group = "Git" },
			{ "<leader>gg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
			{ "<leader>gs", "<cmd>terminal git status<cr>", desc = "Git Status" },
			{ "<leader>ga", "<cmd>terminal git add .<cr>", desc = "Git Add All" },
			{ "<leader>gc", "<cmd>terminal git commit<cr>", desc = "Git Commit" },
			{ "<leader>gp", "<cmd>terminal git push<cr>", desc = "Git Push" },
			{ "<leader>gl", "<cmd>terminal git log<cr>", desc = "Git Log" },
			{ "<leader>gd", "<cmd>terminal git diff<cr>", desc = "Git Diff" },
			{ "<leader>gf", "<cmd>LazyGitFilterCurrentFile<cr>", desc = "LazyGit Current File" },

			-- Search operations
			{ "<leader>s", group = "Search" },
			{ "<leader>sc", "<cmd>noh<cr>", desc = "Clear Search Highlight" },
			{ "<leader>sr", ":%s/", desc = "Search & Replace" },
			{ "<leader>sw", "/\\<\\><left><left>", desc = "Search Whole Word" },

			-- Toggle operations
			{ "<leader>t", group = "Toggle" },
			{ "<leader>tn", ":set number!<cr>", desc = "Toggle Line Numbers" },
			{ "<leader>tr", ":set relativenumber!<cr>", desc = "Toggle Relative Numbers" },
			{ "<leader>tw", ":set wrap!<cr>", desc = "Toggle Word Wrap" },
			{ "<leader>ts", ":set spell!<cr>", desc = "Toggle Spell Check" },
			{ "<leader>th", ":set hlsearch!<cr>", desc = "Toggle Search Highlight" },

			-- Diagnostics/Quickfix
			{ "<leader>x", group = "Diagnostics/Quickfix" },
			{ "<leader>xx", vim.diagnostic.open_float, desc = "Show Diagnostics" },
			{ "<leader>xn", vim.diagnostic.goto_next, desc = "Next Diagnostic" },
			{ "<leader>xp", vim.diagnostic.goto_prev, desc = "Previous Diagnostic" },
			{ "<leader>xl", vim.diagnostic.setloclist, desc = "Diagnostic List" },

			-- Pi (AI Agent)
			{ "<leader>p", group = "Pi" },
			{ "<leader>pp", function() vim.cmd("Pi layout=side") end, desc = "Open Side Panel", mode = { "n", "v" } },
			{ "<leader>pf", function() vim.cmd("Pi layout=float") end, desc = "Open Float", mode = { "n", "v" } },
			{ "<leader>pl", "<Cmd>PiToggleLayout<CR>", desc = "Toggle Layout", mode = { "n", "v" } },
			{ "<leader>pc", "<Cmd>PiContinue<CR>", desc = "Continue Last Session", mode = { "n", "v" } },
			{ "<leader>pr", "<Cmd>PiResume<CR>", desc = "Resume Past Session", mode = { "n", "v" } },
			{ "<leader>pm", "<Cmd>PiSendMention<CR>", desc = "Mention File/Selection", mode = { "n", "v" } },
			{ "<leader>pa", "<Cmd>PiAttention<CR>", desc = "Open Attention Request", mode = { "n", "v" } },
			{ "<leader>ps", "<Cmd>PiAbort<CR>", desc = "Stop/Abort Agent", mode = { "n", "v" } },
			{ "<leader>pq", "<Cmd>PiToggleChat<CR>", desc = "Close/Toggle Chat", mode = { "n", "v" } },
			{ "<leader>pS", "<Cmd>PiStop<CR>", desc = "Stop Pi Process", mode = { "n", "v" } },
		})
	end,
}

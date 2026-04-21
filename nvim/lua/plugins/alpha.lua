return {
	"goolord/alpha-nvim",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},

	config = function()
		local alpha = require("alpha")
		local dashboard = require("alpha.themes.dashboard")

		dashboard.section.header.val = {
			[[                                                                       ]],
			[[                                                                       ]],
			[[                                                                       ]],
			[[                                                                       ]],
			[[                                                                     ]],
			[[       ████ ██████           █████      ██                     ]],
			[[      ███████████             █████                             ]],
			[[      █████████ ███████████████████ ███   ███████████   ]],
			[[     █████████  ███    █████████████ █████ ██████████████   ]],
			[[    █████████ ██████████ █████████ █████ █████ ████ █████   ]],
			[[  ███████████ ███    ███ █████████ █████ █████ ████ █████  ]],
			[[ ██████  █████████████████████ ████ █████ █████ ████ ██████ ]],
			[[                                                                       ]],
			[[                                                                       ]],
			[[                                                                       ]],
		}

		dashboard.section.buttons.val = {
			dashboard.button("f", "  Find file",    "<cmd>Telescope find_files<cr>"),
			dashboard.button("r", "  Recent files", "<cmd>Telescope oldfiles<cr>"),
			dashboard.button("g", "  Live grep",    "<cmd>Telescope live_grep<cr>"),
			dashboard.button("e", "  File tree",    "<Cmd>Neotree filesystem reveal left toggle<CR>"),
			dashboard.button("l", "  Lazy",         "<cmd>Lazy<cr>"),
			dashboard.button("q", "  Quit",         "<cmd>qa<cr>"),
		}

		alpha.setup(dashboard.opts)
	end,
}

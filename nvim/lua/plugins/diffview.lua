return {
	"sindrets/diffview.nvim",
	lazy = true,
	cmd = {
		"DiffviewOpen",
		"DiffviewClose",
		"DiffviewFileHistory",
		"DiffviewToggleFiles",
		"DiffviewFocusFiles",
		"DiffviewRefresh",
	},
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	config = function()
		require("diffview").setup({
			enhanced_diff_hl = true,
			view = {
				default = {
					layout = "diff2_horizontal",
				},
				merge_tool = {
					layout = "diff3_horizontal",
					disable_diagnostics = true,
				},
			},
		})
	end,
}

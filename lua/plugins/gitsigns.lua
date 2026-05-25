return {
	"lewis6991/gitsigns.nvim",

	event = "BufReadPre",

	keys = {
		{
			"<leader>tb",
			function()
				require("gitsigns").toggle_current_line_blame()
			end,
			desc = "Toggle Git Blame",
		},
	},

	config = function()
		require("gitsigns").setup({
			current_line_blame = true,

			current_line_blame_opts = {
				delay = 50,
				virt_text_pos = "eol",
			},

			current_line_blame_formatter = "<author>, <author_time:%R> - <summary>",
		})
	end,
}

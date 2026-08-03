return {
	-- {
	--   "catppuccin/nvim",
	--   lazy = false,
	--   name = "catppuccin",
	--   priority = 1000,
	--   config = function()
	--     vim.cmd.colorscheme "catppuccin-mocha"
	--   end
	-- }
	-- {
	--   "ellisonleao/gruvbox.nvim",
	--   lazy = false,
	--   priority = 1000,
	--   config = function()
	--     vim.o.background = "dark" -- or "light"
	--     vim.cmd.colorscheme("gruvbox")
	--   end,
	-- }
	{
		"rebelot/kanagawa.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			-- Optional configuration
			require("kanagawa").setup({
				compile = false,
				transparent = false,
				dimInactive = false,
				terminalColors = true,
				theme = "wave", -- "wave", "dragon", or "lotus"
			})

			vim.cmd.colorscheme("kanagawa")
		end,
	},
}

return {
	{
		"NeogitOrg/neogit",

		cmd = "Neogit",

		keys = {
			{
				"<leader>gg",
				"<cmd>Neogit<CR>",
				desc = "Neogit",
			},

			{
				"<leader>gv",
				function()
					local lib = require("diffview.lib")
					local view = lib.get_current_view()

					if view then
						vim.cmd("DiffviewClose")
					else
						vim.cmd("DiffviewOpen")
					end
				end,
				desc = "Toggle Diffview",
			},

			{
				"<leader>gh",
				function()
					local lib = require("diffview.lib")
					local view = lib.get_current_view()

					if view then
						vim.cmd("DiffviewClose")
					else
						vim.cmd("DiffviewFileHistory %")
					end
				end,
				desc = "Toggle File History",
			},

			{
				"<leader>gm",
				"<cmd>DiffviewOpen --imply-local<CR>",
				desc = "Merge Conflicts",
			},
		},

		dependencies = {
			"nvim-lua/plenary.nvim",
			"sindrets/diffview.nvim",
			"nvim-telescope/telescope.nvim",
		},

		config = function()
			-- DIFFVIEW
			require("diffview").setup({
				enhanced_diff_hl = true,
				use_icons = true,

				view = {
					default = {
						layout = "diff2_horizontal",
					},

					merge_tool = {
						layout = "diff3_horizontal",
						disable_diagnostics = true,
					},
				},

				file_panel = {
					listing_style = "tree",

					win_config = {
						position = "left",
						width = 35,
					},
				},

				file_history_panel = {
					log_options = {
						git = {
							single_file = {
								diff_merges = "combined",
							},
						},
					},
				},

				keymaps = {
					view = {
						["q"] = "<cmd>DiffviewClose<CR>",
					},

					file_panel = {
						["q"] = "<cmd>DiffviewClose<CR>",
					},
				},
			})

			-- NEOGIT
			require("neogit").setup({
				kind = "split",

				integrations = {
					diffview = true,
					telescope = true,
				},

				disable_commit_confirmation = true,
				auto_refresh = true,
				graph_style = "unicode",

				signs = {
					section = { "", "" },
					item = { "", "" },
					hunk = { "", "" },
				},

				status = {
					recent_commit_count = 10,
				},

				commit_editor = {
					kind = "tab",
				},

				commit_select_view = {
					kind = "tab",
				},

				commit_view = {
					kind = "vsplit",
				},

				log_view = {
					kind = "tab",
				},

				rebase_editor = {
					kind = "split",
				},

				reflog_view = {
					kind = "tab",
				},

				preview_buffer = {
					kind = "split",
				},

				popup = {
					kind = "split",
				},

				mappings = {
					status = {
						["q"] = "Close",
						["<tab>"] = "Toggle",
						["<cr>"] = "GoToFile",
						["s"] = "Stage",
						["u"] = "Unstage",
						["x"] = "Discard",
					},
				},
			})
		end,
	},
}

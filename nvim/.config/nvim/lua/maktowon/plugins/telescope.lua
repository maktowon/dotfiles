return {
	{
		"nvim-telescope/telescope.nvim",
		branch = "0.1.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
			"nvim-tree/nvim-web-devicons",
			"folke/todo-comments.nvim",
		},

		config = function()
			local telescope = require("telescope")
			local actions = require("telescope.actions")
			-- local transform_mod = require("telescope.actions.mt").transform_mod

			-- local trouble = require("trouble")
			-- local trouble_telescope = require("trouble.sources.telescope")

			-- or create your custom action
			-- local custom_actions = transform_mod({
			--   open_trouble_qflist = function(prompt_bufnr)
			--     trouble.toggle("quickfix")
			--   end,
			-- })

			telescope.setup({
				defaults = {
					mappings = {
						i = {
							["<C-j>"] = actions.move_selection_next,
							["<C-k>"] = actions.move_selection_previous,
						},
						n = {
							["<C-j>"] = actions.move_selection_next,
							["<C-k>"] = actions.move_selection_previous,
						},
					},
				},
			})

			telescope.load_extension("fzf")

			vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Fuzzy find files in cwd" })
			vim.keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "Fuzzy find recent files" })
			vim.keymap.set("n", "<leader>fs", "<cmd>Telescope live_grep<cr>", { desc = "Find string in cwd" })
			vim.keymap.set(
				"n",
				"<leader>fc",
				"<cmd>Telescope grep_string<cr>",
				{ desc = "Find string under cursor in cwd" }
			)
			vim.keymap.set("n", "<leader>ft", "<cmd>TodoTelescope<cr>", { desc = "Find todos" })
		end,
	},
	{
		"nvim-telescope/telescope-ui-select.nvim",

		config = function()
			require("telescope").setup({
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown({
							-- more opts
						}),
					},
				},
			})
			require("telescope").load_extension("ui-select")
		end,
	},
}

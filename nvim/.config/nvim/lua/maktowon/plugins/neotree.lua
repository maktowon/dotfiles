return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
		"MunifTanjim/nui.nvim",
		-- {"3rd/image.nvim", opts = {}}, -- Optional image support in preview window: See `# Preview Mode` for more information
	},
	lazy = false, -- neo-tree will lazily load itself
	---@module "neo-tree"
	---@type neotree.Config?
	opts = {
		event_handlers = {
			{
				event = "file_opened",
				handler = function(_)
					-- auto close neo-tree
					require("neo-tree.command").execute({ action = "close" })
				end,
			},
		},
	},
	vim.keymap.set("n", "<leader>e", ":Neotree reveal position=float toggle left<CR>"),
}


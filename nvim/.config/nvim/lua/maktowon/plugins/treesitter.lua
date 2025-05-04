return {
	"nvim-treesitter/nvim-treesitter",
	build = function()
		require("nvim-treesitter.install").update({ with_sync = true })()
    ":TSUpdate"
	end,

	config = function()
		local treesitter = require("nvim-treesitter.configs")
		treesitter.setup({
      auto_install = true,
			highliht = {
				enable = true,
			},
			indent = {
				enable = true,
			},
		})
	end,
}

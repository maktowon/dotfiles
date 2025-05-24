return {
  "nvimtools/none-ls.nvim",
  dependencies = {
    "nvimtools/none-ls-extras.nvim",
  },
  config = function()
    local null_ls = require("null-ls")

    null_ls.setup({
      sources = {
        -- Lua formatting
        null_ls.builtins.formatting.stylua,

        -- JavaScript / TypeScript
        null_ls.builtins.formatting.prettier,
        require("none-ls.diagnostics.eslint"),

        -- Python
        null_ls.builtins.formatting.yapf,
        null_ls.builtins.formatting.isort,
        require("none-ls.diagnostics.flake8"),

        -- C / C++
        null_ls.builtins.formatting.clang_format,
        require("none-ls.diagnostics.cpplint"), -- or clang_check
      },
    })

    vim.keymap.set("n", "<leader>L", function()
      vim.lsp.buf.format({ async = true })
    end, { desc = "Format current buffer" })
  end,
}


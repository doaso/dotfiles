return {
    "nvim-treesitter/nvim-treesitter",
    config = function()
        local treesitter = require("nvim-treesitter")
        treesitter.install({ "cpp", "rust" })

        vim.api.nvim_create_autocmd("FileType", {
            pattern = { "cpp", "hpp", "c", "h", "rs" },
            callback = function() vim.treesitter.start() end
        })
    end
}

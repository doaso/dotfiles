return {
    "nvim-treesitter/nvim-treesitter",
    config = function()
        require("nvim-treesitter").install({
            "cpp", "rust"
        })

        vim.api.nvim_create_autocmd("FileType", {
            pattern = { 
                "cpp", "hpp", "rs"
            },

            callback = function()
                vim.treesitter.start()
            end
        })
    end
}

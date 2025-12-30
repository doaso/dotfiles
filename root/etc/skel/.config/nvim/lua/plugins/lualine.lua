return {
    "nvim-lualine/lualine.nvim",
    dependencies = {
        "nvim-tree/nvim-web-devicons"
    },

    config = function()
        require("lualine").setup({
            options = {
                icons_enabled = true,
                theme = "onedark",
                component_separators = {
                    left = " ",
                    right = " ",
                },

                section_separators = {
                    left = "",
                    right = ""
                },
            },

            sections = {
                lualine_a = { "mode" },
                lualine_b = {},
                lualine_c = {},
                lualine_x = {},
                lualine_y = { "filetype", "encoding" },
                lualine_z = { "location" }
            }
        })
    end
}

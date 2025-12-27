return {
    "hrsh7th/nvim-cmp",
    dependencies = { "hrsh7th/cmp-nvim-lsp", "hrsh7th/cmp-buffer", "hrsh7th/cmp-path", "L3MON4D3/LuaSnip" },
    config = function()
        local cmp = require("cmp")
        
        cmp.setup({
            sources = cmp.config.sources({
                { name = "nvim_lsp" },
                { name = "buffer" },
                { name = "path" }
            }),

            mapping = cmp.mapping.preset.insert({
                ["<C-p>"] = cmp.mapping.select_prev_item({behavior = cmp.SelectBehavior.Select}),
                ["<C-n>"] = cmp.mapping.select_next_item({behavior = cmp.SelectBehavior.Select}),
                ["<CR>"] = cmp.mapping.confirm({select = false}),
            }),

            snippet = {
                expand = function(args)
                    require("luasnip").lsp_expand(args.body)
                end,
            },

            window = {
                completion = cmp.config.window.bordered(),
                documentation = cmp.config.window.bordered()
            }
        })
    end
}

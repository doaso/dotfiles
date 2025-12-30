return {
    "saghen/blink.cmp",
    dependencies = { "rafamadriz/friendly-snippets" },
    version = "1.*",
    opts = {
        keymap = { preset = "default" },
        completion = {
            documentation = { auto_show = false }
        },

        sources = {
            default = { "lsp", "path", "snippets", "buffer" },
        },

        fuzzy = {
            implementation = "prefer_rust_with_warning"
        },

        cmdline = {
            keymap = { preset = "inherit" },
            completion = {
                menu = {
                    auto_show = true
                }
            }
        }
    },

    opts_extend = { "sources.default" }
}

-- stylua: ignore
-- if true then return {} end

return {
    {
       "williamboman/mason.nvim",
        opts = function(_, opts)
            table.insert(opts.ensure_installed, "black")
            table.insert(opts.ensure_installed, "isort")
        end,
    },
}

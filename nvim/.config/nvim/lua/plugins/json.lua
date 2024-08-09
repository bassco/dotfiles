return {
  -- add json
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "json", "json5", "jsonc" })
      end
    end,
  },

  -- yaml schema support
  {
    "b0o/SchemaStore.nvim",
    lazy = true,
    version = false, -- last release is way too old
  },

  -- correctly setup lspconfig
  {
    "neovim/nvim-lspconfig",
    opts = {
      -- make sure mason installs the server
      servers = {
        jsonls = {
          -- lazy-load schemastore when needed
          on_new_config = function(new_config)
            new_config.settings.json.schemas = new_config.settings.json.schemas or {}
            vim.list_extend(new_config.settings.json.schemas, require("schemastore").json.schemas())
            vim.list_extend(new_config.settings.json.schemas.extra, {
              name = "Gitlab CI",
              description = "Gitlab CI files",
              fileMatch = { "gitlab-ci/*.yml", ".gitlab-ci.yml", ".gitlab/*.yml" },
              url = "https://gitlab.com/gitlab-org/gitlab/-/raw/master/app/assets/javascripts/editor/schema/ci.json",
            })
            vim.list_extend(new_config.settings.json.schemas.extra, {
              name = "Helm Unittest",
              description = "Helm Unittest files",
              fileMatch = { "tests/*_test.yaml" },
              url = "https://raw.githubusercontent.com/helm-unittest/helm-unittest/main/schema/helm-testsuite.json",
            })
          end,
          validate = { enable = true },
        },
      },
    },
  },
}

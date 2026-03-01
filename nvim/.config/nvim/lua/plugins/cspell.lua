local cspell_config = vim.fn.expand("~/.config/cspell/cspell.json")

--- Add the word under the cursor to a cspell dictionary file.
--- Prompts to choose between global (base-words) and project (cwd/cspell.json).
local function add_word()
  local word = vim.fn.expand("<cword>")
  if word == "" then
    return
  end

  vim.ui.select({ "global (base-words)", "project (cspell.json)" }, {
    prompt = 'Add "' .. word .. '" to:',
  }, function(choice)
    if not choice then
      return
    end

    if choice:match("^global") then
      local dict = vim.fn.expand("~/.config/cspell/base-words.txt")
      vim.fn.writefile({ word }, dict, "a")
      vim.notify('Added "' .. word .. '" to base-words.txt')
    else
      local project_config = vim.fn.getcwd() .. "/cspell.json"
      local config = {}
      if vim.fn.filereadable(project_config) == 1 then
        local content = table.concat(vim.fn.readfile(project_config), "\n")
        config = vim.json.decode(content) or {}
      end
      config.words = config.words or {}
      table.insert(config.words, word)
      table.sort(config.words)
      vim.fn.writefile({ vim.json.encode(config) }, project_config)
      vim.notify('Added "' .. word .. '" to project cspell.json')
    end

    -- refresh diagnostics
    vim.cmd("edit")
  end)
end

return {
  {
    "mfussenegger/nvim-lint",
    opts = function(_, opts)
      opts.linters_by_ft = opts.linters_by_ft or {}
      opts.linters_by_ft["*"] = opts.linters_by_ft["*"] or {}
      table.insert(opts.linters_by_ft["*"], "cspell")

      opts.linters = opts.linters or {}
      opts.linters.cspell = {
        args = {
          "lint",
          "--no-color",
          "--no-progress",
          "--no-summary",
          "--config",
          cspell_config,
          function()
            return "stdin://" .. vim.api.nvim_buf_get_name(0)
          end,
        },
      }
    end,
  },
  {
    "folke/which-key.nvim",
    opts = {
      defaults = {},
    },
    keys = {
      { "<leader>cw", add_word, desc = "Add word to cspell dictionary" },
    },
  },
}

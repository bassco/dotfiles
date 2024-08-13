local ls = require("luasnip")

local s = ls.s
local i = ls.insert_node
local c = ls.choice_node
local t = ls.text_node

ls.add_snippets("lua", {
  s("hello", {
    t('print("hello world!")'),
  }),
})

-- since this is just an example spec, don't actually load anything here and return an empty spec
return {
  -- add night-owl
  { "oxfist/night-owl.nvim" },
  -- Configure LazyVim to load night-owl
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "night-owl",
    },
  },
}

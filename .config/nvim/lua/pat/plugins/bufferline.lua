require("bufferline").setup({
  options = {
    mode = "tabs",
    numbers = function(opts)
      return string.format("%s", opts.ordinal)
    end,
    show_close_icon = false,
    show_buffer_close_icons = false,
    separator_style = "thick",
  },
  highlights = {
    buffer_selected = {
      gui = "bold",
    },
  },
})

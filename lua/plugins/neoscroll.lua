return {
  "karb94/neoscroll.nvim",
  opts = {
    -- General options for smoother 60fps scrolling
    mappings = { "<C-u>", "<C-d>", "<C-b>", "<C-f>", "<C-y>", "<C-e>", "zt", "zz", "zb" },
    hide_cursor = true,
    stop_eof = true,
    respect_scrolloff = false,
    cursor_scrolls_alone = true,
    duration_multiplier = 1.5, -- Adjust this for your scroll speed preference
    easing = "quadratic",
    performance_mode = false,
  },
}

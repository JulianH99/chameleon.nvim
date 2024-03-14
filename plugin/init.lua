vim.api.nvim_create_user_command("RainbowPickColor", function()
  require("lualine-peacock").pick_color()
end, {})

vim.api.nvim_create_user_command("RainbowClearAllConfig", function()
  require("lualine-peacock").clear_configuration()
end, {})

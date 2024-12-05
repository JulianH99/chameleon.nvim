vim.api.nvim_create_user_command("ChamPickColor", function()
	require("chameleon").pick_color()
end, {})

vim.api.nvim_create_user_command("ChamClearAllConfig", function()
	require("chameleon").clear_configuration()
end, {})

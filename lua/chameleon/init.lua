local lualine = require("lualine")
local util = require("chameleon.util")

-- TODO: use plenary for file operations
-- TODO: support for selecting a proper foreground when using bg option
-- TODO: write help file

-- @class ChameleonConfig
-- @field config_path string
-- @field lualine {{section: string, component_index: number, change: 'fg' | 'bg'}}
-- @field dark_fg string
-- @field light_fg string
local ChameleonConfig = {
	config_path = vim.fs.normalize(vim.fn.stdpath("data") .. "/chameleon.json"),
	lualine = {
		-- { section = "c", component_index = 2, change = "bg" },
	},
	dark_fg = "#fff",
	light_fg = "#222",
}

-- @class M
-- @field config ChameleonConfig
-- @field color_config table
-- @field pick_color function
-- @field assign_color function
-- @field check_config_file function
-- @field setup function
local M = {
	config = {},
	color_config = {},
}

-- Clears configuration from config file by erasing all data
-- @return nil
function M.clear_configuration()
	local handler = io.open(M.config.config_path, "w")
	if handler then
		handler:write("")
		handler:close()
	end
end

-- @param path string
-- @param color string
-- @return nil
function M.save_configuration(path, color)
	M.color_config[path] = color

	local handler = io.open(M.config.config_path, "w")
	if handler then
		handler:write(vim.fn.json_encode(M.color_config))
		handler:close()
	end
end

-- @return table
function M.read_configuration()
	local handler = io.open(M.config.config_path, "r")

	local config = handler and handler:read("*a")

	if handler then
		handler:close()
	end

	if not config or config == "" then
		return {}
	end

	return vim.fn.json_decode(config) or {}
end

-- @param path string
-- @return string
function M.get_color_for_path(path)
	local config = M.read_configuration()

	if config[path] then
		return config[path]
	end
end

-- @param color string
-- @return nil
function M.assign_color(color)
	local lualine_config = lualine.get_config()
	local local_config = M.config
	print(vim.inspect(local_config))
	if color then
		for _, conf in ipairs(local_config.lualine) do
			if lualine_config.sections["lualine_" .. conf.section] then
				if lualine_config.sections["lualine_" .. conf.section][conf.component_index] then
					local section = lualine_config.sections["lualine_" .. conf.section][conf.component_index]
					if section.color ~= nil then
						section.color[conf.change] = color
					else
						section.color = { [conf.change] = color }
					end

					if conf.change == "bg" then
						if util.is_dark(color) then
							lualine_config.sections["lualine_" .. conf.section][conf.component_index].color["fg"] =
								M.config.dark_fg
						else
							lualine_config.sections["lualine_" .. conf.section][conf.component_index].color["fg"] =
								M.config.light_fg
						end
					end
				else
					util.notify(
						"Lualine does not have a component at index "
							.. conf.component_index
							.. " on section "
							.. conf.section,
						vim.log.levels.WARN
					)
				end
			else
				util.notify("Lualine does not have a section on " .. conf.section, vim.log.levels.WARN)
			end
		end
		lualine.setup(lualine_config)
	end
end

-- @return nil
function M.pick_color()
	local path = vim.loop.cwd()

	vim.ui.input({ prompt = "Pick a color: " }, function(color)
		M.save_configuration(path, color)

		M.assign_color(color)
	end)
end

-- @return nil
function M.check_config_file()
	if vim.fn.filereadable(M.config.config_path) == 0 then
		-- create config file
		vim.fn.writefile({}, M.config.config_path)
	end
end

-- @param config ChameleonConfig
function M.setup(config)
	if config.lualine == nil or #config.lualine == 0 then
		util.notify("No lualine config was provided", vim.log.levels.WARN)
		return nil
	end
	local local_config = vim.tbl_deep_extend("force", ChameleonConfig, config or {})

	M.config = local_config

	M.color_config = M.read_configuration()

	local current_cwd = vim.loop.cwd()
	local color = M.get_color_for_path(current_cwd)

	M.assign_color(color)
end

return M

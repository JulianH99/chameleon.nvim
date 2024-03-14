local lualine = require("lualine")

-- @class PeacockConfig
-- @field config_path string
-- @field lualine {section: string, component_index: number, change: 'fg'|'bg'}
local PeacockConfig = {
  config_path = vim.fs.normalize(vim.fn.stdpath("data") .. "\\lualine-peacock.json"),
  lualine = {
    section = "c",
    component_index = 1,
    change = "fg",
  },
}

-- @class M
-- @field config PeacockConfig
-- @field color_config table
-- @field pick_color function
-- @field assign_color function
-- @field check_config_file function
-- @fiend setup function

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
  if color then
    lualine_config.sections["lualine_" .. local_config.lualine.section][local_config.lualine.component_index].color[local_config.lualine.change] =
      color
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

-- @param config PeacockConfig
function M.setup(config)
  local local_config = vim.tbl_deep_extend("force", PeacockConfig, config or {})

  M.config = local_config

  M.color_config = M.read_configuration()

  local current_cwd = vim.loop.cwd()
  local color = M.get_color_for_path(current_cwd)

  M.assign_color(color)
end

return M

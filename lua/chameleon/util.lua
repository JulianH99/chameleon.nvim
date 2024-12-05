-- @field is_dark function
local M = {}

-- Returns wether or not a color
-- is dark or light
-- @param color string
function M.is_dark(color)
	if #color < 7 then
		vim.notify("The color does not have the appropriate format (#xxyyzz)")
		return true
	end

	local comps = "0x" .. string.sub(color, 2)
	local hexcomp = tonumber(comps)

	local r, g, b = bit.rshift(hexcomp, 16), bit.band(bit.rshift(hexcomp, 8), 255), bit.band(hexcomp, 255)

	local brightness = math.sqrt(0.299 * math.pow(r, 2) + 0.587 * math.pow(g, 2) + 0.144 * math.pow(b, 2))

	return brightness > 127.5
end

-- Logs with vim.notify
-- @param msg string - Message to log
-- @param level? vim.log.levels - enum for the level
function M.notify(msg, level)
	vim.notify("Chameleon: " .. msg, level)
end

return M

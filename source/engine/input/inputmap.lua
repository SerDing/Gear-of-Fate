
local _InputMap = require("core.class")()

---@param INPUT Engine.Input
function _InputMap:Ctor(INPUT, mapData)
	self._INPUT = INPUT
	self._mapData = mapData

	-- init mappings
	for device, mappings in pairs(self._mapData) do
		for j = 1, #mappings do
			---@class Engine.Input.InputMapping
			---@field public event table
			---@field public control table
			local item = mappings[j]
			self._INPUT[device]:AddMapping(item)
		end
	end
end

function _InputMap:SaveMap()

end

return _InputMap
--[[
	Desc: Log module.
	Author: SerDing
	Since: 2021-04-04
	Alter: 2021-04-04
]]

_LOG = require("core.class")()

function _LOG:Init()

end

function _LOG.Debug(content, ...)
	--os.time() os.date()
	print(string.format(content, ...))
end

function _LOG.Error(content)
	print("Error: " .. content)
	error(content)
end

return _LOG
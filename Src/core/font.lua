--[[
	Desc: Font class based on the font functions of love
	Author: SerDing
	Since: 2018-08-16 01:31:24 
	Last Modified time: 2018-08-16 01:31:24 

]]

local _Font = require("core.class")()

local _NewFont = love.graphics.newFont -- filename (string), size (number)
local _IsFileExisting = love.filesystem.exists
local _GetFont = love.graphics.getFont
local _SetFont = love.graphics.setFont
local _GPrint = love.graphics.print

function _Font:Ctor(path, size)
    assert(_IsFileExisting(path), "_Font:Ctor()  the font file is not existing: " .. path)
    self.font = _NewFont(path, size or 12)
end 

function _Font:Print(text, x, y, rotation, sx, sy)
    local _oriFont = _GetFont()
    _SetFont(self.font)
    _GPrint(text, x, y, rotation, sx, sy)
    _SetFont(_oriFont)
end

return _Font 
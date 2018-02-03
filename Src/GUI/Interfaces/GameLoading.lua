--[[
	Desc: A new lua class
 	Author: Night_Walker
	Since: 2017-07-28 21:54:14
	Alter: 2017-07-30 12:40:40
	Docs:
		*Write notes here even more
]]

local _GameLoading = require("Src.Core.Class")()

local _RESMGR = require "Src.ResManager"


function _GameLoading:Ctor()
    self.background = _RESMGR.LoadTexture()
end 

function _GameLoading:Update(dt)
    --body
end 

function _GameLoading:Draw(x,y)
    --body
end

return _GameLoading 
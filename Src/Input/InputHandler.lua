--[[
	Desc: Input Handler class
	Author: Night_Walker 
	Since: 2018-04-06 16:21:59 
	Last Modified time: 2018-04-06 16:21:59 
	Docs: 
		* This class run as the interface for some actor's input components
]]

local _InputHandler = {}

local _Inputs = {}

function _InputHandler.PressHandle(key)
    for i=1,#_Inputs do
        if not _Inputs[i]:GetActor():IsAI() then
            _Inputs[i]:Press(key)
        end
    end
end 

function _InputHandler.ReleaseHandle(key)
    for i=1,#_Inputs do
        if not _Inputs[i]:GetActor():IsAI() then
            _Inputs[i]:Release(key)
        end
    end
end

function _InputHandler.Register(input)
    _Inputs[#_Inputs + 1] = input
end

return _InputHandler 
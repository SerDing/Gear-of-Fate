--[[
	Desc: Input Manager
	Author: Night_Walker 
	Since: 2018-04-06 16:21:59 
	Last Modified time: 2018-04-06 16:21:59 
	Docs: 
		* handle input messages and register input observer
]]

local _InputMgr = {}

local _Inputs = {}

function _InputMgr.PressHandle(key)
    for i=1,#_Inputs do
        if not _Inputs[i]:GetActor():IsAI() then
            _Inputs[i]:Press(key)
        end
    end
end 

function _InputMgr.ReleaseHandle(key)
    for i=1,#_Inputs do
        if not _Inputs[i]:GetActor():IsAI() then
            _Inputs[i]:Release(key)
        end
    end
end

function _InputMgr.Register(input)
    _Inputs[#_Inputs + 1] = input
end

return _InputMgr
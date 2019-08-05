--[[
	Desc: Hotkey manager
	Author: SerDing 
	Since: 2018-09-14 16:17:23 
	Last Modified time: 2018-09-14 16:17:23 
	Docs: 
		* manage hotkeys of skills and game functions
]]

local _HotkeyMgr = {KEY = {}, ABS_KEY = {}}

local this = _HotkeyMgr

function _HotkeyMgr.Ctor(hero_job)
    this.KEY = {
		["UP"] = "up",
		["DOWN"] = "down",
		["LEFT"] = "left",
		["RIGHT"] = "right",
		
		["JUMP"] = "c",
		["ATTACK"] = "x",
		["SKL_UNIQUE"] = "z",
		["BACK"] = "v",

		["SKL_A"] = "a",
		["SKL_S"] = "s",
		["SKL_D"] = "d",
		["SKL_F"] = "f",
		["SKL_G"] = "g",
		["SKL_H"] = "h",

		["SKL_Q"] = "q",
		["SKL_W"] = "w",
		["SKL_E"] = "e",
		["SKL_R"] = "r",
		["SKL_T"] = "t",
		["SKL_Y"] = "y",
	}

	this.ABS_KEY = {} -- abstract keys, format:[skillID] = {shortcut_key_msg, command_key_msg},

    -- set command key msg for special skills
	if hero_job == "[swordman]" then
		this.ABS_KEY[46] = {"", "SKL_UNIQUE"} -- UpperSlash
		this.ABS_KEY[16] = {"", "SKL_UNIQUE"} -- Ashenfork
	end

end 

function _HotkeyMgr.GetSkillCMDKey(name)
	local idArr = this.ABS_KEY[name]
	if #idArr > 1 then
		return this.KEY[idArr[2]]
	end
	return this.KEY[idArr[1]]
end 

return _HotkeyMgr
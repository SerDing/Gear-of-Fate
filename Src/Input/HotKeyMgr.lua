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
-- local _SkillMgr = 

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

	this.ABS_KEY = {} -- abstract keys, format:[sklName] = {"SKL_12", "SKL_UNIQUE"},

	if hero_job == "[swordman]" then
		this.ABS_KEY[46] = {"SKL_Q", "SKL_UNIQUE"} -- UpperSlash
		this.ABS_KEY[16] = {"SKL_R", "SKL_UNIQUE"} -- Ashenfork
	end

end 

function _HotkeyMgr.GetSkillKey(sklID)
	local id = this.ABS_KEY[sklID][1]
	return this.KEY[id]
end 

function _HotkeyMgr.GetSkillCMDKey(name)
	local idArr = this.ABS_KEY[name]
	if #idArr > 1 then
		return this.KEY[idArr[2]]
	end
	return this.KEY[idArr[1]]
end 

function _HotkeyMgr.SetSkillAbsKey(name, key, CMDKey) -- set skill abstract key
	if not this.ABS_KEY[name] then
		this.ABS_KEY[name] = {}
	end
	this.ABS_KEY[name][1] = key
	this.ABS_KEY[name][2] = CMDkey or nil
end 

function _HotkeyMgr.InitSklAbsKey(id_key_table)
	-- id_key_table < sklID, absKey >  example: [8] = "SKL_Q"
	for k,v in pairs(id_key_table) do
		if not this.ABS_KEY[k] then
			this.ABS_KEY[k] = {}
		end
		this.ABS_KEY[k][1] = v
	end
end

return _HotkeyMgr 
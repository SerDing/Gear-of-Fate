--[[
	Desc: A new lua class
 	Author: Night_Walker
	Since: 2017-07-28 21:54:14
	Alter: 2017-07-30 12:40:40
	Docs:
		*Write notes here even more
]]

local _BuffMgr = {}

local _AniPack = require "Src.AniPack" 

_buffAnis = {
	["frenzy"] = "/Data/character/swordman/effect/animation/frenzy/buff", 

}
function _BuffMgr.Ctor()
    --body
end

function _BuffMgr.AddBuff(object,buffName)
	
	if object.buff[buffName].switch then
		-- print("The buff " .. buffName .. " has been added.")
		return  
	else 
		-- print("BuffSystem: Adding The buff " .. buffName)
		object.buff[buffName].switch = true
	end 

	if not object.buff[buffName].ani then
		local _aniLua = require (_buffAnis[buffName])
	
		object.buff[buffName].ani = _AniPack.New()
		object.buff[buffName].ani:SetAnimation(_aniLua)
		object.buff[buffName].ani:SetFilter(true)
	end 

end

function _BuffMgr.OffBuff(object,buffName)
	
	if not object.buff[buffName] then
		print("Error:The objected buff is not existing!")
		return false 
	end 

	if object.buff[buffName].switch then
		object.buff[buffName].switch = false
	end 
end

return _BuffMgr 
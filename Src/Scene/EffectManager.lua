--[[
	Desc: effect manager
 	Author: Night_Walker
	Since: 2017-07-28 21:54:14
	Alter: 2017-07-30 12:40:40
	Docs:
		*Write notes here even more
]]

local _EffectMgr = {}

local _Effect = require "Src.Scene.Blocks.Effect" 
local _ObjectMgr = require "Src.Scene.ObjectManager"

function _EffectMgr.Ctor()
	_EffectMgr.pathHead = {
		["SwordMan"] = "Data/character/swordman/effect/animation/" ,
		["HERO_SWORDMAN"] = "Data/character/swordman/effect/animation/" ,
	}
end 

-- _EffectMgr.GenerateEffect(animPath,x,y,playNum,dir)
-- animPath must contain the suffix".lua"
function _EffectMgr.GenerateEffect(animPath, x, y, playNum, dir)
	local effect = _Effect.New(animPath)
	effect:SetPos(x,y)
	effect:SetDir(dir)
	effect:GetAni():SetCurrentPlayNum(playNum) 
	_ObjectMgr.AddObject(effect)

	return effect
end

-- generate an extra effect to hero class
function _EffectMgr.ExtraEffect(animPath, x, y, playNum, dir, entity_)
	local effect = _Effect.New(animPath)
	effect:SetPos(x,y)
	effect:SetDir(dir)
	effect:GetAni():SetCurrentPlayNum(playNum) 
	entity_:AddExtraEffect(effect)

	return effect
end

return _EffectMgr 
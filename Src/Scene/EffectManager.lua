--[[
	Desc: effect manager
 	Author: Night_Walker
	Since: 2017-07-28 21:54:14
	Alter: 2017-07-30 12:40:40
	Docs:
		* effect factory
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

-- generate an extra effect to hero class
-- animPath must contain the suffix".lua"
function _EffectMgr.ExtraEffect(animPath, entity)
	local effect = _Effect.New(animPath)
	effect:SetPos(entity.pos.x, entity.pos.y)
	effect:SetDir(entity.dir)
	effect:GetAni():SetCurrentPlayNum(1)
	entity:AddExtraEffect(effect)

	return effect
end

return _EffectMgr 
--[[
	Desc: A new lua class
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
		["SwordMan"] = "../Data/character/swordman/effect/animation/" ,
		["HERO_SWORDMAN"] = "../Data/character/swordman/effect/animation/" ,
	}
end 

-- _EffectMgr.GenerateEffect(_aniPath,x,y,playNum,dir)
-- _aniPath must contain the suffix".lua" 
function _EffectMgr.GenerateEffect(_aniPath, x, y, playNum, dir)
	
	local _tmpEffect = _Effect.New(_aniPath)
	
	_tmpEffect:SetPos(x,y)
	
	_tmpEffect:SetDir(dir)
	
	_tmpEffect:GetAni():SetCurrentPlayNum(playNum) 
	
	_ObjectMgr.AddObject(_tmpEffect)

	return _tmpEffect
end

function _EffectMgr.ExtraEffect(_aniPath, x, y, playNum, dir, entity_)  -- generate an extra effect to hero class
	
	local _tmpEffect = _Effect.New(_aniPath)
	
	_tmpEffect:SetPos(x,y)
	
	_tmpEffect:SetDir(dir)
	
	_tmpEffect:GetAni():SetCurrentPlayNum(playNum) 
	
	entity_:AddExtraEffect(_tmpEffect)

	return _tmpEffect
end

return _EffectMgr 
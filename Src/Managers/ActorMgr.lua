--[[
	Desc: Actor manager
	Author: SerDing 
	Since: 2019-03-14
	Alter: 2019-03-14
	Docs: 
        * Create or destruct actor
        * Hold the id list data of monsters to create monster by id
        * Register some callbacks of self into the SCENEMGR to implement response for some scene event works
]]

---@class ACTORMGR
---@public field mainPlayer Hero_SwordMan

local _ACTORMGR = {}
local this = _ACTORMGR

local _SwordMan = require "Src.Heroes.Hero_SwordMan"

local _Avatar = require "Src.Engine.Animation.Avatar"
local _Weapon = require "Src.Components.Weapon"
local _FSM = require "Src.FSM.FSM_Hero"
local _AttackJudger = require "Src.Components.AttackJudger"
local _Input = require "Src.Components.Input"
local _Movement = require "Src.Components.Movement"
local _SkillHandler = require "Src.BattleSystem.SkillManager"
local _HP_Model = require "Src.Components.Model.HP"
local HP_ModelUnitTest = require("Src.Components.Model.HP_UnitTest")

-- 1.采用配置文件的形式避免硬编码，只需实现NewActor()
-- 2.暂时采用硬编码，实现 NewHero() 和 NewMonster()，

function _ACTORMGR.Ctor()
    this.mainPlayer = nil ---@type Hero_SwordMan
    this.monsters = {} ---@type Monster[]
end

function _ACTORMGR.NewActor()
    -- body
end

function _ACTORMGR.DestructActor(actor)
    local _movement = actor:GetComponent("Movement")
    this._SCENEMGR.DelEventListener("OnSwitchScene", _movement, _movement.SetSceneRef)
end

---@return Hero_SwordMan
function _ACTORMGR.NewHero()
    local hero = _SwordMan.New(400, 460)
    local _movement = hero:GetComponent("Movement")
    this._SCENEMGR.RegEventListener("OnSwitchScene", _movement, _movement.SetSceneRef)
    this.mainPlayer = hero
    return hero
end 

function _ACTORMGR._NewHero()
    local hero = _SwordMan.New(0, 0)
    
    hero:AddComponent("HP", _HP_Model.New(120, 120))
    hero:AddComponent("MP", _HP_Model.New(120, 120, 0.325))
    hero:AddComponent("Movement", _Movement.New(hero))
    hero:AddComponent("Weapon", _Weapon.New(hero.subType, hero))
    hero:AddComponent("AttackJudger", _AttackJudger.New(hero, hero.subType))
    hero:AddComponent("Avatar", _Avatar.New())

    hero:AddComponent("Input", _Movement.New(hero))
    hero:AddComponent("SkillHandler", _SkillMgr.New(hero, {8, 16, 46, 64, 65, 76, 77, 169}))
    hero:AddComponent("FSM", _FSM.New(hero, "stay", hero.subType))
    hero:GetComponent("FSM"):OnNewStateEnter(hero)
    

    local _weapon = hero:GetComponent("Weapon")
    local _avatar = hero:GetComponent("Avatar")
    local _movement = hero:GetComponent("Movement")

    _avatar:AddWidget("body")
	_avatar:AddWidget("weapon_b1")
	_avatar:AddWidget("weapon_b2")
	_avatar:AddWidget("weapon_c1")
	_avatar:AddWidget("weapon_c2")
	_avatar:GetWidget("body"):SetImgPathArg(0001)

	_weapon:SetType("katana", "katana")  -- mainType, subType
	_weapon:SetRes("katana", 0001)  -- subType, fileNum

    this._SCENEMGR.RegEventListener("OnSwitchScene", _movement, _movement.SetSceneRef)
end

function _ACTORMGR.NewMonster(monID)
    
end

function _ACTORMGR.SetSceneMgrRef(s)
	assert(s, "SceneMgr reference is invalid")
    this._SCENEMGR = s
end

return _ACTORMGR 
--[[
	Desc: TripSlash, a skill state.
 	Author: SerDing
	Since: 2017-07-28 21:54:14
	Alter: 2017-07-30 12:40:40
]]

local _AUDIO = require("engine.audio")
local _FACTORY = require("system.entityfactory") 
local _Base  = require "entity.states.base"

---@class State.TripSlash : State.Base
local _TripleSlash = require("core.class")(_Base)

function _TripleSlash:Ctor(data, ...)
	_Base.Ctor(self, data, ...)
	self._keyFrames = data.keyFrames
	self._combo = #self._keyFrames + 1
	self.skillID = 8
	self._process = 0
	self.time_left = 0
	self.time_right = 0
	self.a = 200 --255
	self.slideX = 0 -- slide x distance accumulation
end 

function _TripleSlash:Enter()
	_Base.Enter(self)

	self._process = 1
	self:OnSetProcess()
	self.slideX = 0
	self.nextDir = self._entity.transform.direction
	self.combat:ClearDamageArr()
end

function _TripleSlash:Update(dt)
	_Base.EaseMove(self)
	self:ChangeDir()

	-- attack judgement
	-- if self._entity:GetAttackBox() then
	-- 	self.combat:Judge(self._entity, "MONSTER", self.attackName)
	-- end

	if self._process < self._combo then
		self:SetProcess(self._process + 1)
	end

	if self.body:TickEnd() and self.movement.easeMoveParam.v == 0 then
		self.STATE:SetState(self._nextState)
	end
end 

function _TripleSlash:SetProcess(nextProcess)
	if self.body:GetFrame() > self._keyFrames[self._process] then 
		if self.input:IsPressed("tripleslash") then
			self._process = nextProcess
			self.avatar:Play(self._animPathSet[nextProcess])
			self.combat:ClearDamageArr()
			self:ChangeDir()
			self._entity.transform.direction = self.nextDir
			self:OnSetProcess()
		end 
	end
end

function _TripleSlash:OnSetProcess()
	_AUDIO.PlaySound(self._soundDataSet.voice[self._process])
	_AUDIO.PlaySound(self._soundDataSet.swing[self._process])

	local param = {master = self._entity}
	_FACTORY.NewEntity(self._entityDataSet.slash[self._process], param)
	_FACTORY.NewEntity(self._entityDataSet.move[math.random(1, 2)], param)
end

function _TripleSlash:ReSetSpeed()
	--[[ 
		滑动距离由移动速度决定
		其不变时，攻速越快，滑动初速度越大，阻力加速度越大。
	]]
	
	--------------------------
	-- self.speed = 180 * (self._entity.stats.attackRate + 1) -- 260
	-- self.a = self.speed * 60 / 20 --  / self._entity.stats.attackRate
	-- self.slideX = 0

	--------------------------
	-- self.slideX = 0
	-- if self.a < 0 then
	-- 	self.a = - self.a
	-- end

	-- speed = baseSpeed * atkSpd -- 移动速度相对固定，因为只受攻击速度影响
	-- slideX = 固定值
	-- t = 580ms / (1000 * 动画播放加速倍数)  -- 单位:秒

	-- 推导加速度
	-- x = speed * t + 0.5 * a * t ^ 2  -- 一般方程 匀减速时 a < 0 
	-- x = 0.5 * a * t ^ 2  -- 反过来看匀减速过程 即为从 v = 0 开始的匀加速
	-- a = 2 * x / t ^ 2 -- 由上式即可求出阻力加速度

end
function _TripleSlash:ChangeDir()
	
	local left = self.input:IsHold("LEFT")
	local right = self.input:IsHold("RIGHT")

	if left or right then
        if left and right then
            if self.time_left > self.time_right then
                self.nextDir = -1
            elseif self.time_left == self.time_right then
                self.nextDir = self._entity.transform.direction
            else 
                self.nextDir = 1
            end 
        elseif left then
			self.nextDir = -1
        else 
            self.nextDir = 1
        end
    end

	if self.input:IsPressed("left") then
        self.time_left = love.timer.getTime()
    end 
   
    if self.input:IsPressed("right") then
        self.time_right = love.timer.getTime()
    end 
	
end

function _TripleSlash:Exit()
	_Base.Exit(self)
end

return _TripleSlash 
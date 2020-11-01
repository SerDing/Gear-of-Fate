--[[
	Desc: TripSlash, a skill state.
 	Author: SerDing
	Since: 2017-07-28 21:54:14
	Alter: 2017-07-30 12:40:40
]]

local _AUDIO = require("engine.audio")
local _FACTORY = require("system.entityfactory") 
local _Base  = require "entity.states.base"

---@class Entity.State.Swordman.TripSlash : State.Base
local _TripleSlash = require("core.class")(_Base)

function _TripleSlash:Ctor(data, ...)
	_Base.Ctor(self, data, ...)
	self.skillID = 8
	self._keyFrames = data.keyFrames
	self._combo = data.combo
	self._process = 0
	self._timeLeft = 0
	self._timeRight = 0
end 

function _TripleSlash:Enter()
	_Base.Enter(self)
	self._process = 1
	self._nextDirection = self._entity.transform.direction
	self._combat:SetSoundGroup(self._soundDataSet.hitting)
	self:_OnSetProcess()
end

function _TripleSlash:Update(dt)
	_Base.EaseMove(self)
	self:_ChangeDirection()

	if self._process < self._combo then
		self:_SetProcess(self._process + 1)
	end

	if self._body:TickEnd() and self._movement:IsEasemoving() == false then
		self._STATE:SetState(self._nextState)
	end
end 

function _TripleSlash:_SetProcess(nextProcess)
	if self._body:GetFrame() > self._keyFrames[self._process] then 
		if self._input:IsPressed("tripleslash") then
			self._process = nextProcess
			self._avatar:Play(self._animNameSet[nextProcess])
			self:_ChangeDirection()
			self:_OnSetProcess()
		end 
	end
end

function _TripleSlash:_OnSetProcess()
	self._entity.transform.direction = self._nextDirection
	self._combat:StartAttack(self._attackDataSet[self._process])
	_AUDIO.PlaySound(self._soundDataSet.voice[self._process])
	_AUDIO.PlaySound(self._soundDataSet.swing[self._process])

	local param = {master = self._entity}
	_FACTORY.NewEntity(self._entityDataSet.slash[self._process], param)
	_FACTORY.NewEntity(self._entityDataSet.move[math.random(1, 2)], param)
end

function _TripleSlash:_ChangeDirection()
	
	local left = self._input:IsHold("LEFT")
	local right = self._input:IsHold("RIGHT")

	if left or right then
        if left and right then
            if self._timeLeft > self._timeRight then
                self._nextDirection = -1
            elseif self._timeLeft == self._timeRight then
                self._nextDirection = self._entity.transform.direction
            else 
                self._nextDirection = 1
            end 
        elseif left then
			self._nextDirection = -1
        else 
            self._nextDirection = 1
        end
	end

	if self._input:IsPressed("left") then
        self._timeLeft = love.timer.getTime()
    end 
   
    if self._input:IsPressed("right") then
        self._timeRight = love.timer.getTime()
    end 
	
end

function _TripleSlash:Exit()
	_Base.Exit(self)
end

return _TripleSlash 
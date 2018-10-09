--[[
	Desc: HP Model
	Author: SerDing 
	Since: 2018-08-19 15:05:57 
	Last Modified time: 2018-08-19 15:05:57 
	Docs: 
		* Write more details here 
]]

local _HP_Model = require("Src.Core.Class")()
local stableFPS = 60
function _HP_Model:Ctor(cur, max, regenSpd)
    self.cur = cur or 100
    self.max = max or 100
    self.regenSpd = regenSpd or 0
    self.regen = (self.regenSpd == 0) and false or true
    self.regenIntervalTimer = 0 -- regeneration interval timer
    self.regenIntervalTime = 0.8
end 

function _HP_Model:Update(dt)
    if self.regen then
        if self.regenIntervalTimer >= self.regenIntervalTime then
            self:Increase(self.regenSpd * 60 * dt)
        else
            self.regenIntervalTimer = self.regenIntervalTimer + dt
        end
    end
end

function _HP_Model:Increase(p)
    if p < 0 then
        p = -p
    end
    self.cur = self.cur + p or 0
    if self.cur > self.max then
        self.cur = self.max
    end
end

function _HP_Model:Decrease(p)
    if p < 0 then
        p = -p
    end
    self.cur = self.cur - p or 0
    if self.cur < 0 then
        self.cur = 0
    end
    self.regenIntervalTimer = 0
end

function _HP_Model:GetMax()
    return self.max
end 

function _HP_Model:GetCur()
    return self.cur
end

return _HP_Model 
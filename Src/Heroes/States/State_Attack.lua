--[[
	Desc: Attack1 state 
 	Author: Night_Walker
	Since: 2017-07-28 21:54:14
	Alter: 2017-07-30 12:40:40
	Docs:
		* wrap the logic of Attack1 state in this class
]]

local _State_Attack = require("Src.Class")()

local _KEYBOARD = require "Src.Core.KeyBoard" 

function _State_Attack:Ctor()
    self.name = "attack"

    self.childName ={
        "attack1",
        "attack2",
        "attack3",

    } 
    

    self.attackNum = 0

end 

function _State_Attack:Enter(hero_)
    
	hero_.pakGrp.body:SetAnimation(self.childName[1])
	hero_.pakGrp.weapon:SetAnimation(self.childName[1])
	self.attackNum = 1

end

function _State_Attack:Update(hero_,FSM_)
    local _body = hero_.pakGrp.body
    local _dt = love.timer.getDelta()
    
    local _leftHold = _KEYBOARD.Hold(hero_.KEY["LEFT"])
    local _rightHold = _KEYBOARD.Hold(hero_.KEY["RIGHT"])

    if self.attackNum == 1 then
        
        if _KEYBOARD.Press(hero_.KEY["ATTACK"]) and _body:GetCount() > 3 then
            self.attackNum = 2
            hero_.pakGrp.body:SetAnimation(self.childName[self.attackNum])
	        hero_.pakGrp.weapon:SetAnimation(self.childName[self.attackNum])
        end 

    elseif self.attackNum == 2 then
        if _body:GetCount() <= 2 then
            
            -- if _leftHold then
            --     --body
            -- end 
            

            hero_:X_Move(hero_.spd.x * 20 * _dt * hero_.dir )

            if (_KEYBOARD.Hold(hero_.KEY["LEFT"]) and hero_.dir == -1 ) or 
            (_KEYBOARD.Hold(hero_.KEY["RIGHT"]) and hero_.dir == 1 )   then
                
                hero_:X_Move(hero_.spd.x * 20 * _dt * hero_.dir )

            end 
        end 
        

        if _KEYBOARD.Press(hero_.KEY["ATTACK"]) and _body:GetCount() > 3 then
            self.attackNum = 3
            hero_.pakGrp.body:SetAnimation(self.childName[self.attackNum])
	        hero_.pakGrp.weapon:SetAnimation(self.childName[self.attackNum])
        end 

    elseif self.attackNum == 3 then
        if _body:GetCount() < 3 then
            
            hero_:X_Move(hero_.spd.x * 20 * _dt * hero_.dir )

            if (_KEYBOARD.Hold(hero_.KEY["LEFT"]) and hero_.dir == -1 ) or 
            (_KEYBOARD.Hold(hero_.KEY["RIGHT"]) and hero_.dir == 1 )   then
                
                hero_:X_Move(hero_.spd.x * 20 * _dt * hero_.dir )

            end 
        end 


    end 
    
    if _KEYBOARD.Press(hero_.KEY["UNIQUE"]) then
		FSM_:SetState("upperslash",hero_)
	end  

end 

function _State_Attack:Exit(hero_)
    --body
end

return _State_Attack 
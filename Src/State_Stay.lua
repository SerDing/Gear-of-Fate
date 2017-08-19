--[[
	Desc: stay state 
 	Author: Night_Walker
	Since: 2017-07-28 21:54:14
	Alter: 2017-07-30 12:40:40
	Docs:
		* wrap the logic of stay state in this class
]]

local _State_Stay = require("Src.Class")()

function _State_Stay:Ctor()
    --body
end 

function _State_Stay:Enter(hero_)
    self.name = "stay"
	hero_.pakGrp.body:SetAnimation(self.name)
	hero_.pakGrp.weapon:SetAnimation(self.name)

end

function _State_Stay:Update(hero_,FSM_)
    
	if(love.keyboard.isDown("up"))then
		FSM_:SetState("move",hero_)
	end 
	
	if(love.keyboard.isDown("down"))then
		FSM_:SetState("move",hero_)
	end 
	
	if(love.keyboard.isDown("left"))then
		FSM_:SetState("move",hero_)
		hero_:SetDir(-1)
	end
	
	if(love.keyboard.isDown("right"))then
		FSM_:SetState("move",hero_)
		hero_:SetDir(1)
	end
end 

function _State_Stay:Exit(hero_)
    --body
end

return _State_Stay 
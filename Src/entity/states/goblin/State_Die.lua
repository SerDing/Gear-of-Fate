

local _State_Die = require("core.class")()

function _State_Die:Ctor(FSM, entity)
    self.FSM = FSM
    self._entity = entity
    self.name = "die"
end 

function _State_Die:Enter()
	self.avatar:Play("down")
    self.avatar:SetFrame(4)
    self._entity:Update(love.timer.getDelta())
    
end

function _State_Die:Update(dt)
    if self.avatar:GetPart():GetFrame() == 4 and #self._entity.extraEffects == 0 then
        self._entity:Die()
    end
end 

function _State_Die:Exit()
    --body
end

return _State_Die 


local _State_Die = require("Src.Core.Class")()

function _State_Die:Ctor(FSM, entity)
    self.FSM = FSM
    self.entity = entity
    self.name = "die"
end 

function _State_Die:Enter()
	self.entity:SetAnimation("[down motion]")
    self.entity.aniArr["body"]:SetFrame(4)
    self.entity:Update(love.timer.getDelta())
    
end

function _State_Die:Update()
    if self.entity.aniArr["body"]:GetCount() == 4 and #self.entity.extraEffects == 0 then
        self.entity:Die()
    end
end 

function _State_Die:Exit()
    --body
end

return _State_Die 
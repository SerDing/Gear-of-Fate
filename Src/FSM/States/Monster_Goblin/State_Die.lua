

local _State_Die = require("Src.Core.Class")()

function _State_Die:Ctor()
    self.name = "die"
end 

function _State_Die:Enter(entity)
	entity:SetAnimation("[down motion]")
    entity.aniArr["body"]:SetFrame(4)
    entity:Update(love.timer.getDelta())
    
end

function _State_Die:Update(entity,FSM_)
    if entity.aniArr["body"]:GetCount() == 4 and #entity.extraEffects == 0 then
        entity:Die()
    end
end 

function _State_Die:Exit(entity)
    --body
end

return _State_Die 
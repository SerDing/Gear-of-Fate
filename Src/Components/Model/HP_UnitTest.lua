-- Init data
local v = 2
local dir = -1

local function HP_ModelUnitTest(hero_)
    for k,_model in pairs(hero_.Models) do
		if _model:GetCur() >= _model:GetMax() then
			dir = - 1
			print("GetCur() >= GetMax(),", _model:GetCur(), _model:GetMax(), " dir has been changed to", dir)
		elseif _model:GetCur() <= 0 then
			dir = 1
			print("GetCur() <= 0,", _model:GetCur(), 0, " dir has been changed to", dir)
		end
	
		if dir < 0 then
			_model:Decrease(v)
		else
			_model:Increase(v)
		end
	end
end

return HP_ModelUnitTest
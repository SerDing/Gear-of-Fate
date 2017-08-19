--[[
	Desc: keyboard class
 	Author: Night_Walker
	Since: 2017-07-28 21:54:14
	Alter: 2017-07-30 12:40:40
	Docs:
		* New methods to check the key state
]]

local _KeyBoard = require("Src.Class")()

function _KeyBoard:Ctor()
    self.KEY = {} -- id: key_name  state: press or hold or release
end 

function _KeyBoard:Update()
   
    for n=1,#self.KEY do
        
        if self.KEY[n].state == "press" then
            self.KEY[n].state = "hold"
        end 

        if self.KEY[n].state == "release" then
            table.remove()
        end 
        
    end

end 

function _KeyBoard:Press(key)
    self:CheckKeyState(key,"press")
end 

function _KeyBoard:Hold(key)
    self:CheckKeyState(key,"hold")
end

function _KeyBoard:Release(key)
    self:CheckKeyState(key,"release")
end

function _KeyBoard:PressHandle(key)
    local key_ = {id = key, state = "press"}
    table.insert(self.KEY,key_)
end

function _KeyBoard:ReleaseHandle(key)
    for n=1,#self.KEY do
        if key == self.KEY[n].id then
            self.KEY[n].state = "release"
        end 
    end 
    
end

function _KeyBoard:CheckKeyState(key,state)
    
    for n=1,#self.KEY do
        if key == self.KEY[n].id then
            local _key = self.KEY[n].id
        end 
    end 

    if _key ~= nil then
        if _key.state = state then
            return true
        else 
            return false  
        end 
    else 
        return false 
    end 


end

    


return _KeyBoard 
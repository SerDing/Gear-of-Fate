--[[
    Desc: 
    Author: Night_Walker
    Since: Sat Sep 09 2017 18:35:30 GMT+0800 (CST)
    Alter: Sat Sep 09 2017 18:35:30 GMT+0800 (CST)
    Docs: 
        * this module is used to create scene by *.map file
]]

local _GameScene = require("Src.Class")()


function _GameScene:Ctor(path) --initialize

	
	

end

function _GameScene:Update(dt)

end


function _GameScene:Draw(x,y)

	for n=1,#self.obejcts do
		self.obejcts[n]:Draw()
	end

end

return _GameScene
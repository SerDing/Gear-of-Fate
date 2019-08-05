
local _Widget = require("Src.Core.Class")()

function _Widget:Ctor()
    self.debug = false
    self.debug = true
    print("_Widget:Ctor()  self.debug", self.debug)
end 

function _Widget:HandleEvent(msg, x, y)
    -- body
end 



return _Widget 
--[[
	Desc: UI widget base
	Author: SerDing 
	Since: 2019-08-10 
	Last Modified time: 2020-02-04 17:29:59
]]

---@class GUI.Widgets.Base
local _Widget = require("core.class")()

function _Widget:Ctor(name, x, y)
    self.name = name
    self.x = x
    self.y = y
    self.subjects = {} ---@type Widget[]
    self.visible = true
    self.controller = nil
end

--- px and py are used by SetTranslate for some widgets that using scissor function
---@param px number
---@param py number
function _Widget:Draw(px, py)
    -- draw subjects at (self.x + self.subjects[i].x, self.y + self.subjects[i].y)
    love.graphics.push()
    love.graphics.translate(self.x, self.y) -- parent position for subjects
    for i = 1, #self.subjects do
        self.subjects[i]:Draw(self.x, self.y) -- transmit parent position for scissor needs
    end
    love.graphics.pop()
end

function _Widget:AddSubject(subject)
    self.subjects[#self.subjects + 1] = subject
end

function _Widget:HandleEvent(msg, x, y)
    for i = 1, #self.subjects do
        self.subjects[i]:HandleEvent(msg, x - self.x, y - self.y)
    end
end

function _Widget:SetPos(x, y)
    self.x = x or self.x
    self.y = y or self.y
end

function _Widget:SetController(controller)
    self.controller = controller
end

function _Widget:SetVisible(v)
    self.visible = v
end

return _Widget 
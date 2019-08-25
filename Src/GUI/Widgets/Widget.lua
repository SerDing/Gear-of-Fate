
---@class Widget
local _Widget = require("Src.Core.Class")()

function _Widget:Ctor(name, x, y)
    self.name = name
    self.x = x
    self.y = y
    self.subjects = {} ---@type Widget[]
    self.translate = { x = 0, y = 0}
    self.visible = true
    self.controller = nil
end

--- px and py is used by SetTranslate for some widgets that using scissor function
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

function _Widget:SetTranslate(x, y)
    self.translate.x = x or self.translate.x
    self.translate.y = y or self.translate.y
end

function _Widget:SetController(controller)
    self.controller = controller
end

function _Widget:SetVisible(v)
    self.visible = v
end



return _Widget 
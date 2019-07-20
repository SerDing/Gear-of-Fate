--[[
	Desc: Avatar is a set of animations
	Author: SerDing 
	Since: 2018-09-22 22:55:23 
	Last Modified time: 2018-09-22 22:55:23 
	Docs: 
		* Write more details here 
]]

local _Avatar = require("Src.Core.Class")()

local _Animator = require "Src.Engine.Animation.Animator"

function _Avatar:Ctor()
    self.widgets = {}
    self.keylist = {} -- store key names of all widgets to draw them in order（(for k,v) cannot draw them in order）
end 

function _Avatar:Update(dt)
    for _,v in pairs(self.widgets) do
        v:Update(dt)
    end
end 

function _Avatar:Draw(x, y, r, sx, sy)
    for _,key in ipairs(self.keylist) do
        self.widgets[key]:Draw(x, y, r, sx, sy)
    end
end

function _Avatar:Play(a)
    for _,v in pairs(self.widgets) do
        v:Play(a)
    end
end 

function _Avatar:NextFrame()
    for _,v in pairs(self.widgets) do
        v:NextFrame()
    end
end 

function _Avatar:SetFrame(n)
    for _,v in pairs(self.widgets) do
        v:SetFrame(n)
    end
end

function _Avatar:SetPlayOver(b)
    for k,v in pairs(self.widgets) do
        v.playOver = b
    end
end

function _Avatar:SetPlayOver(b)
    for _,v in pairs(self.widgets) do
        v.playOver = b
    end
end

function _Avatar:Stop()
    for k,v in pairs(self.widgets) do
        v:Stop()
    end
end

function _Avatar:Continue()
    for _,v in pairs(self.widgets) do
        v:Continue()
    end
end

function _Avatar:SetDir(d)
    for k,v in pairs(self.widgets) do
        v:SetDir(d)
    end
end 

function _Avatar:SetPlayRate(s)
    for _,v in pairs(self.widgets) do
        v:SetPlayRate(s)
    end
end 

function _Avatar:SetColor(r, g, b, a)
    for _,v in pairs(self.widgets) do
        v:SetColor(r, g, b, a)
    end
end 

function _Avatar:GetAttackBox()
    return self.widgets["weapon_c1"]:GetAttackBox() or self.widgets["body"]:GetAttackBox()
end
---@param k string
function _Avatar:AddWidget(k)
    local w = _Animator.New()
    self.widgets[k] = w
    self.keylist[#self.keylist + 1] = k
end

---@return _Animator
function _Avatar:GetWidget(k)
    assert(self.widgets[k], "_AvatarGrp:GetWidget(k) nowidget" .. k)
    return self.widgets[k]
end

function _Avatar:AddActionData(k, path, num, name)
    self.widgets[k]:AddAnimation(path, num, name)
end

function _Avatar:ClearWidget(k)
    self.widgets[k] = {}
end

return _Avatar
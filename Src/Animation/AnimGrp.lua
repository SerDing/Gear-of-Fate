--[[
	Desc: Avatar animation group
	Author: SerDing 
	Since: 2018-09-22 22:55:23 
	Last Modified time: 2018-09-22 22:55:23 
	Docs: 
		* Write more details here 
]]

local _AvatarGrp = require("Src.Core.Class")()

local _Animation = require "Src.AniPack"

function _AvatarGrp:Ctor()
    self.widgets = {}
    self.keylist = {} -- store key names of all widgets to draw them in order（(for k,v) cannot draw them in order）
end 

function _AvatarGrp:Update(dt)
    for k,v in pairs(self.widgets) do
        v:Update(dt)
    end
end 

function _AvatarGrp:Draw(x, y, r, sx, sy)
    for i,key in ipairs(self.keylist) do
        self.widgets[key]:Draw(x, y, r, sx, sy)
    end
end

function _AvatarGrp:SetAnimation(a)
    for k,v in pairs(self.widgets) do
        v:SetAnimation(a)
    end
end 

function _AvatarGrp:NextFrame(n)
    for k,v in pairs(self.widgets) do
        v:NextFrame(n)
    end
end 

function _AvatarGrp:SetFrame(n)
    for k,v in pairs(self.widgets) do
        v:SetFrame(n)
    end
end 

function _AvatarGrp:SetCurrentPlayNum(n)
    for k,v in pairs(self.widgets) do
        v:SetCurrentPlayNum(n)
    end
end

function _AvatarGrp:Stop()
    for k,v in pairs(self.widgets) do
        v:Stop()
    end
end

function _AvatarGrp:Continue()
    for k,v in pairs(self.widgets) do
        v:Continue()
    end
end

function _AvatarGrp:SetDir(d)
    for k,v in pairs(self.widgets) do
        v:SetDir(d)
    end
end 

function _AvatarGrp:SetBaseRate(s)
    for k,v in pairs(self.widgets) do
        v:SetBaseRate(s)
    end
end 

function _AvatarGrp:SetColor(r, g, b, a)
    for k,v in pairs(self.widgets) do
        v:SetColor(r, g, b, a)
    end
end 

function _AvatarGrp:GetAttackBox()
    return self.widgets["weapon_c1"]:GetAttackBox() or self.widgets["body"]:GetAttackBox()
end

function _AvatarGrp:AddWidget(k)
    local w = _Animation.New()
    self.widgets[k] = w
    self.keylist[#self.keylist + 1] = k
end

function _AvatarGrp:GetWidget(k)
    assert(self.widgets[k], "_AvatarGrp:GetWidget(k) nowidget" .. k)
    return self.widgets[k]
end

function _AvatarGrp:AddActionData(k, path, num, name)
    self.widgets[k]:AddAnimation(path, num, name)
end

function _AvatarGrp:ClearWidget(k)
    self.widgets[k] = {}
end

return _AvatarGrp
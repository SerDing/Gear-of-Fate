--[[
	Desc: User Interface Manager
	Author: Night_Walker 
	Since: 2018-08-14 15:41:03 
	Last Modified time: 2018-08-14 15:41:03 
    Docs: 
        * Draw all interfaces
		* Dispatch messages by three callbacks (mousemoved(), mousepressed(), mousereleased())
]]
local _UI_Manager = {}

local this = _UI_Manager
local _Button = require("Src.GUI.Widgets.Button")
local _Sprite = require("Src.Core.Sprite")
local _RESMGR = require("Src.Resource.ResManager")

local _ENUM = require "Src.GUI.ENUM"

function _UI_Manager.Ctor()
    this.interfaces = {}
    this.curIndex = 1
    imagedata = love.image.newImageData(love.graphics.getWidth(), love.graphics.getHeight())
    _RESMGR.InstantiateImageData(imagedata)
    this.tmpSprite = _Sprite.New(love.graphics.newImage(imagedata))
    this.tmpSprite:SetColor(0, 0, 0,200)
end 

function _UI_Manager.Update(dt)
    -- body
end 

function _UI_Manager.MessageHandler(msg) -- CallBack
    if msg == _ENUM.SWITCH_HUD then
        this.SwitchInterface(_ENUM.INDEX_HUD)
        
    end
end

function _UI_Manager.SwitchInterface(index)
    this.curIndex = index
end

function _UI_Manager.Find(frameID, compArrName, compID)
    --Find(PanelID, tag)
    -- this.interfaces[this.curIndex].frames[frameID].
end

function _UI_Manager.Draw()
    -- this.tmpSprite:Draw(0, 0)
    this.interfaces[this.curIndex]:Draw()
end

function _UI_Manager.DispatchMessage(msg, x, y)
    for i,v in ipairs(this.interfaces) do
        v:DispatchMessage(msg, x, y)
    end
end

function _UI_Manager.MousePressed(x, y, button, istouch)
    print("_UI_Manager.MousePressed(x, y, button)", x, y, button)
	if button == 1 then
        _UI_Manager.DispatchMessage("MOUSE_LEFT_PRESSED", x, y)
    end
end

function _UI_Manager.MouseReleased(x, y, button, istouch)
    if button == 1 then
        _UI_Manager.DispatchMessage("MOUSE_LEFT_RELEASED", x, y)
    end
end

function _UI_Manager.MouseMoved(x, y, dx, dy)
    _UI_Manager.DispatchMessage("MOUSE_MOVED", x, y)
end

function _UI_Manager.AddInterface(k, i)
    this.interfaces[#this.interfaces + 1] = i
    print("UI_Manager.AddInterface()  ", i)
end



return _UI_Manager 
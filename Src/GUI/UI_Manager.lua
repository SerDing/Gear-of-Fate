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
local _Stack = require("Src.Core.Stack")
local _RESMGR = require("Src.Resource.ResManager")

local _ENUM = require "Src.GUI.ENUM"

function _UI_Manager.Ctor()
    this.interfaces = {}
    this.curIndex = 1
    imagedata = love.image.newImageData(love.graphics.getWidth(), love.graphics.getHeight())
    _RESMGR.InstantiateImageData(imagedata)
    this.backGround = _Sprite.New(love.graphics.newImage(imagedata))
    this.backGround:SetColor(0, 0, 0,200)

    this.stack = _Stack.New(10)
    this.backKey = "f2" -- esc default
    this.panels = {}
    -- this.InitPanels()
end 

function _UI_Manager.Update(dt)
    
end 

function _UI_Manager.MessageHandler(msg) -- CallBack
    if msg.type == "OPEN" then -- msg = {type = "", name = ""}
        this.Enter(msg.name)
    end
end

function _UI_Manager.Enter(name)
    local backAnimation
    this.stack:Push(this.GetPanelRefByName(name))
end

function _UI_Manager.Back()
    this.stack:Pop()
end

function _UI_Manager.Find(frameID, compArrName, compID)
    --Find(PanelID, tag)
    -- this.interfaces[this.curIndex].frames[frameID].
end

function _UI_Manager.Draw()
    local _topPanel = this.stack:GetTopE()
    if _topPanel then
        -- this.backGround:Draw(0, 0)
        _topPanel:Draw()
    end

    this.interfaces["HUD"]:Draw()
end

function _UI_Manager.DispatchMessage(msg, x, y)
    -- for k,v in pairs(this.interfaces) do
    --     v:DispatchMessage(msg, x, y)
    -- end

    local _topPanel = this.stack:GetTopE()
    if _topPanel then
        _topPanel:DispatchMessage(msg, x, y)
    end
    this.interfaces["HUD"]:DispatchMessage(msg, x, y)
end

function _UI_Manager.KeyPressed(key)
    if key == this.backKey then
        if this.stack:IsEmpty() then
            this.stack:Push(this.GetPanelRefByName("Inventory"))
        else
            --[[
                local funciton Back()
                    this.stack:Pop()
                end
                -- BackAnimation(Back) -- 返回动画播放完毕后自动调用callback Back() 来执行Pop操作
            ]]
            this.stack:Pop()
        end
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
    this.interfaces[k] = i
    print("UI_Manager.AddInterface()  ", k)
end

function _UI_Manager.GetPanelRefByName(name)
    assert(this.interfaces[name], "_UI_Manager.GetPanelRefByName() no panel:" .. name)
    return this.interfaces[name]
end


return _UI_Manager 
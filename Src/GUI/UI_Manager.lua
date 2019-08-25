--[[
	Desc: User Interface Manager
	Author: Night_Walker 
	Since: 2018-08-14 15:41:03 
	Last Modified time: 2018-08-14 15:41:03 
    Docs: 
        * Manage all panels
		* Dispatch messages by three callbacks (mousemoved(), mousepressed(), mousereleased())
]]
local _UI_Manager = {} ---@class UI_Manager

local this = _UI_Manager ---@type UI_Manager
local _Sprite = require("Src.Core.Sprite")
local _Stack = require("Src.Core.Stack")
local _RESMGR = require("Src.Resource.ResManager")
local _LayoutMgr = require("Src.GUI.LayoutManager")

function _UI_Manager.Ctor()
    this.panels = {} ---@type Panel[]

    this.curIndex = 1
    local imagedata = love.image.newImageData(love.graphics.getWidth(), love.graphics.getHeight())
    _RESMGR.InstantiateImageData(imagedata)
    this.backGround = _Sprite.New(love.graphics.newImage(imagedata))
    this.backGround:SetColor(0, 0, 0,200)

    this.stack = _Stack.New(10)
    this.backKey = "f2" -- esc default

    love.graphics.setFont(love.graphics.newFont("Font/simsun_bitmap_fnt/simsun12.fnt"))

    _LayoutMgr.Ctor()
end

function _UI_Manager.Draw()
    local _topPanel = this.stack:GetTopE()
    if _topPanel then
        -- this.backGround:Draw(0, 0)
        _topPanel:Draw()
    end

    this.panels["HUD"]:Draw()
end

function _UI_Manager.MessageHandler(msg) -- CallBack
    if msg.type == "OPEN" then -- msg = {type = "", name = ""}
        this.Enter(msg.name)
    end
end

function _UI_Manager.Enter(name)
    this.stack:Push(this.GetPanel(name))
end

function _UI_Manager.Back()
    this.stack:Pop()
end

---@param name string
---@param panel Panel
function _UI_Manager.AddPanel(name, panel)
    this.panels[name] = panel
    print("UI_Manager.AddPanel(): ", name)
end

---@param name string
function _UI_Manager.GetPanel(name)
    assert(this.panels[name], "not found panel:" .. name)
    return this.panels[name]
end

function _UI_Manager.GetWidget(panelName, widgetName)
    return this.panels[panelName]:GetWidgetById(widgetName)
end

function _UI_Manager.DispatchMessage(msg, x, y)

    local _topPanel = this.stack:GetTopE()
    if _topPanel then
        _topPanel:DispatchMessage(msg, x, y)
    end
    this.panels["HUD"]:DispatchMessage(msg, x, y)
end

function _UI_Manager.KeyPressed(key)
    if key == this.backKey then
        if this.stack:IsEmpty() then
            this.stack:Push(this.GetPanel("Inventory"))
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




return _UI_Manager 
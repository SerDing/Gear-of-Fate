--[[
	Desc: User Interface Manager
	Author: SerDing 
	Since: 2018-08-14 15:41:03 
	Last Modified time: 2018-08-14 15:41:03 
    Docs: 
        * Manage all panels
		* Dispatch messages by three callbacks (mousemoved(), mousepressed(), mousereleased())
]]
local _Vector2 = require("utils.vector2") 
local _GRAPHICS = require("engine.graphics.graphics")
local _CAMERA = require("scene.camera")
local _Stack = require("core.stack")
local _LayoutMgr = require("system.gui.layoutmgr")

---@class UIManager
---@field protected _panels GUI.Panel[] @panel list
local _UIMgr = {}

function _UIMgr.Init(data)
    _UIMgr._panels = {}
    _UIMgr._stack = _Stack.New(10)
    _UIMgr._scale = _Vector2.New(1, 1)
    _UIMgr._scale.x = _CAMERA._scale.x / 1.3
    _UIMgr._scale.y = _CAMERA._scale.y / 1.3

    -- love.graphics.setFont(love.graphics.newFont("resource/font/simsun_bitmap_fnt/simsun12.fnt"))
    love.graphics.setFont(love.graphics.newFont("resource/font/simsun.ttc", 12))
    
    for key, value in pairs(data) do
        _UIMgr.AddPanel(key, require("system.gui." .. value).New())
    end
end

function _UIMgr.Draw(x, y)
    _GRAPHICS.Push()
	_GRAPHICS.Scale(_UIMgr._scale.x, _UIMgr._scale.y)
	
    _UIMgr._panels["hud"]:Draw()

    local topPanel = _UIMgr._stack:GetTopE()
    if topPanel then
        _GRAPHICS.SetColor(0, 0, 0, 200)
        _GRAPHICS.DrawRect("fill", 0, 0, love.graphics.getDimensions())
        _GRAPHICS.ResetColor()
        topPanel:Draw()
    end

	_GRAPHICS.Pop()
end

function _UIMgr.HandleMessage(msg) -- CallBack
    if msg.type == "OPEN" then -- msg = {type = "", name = ""}
        _UIMgr.Enter(msg.name)
    end
end

function _UIMgr.Enter(name)
    _UIMgr._stack:Push(_UIMgr.GetPanel(name))
end

function _UIMgr.Back()
    _UIMgr._stack:Pop()
end

---@param name string
---@param panel GUI.Panel
function _UIMgr.AddPanel(name, panel)
    _UIMgr._panels[name] = panel
end

---@param name string
function _UIMgr.GetPanel(name)
    return _UIMgr._panels[name]
end

function _UIMgr.GetWidget(panelName, widgetName)
    return _UIMgr._panels[panelName]:GetWidgetById(widgetName)
end

function _UIMgr.DispatchMessage(msg, ...)
    local _topPanel = _UIMgr._stack:GetTopE()
    if _topPanel then
        _topPanel:DispatchMessage(msg, ...)
    end
    _UIMgr._panels['hud']:DispatchMessage(msg, ...)
end

function _UIMgr.KeyPressed(action)
    if action == "MENU" then 
        if _UIMgr._stack:IsEmpty() then
            _UIMgr._stack:Push(_UIMgr.GetPanel("inventory"))
        else
            _UIMgr._stack:Pop()
        end
    end
end

function _UIMgr.MousePressed(x, y, button, istouch)
	if button == 1 then
        _UIMgr.DispatchMessage("MOUSE_LEFT_PRESSED", x / _UIMgr._scale.x, y / _UIMgr._scale.x)
    end
end

function _UIMgr.MouseReleased(x, y, button, istouch)
    if button == 1 then
        _UIMgr.DispatchMessage("MOUSE_LEFT_RELEASED", x / _UIMgr._scale.x, y / _UIMgr._scale.x)
    end
end

function _UIMgr.MouseMoved(x, y, dx, dy)
    _UIMgr.DispatchMessage("MOUSE_MOVED", x / _UIMgr._scale.x, y / _UIMgr._scale.x)
end

return _UIMgr 
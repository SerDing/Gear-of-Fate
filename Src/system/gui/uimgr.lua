--[[
	Desc: User Interface Manager (Singleton)
	Author: SerDing 
	Since: 2018-08-14 15:41:03 
	Last Modified time: 2018-08-14 15:41:03 
    Docs: 
        * Manage all panels
		* Handle input from mouse and virtual buttons.
]]
local _Vector2 = require("utils.vector2")
local _MATH = require("engine.math")
local _MOUSE = require("engine.mouse")
local _GRAPHICS = require("engine.graphics.graphics")
local _Color = require("engine.graphics.config.color")
local _CAMERA = require("system.scene.camera")
local _Stack = require("core.stack")
local _Panel = require("system.gui.panels.panel")
local _SETTING = require("setting")

---@class UIManager
---@field protected _panels GUI.Panel[] @panel list
---@field protected _topPanel GUI.Panel
---@field protected _persistentPanel GUI.Panel
---@field protected _dragWidget GUI.Widgets.Base
local _UIMGR = {}
local this = _UIMGR

local _emptyPanel = _Panel.New("empty")
local _easeInAnim = {
    color = _Color.New(255, 255, 255, 0),
    easeInSpeed = 0.1,
    from = 0,
    to = 255,
    positiveStopRange = 2.0,
    negativeStopRange = 5.0,
    isRunning = false,
    direction = 1,
}
local _Abs = math.abs

---@param data table<string, string>
---@param persistentPanel string
function _UIMGR.Init(data, persistentPanel)
    this._panels = {}
    this._topPanel = _emptyPanel
    this._persistentPanel = _emptyPanel
    this._stack = _Stack.New(10)
    this._scale = _Vector2.New(_CAMERA._scale.x / 1.3, _CAMERA._scale.y / 1.3)
    this._lastMousePosition = _Vector2.New(_MOUSE.GetScaledMousePosition())
    this._dragWidget = nil
    this._dragOffset = _Vector2.New(0, 0)

    --local font = love.graphics.newFont("resource/font/simsun.ttc", 16)
    --local font = love.graphics.newFont("resource/font/simsun_bitmap_fnt/simsun12.fnt")
    local font = love.graphics.newFont("resource/font/notosans/normal.otf", 12)
    love.graphics.setFont(font)

    for key, value in pairs(data) do
        this.AddPanel(key, require(value).New())
    end

    if persistentPanel then
        this.Enter(persistentPanel)
        this._persistentPanel = this._topPanel
    end
end

function _UIMGR.Draw()
    _GRAPHICS.Push()
    _GRAPHICS.Scale(this._scale:Get())
	
    this._persistentPanel:Draw()

    if this._topPanel and this._topPanel ~= this._persistentPanel then
        --_GRAPHICS.SetColor(0, 0, 0, 200)
        --_GRAPHICS.DrawRect("fill", 0, 0, _GRAPHICS.GetDimension())
        --_GRAPHICS.ResetColor()

        if _easeInAnim.isRunning then
            local nowAlpha = _easeInAnim.color:Get("alpha")
            local absAlphaDist = _Abs(nowAlpha - _easeInAnim.to)
            if _easeInAnim.direction == 1 and absAlphaDist > _easeInAnim.positiveStopRange then
                _easeInAnim.from = _MATH.Lerp(_easeInAnim.from, _easeInAnim.to, _easeInAnim.easeInSpeed)
            elseif _easeInAnim.direction == -1 and absAlphaDist > _easeInAnim.negativeStopRange then
                _easeInAnim.from = _MATH.Lerp(_easeInAnim.from, _easeInAnim.to, _easeInAnim.easeInSpeed)
            else
                _easeInAnim.isRunning = false
            end
            _easeInAnim.color:Set(255, 255, 255, _easeInAnim.from)
            this._topPanel.root:SetRenderValue("color", _easeInAnim.color:Get())
            if _easeInAnim.direction == -1 and _easeInAnim.isRunning == false then
                this._stack:Pop()
                this._topPanel = this._stack:GetTopE()
            end
        end

        if this._topPanel ~= this._persistentPanel then
            this._topPanel:Draw()
        end

    end

	_GRAPHICS.Pop()
end

---@param name string
---@param anim boolean
function _UIMGR.Enter(name, anim)
    if this._stack:Size() < this._stack:Capacity() then
        this._stack:Push(this.GetPanel(name))
        this._topPanel = this._stack:GetTopE()
        if anim then
            _easeInAnim.direction = 1
            _easeInAnim.to = 255
            _easeInAnim.isRunning = true
            this._topPanel.root:SetRenderValue("color", _easeInAnim.color:Get())
        end
    end
end

function _UIMGR.Back()
    if this._stack:Size() > 1 and _easeInAnim.isRunning == false then
        _easeInAnim.direction = -1
        _easeInAnim.to = 0
        _easeInAnim.isRunning = true
        this._topPanel.root:SetRenderValue("color", _easeInAnim.color:Get())
    end
end

---@param name string
---@param panel GUI.Panel
function _UIMGR.AddPanel(name, panel)
    this._panels[name] = panel
end

---@param name string
function _UIMGR.GetPanel(name)
    return this._panels[name]
end

function _UIMGR.GetWidget(panelName, widgetName)
    return this._panels[panelName]:GetWidgetById(widgetName)
end

---@param name string
function _UIMGR.OnOff(name)
    if this._topPanel.name == name then
        this.Back()
    else
        this.Enter(name, true)
    end
end

function _UIMGR.ButtonPressed(_, btn)
    if btn == "MENU" then
        this.OnOff("inventory")
    end
end

function _UIMGR.ButtonReleased(_, btn)
end

---@param x float
---@param y float
---@param button int @left:1, middle:2, right:3.
---@param istouch boolean
function _UIMGR.MousePressed(_, x, y, button, istouch)
    if button == 1 and not _easeInAnim.isRunning then
        ---@param w GUI.Widgets.Base
        local function HandleEvent(w)
            if w:CheckPoint(x, y) then
                w:MousePressed(button, x - w.x, y - w.y)
                if _SETTING.debug.uidrag then
                    this._dragWidget = w
                    this._dragOffset:Set(x - w.x, y - w.y)
                end
            end
        end

        this._topPanel:DoForWidgets(HandleEvent)
    end
end

---@param x float
---@param y float
---@param button int @left:1, middle:2, right:3.
---@param istouch boolean
function _UIMGR.MouseReleased(_, x, y, button, istouch)
    if button == 1 and not _easeInAnim.isRunning then
        ---@param w GUI.Widgets.Base
        local function HandleEvent(w)
            if w:CheckPoint(x, y) then
                w:MouseReleased(button, x - w.x, y - w.y)
                this._dragWidget = nil
            else
                w.mousePressed = false
            end
        end

        this._topPanel:DoForWidgets(HandleEvent)
    end
end

---@param x float
---@param y float
---@param dx float
---@param dy float
function _UIMGR.MouseMoved(_, x, y, dx, dy)
    ---@param w GUI.Widgets.Base
    local function HandleEvent(w)
        local lastIsIn = w:CheckPoint(this._lastMousePosition:Get())
        local nowIsIn = w:CheckPoint(x, y)
        if not lastIsIn and nowIsIn then
            w:MouseEntered()
        elseif lastIsIn and not nowIsIn then
            w:MouseExited()
        end
    end

    this._topPanel:DoForWidgets(HandleEvent)
    this._lastMousePosition:Set(x, y) -- update last mouse position
    
    if this._dragWidget then
        local sx, sy, sz = this._dragWidget:GetRenderValue("position", true)
        this._dragWidget:SetRenderValue("position", sx + dx, sy + dy, sz)
    end
end

_UIMGR.OnPress = _UIMGR.ButtonPressed
_UIMGR.OnRelease = _UIMGR.ButtonReleased

return _UIMGR 
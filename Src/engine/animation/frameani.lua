--[[
	Desc: Animator
 	Author: SerDing
	Since: 2017-07-28 21:54:14
	Alter: 2017-07-30 23:36:07
]]
local _Sprite = require('engine.graphics.drawable.sprite')
local _Rect = require('core.rect')
local _Event = require("core.event")
local _ImgPack = require('system.resource.imgpack')
local _RESMGR = require("system.resource.resmgr")
local _RESOURCE = require("engine.resource")
local _AUDIO = require('engine.audio')

---@class Engine.Animation.Frameani
---@field protected _frame int
---@field protected _time float
local _Frameani = require('core.class')()

local _BLENDMODES = {
    [1] = 'add', -- The pixel colors of what's drawn are added to the pixel colors already on the screen. The alpha of the screen is not modified.
    [2] = 'alpha', -- Alpha blending (normal). The alpha of what's drawn determines its opacity.
    [3] = 'replace', -- The colors of what's drawn completely replace what was on the screen, with no additional blending. The BlendAlphaMode specified in love.graphics.setBlendMode still affects what happens.
    [4] = 'screen', -- 'Screen' blending.
    [5] = 'subtrac', -- The pixel colors of what's drawn are subtracted from the pixel colors already on the screen. The alpha of the screen is not modified.
    [6] = 'multiply', -- The pixel colors of what's drawn are multiplied with the pixel colors already on the screen (darkening them). The alpha of drawn objects is multiplied with the alpha of the screen rather than determining how much the colors on the screen are affected, even when the "alphamultiply" BlendAlphaMode is used.
    [7] = 'lighten', -- The pixel colors of what's drawn are compared to the existing pixel colors, and the larger of the two values for each color component is used. Only works when the "premultiplied" BlendAlphaMode is used in love.graphics.setBlendMode.
    [8] = 'darken' -- The pixel colors of what's drawn are compared to the existing pixel colors, and the smaller of the two values for each color component is used. Only works when the "premultiplied" BlendAlphaMode is used in love.graphics.setBlendMode.    
}

function _Frameani:Ctor()
    self.pos = {x = 0, y = 0, z = 0}
    self._imgOrigin = { x = 0, y = 0}
    self._imgOffset = { x = 0, y = 0}
    self.scale = {x = 1, y = 1}
    self.blendmode = "alpha"

    self.playOver = false;
    self.imgPathArg = {0000}

    self.animClips = {} --- animation clips
    self.curAnim = {}
    self.frameHead = "[FRAME000]"
    self.aniID = ""
    self._imgPath = ""
    self._tick = 0
    self._frame = 0
    self._time = 0
    self._length = 0
    self.playRate = 1
    self.active = true
    self.stop = false

    self._imgPack = _ImgPack.New()
    self.OnChangeFrame = _Event.New()
    self.sprite = _Sprite.New()
    self.box = _Rect.New(0, 0, 1, 1)

    self.debug = false

    
end

function _Frameani:NextFrame()
    if not self.active or self.playOver then
        return
    end

    if self._frame + 1 == self._length then
        if self.curAnim["[LOOP]"] then
            self._frame = 0
        else
            self.playOver = true
        end
    else
        self._frame = self._frame + 1
    end
    self._time = 0
    self:Refresh()
end

function _Frameani:Update(dt)
    if not self.active or self.stop or self.playOver then
        return
    end

    self._time = self._time + (dt or 0) * self.playRate
    if self._time >= (self.curAnim[self.frameHead]['[DELAY]'] or 100) / 1000 then
        self._time = 0
        self._tick = self._frame

        if self._frame + 1 == self._length then -- final frame
            if self.curAnim["[LOOP]"] then
                self._frame = 0
            else
                self.playOver = true
            end
        else
            self._frame = self._frame + 1
        end

        self.OnChangeFrame:Notify(self._frame)
        self:Refresh()
        self:SoundProcess()
    end

end

function _Frameani:Refresh()
    if not self.active or self.playOver then
        return
    end

    self.frameHead = string.format('[FRAME%03d]', self._frame)
    if self.curAnim[self.frameHead]['[IMAGE]'][1] ~= '' then
        self._imgPath = string.format(string.lower(self.curAnim[self.frameHead]['[IMAGE]'][1]), unpack(self.imgPathArg))
        self._imgPack:Load(self._imgPath)

        self.sprite:SetImage(self._imgPack:GetTexture(self.curAnim[self.frameHead]['[IMAGE]'][2] + 1))
        
        self._imgOffset = self._imgPack:GetOffset(self.curAnim[self.frameHead]['[IMAGE]'][2] + 1)
    else
        self.sprite:SetImage(_RESOURCE.nullImg)
    end

    self:SetOrigin(-self.curAnim[self.frameHead]['[IMAGE POS]'][1], -self.curAnim[self.frameHead]['[IMAGE POS]'][2])

    -- update graphics effect
    if self.curAnim[self.frameHead]['[GRAPHIC EFFECT]'] then
        if string.lower(self.curAnim[self.frameHead]['[GRAPHIC EFFECT]']) == 'lineardodge' then
            self:SetBlendMode("add")
        end
    end
    if self.curAnim[self.frameHead]['[RGBA]'] then
        self:SetColor(
            self.curAnim[self.frameHead]['[RGBA]'][1],
            self.curAnim[self.frameHead]['[RGBA]'][2],
            self.curAnim[self.frameHead]['[RGBA]'][3],
            self.curAnim[self.frameHead]['[RGBA]'][4]
        )
    end

end

function _Frameani:SoundProcess()
    -- if self.curAnim[self.frameHead]['[PLAY SOUND]'] then
    --     _AUDIO.PlaySound(self.curAnim[self.frameHead]['[PLAY SOUND]'])
    -- end
end

function _Frameani:Draw(x, y, r, sx, sy)
    if not self.active then
        return
    end

    r = r or 0
    sx = sx or 1
    sy = sy or sx

    self.sprite:SetOrigin(self._imgOrigin.x - self._imgOffset.x, self._imgOrigin.y - self._imgOffset.y)
    self.sprite:Draw(x, y, r, (sx or 1), (sy or 1))
end

---@param anim string
function _Frameani:Play(anim)
    if not self.active then
        return
    end

    local t = type(anim)
    if t == 'string' then -- play animation by id
        -- print("play animation by id")
        assert(self.animClips[anim], "not found " .. anim .. " in animClips.")
        self.curAnim = self.animClips[anim]
        self.aniID = anim
    elseif t == 'table' then -- play animation by aniData
        -- print("play animation by aniData")
        self.curAnim = anim
    end

    self._frame = 0
    self._time = 0
    self._length = self.curAnim['[FRAME MAX]']
    self.playOver = false
    self:Continue()
    self:Refresh()
    self:SoundProcess()

end

function _Frameani:Stop()
    self.stop = true
end

function _Frameani:Continue()
    self.stop = false
end

---@param aniPath string
---@param playNum number
---@param id string
function _Frameani:AddAnimation(aniPath, id)
    self.animClips[id] = dofile(aniPath)
end

---@param s boolean
function _Frameani:SetActive(s)
    self.active = s
end

---@param frame number
function _Frameani:SetFrame(frame)
    self._frame = frame
    self:Refresh()
end

---@param playRate number
function _Frameani:SetPlayRate(playRate)
    self.playRate = playRate
end

function _Frameani:SetOrigin(x, y)
    self._imgOrigin.x = x or self._imgOrigin.x
    self._imgOrigin.y = y or self._imgOrigin.y
end

function _Frameani:SetColor(r, g, b, a)
    self.color = {r = r, g = g, b = b, a = a}
    self.sprite:SetRenderValue("color", r, g, b, a)
end

function _Frameani:SetBlendMode(blendmode)
    self.blendmode = blendmode
    self.sprite:SetRenderValue("blendmode", blendmode)
end

function _Frameani:SetImgPathArg(...)
    self.imgPathArg = {...}
end

function _Frameani:GetCount()
    return self._frame
end

function _Frameani:GetLength()
    return self._length
end

function _Frameani:GetTick()
    return self._tick
end

function _Frameani:TickEnd()
    return self._tick == self._length - 1
end

function _Frameani:GetRect()
    return self.sprite:GetRect()
end

function _Frameani:GetWidth()
    return self.sprite:GetWidth()
end

function _Frameani:GetHeight()
    return self.sprite:GetHeight()
end

return _Frameani

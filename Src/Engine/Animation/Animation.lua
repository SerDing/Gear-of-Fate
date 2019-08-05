--[[
	Desc: FrenzyAttack state
 	Author: SerDing
	Since: 2019-07-13 12:23:14
	Alter: 2019-07-13 12:23:14
	Docs:
		* wrap the logic of frenzy attack state in this class
]]

local _Animation = require('Src.Core.Class')()

local _Sprite = require 'Src.Core.Sprite'
local _Rect = require 'Src.Core.Rect'
local _ImgPack = require 'Src.Resource.ImgPack'
local _RESMGR = require 'Src.Resource.ResManager'
local _AUDIOMGR = require 'Src.Audio.AudioManager'

function _Animation:Ctor(anim)

    self.anim = anim
    self.frameHead = "[FRAME000]"
    self.playOver = false;
    self.imgPathArg = {0000}

    self._imgPath = ""
    self._imgPack = _ImgPack.New()
    self._sprite = _Sprite.New(_RESMGR.imageNull)

    self._count = 0
    self._time = 0
    self.baseRate = 1
    self.num = self.anim['[FRAME MAX]']

    self.box = _Rect.New(0, 0, 1, 1)

    self.pos = {x = 0, y = 0, z = 0}
    self._imgPos = { x = 0, y = 0}
    self._imgOffset = { x = 0, y = 0}
    self.scale = {x = 1, y = 1}
    self.angle = 0
    self.dir = 1 -- direction

    self.filter = false
    self.debug = false

    self.blendModeList = {
        [1] = 'add', -- The pixel colors of what's drawn are added to the pixel colors already on the screen. The alpha of the screen is not modified.
        [2] = 'alpha', -- Alpha blending (normal). The alpha of what's drawn determines its opacity.
        [3] = 'replace', -- The colors of what's drawn completely replace what was on the screen, with no additional blending. The BlendAlphaMode specified in love.graphics.setBlendMode still affects what happens.
        [4] = 'screen', -- 'Screen' blending.
        [5] = 'subtrac', -- The pixel colors of what's drawn are subtracted from the pixel colors already on the screen. The alpha of the screen is not modified.
        [6] = 'multiply', -- The pixel colors of what's drawn are multiplied with the pixel colors already on the screen (darkening them). The alpha of drawn objects is multiplied with the alpha of the screen rather than determining how much the colors on the screen are affected, even when the "alphamultiply" BlendAlphaMode is used.
        [7] = 'lighten', -- The pixel colors of what's drawn are compared to the existing pixel colors, and the larger of the two values for each color component is used. Only works when the "premultiplied" BlendAlphaMode is used in love.graphics.setBlendMode.
        [8] = 'darken' -- The pixel colors of what's drawn are compared to the existing pixel colors, and the smaller of the two values for each color component is used. Only works when the "premultiplied" BlendAlphaMode is used in love.graphics.setBlendMode.
    }
    self.blendMode = self.blendModeList[1]
end

function _Animation:Update(dt)

    if self.playOver then
        return
    end

    self.frameHead = string.format('[FRAME%03d]', self._count)

    self._time = self._time + (dt or 0) * self.baseRate
    if self._time >= (self.anim[self.frameHead]['[DELAY]'] or 100) / (1000 ) then
        self._time = 0
        self._count = self._count + 1
        if self._count >= self.num then
            if self.anim["[LOOP]"] then
                self._count = 0
            else
                self.playOver = true
            end
        end

        -- processing for frame changing
        if self.anim[self.frameHead]['[PLAY SOUND]'] then
            _AUDIOMGR.PlaySound(self.anim[self.frameHead]['[PLAY SOUND]'])
        end
    end

    self:UpdateSprite()
end

function _Animation:UpdateSprite()
    if self.anim[self.frameHead]['[IMAGE]'][1] ~= '' then
        self._imgPath = string.format(string.lower(self.anim[self.frameHead]['[IMAGE]'][1]), unpack(self.imgPathArg))
        self._imgPack:Load(_RESMGR.pathHead .. self._imgPath)
        self._sprite:SetTexture(self._imgPack:GetTexture(self.anim[self.frameHead]['[IMAGE]'][2] + 1))
        self._imgOffset = self._imgPack:GetOffset(self.anim[self.frameHead]['[IMAGE]'][2] + 1)
    else
        self._sprite:SetTexture(_RESMGR.imageNull)
    end
    self:SetCenter(-self.anim[self.frameHead]['[IMAGE POS]'][1], -self.anim[self.frameHead]['[IMAGE POS]'][2])

    -- update graphics effect
    if self.anim[self.frameHead]['[GRAPHIC EFFECT]'] then
        if string.lower(self.anim[self.frameHead]['[GRAPHIC EFFECT]']) == 'lineardodge' then
            self:SetBlendMode(1)
        end
    end
    if self.anim[self.frameHead]['[RGBA]'] then
        self:SetColor(
            self.anim[self.frameHead]['[RGBA]'][1],
            self.anim[self.frameHead]['[RGBA]'][2],
            self.anim[self.frameHead]['[RGBA]'][3],
            self.anim[self.frameHead]['[RGBA]'][4]
        )
    end

end

function _Animation:Draw(x, y, r, sx, sy)

    if x and y then self:SetPos(x, y) end
    if sx and sy then self:SetScale(sx, sy) end
    if r then self:SetAngle(r) end

    self._sprite:SetCenter(self._imgPos.x - self._imgOffset.x, self._imgPos.y - self._imgOffset.y)
    self._sprite:Draw(
            self.pos.x ,
            self.pos.y + self.pos.z,
            self.angle or 0,
            self.scale.x * self.dir,
            self.scale.y
    )

    if GDebug then
        self:DrawBox("[ATTACK BOX]", {255, 0, 180, 150})
        self:DrawBox("[DAMAGE BOX]", {0, 255, 0, 150})
        --self.sprite.rect:Draw()
    end
end

---@param type string
---@param color table
function _Animation:DrawBox(type, color)
    local boxTab = self.anim[self.frameHead][type]
    self.box:SetColor(255, 0, 180, 150)
    if boxTab then
        for n = 1, #boxTab, 6 do

            -- draw attack box
            self.box:SetColor(unpack(color))
            self.box:SetPos(self.pos.x + boxTab[n] * self.dir, self.pos.y - boxTab[n + 2])
            self.box:SetSize(boxTab[n + 3] * self.scale.x, -boxTab[n + 5] * self.scale.y)
            self.box:SetDir(self.dir)
            self.box:Draw()

            -- draw collision area box
            self.box:SetColor(0, 0, 180, 150)
            self.box:SetPos(self.pos.x + boxTab[n] * self.dir, self.pos.y - boxTab[n + 1])
            self.box:SetSize(boxTab[n + 3] * self.scale.x, -boxTab[n + 4] * self.scale.y)
            self.box:SetDir(self.dir)
            self.box:Draw()

            -- boxTable = {x, z, y, size_x, size_z, size_y}
        end
    end
end

function _Animation:Play()
    assert(self.anim, "invalid anim")

    self._count = 0
    self._time = 0
    self.playOver = false
    self:Update(0)

    return self
end

---@param anim table
function _Animation:SetAnim(anim)
    assert(anim, "invalid anim")

    self.anim = anim
    self.num = self.anim['[FRAME MAX]']

    return self
end

function _Animation:GetAttackBox()
    return self.anim[self.frameHead]['[ATTACK BOX]'] or nil
end

function _Animation:GetDamageBox()
    return self.anim[self.frameHead]['[DAMAGE BOX]'] or nil
end

function _Animation:SetPos(x, y, z)
    self.pos.x = x or self.pos.x
    self.pos.y = y or self.pos.y
    self.pos.z = z or self.pos.z
    self._sprite:SetPos(self.pos.x + self._imgOffset.x * self.dir, self.pos.y + self._imgOffset.y)
end

function _Animation:SetScale(x, y)
    self.scale.x = x or self.scale.x
    self.scale.y = y or self.scale.y
    self._sprite:SetScale(x, y)
end

function _Animation:SetAngle(r)
    self.angle = r or self.angle
    self._sprite:SetAngle(r)
end

function _Animation:SetPlayRate(playRate)
    self.baseRate = playRate
end

function _Animation:SetCenter(x, y)
    self._imgPos.x = x or self._imgPos.x
    self._imgPos.y = y or self._imgPos.y
end

function _Animation:SetColor(r, g, b, a)
    self.color = {r = r, g = g, b = b, a = a}
    self._sprite:SetColor(r, g, b, a)
end

function _Animation:SetBlendMode(modeNum)
    self.blendMode = self.blendModeList[modeNum]
    self._sprite:SetBlendMode(self.blendMode)
end

function _Animation:SetFilter(switch)
    self.filter = switch or false
end

function _Animation:SetImgPathArg(...)
    self.imgPathArg = {...}
end

function _Animation:SetDir(dir)
    self.dir = dir
end

function _Animation:GetCount()
    return self._count or 0
end

function _Animation:GetRect()
    return self._sprite:GetRect()
end

function _Animation:GetWidth()
    return self._sprite:GetWidth()
end

function _Animation:GetHeight()
    return self._sprite:GetHeight()
end

function _Animation:Destroy()
    self._sprite:Destroy()
    self = {}
end

return _Animation

--[[
	Desc: Animation Pack class
 	Author: Night_Walker
	Since: 2017-07-28 21:54:14
	Alter: 2017-07-30 23:36:07
	Docs:
		* Bind animation clip data(*.ani) by AddAnimation(path, id)
		* Play animation by Play(id)
]]

---@class _Animator
---@field private playOver boolean
---@field public animClips table @animation clips
---@field private _count number
---@field private _time number
local _Animator = require('Src.Core.Class')()

local _Sprite = require 'Src.Core.Sprite'
local _Rect = require 'Src.Core.Rect'
local _ImgPack = require 'Src.Resource.ImgPack'
local _RESMGR = require 'Src.Resource.ResManager'
local _AUDIOMGR = require 'Src.Audio.AudioManager'

function _Animator:Ctor()
    self.pos = {x = 0, y = 0, z = 0}
    self._imgPos = { x = 0, y = 0}
    self._imgOffset = { x = 0, y = 0}
    self.scale = {x = 1, y = 1}
    self.angle = 0
    self.dir = 1 -- direction

    self.playOver = false;
    self.imgPathArg = {0000}

    self.animClips = {}
    self.curAnim = {}
    self.frameHead = "[FRAME000]"
    self.aniID = ""

    self._imgPath = ""
    self._imgPack = _ImgPack.New()
    self.sprite = _Sprite.New(_RESMGR.imageNull)

    self.box = _Rect.New(0, 0, 1, 1)

    self._count = 0
    self._time = 0
    self.frameNum = 0
    self.playRate = 1

    self.focus = {
        focus = false,
        max = 1.0,
        min = 0.0,
        dir = -1,
        speed = 6,
        ARGB = {A = 255, R = 255, G = 0, B = 0},
        scale = {x = 1.5, y = 1.5, spd = 0.048},
        sprite = {
            _Sprite.New(_RESMGR.imageNull),
            _Sprite.New(_RESMGR.imageNull),
            _Sprite.New(_RESMGR.imageNull),
            _Sprite.New(_RESMGR.imageNull)
        },
        shader = love.graphics.newShader(
            [[
				extern number green;
				vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords)
				{
					vec4 GlowColor = vec4(255, 0, 0, 0);		// 发光色
					vec4 GlowColor2 = vec4(0, 150, 0, 0);
					vec2 TextureSize = vec2(800, 600); 			// 纹理尺寸
					number samplerPre = 1.0;					// 采样器
					number radiusX = 0.5 / TextureSize.x;		// 半径x
					number radiusY = 0.5 / TextureSize.y;		// 半径y
					number glowAlpha = 0.0;						// 背景发光透明度
					number count = 0.0;							// 计数
					number GlowRange = 0.5;						// 发光范围
					number GlowExpand = 255;						// 发光强度 0 - 255
					
					for( number i = -GlowRange; i <= GlowRange; i += samplerPre){
						for(number j = -GlowRange; j <= GlowRange; j += samplerPre){
							vec2 samplerTexCoord = vec2(texture_coords.x + j * radiusX, texture_coords.y + i * radiusY);
							
							if(samplerTexCoord.x < 0.0 || samplerTexCoord.x > 1.0 || samplerTexCoord.y < 0.0 || samplerTexCoord.y > 1.0){
								glowAlpha += 0.0;
							}else{
								glowAlpha += Texel(texture, samplerTexCoord).a;
							}
							
							glowAlpha += Texel(texture, samplerTexCoord).a;
							count += 1.0;
						}
					}

					glowAlpha = glowAlpha / (count + 100);
					GlowColor.a = glowAlpha * GlowExpand;
                    GlowColor.g = green;
					return GlowColor;
				}
			]]
        )
    }

    --[[
        vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords){
            vec4 texcolor = Texel(texture, texture_coords);
            texcolor.rgb = texcolor.rgb/2;
            texcolor.a = 1;
            //vec4 color = vec4(255, 1, 0 ,255);
            color.r = 255;
            color.g = 0.7;
            color.b = 0;
            return color;
        }
        vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords)
        {
            vec4 texcolor = Texel(texture, texture_coords);
            texcolor.rgb = texcolor.rgb/2;
            texcolor.a = 1;
            return texcolor * color;
        }
	]]

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
    self.active = true
    self.stop = false
end

--- jump to next frame
function _Animator:NextFrame()
    if self.playOver then
        return
    end

    if self._count + 1 == self.frameNum then
        if self.curAnim["[LOOP]"] then
            self._count = 0
        else
            self.playOver = true
        end
    else
        self._count = self._count + 1
    end
    self._time = 0
end

function _Animator:Update(dt)

    if not self.active or self.stop or self.playOver then
        return
    end

    self.frameHead = string.format('[FRAME%03d]', self._count)

    self._time = self._time + (dt or 0) * self.playRate
    if self._time >= (self.curAnim[self.frameHead]['[DELAY]'] or 100) / 1000 then
        self._time = 0
        self._count = self._count + 1
        if self._count >= self.frameNum then
            if self.curAnim["[LOOP]"] then
                self._count = 0
            else
                self.playOver = true
            end
        end

        -- processing for frame changing
        self:OnChangeFrame(self._count)
        if self.curAnim[self.frameHead]['[PLAY SOUND]'] then
            _AUDIOMGR.PlaySound(self.curAnim[self.frameHead]['[PLAY SOUND]'])
        end
    end

    self:UpdateSprite()
    self:_UpdateSuperArmor(dt)

end

function _Animator:UpdateSprite()
    if self.curAnim[self.frameHead]['[IMAGE]'][1] ~= '' then
        self._imgPath = string.format(string.lower(self.curAnim[self.frameHead]['[IMAGE]'][1]), unpack(self.imgPathArg))
        self._imgPack:Load(_RESMGR.pathHead .. self._imgPath)
        self.sprite:SetTexture(self._imgPack:GetTexture(self.curAnim[self.frameHead]['[IMAGE]'][2] + 1))
        self._imgOffset = self._imgPack:GetOffset(self.curAnim[self.frameHead]['[IMAGE]'][2] + 1)
    else
        self.sprite:SetTexture(_RESMGR.imageNull)
    end

    self:SetCenter(-self.curAnim[self.frameHead]['[IMAGE POS]'][1], -self.curAnim[self.frameHead]['[IMAGE POS]'][2])

    -- update graphics effect
    if self.curAnim[self.frameHead]['[GRAPHIC EFFECT]'] then
        if string.lower(self.curAnim[self.frameHead]['[GRAPHIC EFFECT]']) == 'lineardodge' then
            self:SetBlendMode(1)
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

function _Animator:Draw(x, y, r, sx, sy)
    if not self.active then
        return
    end

    if x and y then
        self:SetPos(x, y)
    end
    if sx and sy then
        self:SetScale(sx, sy)
    end
    if r then
        self:SetAngle(r)
    end

    self:_DrawSuperArmor()

    self.sprite:SetCenter(self._imgPos.x - self._imgOffset.x, self._imgPos.y - self._imgOffset.y)
    self.sprite:Draw(self.pos.x, self.pos.y, self.angle or 0, self.scale.x * self.dir, self.scale.y)

    if GDebug then
        self:DrawBox("[ATTACK BOX]", {255, 0, 180, 150})
        self:DrawBox("[DAMAGE BOX]", {0, 255, 0, 150})
    -- self.sprite.rect:Draw()
    end
end

function _Animator:OnChangeFrame()
    --print("change frame callback: " .. frame)
end

---@param s boolean
function _Animator:SwitchSuperArmor(s)
    if self.focus.focus == s then
        return
    end
    if s == true then

        if self.focus.focus == false then --
            self.focus.focus = true
            self.focus.scale.x = self.scale.x + 0.5
            self.focus.scale.y = self.scale.y + 0.5
            self.focus.ARGB.G = 0
        end
    else
        self.focus.focus = false
    end
end

function _Animator:_UpdateSuperArmor(dt)
    local _damageType = self.curAnim[self.frameHead]['[DAMAGE TYPE]']
    if _damageType and _damageType == 'superarmor' then
        self:SwitchSuperArmor(true)
    else
        self:SwitchSuperArmor(false)
    end

    for _, v in ipairs(self.focus.sprite) do -- set texture
        v:SetTexture(self.sprite:GetTexture())
    end

    if self.focus.focus then
        -- update scale
        if self.focus.scale.x > self.scale.x then
            self.focus.scale.x = self.focus.scale.x - self.focus.scale.spd
            if self.focus.scale.x < self.scale.x then
                self.focus.scale.x = self.scale.x
            end
        end
        if self.focus.scale.y > self.scale.y then
            self.focus.scale.y = self.focus.scale.y - self.focus.scale.spd
            if self.focus.scale.y < self.scale.y then
                self.focus.scale.y = self.scale.y
            end
        end

        -- update color
        self.focus.ARGB.G = self.focus.ARGB.G + self.focus.dir * self.focus.speed * dt
        if self.focus.ARGB.G >= self.focus.max then
            self.focus.dir = -1
        elseif self.focus.ARGB.G <= self.focus.min then
            self.focus.dir = 1
        end
        self.focus.shader:send('green', self.focus.ARGB.G)
    end
end

function _Animator:_DrawSuperArmor()
    if self.focus['focus'] then
        local _baseX = math.floor(self.pos.x + self._imgOffset.x * self.focus.scale.x * self.dir)
        local _baseY = math.floor(self.pos.y + self._imgOffset.y * self.focus.scale.y)
        for _, v in ipairs(self.focus['sprite']) do
            v:SetCenter(self._imgPos.x, self._imgPos.y)
        end
        love.graphics.setShader(self.focus['shader'])
        -- self.focus['sprite'][1]:SetColor(255, 255, 255, 50)
        -- self.focus['sprite'][2]:SetColor(255, 255, 255, 50)
        -- self.focus['sprite'][3]:SetColor(255, 255, 255, 50)
        -- self.focus['sprite'][4]:SetColor(255, 255, 255, 50)

        self.focus['sprite'][1]:Draw(_baseX - 1, _baseY - 1, self.angle, self.focus.scale.x * self.dir, self.focus.scale.y)
        self.focus['sprite'][2]:Draw(_baseX + 1,_baseY - 1,self.angle,self.focus.scale.x * self.dir,self.focus.scale.y)
        self.focus['sprite'][3]:Draw(_baseX + 1,_baseY + 1,self.angle,self.focus.scale.x * self.dir,self.focus.scale.y)
        self.focus['sprite'][4]:Draw(_baseX - 1,_baseY + 1,self.angle,self.focus.scale.x * self.dir,self.focus.scale.y)
        love.graphics.setShader()
    end
end

function _Animator:Stop()
    self.stop = true
end

function _Animator:Continue()
    self.stop = false
end

---@param type string
---@param color table
function _Animator:DrawBox(type, color)
    local boxTab = self.curAnim[self.frameHead][type]
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

function _Animator:GetAttackBox()
    if not self.active then
        return nil
    end
    return self.curAnim[self.frameHead]['[ATTACK BOX]'] or nil
end

function _Animator:GetDamageBox()
    return self.curAnim[self.frameHead]['[DAMAGE BOX]'] or nil
end

---@param id string
function _Animator:Play(id)
    if not self.active then
        return
    end

    local _idType = type(id)
    if _idType == 'string' then -- play animation by id
        assert(self.animClips[id], "not found " .. id .. " in animClips.")
        self.curAnim = self.animClips[id].data
        self.aniID = id
    elseif _idType == 'table' then -- play animation by aniData
        print("play animation by aniData")
        self.curAnim = id
    end

    self._count = 0
    self._time = 0
    self.frameNum = self.curAnim['[FRAME MAX]']
    self.playOver = false
    self:Continue()
    self:Update(0)

end

---@param aniPath string
---@param playNum number
---@param id string
function _Animator:AddAnimation(aniPath, playNum, id)
    local content = require(aniPath) -- content is a table
    self.animClips[id] = {data = content, num = playNum}

    if content['[LOOP]'] == 1 then
        self.animClips[id].num = -1
    else
        self.animClips[id].num = 1
    end
end

function _Animator:SetActive(s)
    self.active = s
end

function _Animator:SetPos(x, y, z)
    self.pos.x = x or self.pos.x
    self.pos.y = y or self.pos.y
    self.pos.z = z or self.pos.z
    self.sprite:SetPos(self.pos.x + self._imgOffset.x * self.dir, self.pos.y + self._imgOffset.y)
end

function _Animator:SetScale(x, y)
    self.scale.x = x or self.scale.x
    self.scale.y = y or self.scale.y
    self.sprite:SetScale(x, y)
end

function _Animator:SetAngle(r)
    self.angle = r or self.angle
    self.sprite:SetAngle(r)
end

function _Animator:SetFrame(num)
    self._count = num
end

function _Animator:SetPlayRate(playRate)
    self.playRate = playRate
end

function _Animator:SetCenter(x, y)
    self._imgPos.x = x or self._imgPos.x
    self._imgPos.y = y or self._imgPos.y
end

function _Animator:SetColor(r, g, b, a)
    self.color = {r = r, g = g, b = b, a = a}
    self.sprite:SetColor(r, g, b, a)
end

function _Animator:SetBlendMode(modeNum)
    self.blendMode = self.blendModeList[modeNum]
    self.sprite:SetBlendMode(self.blendMode)
end

function _Animator:SetFilter(switch)
    self.filter = switch or false
end

function _Animator:SetImgPathArg(...)
    self.imgPathArg = {...}
end

function _Animator:SetDir(dir)
    self.dir = dir
end

function _Animator:GetCount()
    return self._count or 0
end

function _Animator:GetRect()
    return self.sprite:GetRect()
end

function _Animator:GetWidth()
    return self.sprite:GetWidth()
end

function _Animator:GetHeight()
    return self.sprite:GetHeight()
end

function _Animator:Destroy()

    self.sprite:Destroy()
    self = {}
end

return _Animator

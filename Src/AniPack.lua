--[[
	Desc: Animation Pack class
 	Author: Night_Walker
	Since: 2017-07-28 21:54:14
	Alter: 2017-07-30 23:36:07
	Docs:
		* Bind animation data(*.ani) by using :AddAnimation(path, id)
		* Play animation by SetAnimation(id)
]]
local _AniPack = require('Src.Core.Class')()

local _KEYBOARD = require 'Src.Core.KeyBoard'
local _Sprite = require 'Src.Core.Sprite'
local _Rect = require 'Src.Core.Rect'
local _ResPack = require 'Src.Resource.ResPack'
local _RESMGR = require 'Src.Resource.ResManager'
local _AUDIOMGR = require 'Src.Audio.AudioManager'

function _AniPack:Ctor(_type) --initialize
    self.type = _type or 'NORMAL_ANI'
    self.pos = {x = 0, y = 0, z = 0}
    self.center = {x = 0, y = 0}
    self.offset = {x = 0, y = 0}
    self.scale = {x = 1, y = 1}
    self.angle = 0
    self.dir = 1 -- direction
    self.soundPlayFinished = false

    self.playNum = 1 -- 播放次数
    self.fileNum = {0000}

    self.frameDataGrp = {} -- 帧数据组 包含多个ani数据
    self.frameData = {} -- 从ani文件中读取出的帧数据
    self.frameHead = '[FRAME000]' -- 每一帧的开头帧号

    self.aniId = '' -- example: attack1 upperslash sit ...

    if not _RESMGR.imageNull then
        local _tmpImageData = love.image.newImageData(1, 1)
        _RESMGR.imageNull = love.graphics.newImage(_tmpImageData)
    end
    self.playingSprite = _Sprite.New(_RESMGR.imageNull)

    self.count = 0
    self.time = 0
    self.updateCount = 0
    self.baseRate = 1

    self.box = _Rect.New(0, 0, 1, 1)

    self.focus = {
        ['focus'] = false,
        ['focus'] = true,
        ['max'] = 1.0,
        ['min'] = 0.0,
        ['dir'] = -1,
        ['speed'] = 6,
        ['ARGB'] = {['A'] = 255, ['R'] = 255, ['G'] = 0, ['B'] = 0},
        ['scale'] = {x = 1.5, y = 1.5, spd = 0.05},
        ['sprite'] = {
            _Sprite.New(_RESMGR.imageNull),
            _Sprite.New(_RESMGR.imageNull),
            _Sprite.New(_RESMGR.imageNull),
            _Sprite.New(_RESMGR.imageNull)
        },
        ['shader'] = love.graphics.newShader(
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
					
					for( number i = -GlowRange; i <= GlowRange; i += samplerPre)
					{
						for(number j = -GlowRange; j <= GlowRange; j += samplerPre)
						{
							vec2 samplerTexCoord = vec2(texture_coords.x + j * radiusX, texture_coords.y + i* radiusY );
							
							/*
							if(samplerTexCoord.x < 0.0 || samplerTexCoord.x > 1.0 || samplerTexCoord.y < 0.0 || samplerTexCoord.y > 1.0)
							{
								glowAlpha += 0.0;
							}
							else
							{
								glowAlpha += Texel(texture, samplerTexCoord).a;
							}
							*/

							glowAlpha += Texel(texture, samplerTexCoord).a;
							
							count += 1.0;
						}
					}

					glowAlpha /= (count + 500);
					GlowColor.a = glowAlpha * GlowExpand;
					GlowColor.g = green;
					return GlowColor;
				}
			]]
        )
    }

    --[[
	vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords)
				{
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
    -- self:SetColor(255, 0, 0, 255)

    self.filter = false
    self.debug = false
    self.plusOffset = true

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
    -- self:Update(love.timer.getDelta())
end

function _AniPack:NextFrame(n)
    if self.playNum == 0 then
        return
    end
    n = n or 1
    if self.count + n == self.num then
        if self.playNum > 1 then
            self.playNum = self.playNum
        end
        self.count = 0
    else
        self.count = self.count + n
        self.time = 0
    end
    -- if self.count == self.num-1 then
    -- 	if self.playNum > 1 then
    -- 		self.playNum = self.playNum
    -- 	end
    -- 	self.count = 0
    -- else
    -- 	self.count = self.count + 1
    -- 	self.time = 0
    -- end
end

function _AniPack:Update(dt)
    if not self.active then
        return
    end

    --[[ Debug Switch ]]
    -- When the aniData just has one frame and this class has updata one time then doesn't update any more
    if self.type == 'MAP_ANI_BLOCK' then
        if self.num <= 1 then
            if self.updateCount >= 1 then
                return
            end
        end
    end

    -- stop effect
    if self.stop then
        return
    end

    local _frameHead = string.format('[FRAME%03d]', self.count)
    if self.frameHead ~= _frameHead then
        self.frameHead = _frameHead
        self.soundPlayFinished = false
    end

    if not self.frameHead then
        print('Error:_AniPack:Update() --> frameHead is null')
        return
    end

    self.time = self.time + (dt or 0)
    -- print(self.frameData[self.frameHead])
    if self.time >= (self.frameData[self.frameHead]['[DELAY]'] or 100) / (1000 * self.baseRate) then
        self.time = 0
        -- self.time - self.frameData[self.frameHead]["[DELAY]"] / 1000
        if self.playNum ~= 0 then
            self.count = self.count + 1
        end

        if self.count >= self.num then
            if self.playNum == -1 then
                self.count = 0
            elseif self.playNum > 1 then
                self.playNum = self.playNum - 1
                self.count = 0
            elseif self.playNum == 1 then
                self.count = self.count - 1
                self.playNum = self.playNum - 1
            end
        end
    end

    if self.frameData[self.frameHead]['[IMAGE]'][1] ~= '' then
        --print(string.format("Sprite/"..self.frameData[self.frameHead]["[IMAGE]"][1],self.str))
        --local img = require "sys/img"(string.format("playingSpriteite/"..self.frameData[self.frameHead]["[IMAGE]"][1], self.str))
        local tmpStr = string.format(string.lower(self.frameData[self.frameHead]['[IMAGE]'][1]), unpack(self.fileNum))

        local img = _ResPack.New(strcat(_RESMGR.pathHead, tmpStr))

        if not img then
            print('Error:_AniPack:Update() --> load imgPack failed. ')
            print(strcat('    ', self.frameData[self.frameHead]['[IMAGE]'][1]))
            return
        end

        self.playingSprite:SetTexture(img:GetTexture(self.frameData[self.frameHead]['[IMAGE]'][2] + 1))
        self.offset = img:GetOffset(self.frameData[self.frameHead]['[IMAGE]'][2] + 1)

        img = nil
    else
        self.playingSprite:SetTexture(_RESMGR.imageNull)
    end

    self:SetCenter(-self.frameData[self.frameHead]['[IMAGE POS]'][1], -self.frameData[self.frameHead]['[IMAGE POS]'][2])

    if self.num > 1 then
        if self.frameData[self.frameHead]['[GRAPHIC EFFECT]'] then
            if self.frameData[self.frameHead]['[GRAPHIC EFFECT]'] == 'lineardodge' then
                -- self:SetBlendMode(1)
                self.playingSprite:SetFilter(self.filter)
            end
        end

        if self.frameData[self.frameHead]['[RGBA]'] then
            self:SetColor(
                self.frameData[self.frameHead]['[RGBA]'][1],
                self.frameData[self.frameHead]['[RGBA]'][2],
                self.frameData[self.frameHead]['[RGBA]'][3],
                self.frameData[self.frameHead]['[RGBA]'][4]
            )
        end
    end

    if self.frameData[self.frameHead]['[PLAY SOUND]'] and not self.soundPlayFinished then
        _AUDIOMGR.PlaySound(self.frameData[self.frameHead]['[PLAY SOUND]'])
        -- print("frameHead", self.frameHead, "frame", self.count, "PlayFinished", self.soundPlayFinished)
        self.soundPlayFinished = true
    end

    self:SuperArmor_Update()

    self.updateCount = self.updateCount + 1
end

function _AniPack:Draw(x, y, r, sx, sy)
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

    self:SuperArmor_Draw()

    self.playingSprite:SetCenter(self.center.x, self.center.y)
    self.playingSprite:Draw(
        self.pos.x + self.offset.x * self.dir * self.scale.x,
        self.pos.y + self.offset.y * self.scale.y,
        self.angle or 0,
        self.scale.x * self.dir,
        self.scale.y
    )

    if GDebug then
        self:DrawBox()
    -- self.playingSprite.rect:Draw()
    end
end

function _AniPack:SuperArmor_Switch(s)
    if s == true then
        for i, v in ipairs(self.focus['sprite']) do
            v:SetTexture(self.playingSprite:GetTexture())
        end
        if self.focus['focus'] == false then
            self.focus['focus'] = true
            self.focus['scale'].x = 1.5
            self.focus['scale'].y = 1.5
            self.focus['ARGB']['G'] = 0
        end
    else
        self.focus['focus'] = false
    end
end

function _AniPack:SuperArmor_Update()
    local _damageType = self.frameData[self.frameHead]['[DAMAGE TYPE]']
    if _damageType and _damageType == 'superarmor' then
        self:SuperArmor_Switch(true)
    else
        self:SuperArmor_Switch(false)
    end

    if self.focus['focus'] then
        for k, v in pairs(self.focus.scale) do
            if self.focus.scale[k] > 1.0 then
                self.focus.scale[k] = self.focus.scale[k] - self.focus.scale.spd
                if self.focus.scale[k] < 1.0 then
                    self.focus.scale[k] = 1.0
                end
            end
        end
        self.focus['ARGB']['G'] =
            self.focus['ARGB']['G'] + self.focus['dir'] * self.focus['speed'] * love.timer.getDelta()
        if self.focus['ARGB']['G'] >= self.focus['max'] then
            self.focus['dir'] = -1
        elseif self.focus['ARGB']['G'] <= self.focus['min'] then
            self.focus['dir'] = 1
        end
        self.focus['shader']:send('green', self.focus['ARGB']['G'])
    end
end

function _AniPack:SuperArmor_Draw()
    if self.focus['focus'] then
        local _baseX = math.floor(self.pos.x + self.offset.x * self.focus.scale.x * self.dir)
        local _baseY = math.floor(self.pos.y + self.offset.y * self.focus.scale.y)
        for i, v in ipairs(self.focus['sprite']) do
            v:SetCenter(self.center.x, self.center.y)
        end
        love.graphics.setShader(self.focus['shader'])
        self.focus['sprite'][1]:Draw(
            _baseX - 1,
            _baseY - 1,
            self.angle,
            self.focus.scale.x * self.dir,
            self.focus.scale.y
        )
        self.focus['sprite'][2]:Draw(
            _baseX + 1,
            _baseY - 1,
            self.angle,
            self.focus.scale.x * self.dir,
            self.focus.scale.y
        )
        self.focus['sprite'][3]:Draw(
            _baseX + 1,
            _baseY + 1,
            self.angle,
            self.focus.scale.x * self.dir,
            self.focus.scale.y
        )
        self.focus['sprite'][4]:Draw(
            _baseX - 1,
            _baseY + 1,
            self.angle,
            self.focus.scale.x * self.dir,
            self.focus.scale.y
        )
        love.graphics.setShader()
    end
end

function _AniPack:Stop()
    self.stop = true
end

function _AniPack:Continue()
    self.stop = false
end

function _AniPack:DrawBox()
    local boxTab = self.frameData[self.frameHead]['[ATTACK BOX]']
    local atkBox = _Rect.New(0, 0, 1, 1)
    atkBox:SetColor(255, 0, 180, 150)
    if boxTab then
        for n = 1, #boxTab, 6 do
            atkBox:SetColor(255, 0, 180, 150)
            atkBox:SetPos(self.pos.x + boxTab[n] * self.dir, self.pos.y - boxTab[n + 2])
            atkBox:SetSize(boxTab[n + 3] * self.scale.x, -boxTab[n + 5] * self.scale.y)
            atkBox:SetDir(self.dir)
            atkBox:Draw()

            atkBox:SetColor(0, 0, 180, 150)
            atkBox:SetPos(self.pos.x + boxTab[n] * self.dir, self.pos.y - boxTab[n + 1])
            atkBox:SetSize(boxTab[n + 3] * self.scale.x, -boxTab[n + 4] * self.scale.y)
            atkBox:Draw()

            -- x, z, y, size_x, size_z, size_y
        end
    end

    local boxTab = self.frameData[self.frameHead]['[DAMAGE BOX]']
    local dmgBox = _Rect.New(0, 0, 1, 1)
    dmgBox:SetColor(0, 255, 0, 150)
    if boxTab then
        for n = 1, #boxTab, 6 do
            dmgBox:SetPos(self.pos.x + boxTab[n] * self.dir, self.pos.y + -boxTab[n + 2])
            dmgBox:SetSize(boxTab[n + 3] * self.scale.x, -boxTab[n + 5] * self.scale.y)
            dmgBox:SetDir(self.dir)
            dmgBox:Draw()
        end
    end
end

function _AniPack:GetAttackBox()
    if not self.active then
        return nil
    end
    return self.frameData[self.frameHead]['[ATTACK BOX]'] or nil
end

function _AniPack:GetDamageBox()
    return self.frameData[self.frameHead]['[DAMAGE BOX]'] or nil
end

---@param id string 
---@param num int 
function _AniPack:SetAnimation(id, num, rate)
    if not self.active then
        return
    end

    local _idType = type(id)

    if _idType == 'string' then -- play animation by id
        if not self.frameDataGrp[id] then
            print('Err:_AniPack:SetAnimation() -- cannot find ani：' .. id .. 'in frameDataGrp')
            return false
        else
            self.frameData = self.frameDataGrp[id].data
            self.playNum = self.frameDataGrp[id].num or 1
            self.aniId = id
        end
    elseif _idType == 'table' then -- play animation by aniData
        self.frameData = id
        self.playNum = num or -1
    else
        error('Err:_AniPack:SetAnimation() -- id type is wrong')
        return false
    end

    self.count = 0
    self.time = 0
    self.num = self.frameData['[FRAME MAX]']
    self:Continue()
    self:Update(0)
    self.frameHead = string.format('[FRAME%03d]', self.count)
    if self.frameData[self.frameHead]['[GRAPHIC EFFECT]'] then
        if string.lower(self.frameData[self.frameHead]['[GRAPHIC EFFECT]']) == 'lineardodge' then
            self:SetBlendMode(1)
        end
    end

    if self.frameData[self.frameHead]['[RGBA]'] then
        self:SetColor(
            self.frameData[self.frameHead]['[RGBA]'][1],
            self.frameData[self.frameHead]['[RGBA]'][2],
            self.frameData[self.frameHead]['[RGBA]'][3],
            self.frameData[self.frameHead]['[RGBA]'][4]
        )
    end
end

function _AniPack:PlayAnimByData(aniData, num)
    if not self.active then
        return
    end

    self.frameData = id
    self.playNum = num or -1

    self.count = 0
    self.time = 0
    self.num = self.frameData['[FRAME MAX]']
    self:Continue()
    self:Update(0)
    self.frameHead = string.format('[FRAME%03d]', self.count)

    if self.frameData[self.frameHead]['[GRAPHIC EFFECT]'] then
        if string.lower(self.frameData[self.frameHead]['[GRAPHIC EFFECT]']) == 'lineardodge' then
            self:SetBlendMode(1)
        end
    end

    if self.frameData[self.frameHead]['[RGBA]'] then
        self:SetColor(
            self.frameData[self.frameHead]['[RGBA]'][1],
            self.frameData[self.frameHead]['[RGBA]'][2],
            self.frameData[self.frameHead]['[RGBA]'][3],
            self.frameData[self.frameHead]['[RGBA]'][4]
        )
    end
end

--@param string aniPath
--@param int playNum
--@param string id
function _AniPack:AddAnimation(aniPath, playNum, id)
    local content = require(aniPath) -- content is a table
    self.frameDataGrp[id] = {data = content, num = playNum}

    if content['[LOOP]'] == 1 then
        self.frameDataGrp[id].num = -1
    else
        self.frameDataGrp[id].num = 1
    end
end

function _AniPack:SetActive(s)
    self.active = s
end

function _AniPack:SetPos(x, y, z)
    self.pos.x = x or self.pos.x
    self.pos.y = y or self.pos.y
    self.pos.z = z or self.pos.z
    self.playingSprite:SetPos(self.pos.x + self.offset.x * self.dir, self.pos.y + self.offset.y)
end

function _AniPack:SetScale(x, y)
    self.scale.x = x or self.scale.x
    self.scale.y = y or self.scale.y
    self.playingSprite:SetScale(x, y)
end

function _AniPack:SetAngle(r)
    self.angle = r or self.angle
    self.playingSprite:SetAngle(r)
end

function _AniPack:SetPlayNum(id, num)
    -- id	ani的对应动作(状态)名称
    -- num	播放次数

    if type(id) == 'string' then
        self.frameDataGrp[id].num = num
    elseif type(id) == 'number' then
        print('Err:_AniPack:SetPlayNum() --> id expected a string not number!')
    else
        print('Err:_AniPack:SetPlayNum() --> id get a unexpected type')
    end
end

function _AniPack:SetCurrentPlayNum(num)
    self.playNum = num
end

function _AniPack:SetFrame(num)
    self.count = num
end

function _AniPack:SetBaseRate(baseRate)
    self.baseRate = baseRate
end

function _AniPack:SetCenter(x, y)
    self.center.x = x or self.center.x
    self.center.y = y or self.center.y
end

function _AniPack:SetColor(r, g, b, a)
    self.color = {r = r, g = g, b = b, a = a}
    self.playingSprite:SetColor(r, g, b, a)
end

function _AniPack:SetBlendMode(modeNum)
    self.blendMode = self.blendModeList[modeNum]
    self.playingSprite:SetBlendMode(self.blendMode)
end

function _AniPack:SetFilter(switch)
    self.filter = switch or false
end

function _AniPack:SetFileNum(...)
    self.fileNum = {...}
    -- print(strcat("fileNum changed :", tostring(self.fileNum)))
end

function _AniPack:SetDir(dir)
    self.dir = dir
end

function _AniPack:GetCount()
    return self.count or 0
end

function _AniPack:GetAniId()
    return self.aniId or ''
end

function _AniPack:GetRect()
    return self.playingSprite:GetRect()
end

function _AniPack:GetScale()
    return self.scale
end

function _AniPack:GetWidth()
    return self.playingSprite:GetWidth()
end

function _AniPack:GetHeight()
    return self.playingSprite:GetHeight()
end

function _AniPack:GetCurrentPlayNum()
    return self.playNum
end

function _AniPack:GetCountTime()
    return self.time
end

function _AniPack:GetSpriteBox()
    return self.box
end

function _AniPack:Destroy()
    -- self.pos = nil
    -- self.center = nil
    -- self.offset = nil
    -- self.dir = nil

    -- self.playNum = nil
    -- self.fileNum = nil

    -- self.frameDataGrp = nil
    -- self.frameData = nil
    -- self.frameHead = nil
    -- self.count = nil
    -- self.time = nil
    -- self.updateCount = nil
    -- self.focus = nil
    -- self.filter = nil
    -- self.debug = nil
    -- self.blendModeList = nil
    -- self.blendMode = nil

    self.playingSprite:Destroy()
    self.box:Destroy()

    self = {}
end

return _AniPack

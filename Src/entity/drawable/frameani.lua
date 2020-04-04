--[[
	Desc: Animator
 	Author: SerDing
	Since: 2017-07-28 21:54:14
	Alter: 2017-07-30 23:36:07
]]
local _RESOURCE = require("engine.resource")
local _Base = require("engine.graphics.drawable.frameani")

---@class Entity.Drawable.Frameani:Engine.Graphics.Drawable.Frameani
local _Frameani = require('core.class')(_Base)

function _Frameani.HandleData(data)
    if data.path then
        data.animData = _RESOURCE.LoadAnimData(data.path)
    end
end

function _Frameani:Ctor(data)
    _Base.Ctor(self, data and data.animData or nil)

    self.focus = {
        focus = false,
        max = 1.0,
        min = 0.0,
        dir = -1,
        speed = 6,
        ARGB = {A = 255, R = 255, G = 0, B = 0},
        scale = {x = 1.5, y = 1.5, spd = 0.048},
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
                    number GlowRange = 12;						// 发光范围
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

end

-- function _Frameani:Update(dt)
--     _Base.Update(self, dt)
-- end

-- function _Frameani:Draw(x, y, r, sx, sy)
--     _Base.Draw(self, x, y, r, sx, sy)
-- end

return _Frameani

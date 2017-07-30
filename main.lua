--[[
	Desc: Entrace file
 	Author: Night_Walker
	Since: 2017-07-01 01:04:56
	Alter: 2017-07-30 23:46:00
	Docs:
		* Program Entrance
]]


require "Src/CommonFunction"

local _GameMgr = require "Src/GameManager"

local _Anima = require "Src/Anima"

local _RESMGR = require "Src/ResManager"




local image = love.graphics.newImage("/Dat/backgroundpic.png")

local hero = _Anima.New("/ImagePacks/Character/Swordman/Equipment/Avatar/Skin/sm_coat14500b.img")
hero:SetCentrePoint(233,336)
local weapon = _Anima.New("/ImagePacks/Character/Swordman/Equipment/Avatar/Weapon/sswd4200c.img")
weapon:SetCentrePoint(233,336)

function love.load()

	local bgm = _RESMGR.LoadSound("/Music/draconian_tower.ogg")
	bgm:play()
	bgm:setLooping(true)




	-- PakPool_Init()

	-- TestPak = ResPack("ImagePacks/character/Swordman_body.pak")

	-- "/ImagePacks/sprite_character_swordman_equipment_avatar_coat.NPK"

	-- empak = require ("pak")

	-- local FileNum,PakInfo = empak.GetPakInfo("ImagePacks/Character/Swordman_body.pak")
	-- print(PakInfo)

end



function love.update(dt)


	hero:Update(7,189,210)
	weapon:Update(7,189,210)
	_RESMGR:Update()

end




function love.draw()


	love.graphics.draw(image, 0, 0)


	love.graphics.line(0, 300, 800, 300) -- 横线
	love.graphics.line(400, 0, 400, 600) -- 竖线

	-- if(love.keyboard.isDown("lctrl")) then
	-- 	love.graphics.print("The Left_Ctrl is down",100,100)
	-- elseif(love.keyboard.isDown("rctrl")) then
	-- 	love.graphics.print("The Right_Ctrl is down",100,100)
	-- end

	hero:Draw(400,300)
	weapon:Draw(400,300)
end



function love.keypressed(key) --键盘检测回调函数，当键盘事件触发是调用





end



function love.mousepressed(x,y,key) --回调函数释放鼠标按钮时触发。





end


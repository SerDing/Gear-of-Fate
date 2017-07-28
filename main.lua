-- @作者: Night_Walker
-- @邮箱:  1076438225@qq.com
-- @创建时间:   2017-07-01 01:04:56
-- @最后修改来自: Night_Walker
-- @Last Modified time: 2017-07-25 23:53:22

require "Src/SystemClass" --加载系统底层的面向对象机制

require "Src/CommonFunction"
require "Src/GameManager"
require "Src/ResManager"
require "Src/ResPack"
require "Src/Rect"
require "Src/ResPack2"

opengl = love.graphics

function love.load()



	image = opengl.newImage("/Dat/backgroundpic.png")

	GameMgr = GameMgr.new()
	ResMgr = ResMgr.new()

	Hero = ResPack.new("/ImagePacks/Character/Swordman/Equipment/Avatar/Skin/sm_coat14500b.img")
	Hero:SetCentrePoint(233,336)
	weapon = ResPack.new("/ImagePacks/Character/Swordman/Equipment/Avatar/Weapon/sswd4200c.img")
	weapon:SetCentrePoint(233,336)

	bgm = ResMgr:LoadSound("/Music/draconian_tower.ogg")
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


	Hero:update(7,189,210)
	weapon:update(7,189,210)
	ResMgr:update()

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

	Hero:draw(400,300)
	weapon:draw(400,300)
end



function love.keypressed(key) --键盘检测回调函数，当键盘事件触发是调用





end



function love.mousepressed(x,y,key) --回调函数释放鼠标按钮时触发。





end


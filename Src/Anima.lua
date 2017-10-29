--[[
	Desc: An old class to open a img folder and create animation object for it.
 	Author: Night_Walker
	Since: 2017-07-28 21:54:14
	Alter: 2017-07-30 23:31:42
	Docs:
		* The class has some basic functions like playing animation.
]]


local _Anima = require("Src.Class")()

local _RESMGR = require "Src.ResManager"
local _Rect = require "Src.Core.Rect"


function _Anima:Ctor(PakName,fir_frame) --initialize



	-- Game.run_path = GetRunPath()

	-- self.real_path = Game.run_path .. [[\]] .. PakName

	-- self.fileNum,self.pakInfo = self.empak.GetPakInfo(self.real_path)



	-- if(self.pak信息 == nil)then
	-- 	print("无法获取PAK文件信息!" .. PakName)
	-- 	-- 引擎:Log("无法获取PAK文件信息!" .. PakName)
	-- 	return
	-- end

	-- if(self.pak信息 ~= nil)then
	-- 	print("获取PAK文件信息成功!" .. PakName)
	-- 	-- 引擎:Log("无法获取PAK文件信息!" .. PakName)
	-- 	return
	-- end



	if(love.filesystem.exists(PakName .. "/offset.txt") == false)then
		print("The pak offset file is not existing! Please check!")
		return
	end



	self.PakName  = PakName
	self.temp_position = {x = 0,y = 0}
	self.centre_point ={x = 0,y = 0}

	--love.filesystem.newFile(name,mode)
	-- local file = assert(love.filesystem.newFile(PakName .. "/offset.txt", "r"))
	-- self.offset_text = file:read()
	-- file:close()

	self.offset_text = LoadFile(PakName .. "/offset.txt")

	if(self.offset_text == nil)then
		print("Can not get offset data!" .. PakName)
		return
	end

	local  first_cut = CutText(self.offset_text, "\n")

	self.pak_info = {}

	for n =1 , table.getn(first_cut) do

		local re_cut = CutText (first_cut[n]," ")

		if (table.getn(re_cut) == 2) then

			self.pak_info[n]=
			{
				centre_x = tonumber( re_cut[1]),
				centre_y = tonumber( re_cut[2]),
				texture = 0
			}
		end
	end


	self.total_num = table.getn(self.pak_info)
	self.pak_info[1].texture = _RESMGR.LoadTexture(self.PakName .. "/0.png")
	-- self.playing_sprite = gge.精灵(self.pak_info[1].texture,0,0,self.pak_info[1].texture:getWidth(),self.pak_info[1].texture:getHeight())
	self.playing_sprite = self.pak_info[1].texture

	self.tmp_width = self.pak_info[1].texture:getWidth()
	self.tmp_height = self.pak_info[1].texture:getHeight()

	self.currentRect = _Rect.New(0,0,self.tmp_width,self.tmp_height)

	self.start_num = 1
	self.end_num = 1
	self.playing_num = 1

	self.global_count = 0
	self.time_count = 0

	self.process  = 1


end


function _Anima:Update(rate,start_num,end_num)

	self.time_count = self.time_count + 0.02

	if (start_num == nil) then
		self.start_num = 1
		self.end_num = self.total_num
	else
		self.start_num = start_num
		self.end_num = end_num
	end


	if (self.time_count > rate/100) then

		self.global_count = self.global_count + 1
		self.time_count = 0
	end


	if (self.global_count > self.end_num - self.start_num) then
		self.global_count = 0
	end


	self.playing_num = self.global_count + self.start_num

	if (self.playing_num <= table.getn(self.pak_info)) then

		if (self.pak_info[self.playing_num].texture == 0) then
			self.pak_info[self.playing_num].texture = _RESMGR.LoadTexture (self.PakName .. "/" .. tostring(self.playing_num - 1) .. ".png")
		end


		self.playing_sprite = self.pak_info[self.playing_num].texture
	end
end


function _Anima:Draw(x,y,w,h,rotation)

	if (w == nil) then
		w = 1
	end

	if (h == nil) then
		h = 1
	end

	if (rotation == nil) then
		rotation = 0
	end


	if (self.playing_num <= table.getn(self.pak_info)) then

		if (self.playing_num > 0) then
			self.temp_position.x = x + self.pak_info[self.playing_num].centre_x
			self.temp_position.y = y + self.pak_info[self.playing_num].centre_y
		end

	end




	-- self.playing_sprite:置坐标_高级(self.temp_position.x,self.temp_position.y,rotation,10,15)
	-- self.playing_sprite.Sprite:SetPositionEx(self.temp_position.x,self.temp_position.y,rotation,15,15)


	-- 颜色设置

	-- if (self.color_data ~= nil) then
	--     love.graphics.setColor( self.color_data )
	-- end

	love.graphics.draw(self.playing_sprite,
		self.temp_position.x,
		self.temp_position.y,
		rotation,
		1 * w,
		1 * h,
		self.centre_point.x,
		self.centre_point.y)

	self.currentRect:SetPos(self.temp_position.x,self.temp_position.y)

	local tmp_width = self.playing_sprite:getWidth()
	local tmp_height = self.playing_sprite:getHeight()

	self.currentRect:SetSize(tmp_width,tmp_height)
	self.currentRect:Draw()
end

function _Anima:Update_back(rate,start_num,end_num) -- 反向更新
	self.time_count = self.time_count + 0.02

	if ( start_num == nil) then
		self.start_num = 1
		self.end_num = self.total_num

	else

		self.start_num = start_num
		self.end_num = end_num
	end


	if(self.global_count == 0)then
		self.process = 1
	end

	if(self.global_count + self.start_num == self.end_num)then
		self.process = -1
	end



	if (self.time_count > rate/100) then

		self.global_count = self.global_count + self.process
		self.time_count = 0

	end

	self.playing_num  = self.global_count + self.start_num

	if (self.pak_info[self.playing_num].texture == 0) then
		self.pak_info[self.playing_num].texture = _RESMGR.LoadTexture (self.PakName .. "/" .. tostring(self.playing_num - 1) .. ".png")
	end
	self.playing_sprite = self.pak_info[self.playing_num].texture
end

function _Anima:SetColor(color_data)
	self.color_data = color_data
	-- self.playing_sprite:置颜色(color_data)

	-- love.graphics.setColor( red, green, blue, alpha )
end

function _Anima:ReSet()

	self.time_count = 0
	self.global_count = 0
end
--=============================================================================--
-- ■ 取间隔帧()
--=============================================================================--

function _Anima:GetLastFrame()

	return self.global_count
end

function _Anima:SetBlendMode(Mode)

	-- self.playing_sprite:置混合(混合值)

	-- love.graphics.setBlendMode( Mode )
	--[[

	BlendMode

	additive

	Additive blend mode.

	alpha

	Alpha blend mode ("normal").

	replace

	Replace blend mode.

	screen

	Screen blend mode.

	subtractive

	Subtractive blend mode.

	multiplicative

	Multiply blend mode.

	premultiplied

	Premultiplied blend mode.


	]]

end

function _Anima:SetCentrePoint(x,y)

	self.centre_point.x = x
	self.centre_point.y = y
	self.currentRect:SetCenter(x,y)
end

function _Anima:Release()


	for n=1,table.getn(self.pak_info) do
		if (self.pak_info[n].texture ~= 0) then
			self.pak_info[n].texture:Release()
		end
	end
	self.playing_sprite:Release()

end

return _Anima
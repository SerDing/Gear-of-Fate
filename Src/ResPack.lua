-- @作者: Night_Walker
-- @邮箱:  1076438225@qq.com
-- @创建时间:   2017-07-03 23:07:34
-- @最后修改来自: Night_Walker
-- @Last Modified time: 2017-07-25 23:09:48


ResPack = class()

-- PakName Pak包标识		fir_frame 首帧序号		IsCompress 是否压缩
function ResPack:init(PakName,fir_frame,IsCompress) --initialize



	-- Game.run_path = GetRunPath()

	-- self.real_path = Game.run_path .. [[\]] .. PakName

	-- self.文件号,self.pak信息 = self.empak.GetPakInfo(self.real_path)



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
		-- Engine.写log("无法获取偏移信息!" .. PakName)
		return
	end

	local  first_cut = CutText(self.offset_text, "\n")

	self.pak_info = {}

	for n =1 , table.getn(first_cut) do

		local re_cut = CutText (first_cut[n]," ")

		if (table.getn(re_cut) == 2) then

			self.pak_info[n]=
			{
				centre_x	= tonumber( re_cut[1]),
				centre_y	= tonumber( re_cut[2]),
				texture = 0
			}
		end
	end


	self.total_num = table.getn(self.pak_info)
	self.pak_info[1].texture = ResMgr:LoadTexture(self.PakName .. "/0.png")
	-- self.playing_sprite = gge.精灵(self.pak_info[1].texture,0,0,self.pak_info[1].texture:getWidth(),self.pak_info[1].texture:getHeight())
	self.playing_sprite = self.pak_info[1].texture

	self.tmp_width = self.pak_info[1].texture:getWidth()
	self.tmp_height = self.pak_info[1].texture:getHeight()

	self.CurrentRect = Rect.new(0,0,self.tmp_width,self.tmp_height)

	self.start_num = 1
	self.end_num = 1
	self.playing_num = 1

	self.global_count = 0
	self.time_count = 0

	self.process  = 1


end


function ResPack:update(rate,start_num,end_num)

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
			self.pak_info[self.playing_num].texture = ResMgr:LoadTexture (self.PakName .. "/" .. tostring(self.playing_num - 1) .. ".png")
		end


		self.playing_sprite = self.pak_info[self.playing_num].texture
	end
end


function ResPack:draw(x,y,w,h,rotation)

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

	self.CurrentRect:setPos(self.temp_position.x,self.temp_position.y)

	local tmp_width = self.playing_sprite:getWidth()
	local tmp_height = self.playing_sprite:getHeight()

	self.CurrentRect:setSize(tmp_width,tmp_height)
	self.CurrentRect:draw()

end

function ResPack:update_back(rate,start_num,end_num) -- 反向更新
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
		self.pak_info[self.playing_num].texture = ResMgr:LoadTexture (self.PakName .. "/" .. tostring(self.playing_num - 1) .. ".png")
	end
	self.playing_sprite = self.pak_info[self.playing_num].texture
end



--=============================================================================--
-- ■ 置颜色()
--=============================================================================--

function ResPack:SetColor(color_data)
	self.color_data = color_data
	-- self.playing_sprite:置颜色(color_data)

	-- love.graphics.setColor( red, green, blue, alpha )

end
--=============================================================================--
-- ■ 重置()
--=============================================================================--

function ResPack:ReSet()

	self.time_count = 0
	self.global_count = 0

end
--=============================================================================--
-- ■ 取间隔帧()
--=============================================================================--

function ResPack:GetLastFrame()

	return self.global_count
end
--=============================================================================--
-- ■ 置渲染模式()
--=============================================================================--

function ResPack:SetBlendMode(Mode)

	-- self.playing_sprite:置混合(混合值)

	love.graphics.setBlendMode( Mode )
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

--=============================================================================--
-- ■ 置中心点()
--=============================================================================--

function ResPack:SetCentrePoint(x,y)

	self.centre_point.x = x
	self.centre_point.y = y
	self.CurrentRect:setCenter(x,y)
end

--=============================================================================--
-- ■ 释放()
--=============================================================================--

function ResPack:release()


	for n=1,table.getn(self.pak_info) do
		if (self.pak_info[n].texture ~= 0) then
			self.pak_info[n].texture:release()
		end
	end
	self.playing_sprite:release()

end

return ResPack
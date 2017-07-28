-- @作者: Night_Walker
-- @邮箱:  1076438225@qq.com
-- @创建时间:   2017-07-03 23:07:34
-- @最后修改来自: Night_Walker
-- @Last Modified time: 2017-07-26 00:07:31


ResPack2 = class()

-- PakName Pak包标识		fir_frame 首帧序号		IsCompress 是否压缩
function ResPack2:init(PakName) --initialize



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

end


function ResPack2:getTexture(num)
	self.pak_info[num].texture = ResMgr:LoadTexture(self.PakName .. "/" .. tostring(num - 1) .. ".png")
	return self.pak_info[num].texture
end

function ResPack2:getOffset(num)

	local offset = { x = self.pak_info[num].centre_x , y = centre_y }
	return offset

end

function ResPack2:getFrameNum() -- 获取帧数量

	return self.total_num

end

--=============================================================================--
-- ■ 释放()
--=============================================================================--

function ResPack2:release()


	for n=1,table.getn(self.pak_info) do
		if (self.pak_info[n].texture ~= 0) then
			self.pak_info[n].texture:release()
		end
	end

end

return ResPack2
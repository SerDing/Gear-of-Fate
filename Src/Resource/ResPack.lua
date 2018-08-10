--[[
	Desc: A new lua class
 	Author: Night_Walker
	Since: 2017-07-28 21:54:14
	Alter: 2017-07-30 12:40:40
	Docs:
		*Write notes here even more
]]

local _ResPack = require("Src.Core.Class")()

local _RESMGR = require "Src.Resource.ResManager"

function _ResPack:Ctor(PakName) --initialize

	-- Game.run_path = GetRunPath()

	-- self.real_path = Game.run_path .. [[\]] .. PakName

	-- self.fileNum,self.pakInfo = self.empak.GetPakInfo(self.real_path)

	-- if self.pakInfo == nil then
	-- 	print("can not get pak infomation!" .. PakName)
	-- 	-- 引擎:Log("can not get pak infomation" .. PakName)
	-- 	return
	-- end
	
	self.PakName = PakName
	
	local tmpArray = string.split(self.PakName,"/")
	
	local _offsetName = string.gsub(tmpArray[#tmpArray],".img",".txt")
	
	if love.filesystem.exists(strcat(self.PakName, "/offset.txt")) == false
	and love.filesystem.exists(strcat(self.PakName, "/", _offsetName)) == false then
		print("The img pack is not existing:",self.PakName)
		return
	end

	

	if love.filesystem.exists(strcat(self.PakName, "/", _offsetName)) then
		self.offset_text = LoadFile(strcat(self.PakName, "/", _offsetName))
	else 
		self.offset_text = LoadFile(strcat(self.PakName, "/offset.txt"))
	end 

	if self.offset_text == nil then
		print("Error:_ResPack:Ctor() --> Can not get offset data!", self.PakName)
		return
	end
	
	local  first_cut = CutText(self.offset_text, "\n")

	self.pak_info = {}

	for n =1 , table.getn(first_cut) do

		local re_cut = CutText (first_cut[n]," ")

		if table.getn(re_cut) == 2 then

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

function _ResPack:GetTexture(num)

	if not self.pak_info then
		return 
	end 
	
	if self.pak_info[num].texture == 0 then
		local _path = strcat(self.PakName, "/", tostring(num - 1), ".png")
		if love.filesystem.exists(_path)then
			local tex = _RESMGR.LoadTexture(_path)
			self.pak_info[num].texture = tex
		else
			print("Err:_ResPack:GetTexture() --> " .. _path .. " not found!")
			return
		end
	end

	return self.pak_info[num].texture
end

function _ResPack:GetOffset(num)
	
	local offset
	
	if not self.pak_info then
		offset = {
			x = 0 ,
			y = 0 ,
		}
	else
		offset = {
			x = self.pak_info[num].centre_x or 0 ,
			y = self.pak_info[num].centre_y or 0 ,
		}
	end

	return offset
end

function _ResPack:GetFrameNum() -- 获取帧数量
	return self.total_num
end

function _ResPack:Release()

	for n=1,table.getn(self.pak_info) do
		if self.pak_info[n].texture ~= 0 then
			self.pak_info[n].texture:release()
		end
	end

end

return _ResPack
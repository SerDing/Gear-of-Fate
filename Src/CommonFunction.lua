-- @作者: Night_Walker
-- @邮箱:  1076438225@qq.com
-- @创建时间:   2017-07-04 02:04:59
-- @最后修改来自: Night_Walker
-- @Last Modified time: 2017-07-18 16:00:41



function CutText(w,z)-- 参数:待分割的字符串,用作分割的字符
	local a = { }            --声明a
    while (true) do          --判断循环
        local pos = string.find(w,z,nil,true) --取出分割的字符的位置
        if (not pos) then            --如果位置的值不为空,↓↓↓
            a [#a+1] = w             --因为取不到z的位置,把w保存到数组a中
        	break
           --如果位置的值为空,跳出循环
        end
        local sub_w = string.sub(w, 1, pos - 1) --取文本中间（文本,起始位置,结束位置）,取出的文本保存到sub_w
        a[ #a + 1] = sub_w                      --把sub_w保存到数组a中
        w = string.sub(w, pos + 1, #w)         --把w当前位置到文本末所剩下的文本赋值到w中
                               --[#字符串]=为取字符串长度
    end
		return a   -- 返回:子串表.(含有空串)
end



function 取ani数据_(路径)
	local FrameData = CutText(ReadFile(路径),"[FRAME")--读取ani数据文本且分割

	local ani = {LOOP=0,FRAME_MAX=0,imgNum=0}

	-- FrameData = 帧数据
	for i=1,#FrameData do -- FrameData成员数就是FrameData数量 [FRAME000] [FRAME001] [FRAME002]
		if i>2 then --分割"[FRAME"后,从第2个数组开始分析

			local Data = CutText(FrameData[i],"\n")--把FrameData内的文本分割,一行一行的分割
			local FrameData = {npkName="",imgName="",frameNum=0,center_x=0,center_y=0,horizon=1,vertical=1,delay=0,blendMode=0,superArmor=0,HurtBox={},AtkBox={},sound={}}
			local HurtBox ={}
			local AtkBox = {}
			for n=1,#Data do --下面开始判定每行代码的内容

				if Data[n] == "[LOOP]" then --ani渲染的循环次数 没有LOOP参数则为 0
					LOOP = LOOP + 1
				elseif Data[n] == "[SHADOW]" then --判定ani渲染时是否开启阴影效果 1=开启 0=关闭
				    --do
				elseif Data[n] == "MAX]" then --ani结构 调用img的总次数 [FRAME MAX]
				    imgNum = imgNum + 1 --因为部分Ani中有空白帧,要创建空白纹理 这里暂时忽略，ani.FRAME_MAX放在最后取--取数组成员数 (ani.imgName)
				elseif Data[n] == "[IMAGE]"then --判定是否imgName
					if Data[n+2] == "[IMAGE POS]" then

					    local tmpStr = CutText(Data[n+1],"	") --分割 img名 和 帧数

					    if tmpStr[1] == "``" then
					        FrameData.imgName = "sprite/"  --如果为空白,则定义为 "sprite/"
					    else
					    	tmpStr[1] =string.gsub(tmpStr[1], "`", "") --替换字符 先把img首尾的"`"点去掉
					        FrameData.imgName = "sprite/" ..string.lower(tmpStr[1]) --转换到小写 imgName
					    end
					    --print(FrameData.imgName)
					    FrameData.frameNum = tonumber(tmpStr[2]) + 1 --img文本下一行就是frameNum是帧号,DNF是由0开始的,这里编程是有1开始 所以要+1
					else
					    if Data[n+1]=="``"then --如果为空白,则定义为 "sprite/"
							FrameData.imgName = "sprite/"
						else
							Data[n+1]=string.gsub(Data[n+1], "`", "")--替换字符 先把img首尾的"`"点去掉
							FrameData.imgName="sprite/" ..string.lower(Data [n+1]) --转换到小写 imgName
						end
						FrameData.frameNum = tonumber(Data [n + 2]) + 1 --img文本下一行就是frameNum是帧号,DNF是由0开始的,这里编程是有1开始 所以要+1

					end

					ani.FRAME_MAX = ani.FRAME_MAX + 1 --当前的ani的FRAME_MAX+1
					_,_,FrameData.npkName = FrameData.imgName:find("(.+)/") --取最后一个"/"前的所有任意字符
		    		FrameData.npkName = string.gsub(FrameData.npkName,"/" , "_")..".NPK"  --等于替换文本 参数1:待替换的字符串 参数2:欲替换的字符 参数3:替换后的字符
					FrameData.blendMode = 0  --正常渲染模式
					--print(FrameData.npkName)
				elseif Data[n]=="[IMAGE POS]" then
		           	local center = CutText(Data [n + 1],"	") -- 这里包含x,y 所以要分割出来
		            FrameData.center_x = tonumber (center [1])
		            FrameData.center_y = tonumber (center [2])
		        elseif Data[n]=="[IMAGE RATE]" then
		            local tmp = CutText(删首尾空(Data [n + 1]),"	")
		            FrameData.horizon = tonumber(tmp[1])
		            FrameData.vertical = tonumber(tmp[2])
		            print(FrameData.horizon,FrameData.vertical)
		        elseif Data[n]=="[DELAY]" then --delay,ani贴图的显示时间,频率
		        	FrameData.delay = tonumber (Data [n + 1])

		        elseif Data[n]=="[DAMAGE BOX]" then --HurtBox
		        	local tmp = CutText(Data [n + 1],"	") --空字符为#Tab
		        	HurtBox = {tmp[1],tmp[2],tmp[3],tmp[4],tmp[5],tmp[6]}
		        	table.insert(FrameData.HurtBox,HurtBox)
		        elseif Data[n]=="[ATTACK BOX]" then     -- AtkBox
		        	local tmp = CutText(Data [n + 1],"	") --空字符为#Tab
		        	AtkBox = {tmp[1],tmp[2],tmp[3],tmp[4],tmp[5],tmp[6]}
		        	table.insert(FrameData.AtkBox,AtkBox)
		        	--table.print(FrameData.AtkBox)
		        elseif Data[n] =="[GRAPHIC EFFECT]" then --贴图渲染效果
		        	if Data[n+1] == "`LINEARDODGE`" or Data[n+1]=="`LINEARDODGE`	"then --线性减淡
		        	    FrameData.blendMode = 2
		        	end
		        elseif Data[n]=="[DAMAGE TYPE]" then
		        	if Data[n+1] == "`SUPERARMOR`" then --superArmor霸体,渲染描边
		        		FrameData.superArmor = 1
		        	end
		       	elseif Data[n]=="[PLAY SOUND]" then --sound
		       	    -- FrameData.sound[#FrameData.sound+1] =_索引.读ini("ogg",string.gsub(Data[n+1], "`", ""))
				end--最新进度 大概完成ani数据读取 暂时取消了音效的读取
			end
			table.insert(ani,FrameData)
			--table.print(FrameData)
		end
	end
	return ani
end



function LoadFile(Path) -- 打开指定文件，读取并返回全部内容。
	--love.filesystem.newFile(name,mode)
	local file = assert(love.filesystem.newFile(Path, "r"))
	local TmpContent = file:read()
	file:close()
	return TmpContent
end

function GetRunPath()
    os.execute("cd > cd.tmp")
    local f = io.open("cd.tmp", r)
    local cwd = f:read("*a")
    f:close()
    os.remove("cd.tmp")
    return string.sub(cwd, 1, -2)
end







--=============================================================================--
-- ■ 初始化PAK缓存池()
--=============================================================================--

function PakPool_Init()

	empak = require ("pak")

	-- local a = 引擎.取游戏时间()

	for n=1, table.getn(Game.Res_pool) do

		local TmpPak = {}

		TmpPak.path = Game.Res_pool[n]

		-- local  FileNum  = 打开文件(TmpPak.path,1,1)

		-- local PakInfo = self.empak.取pak信息(FileNum)

		Game.run_path = GetRunPath()

		local real_path = Game.run_path .. [[/]] .. TmpPak.path
		print(Game.run_path)
		local FileNum,PakInfo = empak.GetPakInfo(real_path)

		if(PakInfo == nil)then
			print("无法获取PAK文件信息!" .. real_path)
			-- 引擎:Log("无法获取PAK文件信息!" .. TmpPak.path)
			return
		end

		local  首次分割 = CutText(PakInfo, "\n")

		TmpPak.FileNum = FileNum
		TmpPak.PAK信息组 = {}

		for n =1 , table.getn(首次分割) do

			local 再一层CutText组 = CutText (首次分割[n],",")

			if (table.getn(再一层CutText组) == 5) then

				TmpPak.PAK信息组[n]=
				{
					编号 = tonumber( 再一层CutText组[1] ),
					偏移 = tonumber( 再一层CutText组[2] ),
					图片大小	= tonumber( 再一层CutText组[3] ),
					center_x	= tonumber( 再一层CutText组[4] ),
					center_y	= tonumber( 再一层CutText组[5])
				}

			end

		end

		--关闭文件(FileNum )

		table.insert(Game.Res_cache_poll,TmpPak)
		print("Pak读取成功！")
	end


	-- Log__("PAK资源信息预读时间:" .. 引擎.取游戏时间()- a .."毫秒" )
end
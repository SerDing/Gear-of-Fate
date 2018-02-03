--======================================================================--
--该 文件由GGELUA创建
--
--作者：nn  创建日期：2014-12-14 7:33:13
--======================================================================--

gj = require("Src.Core.Class")()

function gj:初始化(xx,yy)

	cout = 0
	-- self.go = g音效.创建("dat/audio/n/go.ogg",false) 
	self.spd = 4.4

	self.lv = 1
	self.exp = 11
	self.maxhp = 100
	self.hp = 22
	self.maxmp = 100
	self.mp = 100
	self.霸体 = false
	
	self.坐标 = {x=xx or 333,y=yy or 222}
	self.上次坐标 = {x=0,y=0}
	
	self.地平线 = self.坐标.y
	self.pause = false
	self.movec = true
	self.att = false
	self.skill = 0

	self.attc = true
	self.skillc = true

	self.keyupL =0 --移动相关属性
	self.keyupR = 0

	self.state ="stop"
	self.orit = 1
	self.lf = 0
	self.jumpoffset = 0
	self.地平线 = self.坐标.y
	self.dz ={
	stop={13.5,91,95,nil,0,0}, --1, s ,2,f,  3, l , 4. p , 5,  n上次连击, 6 .ys
	stop2={13.5,177,180,nil,0,0}, --1, s ,2,f,  3, l , 4. p , 5,  n上次连击, 6 .ys
	go={11.6,181,188,nil,0,0},   
	run={12.2,106,113,nil,0,0},  --11.2
	x1={6,1,10,4,0,0},
	x2={6,11,20,14,0,0},
	x3={6,43,52,47,0,0},
	x11={6.5,189,194,4,0,0},
	x22={6.5,195,199,14,0,0},
	x33={6.5,200,204,47,0,0},
	x44={6.5,205,210,47,0,0},
	前刺={10,114,123,117,0,0},

	上挑={8,44,52,47,0,0},
	鬼斩1={1,140,140,47,0,0},
	鬼斩2={8,141,148,47,0,0},
	鬼斩3={8,13,21,47,0,0},

	地波={8,44,52,47,0,0},
	爆波={9,43,52,47,0,0},
	冰波={8,44,52,47,0,0},
	波动爆发={8,79,86,47,0,0},
	墓碑={10,76,90,47,0,0},

	jump1={8,127,127,127,0,0},
	jump2={8,128,128,128,0,0},
	jump2={8,131,131,131,0,0},
	格挡1 ={1,124,124,131,0,0 },
	格挡2 ={1,125,125,131,0,0 },
	邪光斩1={1,140,140,47,0,0},
	邪光斩2={10,141,150,47,0,0},

	moon1={7.5,195,199,14,0,0},
	moon2={7.5,200,204,47,0,0},
	moon3={7.5,43,52,47,0,0},

	}--
	self.档time =0




	self.wawa = {}

	self.wawa [1] = {action = B.创建("x.txt","Dat/b/")}
	self.wawa [2] = {action = B.创建("x.txt","Dat/a/")}
	self.wawa [3] = {action = B.创建("x.txt","Dat/a/")}
	-- self.wawa [4] = {action = B.创建("x.txt","Dat/300b/")}
	-- self.wawa [5] = {action = B.创建("x.txt","Dat/300c/")}


	self.b = self.wawa [1].action

	for n=1,#self.wawa do
		self.wawa [n].action:置中心(233,336)
	end
self.排序参照点 =self.b.临时位置.y




	self.底部光圈精灵 = g精灵(g纹理("dat/ui/q0.png"))
	self.底部光圈精灵 :置中心(126/2,42/2)
	self.底部光圈透明度 = 180
	self.底部光圈控制变量 = 1.5

	self.边线可视 = true
	self.边线透明度 = 90
	self.边线透明控制变量 =4	  --4

	skrun = 0
end

-----UPDATE ------ 
function gj:更新()  
	if(self.exp <50 )then
		self.exp = self.exp +0.01
	end
	if(self.hp < 100 )then
		self.hp = self.hp +0.1
	end
	if(self.mp >0) then
		self.mp = self.mp -0.05
	end

	self.上次坐标.x =  self.坐标.x 
	self.上次坐标.y =  self.坐标.y 
	self.排序参照点 =self.b.临时位置.y
	self.lf = self.wawa[1].action:dhz()
	-- self.b.碎图片精灵 :置过滤(true)
		if not self.pause then  --update
			self:update()

		end 


		if FO then
			self:attack()
			self:sk()

			self:格挡()

			self:movelogic()
			self:jumplogic()
		else
			-- if self.state == "go" or self.state == "run" then self:toupdate("stop") end

			self:stateClr()
			self:toupdate("stop") 
		end


 		self:碰撞检测() --
 		 offset =  取画面坐标1(self.坐标.x ,self.坐标.y , 地图宽度   , 地图高度)--

	--------------------------

	self.底部光圈透明度 = self.底部光圈透明度  + self.底部光圈控制变量 --底部光圈
	if (self.底部光圈透明度 <=180 or self.底部光圈透明度 >=250) then 
		self.底部光圈控制变量 = - self.底部光圈控制变量 
	end 


	if(self.边线可视 or self.霸体 )then --武器强化效果
		self.边线透明度 = self.边线透明度 + self.边线透明控制变量 

		if (self.边线透明度 <=90 or self.边线透明度 >=220) then 
			self.边线透明控制变量 = - self.边线透明控制变量  
		end 

	end


end



--SHOW---------------------------------------------------

function gj:显示()  
	if 引擎.按键按住(KEY.V) then
		print(self.坐标.x,"~~~~~~~~~~人坐标	",self.坐标.y)
	end
	self.底部光圈精灵:置坐标_高级(self.坐标.x +  offset.x,self.坐标.y +offset.y,0,self.orit *1.3,1.2)
	self.底部光圈精灵:置颜色(ARGB(self.底部光圈透明度 ,255,255,255))
	self.底部光圈精灵:显示()

	self.wawa[1].action:置颜色(ARGB(145,0,0,0))  --影子
	self.wawa[1].action:显示( self.坐标.x +  offset.x,self.坐标.y +self.jumpoffset+offset.y,self.orit ,0.44     )

	if self.霸体 then
	self.wawa[1].action:置混合(1) --霸体效果
	self.wawa[1].action:置颜色(ARGB(self.底部光圈透明度,233,223,12))
	self.wawa[1].action:显示( self.坐标.x+  offset.x+1.4 ,self.坐标.y  ,self.orit ,1   )
	self.wawa[1].action:显示( self.坐标.x+  offset.x-1.6 ,self.坐标.y  ,self.orit ,1   )
	self.wawa[1].action:显示( self.坐标.x+  offset.x ,self.坐标.y +1.6,self.orit ,1   )
	self.wawa[1].action:显示( self.坐标.x+  offset.x ,self.坐标.y  -1.4,self.orit ,1   )
end

for n=1,#self.wawa do
	if(n~=3  ) then
		self.wawa[n].action:置混合(0)
		self.wawa[n].action:置颜色(ARGB(255,255,255,255))
		self.wawa[n].action:显示( self.坐标.x +offset.x ,self.坐标.y ,self.orit ,1   )
	end
end



	if self.边线可视 then	-- 强化效果
		for n=3,#self.wawa do
			self.wawa[n].action:置混合(2)
			self.wawa[n].action:置颜色(ARGB(self.边线透明度,60,60,200))--211,0,211
			self.wawa[n].action:显示( self.坐标.x+  offset.x  ,self.坐标.y  +self.jumpoffset,self.orit ,1   )
		end
	end


	引擎.画矩形(self.坐标.x +offset.x  +1,self.坐标.y  +offset.y, self.坐标.x +offset.x +offset.y,0,ARGB(222,222,222,222) )

end



function gj:toupdate(action,unique)
	

for k,v in pairs(self.dz) do--	 
	if(v[6]~=0)then v[6] = 0 end
end	--


if ( unique ~= nil ) then 
	if (self.state ~= action) then 
		self.state = action
		self:reset()
		self:update()

	end 

else 
	self.state = action
	self:reset()

	self:update()
	self.lf  =0

end 


if(self.pause and self.state~="stop" )then 
	self.pause = false
end



end



function gj:update()



	for n=1,#self.wawa do
		self.wawa[n].action:更新(self.dz[self.state][1],self.dz[self.state][2],self.dz[self.state][3])
	end
end

function gj:reset()

	for n=1,#self.wawa do
		self.wawa[n].action:reset()
	end

end




function gj:碰撞检测()

	if self.上次坐标.x ~= self.坐标.x or self.上次坐标.y ~= self.坐标.y then 

		for n=1 , # Q_地图.矩形_障碍层  do

			if Q_地图.矩形_障碍层[n].包围盒:检查点(self.坐标.x + offset.x,self.坐标.y  )  then -- 接触到包围盒
				
				if(self.上次坐标.x  <=  Q_地图.矩形_障碍层[n].x) then
					
					self.上次坐标.x =  Q_地图.矩形_障碍层[n].x
					self.坐标.x = self.上次坐标.x
				end	
				if self.上次坐标.x  >=  Q_地图.矩形_障碍层[n].x +  Q_地图.矩形_障碍层[n].包围盒:取宽度() then
					self.上次坐标.x =  Q_地图.矩形_障碍层[n].x + Q_地图.矩形_障碍层[n].包围盒:取宽度()
					self.坐标.x = self.上次坐标.x
				end

				if self.上次坐标.y  <=  Q_地图.矩形_障碍层[n].y then
					self.坐标.y =  Q_地图.矩形_障碍层[n].y
					
					elseif self.上次坐标.y  >=  Q_地图.矩形_障碍层[n].y +  Q_地图.矩形_障碍层[n].包围盒:取高度() then
						self.坐标.y =  Q_地图.矩形_障碍层[n].y +  Q_地图.矩形_障碍层[n].包围盒:取高度()

					end

				end

			end


		end

	end





function gj:s(_spd,可左右,可y,自动位移) --	对xorit在次封装

	if 自动位移 ~=nil and not 引擎.按键按住(KEY.A) and not 引擎.按键按住(KEY.D) then
		self:xorit(_spd* self.orit  /2)
		elseif(可左右~=nil or 可左右~=false)then
			if(引擎.按键按住(KEY.A) and self.orit == -1)then
				self:xorit(_spd* self.orit ) 
				elseif(引擎.按键按住(KEY.D) and self.orit ==1)then
					self:xorit(_spd* self.orit )
				end

			end



			if( 可y )then

				if 引擎.按键按下(QKEY.up)  and self.orit ==1 and   引擎.按键按下(QKEY.right) then
					self:xorit(0,_spd ,1 ) 
					elseif 引擎.按键按下(QKEY.down)  and  self.orit == 1  and  引擎.按键按下(QKEY.right) then 
						self:xorit(0,5  ) 
					end

					if 引擎.按键按下(QKEY.up)  and self.orit ==-1 and   引擎.按键按下(QKEY.left) then
						self:xorit(0,_spd,1 ) 
						elseif 引擎.按键按下(QKEY.down)  and  self.orit == -1  and  引擎.按键按下(QKEY.left) then 
							self:xorit(0,_spd  ) 
						end

					end
end--

function gj:xorit(_xorit)--

	self.坐标.x = self.坐标.x + _xorit
end--
function gj:yorit(_yorit)--

	self.坐标.y = self.坐标.y - _yorit
end--




function gj:zdhz(值)
	for n=1,#self.wawa do
		self.wawa[n].action:置当前帧(值)
	end

end 

function gj:getlf() --getlf  得尾帧

	local temp = self.dz[self.state][3] - self.dz[self.state][2]
	return  temp;
end--




--移动逻辑
function gj:movelogic()
	self.地平线 = self.坐标.y
	if not self.movec  then

		return 
	end



	if  引擎.按键弹起(KEY.A) then
		self.keyupL = 引擎:取游戏时间()
		
	elseif 引擎.按键弹起(KEY.D) then
		self.keyupR = 引擎:取游戏时间() 
	end
	

	
	if not 引擎.按键按住(KEY.A) and 
	not  引擎.按键按住(KEY.D) and 
	not 引擎.按键按住(KEY.W) and 
	not 引擎.按键按住(KEY.S) then
		if self.state~="stop"   then
			self:toupdate("stop")
			
		end
	end


	if  引擎.按键按住(KEY.A) then  --左
		
		if(self.orit~=-1)then
			self.orit = -1
			self:toupdate("go",true)
			
			self.坐标.x = self.坐标.x-self.spd
			return
		end
		
		
		self.orit = -1
		if(self.state~="run")then
			self:toupdate("go",true)
		end
		
		if(self.state=="go")then
			self.坐标.x = self.坐标.x-self.spd	 
		elseif(self.state=="run")then
			self.坐标.x = self.坐标.x- self.spd * 1.47
		end
		
		if 引擎.按键按下(KEY.A) and 引擎:取游戏时间() - self.keyupL<= 0.15  then
			self:toupdate("run")
		end 
	elseif 引擎.按键按住(KEY.D) then --右	


		if(self.orit~=1)then
			self.orit = 1
			self:toupdate("go",true)

			self.坐标.x = self.坐标.x+self.spd	

			return
		end


		self.orit = 1

		if(self.state~="run")then
			self:toupdate("go",true)
		end

		if(self.state=="go")then
			self.坐标.x = self.坐标.x+ self.spd	 
		elseif(self.state=="run")then
			self.坐标.x = self.坐标.x+ self.spd * 1.47
		end

		if 引擎.按键按下(KEY.D) and 引擎:取游戏时间() - self.keyupR<= 0.15  then
			
			self:toupdate("run")
		end 
	end



	if 引擎.按键按住(KEY.W) then --上
		
		if(self.state~="run")then
			self:toupdate("go",true)
		end
		
		if(self.state=="go")then
			self.坐标.y = self.坐标.y- self.spd * 0.77
		elseif(self.state=="run")then
			self.坐标.y = self.坐标.y- self.spd * 0.87
		end
		
	elseif  引擎.按键按住(KEY.S)  then --下
		
		if(self.state~="run")then
			self:toupdate("go",true)
		end	
		
		if(self.state=="go")then
			self.坐标.y = self.坐标.y + self.spd * 0.77
		elseif(self.state=="run")then
			self.坐标.y = self.坐标.y + self.spd * 0.87
		end	

	end

	-- if self.state== "run" or   self.state== "go" then
	-- 	if self.lf ~=self.b:dhz()  and not self.go:是否播放() then 	self.go:播放_高级(60,0,1.0,false) end
	-- end



end--



function gj:attxxx()
	if (self.state=="x1" or self.state=="x2" or self.state=="x3" )     then


		if self.state=="x2" and self.lf <=1 then
			self:s(4,false,false,false)  --3.6
		end
		if self.state=="x3" and self.lf <=2 then
			self:s(3.8 ,false,false,true)  --4.6
		end

		if self.b:dhz() == self:getlf() then
			self.dz[self.state][6]  = self.dz[self.state][6] +0.023
			if(self.dz[self.state][6] >0.46)then

				self.dz[self.state][6] = 0

				self:stateClr()
				self:toupdate("stop")
				-- self.att = false
				-- self.movec = true
				-- self.pause = false

				elseif self.dz[self.state][6] <=0.023 then
					self.pause = true
					if self.state=="x2" and  self.dz[self.state][6] <= 0.4 then self:s(-0.3,false) end--0.48
					-- if self.state~="x1" then self:xorit( -(0.3 % self.orit) ) end

					self:zdhz(self.dz[self.state][3]-1) 

				end
			end
		end




		if self.state~="x1" and self.state~="x2" and self.state~="x3" and not self.att and self.skill==0 then
			if(引擎.按键按下(KEY.K) ) then
				self.movec = false
				self.att = true
				self:toupdate("x1")
				sondm(sondinit()[self.state][1])
				sondm(sondinit()[self.state][2])
			end
		end

		if self.lf >=4 and self.state=="x1" then
			if(引擎.按键按下(KEY.K) ) then
				self:toupdate("x2")
				sondm(sondinit()[self.state][1])
				sondm(sondinit()[self.state][2])
			end
		end
		if self.lf >=4 and self.state=="x2" then
			if(引擎.按键按下(KEY.K) ) then
				self:toupdate("x3")
				sondm(sondinit()[self.state][1])
				sondm(sondinit()[self.state][2])
			end
		end
end--

function gj:skxxxx()
	


	if self.state=="x33"  or self.state=="x22" or self.state=="x11" or self.state=="x44" then


		if self.state=="x22" and self.lf <=2 then

			self:s(3.6,false,false,true)
		end
		if self.state=="x33" and self.lf <=3 then
			self:s(4,false,false,true)
		end
		if self.state=="x44" and self.lf <=3 then
			self:s(4,false,false,true)
		end



		if self.b:dhz() == self:getlf() then
			self.dz[self.state][6]  = self.dz[self.state][6] +0.007

			if(self.dz[self.state][6] >0.2)then
				self.dz[self.state][6]= 0

				self:stateClr()
				self:toupdate("stop")

				elseif self.dz[self.state][6] <=0.2 then

					self.pause = true
					-- if self.state=="x44" then self:xorit( -(0.06 % self.orit) ) end
					-- if self.state=="x44" then self:s(-0.1,false) end
					self:zdhz(self.dz[self.state][3])
				end
			end
		end


		if(self.b:dhz() >=4 and self.state=="x11" ) then
			if(引擎.按键按下(KEY.H) ) then
				self:toupdate("x22")
				-- sondm(sondinit()[self.state][1])
				-- sondm(sondinit()[self.state][2])
				创建efskill("dat/efskill/common/" ,sks ,self.state,self.坐标.x,self.坐标.y,1,"me",self.orit 	 , 1)
				
			end
		end
		if(self.b:dhz() >=3 and self.state=="x22") then
			if(引擎.按键按下(KEY.H) ) then
				self:toupdate("x33")
				-- sondm(sondinit()[self.state][1])
				-- sondm(sondinit()[self.state][2])
				创建efskill("dat/efskill/common/" ,sks ,self.state,self.坐标.x,self.坐标.y,1,"me",self.orit 	 , 1)
				
			end
		end
		if(self.lf >= 3 and self.state=="x33") then
			if(引擎.按键按下(KEY.H) ) then
				self:toupdate("x44")
				-- sondm(sondinit()[self.state][1])
				-- sondm(sondinit()[self.state][2])
				创建efskill("dat/efskill/common/" ,sks ,self.state,self.坐标.x,self.坐标.y,1,"me",self.orit 	 , 1)


			end
		end


		if  self.state~="x11" and self.state~="x22" and self.state~="x33" and self.state~="x44" and self.skill==0  then
			if(引擎.按键按下(KEY.H) ) then
				self.movec = false
				self.att = true
				self:toupdate("x11")
				sondm(sondinit()[self.state][1])
				sondm(sondinit()[self.state][2])
				创建efskill("dat/efskill/common/" ,sks ,self.state,self.坐标.x,self.坐标.y,1,"me",self.orit 	 , 1)
				
			end
		end
end--


function gj:moonsk(_KEY)
	local key = _KEY

	if self.state=="moon1"  or self.state=="moon2" or self.state=="moon3"  then

		if self.state=="moon1" and self.lf <=1 then

			self:s(3.6,false,false)
			if skrun == 0 then
				创建efskill("dat/efskill/common/" ,sks ,self.state,self.坐标.x,self.坐标.y,1,"me",self.orit 	 , 1)
				skrun =1
			end

		end
		if self.state=="moon2" and self.lf <=2 then
			self:s(4,false,false)
			if skrun == 0 then
				创建efskill("dat/efskill/common/" ,sks ,self.state,self.坐标.x,self.坐标.y,1,"me",self.orit 	 , 1)
				skrun =1
			end
			
		end
		if self.state=="moon3" and self.lf <=2 then
			self:s(3,false,false)
			创建efskill("dat/efskill/common/" ,sks ,self.state,self.坐标.x,self.坐标.y,1,"me",self.orit 	 , 1)
		end



		if self.b:dhz() == self:getlf() then
			self.dz[self.state][6]  = self.dz[self.state][6] +0.007

			if(self.dz[self.state][6] >0.16)then

				self.dz[self.state][6]= 0


				self:stateClr()
				self:toupdate("stop")

				elseif self.dz[self.state][6] <=0.16 then

					self.pause = true
					-- if self.state=="x44" then self:xorit( -(0.06 % self.orit) ) end
					-- if self.state=="x44" then self:s(-0.1,false) end
					if self.state=="moon3" then 
						self:zdhz(self.dz[self.state][3]-1)
					else
						self:zdhz(self.dz[self.state][3])
					end
				end
			end
		end


		if(self.lf >=3 and self.state=="moon1") then
			if 引擎.按键按下(key)   then
				self:toupdate("moon2")
				skrun = 0
				-- sondm(sondinit()[self.state][1])
				-- sondm(sondinit()[self.state][2])
			end
		end
		if(self.lf >=3 and self.state=="moon2") then
			if 引擎.按键按下(key)  then
				self:toupdate("moon3")
				skrun = 0
				sondm(sondinit()[self.state][1])
				-- sondm(sondinit()[self.state][2])
			end
		end



		if  self.state~="moon1" and self.state~="moon2" and self.state~="moon3"  and self.skill==0  then
			if 引擎.按键按下(key)  then
				self.movec = false
				self.att = true
				self:toupdate("moon1")
				-- sondm(sondinit()[self.state][1])
				-- sondm(sondinit()[self.state][2])

			end
		end
end--

function gj:attack()

	if not self.attc then return end


	self:attxxx()
	self:skxxxx()
	self:moonsk(KEY.O)

end
function gj:sk()
	if not self.skillc then	return end


	self:singlsk("上挑" ,KEY.J,0.1,4,true)
	self:singlsk("冰波" ,KEY.P,0.04)
	if  self.att then return end


	self:鬼斩(KEY.M)
	self:邪光斩()
	self:singlsk("波动爆发" ,KEY.U,0.1)
	self:墓碑("墓碑" ,KEY.Y,0.1)

	self:singlsk("爆波" ,KEY.I,0.2)
	self:singlsk("地波" ,KEY.N,0.1)
end

function gj:singlsk(_state,_KEY,_ys,_s,可_xorit)

	local stat = _state
	if self.state==stat then
		if self.lf == 2 and skrun ==0    then
			创建efskill("dat/efskill/common/" ,sks ,self.state,self.坐标.x,self.坐标.y,1,"普通",self.orit 	 , 1)
			-- sondm(sondinit()[_state][1])
			-- sondm(sondinit()[_state][2])
			skrun = 1
		end



		if self.att then self.att = false end
		if 可_xorit ~=nil then
			if self.state==_state and self.lf <=1 then

				self:s(_s or 0,false,false,true)
			-- self:xorit(self* 4)
		end
	end


	if self.b:dhz() == self:getlf()-1 then
		self.dz[self.state][6]  = self.dz[self.state][6] +0.007

		if(self.dz[self.state][6] >_ys)then

			self.dz[self.state][6]= 0
			self:stateClr()
			self:toupdate("stop")

			elseif self.dz[self.state][6] <= _ys then

				self.pause = true

				self:zdhz(self.dz[self.state][3]-1)
			end
		end
	end
	if self.state~=_state and self.skill == 0 then
		if 引擎.按键按下( _KEY)  then
			self.skill = 1
			self.movec = false
			self:toupdate(_state)


		end
	end

end

function gj:墓碑(_state,_KEY,_ys,_s,可_xorit)

	local stat = _state
	if self.state==stat then
		-- if self.lf == 2 and skrun ==0    then
		-- 	for i=1,10 do
		-- 		引擎.置随机种子(引擎.取时间戳())
		-- 		创建efskill("dat/efskill/common/" ,sks ,self.state,self.坐标.x +引擎.取随机小数(-20,20) ,self.坐标.y+引擎.取随机小数(-20,20),1,"普通",self.orit 	 , 1)
		-- 	end
		-- 	-- sondm(sondinit()[_state][1])
		-- 	-- sondm(sondinit()[_state][2])
		-- 	skrun = 1
		-- end

		if self.state==stat then

			self.霸体 = true
			-- if self.lf ==  引擎.取随机整数(7,self:getlf()) and skrun ==0    then

				-- 墓碑time = 引擎.取游戏时间()

				-- for i=1, 2 do
					-- 创建efskill("dat/efskill/common/" ,sks ,self.state,self.坐标.x +引擎.取随机整数(-180,220) ,self.坐标.y+引擎.取随机整数(-250,60),1,"普通",self.orit 	 , 1) 
				-- end
				-- if 引擎.取游戏时间() -墓碑time  >= 0.1 then
				-- 	skrun = 1
				-- end
			-- end


			if self.lf ~= self.b:dhz()  then
				if skrun ~=self.lf  then
					-- 引擎.置随机种子(引擎.取时间戳())
					创建efskill("dat/efskill/common/" ,sks ,self.state,self.坐标.x +引擎.取随机小数(-180,230) ,self.坐标.y+引擎.取随机整数(-170,60),1,"普通",self.orit 	 , 1) 
					创建efskill("dat/efskill/common/" ,sks ,self.state,self.坐标.x +引擎.取随机小数(-180,230) ,self.坐标.y+引擎.取随机整数(-170,60),1,"普通",self.orit 	 , 1) 
				end
			end
		end



		if self.att then self.att = false end
		if 可_xorit ~=nil then
			if self.state==_state and self.lf <=1 then

				self:s(_s or 0,false,false,true)
			-- self:xorit(self* 4)
		end
	end


	if self.b:dhz() == self:getlf()-1 then
		self.dz[self.state][6]  = self.dz[self.state][6] +0.007 

		if(self.dz[self.state][6] >_ys)then

			self.dz[self.state][6]= 0
			-- 创建efskill("dat/efskill/common/" ,sks ,self.state,self.坐标.x +引擎.取随机整数(-180,220) ,self.坐标.y+引擎.取随机整数(-250,60),1,"普通",self.orit 	 , 1) 

			self.霸体 = false
			self:stateClr()
			self:toupdate("stop")


			elseif self.dz[self.state][6] <= _ys then

				self.pause = true
				self:zdhz(self.dz[self.state][3]-1)
			end
		end
	end
	if self.state~=_state and self.skill == 0 then
		if 引擎.按键按下( _KEY)  then
			self.skill = 1
			self.movec = false
			self:toupdate(_state)


		end
	end

end




function gj:格挡()


	if 引擎.按键按住(KEY.L) then

		if self.state ~="格挡1" and self.state ~="格挡2"  then

			self.档time = 引擎.取游戏时间()
			self.movec = false
			self.attc = false
			self.skillc = false

			self:toupdate("格挡1")
			sondm(sondinit()[self.state][1])	
		-- 		-- sondm(sondinit()[self.state][2])
	end

	if  引擎.取游戏时间() - self.档time >= 0.18 then
		self:toupdate("格挡2")
	end


end


if self.state == "格挡2" or self.state == "格挡1" then

	if 引擎.按键弹起(KEY.L) then 

		self:stateClr()
		self:toupdate("stop")
		

	end


	if (引擎.取游戏时间() - self.档time >= 4) then
		xgz2 = nil
		self:stateClr()
		self:toupdate("stop")
	end
end


end--


function gj:邪光斩()


	if 引擎.按键按住(KEY.B) then

		if self.state ~="邪光斩1" and self.state ~="邪光斩2"  and self.skill ==0  then

			self.邪光斩time = 引擎.取游戏时间()
			self.movec = false
			self.attc = false
			self.skill = 1

			self:toupdate("邪光斩1")
			-- sondm(sondinit()[self.state][1])	

		end
	end	


	-- if self.state=="邪光斩2" and self.lf >1 then--大小方向 
	-- 	local 内部spd = 7
	-- 	local 大小 = 0.8
	-- 	if 引擎.取游戏时间() - self.邪光斩time   >= 2 then
	-- 		大小 = 1.3
	-- 		内部spd = 10


	-- 	end
	-- 	if  skrun ==0 then
	-- 		xgz2 = 创建efskill("dat/efskill/common/" ,sks ,self.state,self.坐标.x + self.orit * 110,self.坐标.y+5,1,"普通",self.orit  * 大小 ,   大小 )
	-- 		skrun = 1
	-- 	end


	-- 	if xgz2 ~=nil then xgz2:xorit(xgz2.方向 * 内部spd) end

	-- end

	if self.state=="邪光斩2" and self.lf >1 then--大小方向
		local 内部spd = 6

		if 引擎.取游戏时间() - self.邪光斩time   >= 1 then

			内部spd = 11
			if  skrun ==0 then
				xgz2 = 创建efskill("dat/efskill/common/" ,sks ,"邪光斩2max",self.坐标.x + self.orit * 50,self.坐标.y ,1,"普通",self.orit  * 1 ,   1 )
				skrun = 1

			end

		else

			if  skrun ==0 then
				xgz2 = 创建efskill("dat/efskill/common/" ,sks ,self.state,self.坐标.x + self.orit * 70,self.坐标.y ,1,"普通",self.orit  * 1 ,   1 )
				skrun = 1
			end


		end



		if xgz2 ~=nil then xgz2:xorit(xgz2.方向 * 内部spd) end

	end












	if not 引擎.按键按住(KEY.B) and self.state=="邪光斩1" then

		if (引擎.取游戏时间() - self.邪光斩time ) >= 0.38 then
			if self.state ~= "邪光斩2" then self:toupdate("邪光斩2") end
			sondm(sondinit()[self.state][1])	

		end


	end--




	if self.state=="邪光斩2"  and self.b:dhz() ==self:getlf() then

		self.dz["邪光斩2"][6]  = self.dz["邪光斩2"][6] +0.007
		if(self.dz[self.state][6] >0.2)then

			self.dz[self.state][6]= 0
			self:stateClr()
			xgz2= nil
			self:toupdate("stop")

			elseif self.dz[self.state][6] <=0.2 then

				self.pause = true
				self:zdhz(self.dz["邪光斩2"][3])
			end
		end


end--



function gj:鬼斩(_key)
	

	local keyss = _key

	if 引擎.按键按住(keyss) then

		if self.state ~="鬼斩1" and self.state ~="鬼斩2" and self.state ~="鬼斩3" and self.skill ==0 then
			self.鬼斩time = 引擎.取游戏时间()
			self.movec = false
			self.attc = false
			self.skill = 1

			self:toupdate("鬼斩1")
			-- sondm(sondinit()[self.state][1])	
		end
	end	

	if self.state=="鬼斩2" then
		if self.lf ==2 and skrun ==0 then 
			创建efskill("dat/efskill/common/" ,sks ,self.state,self.坐标.x,self.坐标.y,1,"me",self.orit 	 , 1)
			skrun =1
		end
	end

	if self.state=="鬼斩3" then
		if self.lf ==2 and skrun ==0 then 
			创建efskill("dat/efskill/common/" ,sks ,self.state,self.坐标.x,self.坐标.y,1,"me",self.orit 	 , 1)
			skrun = 1
		end
	end


	if not 引擎.按键按住(keyss) and self.state=="鬼斩1" then
		if self.state ~= "鬼斩2" then
			self:toupdate("鬼斩2") 

		end
			-- sondm(sondinit()[self.state][1])	
	end--


	if self.state=="鬼斩3" and self.lf <4 and self.b:dhz() >0 then self:xorit(self.orit * 20)   end

	if self.state =="鬼斩1" or self.state =="鬼斩2" or self.state =="鬼斩3" then
		if self.state~="鬼斩1" and self.b:dhz() ==self:getlf() then

			self.dz[self.state][6]  = self.dz[self.state][6] +0.007
			if(self.dz[self.state][6] >0.2)then



				self.dz[self.state][6]= 0
				self:stateClr()
				self.鬼斩time  = nil


				self:toupdate("stop")

				elseif self.dz[self.state][6] <=0.2 then
					if self.state=="鬼斩2"  and  (引擎.取游戏时间() - self.鬼斩time > 1.7 ) then 
						skrun = 0
						self:toupdate("鬼斩3")
						return 
					end
					self.pause = true
					self:zdhz(self.dz[self.state][3])
				end

			end
		end
end--

function gj:jumplogic()
	-- body
	if 引擎.按键按住(KEY.SPACE) then
		self.movec = false
		self:xorit(60 * self.orit)
		self:stateClr()
		self:toupdate("jump1")
	end

	if 引擎.按键弹起(KEY.SPACE) then
		self.movec = true
	end

end

function gj:stateClr()
	skrun = 0

	self.attc = true
	self.skillc = true
	self.skill = 0
	self.att = false
	self.movec = true
end
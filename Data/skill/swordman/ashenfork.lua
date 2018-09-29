return {--[[ #PVF_File --]]
		["[name]"]="银光落刃",
		
		["[explain]"]="    跳跃状态中向下方敌人发出强力刺击； 跳跃的高度越高， 攻击力就越强。 若达到一",
		
		["[basic explain]"]="    跳跃状态中向下方敌人发出强力刺击， 可以出现冲击波。",
		
		["[caption]"]="",
		
		["[skill explain icon]"]={2,4,8,},
		
		["[purchase cost]"]={15,},
		
		["[required level]"]=5,
		
		["[required level range]"]=2,
		
		["[type]"]="[active]",
		
		["[skill class]"]=1,
		
		["[maximum level]"]=60,
		
		["[growtype maximum level]"]={50,50,50,50,50,50},
		
		["[skill fitness growtype]"]={0,1,2,3,4,},
		
		["[durability decrease rate]"]=20,
		
		["[icon]"]={"Character/Swordman/Effect/SkillIcon.img",12,"Character/Swordman/Effect/SkillIcon.img",13},
		
		["[weapon effect type]"]="[physical]",
		
		["[command]"]={'SKILL'},
		
		["[command key explain]"]="操作指令 : (跳跃状态下) Z",
		
		["[command customizing]"]=0,
		
		["[dungeon]"]={ 
		
			["[consume MP]"]={10,120},
		
			["[cool time]"]={4000,4000},
		
			["[static data]"]={50,10,50,100,23,3,60,75,},
		
			["[level info]"]={5,
			204,204,100,561,120,
			229,229,102,617,122,
			254,254,103,673,124,
			278,278,105,727,126,
			304,304,107,783,128,
			329,329,109,838,131,
			},
		
			["[special level up]"]={3,3,"-",8,-1,0,"%",8,-1,1,"%",8,-1,3,"%",8,},
		},
		
		["[pvp]"]={
			
			["[static data]"]={50,10,50,75,23,3,60,75,},
	
			["[cool time]"]={5000,5000},
	
			["[level info]"]={5,
			40,40,89,50,93,
			45,45,90,56,95,
			51,51,91,64,96,
			56,56,92,70,97,
			61,61,93,76,98,
			},
		},
	
		["[death tower]"]={ },

		["[warroom]"]={ },

		["[level property]"]={1,99,"物理攻击力 : <int>%%,冲击波物理攻击力 : <int>,冲击波大小比率 : <int>%%,佩戴巨剑时附加攻击力 : [银光落刃]攻击力<int>%%,佩戴巨剑时附加攻击的攻击次数上限 : <int>,佩戴钝器时刺击攻击力减少率 : <int>%%,佩戴钝器时冲击波攻击力 : <int>%%,佩戴钝器时冲击波大小增加比率 : <int>%%",-1,0,1.00,-2,1,1.00,-1,2,1.00,4,4,1.00,5,5,1.00,7,7,1.00,-1,3,1.00,-1,4,1.00,},

		["[skill preloading image]"]={"Character/Swordman/Effect/JumpAttackHold.img",},

		["[feature skill index]"]=153,
}

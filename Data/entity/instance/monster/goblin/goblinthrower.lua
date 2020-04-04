return {--[[ #PVF_File ]]

	["[name]"]="投掷哥布林",

	["[face image]"]={"Monster/MonsterFace.img",4},

	["[die effect]"]={0,1,0},

	["[width]"]={40,10},

	["[category]"]={"[human]","[goblin]","[range combat]","[close-passive]",},

	["[ambient sound]"]="",

	["[attack sound]"]="",

	["[appear sound]"]="",

	["[damage sound]"]="",

	["[die sound]"]="",

	["[ability category]"]={
		"[HP MAX]","*",100,
		"[EQUIPMENT_PHYSICAL_ATTACK]","*",75,
		"[EQUIPMENT_PHYSICAL_DEFENSE]","*",100,
		"[EQUIPMENT_MAGICAL_ATTACK]","*",80,
		"[EQUIPMENT_MAGICAL_DEFENSE]","*",100,
	},

	["[level]"]={6,6},

	["[move speed]"]={350,350},

	["[attack speed]"]={300,300},

	["[cast speed]"]={690,690},

	["[hit recovery]"]={500,500},

	["[weight]"]={45000,45000},

	["[sight]"]=300,

	["[targeting nearest]"]=1,

	["[warlike]"]=30,

	["[attack delay]"]=3000,

	["[stuckbonus on damage]"]={0,0,0,0},

	["[item]"]={1000,50,1047,200,1004,100,},

	["[attack kind]"]={15.00,2.00,1.00,1,300,0,0,0,15,0,15,0,},

	["[waiting motion]"]="Animation_Thrower/Stay.ani",

	["[move motion]"]="Animation_Thrower/Move.ani",

	["[sit motion]"]="Animation_Thrower/Sit.ani",

	["[damage motion 1]"]="Animation_Thrower/Damage1.ani",

	["[damage motion 2]"]="Animation_Thrower/Damage2.ani",

	["[down motion]"]="Animation_Thrower/Down.ani",

	["[overturn motion]"]="Animation_Thrower/Overturn.ani",

	["[attack motion]"]={"Animation_Thrower/Throw.ani",},

	["[attack info]"]={"",},

	["[speech on situation]"]={"[on revenge]","有人砸场子啦！！",0,"[on revenge]","兄弟们抄家伙啊！",0,"[on etc]","哼！好哥布林不吃眼前亏！",0,"[on etc]","只剩下我了？撤！ ",0,},

	["[throw attack]"]={"[attack index]",0,"[passive object number]",1,"[passive object filename]","Particle/ThrowStone.ptl","[object type]",1,"[passive object index]",30001,"[power]",0,"[throw frame]",2,"[passive object start x cood]",20,"[passive object start y cood]",0,"[passive object start z cood]",60,"[attack number]",1,"[throw sound]","THROW_STONE",},

	["[equipment]"]={4,"Monster/Goblin/tcc2.equ","Monster/Goblin/acc2.equ","Monster/Goblin/hcc3.equ","Monster/Goblin/gcc1.equ",},

	["[destination change term]"]=1000,

	["[ai pattern]"]={ 

		["[normal]"]={"ai/Event.ai","ai/DestinationSelect.ai","ai/Action.ai","ai/MoveMethod.ai",},

		["[expert]"]={"ai/Event.ai","ai/DestinationSelect.ai","ai/Action.ai","ai/MoveMethod.ai",},

		["[master]"]={"ai/Event.ai","ai/DestinationSelect.ai","ai/Action.ai","ai/MoveMethod.ai",},

		["[king]"]={"ai/Event.ai","ai/DestinationSelect.ai","ai/Action.ai","ai/MoveMethod.ai",},

		["[slayer]"]={"ai/Event.ai","ai/DestinationSelect.ai","ai/Action.ai","ai/MoveMethod.ai",},
	},

	["[hp regen rate]"]=0.00,0.00,
}
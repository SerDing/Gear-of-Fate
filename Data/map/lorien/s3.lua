return {--[[ #PVF_File ]]

	["[player number]"]={2,8},

	["[pvp start area]"]={0,0,0,0,0,0,0,0,0,0,0,0},

	["[dungeon]"]={10001,},

	["[type]"]="[normal]",

	["[greed]"]="EE EE",

	["[tile]"]={"Tile/ForestOver.til","Tile/ForestOver.til","Tile/ForestOverUnder.til","Tile/ForestUnderOver.til","Tile/ForestOver.til",},

	["[far sight scroll]"]=56,

	["[middle sight scroll]"]=90,

	["[near sight scroll]"]=110,

	["[background animation]"]={ 

		["[ani info]"]={ 

			["[filename]"]="Animation/far1.ani",

			["[layer]"]="[distantback]",

			["[order]"]="[below]",
		},

		["[ani info2]"]={ 

			["[filename]"]="Animation/mid1.ani",

			["[layer]"]="[middleback]",

			["[order]"]="[below]",
		},
	},

	["[pathgate pos]"]={
		15,233,
		1105,226,
		608,168,
		560,348
	},

	["[virtual movable area]"] = {15 + 20, 233 - 80, 1105 - 40, 226 - 20},

	["[dungeon start area]"]={775,314,119,50},

	["[sound]"]={"AMB_FOREST_01", "M_VILMARK_BOSS",}, -- M_FOREST_01_NEW  M_VILMARK_BOSS

	["[animation]"]={
		"Animation/BurntTree4.ani","[close]",896,454,0,
		"Animation/Flower2.ani","[normal]",739,219,0,
		"Animation/Flower1.ani","[normal]",463,189,0,
		"Animation/BurntTree2.ani","[normal]",713,167,0,
		"Animation/Flower0.ani","[normal]",151,143,0,
		"Animation/Flower1.ani","[normal]",484,141,0,
		"Animation/BurntTree5.ani","[normal]",227,139,0,
		"Animation/Tree3.ani","[closeback]",802,149,0,
		"Animation/Tree0.ani","[closeback]",401,138,0,
		"Animation/smallTree1.ani","[closeback]",574,137,0,
		"Animation/smallTree0.ani","[closeback]",908,126,0,
	},

	["[passive object]"]={
		5,150,150,0,
		6,330,230,500,
		5,650,190,0,
		6,830,270,500,
		5,1150,170,0,
		6,1330,250,500,
		273,513,194,0,
		273,669,289,0,
	},

	["[monster]"]={
		1,1,0,372,184,0,1,1,"[fixed]","[normal]",
		-- 1,1,0,300,221,0,1,1,"[fixed]","[normal]",
		-- 1,1,0,241,328,0,1,1,"[fixed]","[normal]",
		-- 1,1,0,496,330,0,1,1,"[fixed]","[normal]",



		-- 1,1,0,372,184,0,1,1,"[fixed]","[normal]",
		-- 1,1,0,300,221,0,1,1,"[fixed]","[normal]",
		-- 1,1,0,241,328,0,1,1,"[fixed]","[normal]",
		-- 1,1,0,496,330,0,1,1,"[fixed]","[normal]",

		-- 1,1,0,372,184,0,1,1,"[fixed]","[normal]",
		-- 1,1,0,300,221,0,1,1,"[fixed]","[normal]",
		-- 1,1,0,241,328,0,1,1,"[fixed]","[normal]",
		-- 1,1,0,496,330,0,1,1,"[fixed]","[normal]",

		-- 1,1,0,372,184,0,1,1,"[fixed]","[normal]",
		-- 1,1,0,300,221,0,1,1,"[fixed]","[normal]",
		-- 1,1,0,241,328,0,1,1,"[fixed]","[normal]",
		-- 1,1,0,496,330,0,1,1,"[fixed]","[normal]",

		-- 1,1,0,372,184,0,1,1,"[fixed]","[normal]",
		-- 1,1,0,300,221,0,1,1,"[fixed]","[normal]",
		-- 1,1,0,241,328,0,1,1,"[fixed]","[normal]",
		-- 1,1,0,496,330,0,1,1,"[fixed]","[normal]",

		-- 1,1,0,372,184,0,1,1,"[fixed]","[normal]",
		-- 1,1,0,300,221,0,1,1,"[fixed]","[normal]",
		-- 1,1,0,241,328,0,1,1,"[fixed]","[normal]",
		-- 1,1,0,496,330,0,1,1,"[fixed]","[normal]",
	},

	["[monster specific AI]"]={"[normal]","[normal]","[normal]","[normal]",},

	["[event monster position]"]={428,214,0,332,317,0,319,259,0,411,293,0,},

	["[map name]"]="PVP无名",
}
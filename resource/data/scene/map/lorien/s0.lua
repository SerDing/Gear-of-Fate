return {--[[ #PVF_File ]]

	["[player number]"]={2,8},

	["[pvp start area]"]={0,0,0,0,0,0,0,0,0,0,0,0},

	["[dungeon]"]={10001,},

	["[type]"]="[normal]",

	["[greed]"]="BB BB",

	["[tile]"]={
		"Tile/ForestOver.til",
		"Tile/ForestOver.til",
		"Tile/ForestOver.til",
		"Tile/ForestOver.til",
		"Tile/ForestOver.til",
	},

	["[far sight scroll]"]=56,

	["[middle sight scroll]"]=90,

	["[near sight scroll]"]=110,

	["[background animation]"]={ 

		["[ani info]"]={

			["[filename]"]="animation/far1.ani",

			["[layer]"]="[distantback]",

			["[order]"]="[below]",},

		["[ani info2]"]={

			["[filename]"]="animation/mid1.ani",

			["[layer]"]="[middleback]",

			["[order]"]="[below]",
		},
	},

	["[pathgate pos]"]={16,216,1106,216,612,145,560,348},

	["[virtual movable area]"] = {15 + 20, 233 - 80, 1105 - 40, 226 - 20},

	["[dungeon start area]"]={210,308,104,45},

	["[sound]"]={"AMB_FOREST_01","M_FOREST_01_NEW",},

	["[animation]"]={
		"animation/smallTree0.ani","[close]",836,466,0,
		"animation/Flower1.ani","[normal]",500,287,0,
		"animation/Flower0.ani","[normal]",424,275,0,
		"animation/Flower1.ani","[normal]",977,213,0,
		"animation/Flower0.ani","[normal]",445,211,0,
		"animation/Flower2.ani","[normal]",836,210,0,
		"animation/Flower2.ani","[normal]",656,208,0,
		"animation/Flower2.ani","[normal]",903,204,0,
		"animation/Flower1.ani","[normal]",805,182,0,
		"animation/Flower1.ani","[bottom]",526,247,0,
		"animation/smallTree0.ani","[closeback]",361,123,0,
		"animation/smallTree1.ani","[closeback]",1278,131,0,
		"animation/Tree2.ani","[closeback]",476,135,0,
	},

	["[passive object]"]={
		5,150,150,0,
		6,330,230,500,
		5,650,190,0,
		6,830,270,500,
		5,1150,170,0,
		6,1330,250,500,
	},

	["[monster]"]={
		1,1,0,535,180,0,1,1,"[fixed]","[normal]",
		1,1,0,695,248,0,1,1,"[fixed]","[normal]",
		1,1,0,582,302,0,1,1,"[fixed]","[normal]",
	},

	["[monster specific AI]"]={"[normal]","[normal]","[normal]",},

	["[event monster position]"]={682,288,0,597,201,0,502,250,0,763,270,0,},

	["[map name]"]="PVP无名",
}
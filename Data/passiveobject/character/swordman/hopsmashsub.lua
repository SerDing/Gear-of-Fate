return {--[[ #PVF_File --]]
	
	["[name]"]="崩山击",
	
	["[floating height]"]=1,

	["[layer]"]="[normal]",

	["[pass type]"]="[pass all]",

	["[piercing power]"]=1000,

	["[basic motion]"]="Animation/HopSmashSubFront1.ani",
	
	["[etc motion]"]={
		"Animation/HopSmashSubBack1.ani", 
		"Animation/HopSmashSubBack2.ani"
	},

	["[attack info]"]="AttackInfo/HopSmashSub.atk",

	["[add object effect]"]={"Animation/HopSmashSubFront2.ani", 1, 0, 0},
	
	["[object destroy condition]"]={"[destroy condition]","[on end of animation]"},
}
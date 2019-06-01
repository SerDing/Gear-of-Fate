return {--[[ #PVF_File --]]
	
	["[name]"]="崩山击",
	
	["[floating height]"]=1,

	["[layer]"]="[normal]",

	["[pass type]"]="[pass all]",

	["[piercing power]"]=1000,

	["[basic motion]"]="Animation/HopSmashSubFront1_tn.ani",
	
	["[etc motion]"]={
		"Animation/HopSmashSubBack1_tn.ani", 
		"Animation/HopSmashSubBack2_tn.ani"
	},

	["[attack info]"]="AttackInfo/HopSmashSub.atk",

	["[add object effect]"]={"Animation/HopSmashSubFront2_tn.ani", 1, 0, 0},
	
	["[object destroy condition]"]={"[destroy condition]","[on end of animation]"},
}
return {--[[ #PVF_File --]]
	["[name]"]="银光落刃的飞溅",

	["[floating height]"]=1,

	["[layer]"]="[bottom]",

	["[pass type]"]="[pass all]",

	["[piercing power]"] = 1000,

	["[basic motion]"]="Animation/AshenForkSub.ani",

	["[etc motion]"]={
		"Animation/AshenForkSubDust.ani", 
		"Animation/AshenForkSubFlash.ani"
	},
	
	["[attack info]"]="AttackInfo/AshenForkSub.atk",

	["[object destroy condition]"]={"[destroy condition]","[on end of animation]",},
}
return {--[[ #PVF_File --]]
	["[name]"]="十字斩",
	
	["[floating height]"]=1,
	
	["[layer]"]="[normal]",
	
	["[pass type]"]="[pass all]",
	
	["[piercing power]"]=1000,
	
	["[basic motion]"]="Animation/GoreCross1.ani",
	
	["[attack info]"]="AttackInfo/GoreCross.atk",
	
	["[add object effect]"] = {"Animation/GoreCross2.ani", -1, 0, 1},
	
	["[object destroy condition]"]={"[destroy condition]","[on end of animation]",},
	
	-- ["[etc motion]"]={
	-- 	"Animation/GoreCross3.ani",
	-- 	"Animation/GoreCross4.ani",
	-- },
	
	["[etc attack info]"]={"AttackInfo/GoreCrossAdd.atk",},
}
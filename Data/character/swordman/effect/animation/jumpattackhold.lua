return {--[[ #PVF_File --]]
	["[SHADOW]"]=0,
	["[FRAME MAX]"]=2,
	["[FRAME000]"]={
		["[IMAGE]"]={"Character/Swordman/Effect/JumpAttackHold.img",0},
		["[IMAGE POS]"]={-145, -221},
		["[IMAGE RATE]"]={1.30, 1.30},
		["[INTERPOLATION]"]=1, -- 窜改; 添写，插补 插值
		["[RGBA]"]={255, 255, 255, 150},
		['[PLAY SOUND]'] = "SKYRADE_SWING",
		["[GRAPHIC EFFECT]"]="LINEARDODGE",
		["[DELAY]"]=200,
	},
	["[FRAME001]"]={
		["[IMAGE]"]={"Character/Swordman/Effect/JumpAttackHold.img",0},
		["[IMAGE POS]"]={-145, -221},
		["[IMAGE RATE]"]={1.30, 1.30},
		["[RGBA]"]={255, 255, 255, 0}, -- 透明
		["[DELAY]"]=200,
		["[GRAPHIC EFFECT]"]="LINEARDODGE",
	}
}
return {--[[ #PVF_File --]]
		["[name]"]="崩山击",
		["[explain]"]="    向前低跃并用武器砸击地面， 有多段攻击判定， 最",
		["[basic explain]"]="    向前低跃并用武器砸击地面， 有多段攻击判定， 最",
		["[caption]"]="    一",
		["[skill explain icon]"]={1,2,4,7,8,},
		["[purchase cost]"]={15,},
		["[required level]"]=10,
		["[required level range]"]=2,
		["[type]"]="[active]",
		["[skill class]"]=2,
		["[maximum level]"]=60,
		["[growtype maximum level]"]={50,50,50,50,50,50},
		["[skill fitness growtype]"]={0,1,2,3,4,},
		["[durability decrease rate]"]=15,
		["[icon]"]={"Character/Swordman/Effect/SkillIcon.img",154,"Character/Swordman/Effect/SkillIcon.img",155},
		["[weapon effect type]"]="[physical]",
		["[command]"]={"RIGHT", ",", "DOWN", ",", "SKILL"},
		["[command key explain]"]="操作指令 : →↓ + Z",
		["[skill command advantage]"]={10,20},
		
		["[dungeon]"]={ 
			["[consume MP]"]={17,150},
			["[cool time]"]={4000,4000},
			["[static data]"]={
				30, 200, 50, 200, 50, 120, 150, 100, 2, 3, 500,
			},
			["[level info]"]={8,125,225,200,12,10000,45,250,375,140,252,232,14,10000,50,254,381,156,281,263,16,10000,56,257,386,171,308,295,18,10000,61,261,392,186,335,326,20,10000,67,265,397,202,364,358,22,10000,72,269,403,217,391,389,24,10000,79,272,408,232,418,421,26,10000,84,276,414,247,445,453,28,10000,89,280,419,263,473,484,30,10000,95,283,425,278,500,516,32,10000,100,287,431,293,527,547,34,10000,106,291,436,309,556,579,36,10000,111,294,442,324,583,611,38,10000,117,298,447,339,610,642,40,10000,122,302,453,355,639,674,42,10000,127,306,458,370,666,705,44,10000,133,309,464,385,693,737,46,10000,138,313,469,401,722,768,48,10000,145,317,475,416,749,800,50,10000,150,320,481,431,776,832,52,10000,155,324,486,446,803,863,54,10000,161,328,492,462,832,895,56,10000,166,331,497,477,859,926,58,10000,171,335,503,492,886,958,60,10000,176,339,508,508,914,989,62,10000,182,343,514,523,941,1021,64,10000,187,346,519,538,968,1053,66,10000,193,350,525,554,997,1084,68,10000,198,354,531,569,1024,1116,70,10000,205,357,536,584,1051,1147,72,10000,210,361,542,599,1078,1179,74,10000,215,365,547,615,1107,1211,76,10000,221,369,553,630,1134,1242,78,10000,226,372,558,645,1161,1274,80,10000,232,376,564,661,1190,1305,82,10000,237,380,569,676,1217,1337,84,10000,243,383,575,691,1244,1368,86,10000,248,387,581,707,1273,1400,88,10000,253,391,586,722,1300,1432,90,10000,259,394,592,737,1327,1463,92,10000,264,398,597,753,1355,1495,94,10000,271,402,603,768,1382,1526,96,10000,276,406,608,783,1409,1558,98,10000,282,409,614,798,1436,1589,100,10000,287,413,619,814,1465,1621,102,10000,292,417,625,829,1492,1653,104,10000,297,420,631,844,1519,1684,106,10000,303,424,636,860,1548,1716,108,10000,308,428,642,875,1575,1747,110,10000,313,431,647,890,1602,1779,112,10000,319,435,653,906,1631,1810,114,10000,324,439,658,921,1658,1842,116,10000,330,443,664,936,1685,1874,118,10000,335,446,669,952,1714,1905,120,10000,341,450,675,967,1741,1937,122,10000,347,454,681,982,1768,1968,124,10000,352,457,686,997,1795,2000,126,10000,358,461,692,1013,1823,2032,128,10000,363,465,697,1028,1850,2063,130,10000,369,468,703,1043,1877,2095,132,10000,374,472,708,1059,1906,2126,134,10000,380,476,714,1074,1933,2158,136,10000,385,480,719,1089,1960,2189,138,10000,391,483,725,1105,1989,2221,140,10000,396,487,731,1120,2016,2253,142,10000,402,491,736,1135,2043,2284,144,10000,407,494,742,1151,2072,2316,146,10000,413,498,747,1166,2099,2347,148,10000,418,502,753,1181,2126,2379,150,10000,424,506,758,},
			["[special level up]"]={4,4,"+",6,5,5,"+",6,-1,0,"%",8,-1,1,"%",8,-1,4,"%",10,-1,6,"%",4,-1,7,"%",4,},
		},
		
		["[pvp]"]={ 
			["[cool time]"]={6000,6000},
			["[static data]"]={30,200,50,200,50,120,150,100,2,3,0,},
			["[level info]"]={8,25,23,200,12,10000,18,220,330,28,25,232,14,10000,20,222,334,31,28,263,16,10000,22,224,338,34,31,295,18,10000,24,227,342,37,33,326,20,10000,27,229,345,40,36,358,22,10000,29,231,350,43,39,389,24,10000,32,233,353,46,42,421,26,10000,34,235,358,49,44,453,28,10000,36,238,361,53,47,484,30,10000,38,240,365,56,50,516,32,10000,40,242,369,59,53,547,34,10000,42,244,373,62,56,579,36,10000,44,246,376,65,58,611,38,10000,47,249,381,68,61,642,40,10000,49,251,384,71,64,674,42,10000,51,253,388,74,67,705,44,10000,53,255,392,77,69,737,46,10000,55,257,396,80,72,768,48,10000,58,260,399,83,75,800,50,10000,60,262,404,86,78,832,52,10000,62,264,407,89,80,863,54,10000,64,266,411,92,83,895,56,10000,66,268,415,95,86,926,58,10000,68,271,419,98,89,958,60,10000,70,273,422,102,91,989,62,10000,73,275,427,105,94,1021,64,10000,75,277,430,108,97,1053,66,10000,77,279,435,111,100,1084,68,10000,79,282,438,114,102,1116,70,10000,82,284,442,117,105,1147,72,10000,84,286,446,120,108,1179,74,10000,86,288,450,123,111,1211,76,10000,88,290,453,126,113,1242,78,10000,90,293,458,129,116,1274,80,10000,93,295,461,132,119,1305,82,10000,95,297,465,135,122,1337,84,10000,97,299,469,138,124,1368,86,10000,99,301,473,141,127,1400,88,10000,101,304,476,144,130,1432,90,10000,104,306,481,147,133,1463,92,10000,106,308,484,151,136,1495,94,10000,108,310,488,154,138,1526,96,10000,110,312,492,157,141,1558,98,10000,113,315,496,160,144,1589,100,10000,115,317,499,163,147,1621,102,10000,117,319,504,166,149,1653,104,10000,119,321,507,169,152,1684,106,10000,121,323,512,172,155,1716,108,10000,123,326,515,175,158,1747,110,10000,125,328,519,178,160,1779,112,10000,128,330,523,181,163,1810,114,10000,130,332,527,184,166,1842,116,10000,132,334,530,187,168,1874,118,10000,134,337,535,190,171,1905,120,10000,136,339,538,193,174,1937,122,10000,139,341,542,196,177,1968,124,10000,141,343,546,199,179,2000,126,10000,143,345,550,203,182,2032,128,10000,145,348,553,206,185,2063,130,10000,148,350,558,209,188,2095,132,10000,150,352,561,212,191,2126,134,10000,152,354,565,215,193,2158,136,10000,154,356,569,218,196,2189,138,10000,156,359,573,221,199,2221,140,10000,158,361,576,224,202,2253,142,10000,161,363,581,227,204,2284,144,10000,163,365,584,230,207,2316,146,10000,165,367,589,233,210,2347,148,10000,167,370,592,236,213,2379,150,10000,170,372,596,},
		},

		["[death tower]"]={ },
		["[warroom]"]={ },
		["[level property]"]={
			1,99,"物理攻击力 : <int>%%,多段攻击次数 : <int>~<int>次,    已学[血气旺盛]时,冲击波物理攻击力 : <int>,出血几率 : <float1>%%； 出血Lv : Lv<int>； 出血持续时间 : <float1>秒； 出血攻击力 : <int>,冲击波范围 : <int>~<int>px",-1,0,1.00,8,8,1.00,9,9,1.00,-2,1,1.00,-1,2,0.10,-1,3,1.00,-1,4,0.00,-4,5,1.00,-1,6,1.00,-1,7,1.00,},
		["[skill preloading image]"]={ },
		["[feature skill index]"]=157,
}
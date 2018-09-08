return {--[[ #PVF_File --]]
		["[name]"]="三段斩",
		["[basic explain]"]="    滑动的同时向前方敌人发出3连斩攻击。",
		["[explain]"]="    滑动的同时向前方敌人发出3连斩攻击， 中断或结束连斩后开",
		["[caption]"]="",
		["[skill explain icon]"]={2,4,7,8,},
		["[purchase cost]"]={15,},
		["[required level]"]=15,
		["[required level range]"]=2,
		["[type]"]="[active]",
		["[skill class]"]=1,
		["[maximum level]"]=60,
		["[growtype maximum level]"]={50,50,50,50,50,50},
		["[skill fitness growtype]"]={0,1,2,3,4,},
		["[durability decrease rate]"]=0,
		["[auto cooltime apply]"]=0,
		["[weapon effect type]"]="[physical]",
		["[icon]"]={"Character/Swordman/Effect/SkillIcon.img",18,"Character/Swordman/Effect/SkillIcon.img",19},
		["[command]"]={{5=""},{7=""},{5=""},},
		["[command key explain]"]="操作指令 : →(按住状态下) + Z",
		["[dungeon]"]={ 
		["[consume MP]"]={12,120},
		["[cool time]"]={6000,6000},
		["[static data]"]={600,-1000,},
		["[level info]"]={6,158,198,198,47,138,158,177,266,266,53,186,212,197,296,296,59,207,236,216,324,324,65,227,259,235,353,353,71,247,282,253,380,380,76,266,304,274,411,411,82,288,329,292,438,438,88,307,350,311,467,467,93,327,373,330,495,495,99,347,396,350,525,525,105,368,420,369,554,554,111,387,443,387,581,581,116,406,464,408,612,612,122,428,490,426,639,639,128,447,511,445,668,668,134,467,534,464,696,696,139,487,557,484,726,726,145,508,581,503,755,755,151,528,604,521,782,782,156,547,625,541,812,812,162,568,649,560,840,840,168,588,672,579,869,869,174,608,695,598,897,897,179,628,718,618,927,927,185,649,742,636,954,954,191,668,763,655,983,983,197,688,786,674,1011,1011,202,708,809,694,1041,1041,208,729,833,713,1070,1070,214,749,856,732,1098,1098,220,769,878,752,1128,1128,226,790,902,770,1155,1155,231,809,924,789,1184,1184,237,828,947,808,1212,1212,242,848,970,828,1242,1242,248,869,994,847,1271,1271,254,889,1016,865,1298,1298,260,908,1038,884,1326,1326,265,928,1061,904,1356,1356,271,949,1085,923,1385,1385,277,969,1108,942,1413,1413,283,989,1130,962,1443,1443,289,1010,1154,981,1472,1472,294,1030,1177,999,1499,1499,300,1049,1199,1018,1527,1527,305,1069,1222,1038,1557,1557,311,1090,1246,1057,1586,1586,317,1110,1268,1076,1614,1614,323,1130,1291,1096,1644,1644,329,1151,1315,1114,1671,1671,334,1170,1337,1133,1700,1700,340,1190,1360,1153,1729,1729,346,1210,1383,1172,1758,1758,352,1230,1406,1191,1786,1786,357,1250,1429,1210,1815,1815,363,1270,1452,1229,1844,1844,369,1290,1475,1248,1872,1872,374,1311,1498,1267,1901,1901,380,1331,1521,1286,1930,1930,386,1351,1544,1306,1958,1958,392,1371,1567,1325,1987,1987,397,1391,1590,1344,2016,2016,403,1411,1612,1363,2044,2044,409,1431,1635,1382,2073,2073,415,1451,1658,1401,2102,2102,420,1471,1681,1420,2130,2130,426,1491,1704,1439,2159,2159,432,1511,1727,1458,2188,2188,438,1531,1750,1478,2216,2216,443,1551,1773,},
		["[feature skill level info]"]={6,134,168,168,40,118,134,150,226,226,45,158,181,167,251,251,50,176,201,184,275,275,55,193,220,200,300,300,60,210,240,215,323,323,65,226,258,233,349,349,70,245,279,248,372,372,74,261,298,264,397,397,79,278,317,281,421,421,84,295,337,298,446,446,89,312,357,314,470,470,94,329,376,329,493,493,99,345,395,347,520,520,104,364,416,362,543,543,109,380,435,378,567,567,113,397,454,394,592,592,118,414,473,411,617,617,123,432,494,428,641,641,128,449,513,443,664,664,133,465,531,460,690,690,138,483,552,476,714,714,143,500,571,492,738,738,148,517,591,508,762,762,152,534,610,525,788,788,158,552,630,541,811,811,162,568,649,557,835,835,167,585,668,573,859,859,172,602,687,590,885,885,177,619,708,606,909,909,182,636,727,622,933,933,187,653,747,639,959,959,192,671,767,655,982,982,196,687,785,671,1006,1006,201,704,805,687,1030,1030,206,721,824,704,1056,1056,211,739,845,720,1080,1080,216,756,864,735,1103,1103,221,772,882,751,1127,1127,225,789,902,768,1153,1153,231,807,922,785,1177,1177,235,824,941,801,1201,1201,240,841,961,818,1227,1227,245,859,981,834,1251,1251,250,876,1001,849,1274,1274,255,892,1019,865,1298,1298,260,909,1038,882,1323,1323,265,926,1059,898,1348,1348,270,943,1078,915,1372,1372,274,960,1098,932,1397,1397,279,978,1118,947,1421,1421,284,995,1137,963,1445,1445,289,1012,1156,980,1470,1470,294,1029,1176,996,1494,1494,299,1046,1195,1012,1518,1518,304,1063,1215,1028,1543,1543,309,1080,1234,1045,1567,1567,313,1097,1254,1061,1591,1591,318,1114,1273,1077,1616,1616,323,1131,1293,1093,1640,1640,328,1148,1312,1110,1665,1665,333,1165,1332,1126,1689,1689,338,1182,1351,1142,1713,1713,343,1199,1371,1158,1738,1738,348,1216,1390,1175,1762,1762,352,1233,1410,1191,1786,1786,357,1250,1429,1207,1811,1811,362,1268,1449,1223,1835,1835,367,1285,1468,1240,1860,1860,372,1302,1488,1256,1884,1884,377,1319,1507,},
		["[special level up]"]={-1,0,"%",8,-1,1,"%",8,-1,2,"%",8,-1,3,"%",8,-1,4,"%",8,-1,5,"%",8,},},
		["[pvp]"]={ 
		["[cool time]"]={7000,7000},
		["[level info]"]={6,33,47,61,3,4,6,37,56,75,3,5,7,42,64,85,4,6,8,46,70,94,4,6,8,52,77,102,5,7,9,56,84,111,5,7,10,61,90,121,5,8,11,65,98,130,6,9,12,69,105,139,6,9,13,74,111,147,7,10,13,78,118,157,7,10,14,84,125,166,8,11,15,88,132,175,8,12,16,92,139,185,8,12,17,97,145,194,9,13,18,101,152,202,9,14,18,106,160,211,10,14,19,110,166,221,10,15,20,114,173,230,10,15,21,120,179,239,11,16,22,124,187,249,11,17,23,129,194,257,12,17,23,133,200,266,12,18,24,138,207,275,13,18,25,142,213,285,13,19,26,146,221,294,13,20,27,152,228,303,14,20,28,156,234,311,14,21,28,161,241,321,15,21,29,165,249,330,15,22,30,169,255,339,15,23,31,174,262,349,16,23,32,178,268,358,16,24,32,184,275,366,17,24,33,188,283,375,17,25,34,193,289,385,17,26,35,197,296,394,18,26,36,201,303,403,18,27,37,206,309,411,19,27,37,210,317,421,19,28,38,216,323,430,20,29,39,220,330,439,20,29,40,224,337,449,20,30,41,229,344,458,21,30,42,233,351,466,21,31,42,238,358,475,22,32,43,242,364,485,22,32,44,246,371,494,22,33,45,252,378,503,23,34,46,256,385,513,23,34,47,261,392,521,24,35,47,265,398,530,24,35,48,270,406,540,25,36,49,274,413,549,25,37,50,278,419,558,25,37,51,284,426,567,26,38,52,288,433,576,26,38,52,293,440,585,27,39,53,297,447,594,27,40,54,301,453,604,27,40,55,306,460,613,28,41,56,310,468,622,28,41,57,316,474,630,29,42,57,320,481,640,29,43,58,325,487,649,29,43,59,329,495,658,30,44,60,333,502,668,30,44,61,338,508,677,31,45,62,342,515,685,31,46,62,348,521,694,32,46,63,},},
		["[death tower]"]={ },
		["[warroom]"]={ },
		["[level property]"]={1,99,"3连斩的各物理攻击力 : <int>%% + <int>、  <int>%% + <int>、  <int>%% + <int>,5连斩的各物理攻击力 : <int>%% + <int>、  <int>%% + <int>、  <int>%% + <int>、  <int>%% + <int>、  <int>%% + <int>",-1,0,1.00,-2,3,1.00,-1,0,1.00,-2,3,1.00,-1,1,1.00,-2,4,1.00,-1,0,1.00,-2,3,1.00,-1,0,1.00,-2,3,1.00,-1,0,1.00,-2,3,1.00,-1,1,1.00,-2,4,1.00,-1,2,1.00,-2,5,1.00,},
		["[feature skill level property]"]={1,99,"5连斩的各物理攻击力 : <int>%% + <int>、  <int>%% + <int>、  <int>%% + <int>、  <int>%% + <int>、  <int>%% + <int>,7连斩的各物理攻击力 : <int>%% + <int>、  <int>%% + <int>、  <int>%% + <int>、  <int>%% + <int>、  <int>%% + <int>、  <int>%% + <int>、  <int>%% + <int>",-1,0,1.00,-2,3,1.00,-1,0,1.00,-2,3,1.00,-1,0,1.00,-2,3,1.00,-1,0,1.00,-2,3,1.00,-1,1,1.00,-2,4,1.00,-1,0,1.00,-2,3,1.00,-1,0,1.00,-2,3,1.00,-1,0,1.00,-2,3,1.00,-1,0,1.00,-2,3,1.00,-1,0,1.00,-2,3,1.00,-1,1,1.00,-2,4,1.00,-1,2,1.00,-2,5,1.00,},
		["[feature skill index]"]=143,}
}
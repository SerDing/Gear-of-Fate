return {

    ["[job]"]="[swordman]",
    ["[width]"]={40,10},
    ["[HP MAX]"] = 180.00,
    ["[MP MAX]"] = 140.00,
    
    ["[move speed]"] = 850.00,
    ["[attack speed]"] = 850.00,
    ["[cast speed]"] = 700.00,
    ["[hit recovery]"] = 600.00,
    
    ["[physical attack]"] = 7.50,
    ["[physical defense]"] = 7.50,
    ["[magical attack]"] = 4.50,
    ["[magical defense]"] = 4.50,

    ["[dark resistance]"] = 20.00,
    ["[light resistance]"] = -20.00,
    ["[inventory limit]"] = 48000.00, -- 负重
    ["[MP regen speed]"] = 50.00, -- mp恢复速度
    
    ["[jump power]"] = 430.00,
    ["[jump speed]"] = 95,
    ["[weight]"] = 50000.00,
    ["[skill]"] = {179,7,174,1,169,1,5,1,46,1,},
    ["[growtype 1]"] = {},
    ["[show skill]"] = {5,8,65,58,},
    ["[weapon wav]"] = {
        ['hsword'] = {"R_SQUARESWDA","SQUARESWDB","R_SQUARESWDA_HIT","SQUARESWDB_HIT",},
        ["ssword"] = {"R_MINERALSWDA","MINERALSWDB","R_MINERALSWDA_HIT","MINERAL_SWDB_HIT",},
        ["katana"] = {"R_KATANAA","KATANAB","R_KATANAA_HIT","KATANAB_HIT",},
        -- ["katana"] = {"R_MINERALSWDA","MINERALSWDB","R_MINERALSWDA_HIT","MINERAL_SWDB_HIT",},
        ["beamsword"] = {"R_BEAMSWDA","BEAMSWDB","R_BEAMSWDA_HIT","BEAMSWDB_HIT",},
        ["club"] = {"R_STICKA","STICKB_01","R_STICKA_HIT","STICKB_HIT_01",},
    },
    ["[weapon hit info]"]={
        ['ssword'] = {"[cut]","[blood]",90,1.00,0.00,0.00},
        ['katana'] = {"[cut]","[blood]",70,0.86,-0.10,0.00},
        ['club'] = {"[blow]","[no blood]",100,1.20,0.10,-0.95},
        ['hsword'] = {"[cut]","[blood]",120,1.40,0.20,0.00},
        ['beamsword'] = {"[cut]","[blood]",100,1.00,0.00,0.00},
        -- ['hsword'] = "[cut]","[blood]",60,0.85,-0.15,0.00,
    },
}
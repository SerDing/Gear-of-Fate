return {
    ['frames'] = {
        -- {x, y, w, h, dataRef},
        {10, 10, 200, 110, require("Data/ui/popup/normal")},
        -- // 不太有必要的两个凹槽，暂时废弃。
        -- {10, 10, 200, 110, require("Data/ui/popup/groove"),},
        -- {15, 20, 190, 40, require("Data/ui/popup/groove")},
    },

    --[[ may be new format design?
        ['widgets'] = {
            [1] = { -- frame[1]
                ['HMP_Bars'] = {
                    {...},
                    {...},
                    ...
                }
                ['Images'] = {
                    {...},
                    {...},
                    ...
                }
            },
            [2] = { -- frame[2]
                ...
            }
        }
    ]]

    ['HMP_Bars'] = {
        -- {frameIndex, x, y, imageInfo, model, controller}
        {1, 70, 25, require("Data/ui/progressbar/hp"), "Hero/Model/HP", nil, true},
        {1, 70, 40, require("Data/ui/progressbar/mp"), "Hero/Model/MP", nil, true},
    },
    ['Images'] = {
        -- {frameIndex, "single", path, x, y, r, sx, sy},
        -- {frameIndex, "batch", path, x, y, blank_x, blank_y, num_x, num_y},
        {1, "batch","interface/windowcommon.img/57.png", 19, 62, 3, 4, 6, 2},

        {1, "single","interface/hud/2.png", 15, 14, 0, 0.7, 0.7},
    },

    -- x, y, id, absKey, origin
    ['SkillGrids'] = { 
        -- {id, "single", x, y, skillid, absKey, origin}, 
        -- {id, "batch", x, y, skillid, absKey, origin, blank_x, blank_y, num_x, num_y}, 
        {"skill_grid_11", "single", 19 , 62, 0, "SKL_Q", false},
        {"skill_grid_12", "single", 19 + (30 + 3) * 1, 62, 0, "SKL_W", false},
        {"skill_grid_13", "single", 19 + (30 + 3) * 2, 62, 0, "SKL_E", false},
        {"skill_grid_14", "single", 19 + (30 + 3) * 3, 62, 0, "SKL_R", false},
        {"skill_grid_15", "single", 19 + (30 + 3) * 4, 62, 0, "SKL_T", false},
        {"skill_grid_16", "single", 19 + (30 + 3) * 5, 62, 0, "SKL_Y", false},

        {"skill_grid_21", "single", 19 , 62 + 30 + 4, 0, "SKL_A", false},
        {"skill_grid_22", "single", 19 + (30 + 3) * 1, 62 + 30 + 4, 0, "SKL_S", false},
        {"skill_grid_23", "single", 19 + (30 + 3) * 2, 62 + 30 + 4, 0, "SKL_D", false},
        {"skill_grid_24", "single", 19 + (30 + 3) * 3, 62 + 30 + 4, 0, "SKL_F", false},
        {"skill_grid_25", "single", 19 + (30 + 3) * 4, 62 + 30 + 4, 0, "SKL_G", false},
        {"skill_grid_26", "single", 19 + (30 + 3) * 5, 62 + 30 + 4, 0, "SKL_H", false},
    },

    ['pops'] = {
        {1, 20, 20, 25, 25, require("Data/ui/popup/groove")},
    },
}
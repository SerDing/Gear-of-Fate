return {
    ['frames'] = {
        -- {x, y, w, h, dataRef},
        {10, 10, 200, 110, require("Data/ui/popup/normal")},
        -- {20, 20, 25, 25, require("Data/ui/popup/groove")},
    },
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
     -- x, y, id, origin
    -- ['Grid_Skill'] = {
    --     -- {frameIndex, "single", x, y, r, sx, sy},
    --     -- {frameIndex, "batch", x, y, blank_x, blank_y, num_x, num_y},
    --     {1, "group", 19, 62, 3, 4, 6, 2},
    -- },
    ['pops'] = {
        {1, 20, 20, 25, 25, require("Data/ui/popup/groove")},
    },
}
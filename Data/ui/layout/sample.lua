return {
    ['frames'] = {
        -- {x, y, w, h, dataRef},
        {20, 50, 100, 70, require("Data/ui/popup/normal")},
    },
    ['HMP_Bars'] = {
        -- {frameIndex, x, y, imageInfo, model, controller}
        {1, 70, 25, require("Data/ui/progressbar/hp"), "Hero/Model/HP", nil},
    },
    ['Images'] = {
        -- {"single", path, x, y},
        -- {"batch", path, x, y, blank_x, blank_y, num_x, num_y},
        {"batch","interface/windowcommon.img/57.png", 19 + 33 * (k - 1), 62 + 34 * (i - 1)},
    },
    -- ['buttons'] = {
    --     {"狂战士", 20, 50, require("Data/ui/buttons/small")},
    -- },
}
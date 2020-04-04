return {
    {
        name = "bottom_pop",
        script = "frame",
        x = 10,
        y = 10,
        w = 215,
        h = 126,
        style_path = "Data/ui/popup/normal",
        subjects = {
            --{
            --    name = "character_head_frame",
            --    script = "frame",
            --    x = 10,
            --    y = 10,
            --    w = 30,
            --    h = 22,
            --    style_path = "Data/ui/popup/groove",
            --},
            {
                name = "character_img",
                script = "image",
                x = 5,
                y = 4,
                r = 0,
                sx = 0.7,
                sy = 0.7,
                img_path = "interface/hud/2"
            },
            {
                name = "hp_bar",
                script = "hmpbar",
                x = 60,
                y = 15,
                style_path = "Data/ui/progressbar/hp",
            },
            {
                name = "mp_bar",
                script = "hmpbar",
                x = 60,
                y = 30,
                style_path = "Data/ui/progressbar/mp",
            },

            -- extended skill shortcuts
            {
                name = "skill_shortcut_ex_1",
                script = "skillshortcut",
                x = 9,
                y = 52,
                is_origin = false,
                img_path = "interface/windowcommon.img/57"
            },
            {
                name = "skill_shortcut_ex_2",
                script = "skillshortcut",
                x = 9 + 33,
                y = 52,
                is_origin = false,
                img_path = "interface/windowcommon.img/57"
            },
            {
                name = "skill_shortcut_ex_3",
                script = "skillshortcut",
                x = 9 + 33 * 2,
                y = 52,
                is_origin = false,
                img_path = "interface/windowcommon.img/57"
            },
            {
                name = "skill_shortcut_ex_4",
                script = "skillshortcut",
                x = 9 + 33 * 3,
                y = 52,
                is_origin = false,
                img_path = "interface/windowcommon.img/57"
            },
            {
                name = "skill_shortcut_ex_5",
                script = "skillshortcut",
                x = 9 + 33 * 4,
                y = 52,
                is_origin = false,
                img_path = "interface/windowcommon.img/57"
            },
            {
                name = "skill_shortcut_ex_6",
                script = "skillshortcut",
                x = 9 + 33 * 5,
                y = 52,
                is_origin = false,
                img_path = "interface/windowcommon.img/57"
            },

            -- simple skill shortcuts
            {
                name = "skill_shortcut_1",
                script = "skillshortcut",
                x = 9,
                y = 52 + 34,
                is_origin = false,
                img_path = "interface/windowcommon.img/57"
            },
            {
                name = "skill_shortcut_2",
                script = "skillshortcut",
                x = 9 + 33,
                y = 52 + 34,
                is_origin = false,
                img_path = "interface/windowcommon.img/57"
            },
            {
                name = "skill_shortcut_3",
                script = "skillshortcut",
                x = 9 + 33 * 2,
                y = 52 + 34,
                is_origin = false,
                img_path = "interface/windowcommon.img/57"
            },
            {
                name = "skill_shortcut_4",
                script = "skillshortcut",
                x = 9 + 33 * 3,
                y = 52 + 34,
                is_origin = false,
                img_path = "interface/windowcommon.img/57"
            },
            {
                name = "skill_shortcut_5",
                script = "skillshortcut",
                x = 9 + 33 * 4,
                y = 52 + 34,
                is_origin = false,
                img_path = "interface/windowcommon.img/57"
            },
            {
                name = "skill_shortcut_6",
                script = "skillshortcut",
                x = 9 + 33 * 5,
                y = 52 + 34,
                is_origin = false,
                img_path = "interface/windowcommon.img/57"
            },
        },
    },
}
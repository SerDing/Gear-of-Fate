return {
    {
        name = "mainframe",
        script = "frame",
        x = (960 - (800)) / 2,
        y = (540 - (450)) / 2,
        w = 800,
        h = 450,
        style_path = "Data/ui/popup/normal",
        positionType = "center",
        subjects = {
            {
                name = "groove_left",
                script = "frame",
                x = 10,
                y = (450 - (410 + 10)),
                w = 430,
                h = 410,
                style_path = "Data/ui/popup/groove",
                subjects = {
                    {
                        name = "button1",
                        script = "button",
                        text = "装备",
                        x = 10,
                        y = 300,
                        style_path = "Data/ui/buttons/small",
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
                        name = "skill_shortcut_ex_3",
                        script = "skillshortcut",
                        x = 9 + 33 * 4,
                        y = 52,
                        is_origin = false,
                        img_path = "interface/windowcommon.img/57"
                    },
                },
            },
            {
                name = "groove_right",
                script = "frame",
                x = 800 - (340 + 10),
                y = (450 - (410 + 10)),
                w = 340,
                h = 410,
                style_path = "Data/ui/popup/groove",
            },
        },
    }
}
return {
    {
        name = "bottom_pop",
        script = "frame",
        x = 20,
        y = 20,
        w = 750,
        h = 510,
        style_path = "Data/ui/popup/normal",
        subjects = {
            {
                name = "groove_left",
                script = "frame",
                x = 10,
                y = 10,
                w = 340,
                h = 490,
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
                },
            },
            {
                name = "groove_right",
                script = "frame",
                x = 390,
                y = 10,
                w = 340,
                h = 490,
                style_path = "Data/ui/popup/groove",
            },
        },
    }
}
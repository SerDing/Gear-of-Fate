return { --  Hero SwordMan attack info 
    ["default"] = { -- template
        ["Y"] = 40,
        ["push"] = { -- on land
            ["backPower"] = 5,
            ["backSpeed"] = 1,
            ["float"] = 0,
        },
        ["lift"] = { -- on air floating
            ["backPower"] = 5,
            ["backSpeed"] = 1,
            ["float"] = 0,
        },
    },

    ["attack1"] = {
        ["push"] = {
            ["backPower"] = 4,
            ["backSpeed"] = 1,
            ["float"] = 0,
        },
        ["lift"] = {
            ["backPower"] = 0,
            ["backSpeed"] = 0.75,
            ["float"] = 2.5,
        },
        ["Y"] = 38,
    },

    ["attack2"] = {
        ["push"] = {
            ["backPower"] = 4,
            ["backSpeed"] = 1,
            ["float"] = 0,
        },
        ["lift"] = {
            ["backPower"] = 0,
            ["backSpeed"] = 0.75,
            ["float"] = 2.5,
        },
        ["Y"] = 38,
    },

    ["attack3"] = {
        ["push"] = {
            ["backPower"] = 5,
            ["backSpeed"] = 1,
            ["float"] = 5,
        },
        ["lift"] = {
            ["backPower"] = 0,
            ["backSpeed"] = 0.75,
            ["float"] = 5,
        },
        ["Y"] = 38,
    },

    ["upperslash"] = {
        ["push"] = {
            ["backPower"] = 1.5,
            ["backSpeed"] = 1,
            ["float"] = 7.5, -- 7.5 * 60 = 450
        },
        ["lift"] = {
            ["backPower"] = 0,
            ["backSpeed"] = 1,
            ["float"] = 7.5,
        },
        ["Y"] = 38,
    },

    ["jumpattack"] = {
        ["push"] = {
            ["backPower"] = 3,
            ["backSpeed"] = 1,
            ["float"] = 2,
        },
        ["lift"] = {
            ["backPower"] = 0,
            ["backSpeed"] = 1,
            ["float"] = 3,
        },
        ["Y"] = 38,
    },   

    ["dashattack1"] = {
        ["push"] = {
            ["backPower"] = 9,
            ["backSpeed"] = 1,
            ["float"] = 0,
        },
        ["lift"] = {
            ["backPower"] = 0,
            ["backSpeed"] = 1.2,
            ["float"] = 3.3 / 0.9,
        },
        ["Y"] = 38,
    },

    ["dashattack2"] = {
        ["push"] = {
            ["backPower"] = 10,
            ["backSpeed"] = 1,
            ["float"] = 0,
        },
        ["lift"] = {
            ["backPower"] = 0,
            ["backSpeed"] = 1.2,
            ["float"] = 3.3 / 0.9,
        },
        ["Y"] = 38,
    },

    ["gorecross1"] = {
        ["push"] = {
            ["backPower"] = 3,
            ["backSpeed"] = 0.5,
            ["float"] = 0,
        },
        ["lift"] = {
            ["backPower"] = 0,
            ["backSpeed"] = 0.5,
            ["float"] = 1.6,
        },
        ["Y"] = 50,
    },

    ["gorecross2"] = {
        ["push"] = {
            ["backPower"] = 3,
            ["backSpeed"] = 0.5,
            ["float"] = 0,
        },
        ["lift"] = {
            ["backPower"] = 0,
            ["backSpeed"] = 0.5,
            ["float"] = 3.3,
        },
        ["Y"] = 40,
    },

    ["moonlightslash1"] = {
        ["push"] = {
            ["backPower"] = 6,
            ["backSpeed"] = 1,
            ["float"] = 0,
        },
        ["lift"] = {
            ["backPower"] = 0,
            ["backSpeed"] = 1,
            ["float"] = 5/0.9,
        },
        ["Y"] = 50,
    },

    ["moonlightslash2"] = {
        ["push"] = {
            ["backPower"] = 3,
            ["backSpeed"] = 1,
            ["float"] = 6,
        },
        ["lift"] = {
            ["backPower"] = 0,
            ["backSpeed"] = 1,
            ["float"] = 6,
        },
        ["Y"] = 50,
    },

    ["tripleslash1"] = {
        ["push"] = {
            ["backPower"] = 5,
            ["backSpeed"] = 1,
            ["float"] = 0,
        },
        ["lift"] = {
            ["backPower"] = 0,
            ["backSpeed"] = 1,
            ["float"] = 2,
        },
        ["Y"] = 34,
    },

    ["tripleslash2"] = {
        ["push"] = {
            ["backPower"] = 5,
            ["backSpeed"] = 1,
            ["float"] = 0,
        },
        ["lift"] = {
            ["backPower"] = 0,
            ["backSpeed"] = 1,
            ["float"] = 2,
        },
        ["Y"] = 34,
    },

    ["tripleslash3"] = {
        ["push"] = {
            ["backPower"] = 5,
            ["backSpeed"] = 1,
            ["float"] = 2,
        },
        ["lift"] = {
            ["backPower"] = 0,
            ["backSpeed"] = 1,
            ["float"] = 2,
        },
        ["Y"] = 34,
    },

    ["hopsmash_normal"] = {
        ["push"] = {
            ["backPower"] = 5,
            ["backSpeed"] = 1,
            ["float"] = 0,
        },
        ["lift"] = {
            ["backPower"] = 0,
            ["backSpeed"] = 1,
            ["float"] = 3,
        },
        ["Y"] = 42,
    },

    ["hopsmash_float"] = {
        ["push"] = {
            ["backPower"] = 5,
            ["backSpeed"] = 1,
            ["float"] = 0,
        },
        ["lift"] = {
            ["backPower"] = 0,
            ["backSpeed"] = 1,
            ["float"] = 1 / 0.9,
        },
        ["Y"] = 42,
    },

    ["ashenfork"] = {
        ["push"] = {
            ["backPower"] = 0,
            ["backSpeed"] = 0,
            ["float"] = 2,
        },
        ["lift"] = {
            ["backPower"] = 0,
            ["backSpeed"] = 0,
            ["float"] = 1 / 0.9,
        },
        ["Y"] = 30,
    },

    ["frenzy1"] = {
        ["push"] = {
            ["backPower"] = 7,
            ["backSpeed"] = 1,
            ["float"] = 0,
        },
        ["lift"] = {
            ["backPower"] = 0,
            ["backSpeed"] = 1,
            ["float"] = 2.5,
        },
        ["Y"] = 38,
    },

    ["frenzy2"] = {
        ["push"] = {
            ["backPower"] = 7,
            ["backSpeed"] = 1,
            ["float"] = 0,
        },
        ["lift"] = {
            ["backPower"] = 0,
            ["backSpeed"] = 1.1,
            ["float"] = 2.5,
        },
        ["Y"] = 38,
    },

    ["frenzy3"] = {
        ["push"] = {
            ["backPower"] = 7,
            ["backSpeed"] = 1,
            ["float"] = 0,
        },
        ["lift"] = {
            ["backPower"] = 0,
            ["backSpeed"] = 1.1,
            ["float"] = 2.5,
        },
        ["Y"] = 38,
    },

    ["frenzy4"] = {
        ["push"] = {
            ["backPower"] = 5,
            ["backSpeed"] = 1,
            ["float"] = 1 / 0.9,
        },
        ["lift"] = {
            ["backPower"] = 0,
            ["backSpeed"] = 1.1,
            ["float"] = 2.5,
        },
        ["Y"] = 38,
    },
    

}
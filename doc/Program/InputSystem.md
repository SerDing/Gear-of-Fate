# Input Manager
## 1.Input abstract layer(InputMap)
To process input messages from multiple kinds of input device and make players could customize key-mapping, we need add a abstract layer to transform all input messages to some game internal logical messages. We called it game action.

    key_msg --> action
    
    eg: "x" --> "attack"
    if input.isActionPressed("attack") then
        self.FSM:SetState("attack")
    end
    
## 2.Skill Shortcut System

Generally, skill is started by shortcut(hot key), so we need a table to store game action of shortcuts and real skill game action.

    key_msg --> skill_shortcut_name --> skill_action(skill_name)

    eg: "a" --> "skill_shortcut_1" --> hero.skillShortcutsMap["skill_shortcut_1"]
    --> skill_action(skill_name)
    
    INPUT(key_msg)-->Input(skill_shortcut_name)-->Hero.skillShortcutsMap(skill_name)-->Input(skill_action)
    
    SkillMgr: skillShortcutsMap<string, string> = { [skill_shortcut_name] = skill_name }
    
    update the skillShortcutsMap:
    HUD:
        SkillShortcuts[i]:HandleEvent(btn, x, y)
        SkillShortcuts[i]:SetSkill(id)
    
    SkillShortcutController(shortcut, btn, x, y):
        skillMgr = EntityManager.mainPlayer.Components.SkillMgr
        hero.skillShortcutsMap[shortcut.name] = skillMgr:GetSkillNameByID(shortcut:GetSkillID())
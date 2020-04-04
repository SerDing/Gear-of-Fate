# Development Plan For Gear Of Fate
 - Version: 0.5
 - Time: 2018.11.2
## Mission:
    自顶向下设计，自底向上构建.
    底层(Engine)构建得太过薄弱，上层(Gameplay)才无法自由构建。
    玩法->剧情->内容(关卡)
    
    .Refactor Resource System
        - redesign resource directories
        - provide methods of various data file
        - set up inter cache pool
    
    .Refactor Sprite
        - use quad to implement image scissoring display
        - add center point feature
    
    .Reconstruct Animation System
        - inherite from sprite
        - difine new animation data structure
        - one anim data for all aniamtors(like body, weapon)
        - don't bind all anim data to animation instance
        - play animation by anim data not key name
    
    .Entity-Component System
        - Standardized all components by data-oriented-design
        - AttackJudger: don't load of atkinfo previously, Judge(attackInfo).
        - State: load state instances by state data. 
        - Graphics: merge sprite, avatar, animation 
        - Convert to entity (swordman, monster, effect, bullet, flower, obstacle, pathgate)
    
    .Refactor States 
        - make all basic state common for swordman or monster
        - complete functions of state base
        - delete surplus/repeated states like dash, rest... 
    
    .Reconstruct Level System
        - make a simple level editor
    
    .Refactor Damage logic
    .Build basical game mechanics
        - add damage state for hero
        - add die state for hero
        - combat evaluation system
    
    .Refactor input system (create internal abstract input message)
    .Refactor AI System (virtual input command control behavior)
    
    .Core systems
        - Bag/Inventory
        - Equipment (atkEffect, avatarReplace, attributes)
        - Attribute
        - Save
        - Plot
    
# Development Plan For Gear Of Fate
## Version_0.5
### Time: 2018.11.2
    Mission:
    
    .Reconstruct SceneMgr
        * add pathgate functionality
        * implement merging terrain grids of all tiles to a big grid table for pathfinding
    .Construct LevelSystem
        * manage levels 
        * call SceneMgr

    .Refactor construction code of hero class
    .Complete construction functionality of hero in ActorManager(Factory)

    .Refactor Damage logic
    .Build basical game mechanics
        * add damage state for hero
        * add die state for hero
        * combat evaluation system
    
    
    .Refactor input system (create internal abstract input message)
    .Refactor AI_Control (virtual input command contorl behavior)
    
    .Core systems
        * Bag/Inventory
        * Equipment (atkEffect, avatarReplace, attributes)
        * Attribute
        * Save
        * Plot

    .GUI_Constructor Refactoring
    .GUI Widget
        * List
        * Slider
        * Panel
        * ScrollBar
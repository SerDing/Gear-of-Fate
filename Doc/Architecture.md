# GOF Architecture design

Note: "* xxx" is a folder, "- xxx" is a source code file.

## Engine
    - ResMgr
    - PoolMgr
    - AudioMgr
    * Core
        - class
        - sprite
        - font
        - rect
    * Input
        - InputHandler
        - Input
    * GUI
        * Widgets
        - UIMgr
        - LayoutMgr
        - Interface
    * Event
        - EventMgr
        - Event
    * Animation
        - Animation
        - Avatar(animations group)
        - Effect
    * Camera
        - Camera
        - Shake
    * Navigation

## Gameplay
    * Managers
        - GameMgr
        - GameStateMgr
        - LevelMgr
        - EntityMgr
        - SkillMgr
        - InventoryMgr
        - HotKeyMgr
    * Components
        - AttackJudger
        - Weapon
        - Movement
        - FSM
        - FSMAIControl
    * Objects
        - GameObject
        * Character
            - Character
            - Hero
            - Monster
            - Npc
        * Level
            - Tile
            - Obstacle
        * Combat
            - Skill
            - AtkObj
    * States
        * Game
            - Startup
            - MainMenu
            - Loading
            - Options(pause)
        * Character
            * Swordman
        * Monster
            * Goblin

## Lib
    * Jumper

## Utility
    - math
    - string
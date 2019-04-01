# GOF Architecture design

Note: "* xxx" is a folder, "- xxx" is a source code file.

## Engine
    - ResMgr
    - PoolMgr
    - AudioMgr
    * Base
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
        - ActorMgr
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
        - Object
        * Actors
            - Actor
            - Hero
            - Monster
            - Npc
        * Level
            - Tile
            - Obstacle
        * Combat
            - Skill
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



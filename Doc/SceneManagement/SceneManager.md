
# What does the scenemanager do and what does it inherit from and such?

    管理游戏场景，不继承于任何类，包含并管理场景中的所有对象。
    场景：游戏中的任何2D或3D区域（SceneMgr必须明确专用于2D或3D，而不是两者混杂。）

## 作为一个容器：

    包含一个容纳场景中所有对象的主列表，所有的摄像机、地形实例、树叶数据、天空盒、角色、模型、静态几何，等等。通过这个列表，所有的对象可以被线性地遍历。不过没有必要把他们都存储在一个列表里，分类存储更好，比如地形存储在地形数组中，动画几何存储在动画几何数组中等。

    self.objects = {}
    self.npcs = {}
    self.heroes = {}
    self.monsters = {}
    self.passiveobjs = {}
    self.tiles = {}
    self.extiles = {}
    self.animations = {}

    包含特殊划分，为了能够轻松进行一些特殊的遍历。比如，在收集渲染对象并执行视锥体剔除的时候，或者物理方面的广泛剔除。（利用树形结构，如二叉树、四叉树、八叉树对空间进行划分，来提高一些功能的效率，比如LOD遮挡剔除，物理碰撞的效率提升。）

## 作为一个管理器：

    它管理许多对象之间的互动。比如启动物理引擎进行物理运算表现。
    它能抽象地将对象聚集到一起为各种子系统所用，例如进行LOD视线遮挡剔除。
    能够为一个对象提供它周围的环境信息，通过一个统一的抽象接口来更新所有对象。


    [[

        比如主菜单是一个场景
        一开始显示logo的屏幕，在我的游戏里也是一个场景。
        显示最高分盒设置选项菜单的屏幕也是场景。

        游戏中的每一个关卡都是一个场景
        甚至连一个弹出式对话框也可以是一个场景
    ]]

    这些最好做成游戏状态
    一个游戏状态管理着游戏的状态。主菜单、分数、游戏中、关卡选择等等。
    所有这些状态都有着宽泛而不太的逻辑和要求。一个经典的场景管理器不适合这个任务。

    关系应该是这样的:
    MyGame继承自Game。MyGame在整个游戏中始终拥有持久化的数据，就像玩家数据统计一样。

    Game has a StateManager object for managing game states.
    Game有一个CStateManager对象来管理游戏状态。

    StateManager对象有一个当前状态current state（State），

    MainMenuState inherits from CState.  All logic for the main menu is implemented here.  There are no scene managers.

    GamePlayState --> SceneManager
    通过SceneManager的实例来加载关卡。
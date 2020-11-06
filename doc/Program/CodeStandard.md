<font face="微软雅黑">

## 命名标准
### 源代码文件名
由开头大写的单词组成，涉及数字时，使用下划线“_”隔开
``` lua
-- example
io.open("Ani_1.lua")
```
### 类名与函数名
由开头大写的单词组成,单例类使用全大写
``` lua
example
local _GAMEMGR = {}
```
### 变量名
小写开头，遵循驼峰命名法，私有变量(private)前面加“_”标示
``` lua
example
local _tile = "Gear"
```
## 注释标准
1.尽量使用全英文
2.给类和函数写Doc时写注释
3.需要__特殊注意__的地方写注释
4.不要用注释解释简单易懂的代码，要标注难以理解或隐藏的重要信息。

## lua编程习惯注意
1.不要使用全局变量，local定义的局部变量效率更高且可以提高模块内聚性
2.使用require方法加载lua模块，可以很清楚的知道对外部的引用情况，为维护提供极大便利。
```lua
-- example
local _RESMGR = require("ResMgr")
local _ActorBase = require("Actor")
```
3.局部变量的开发思想实质上就是模块化
4.单例类不用class化，只需使用空table定义即可。单例类特指那些只出现一个实例的类，它们既不会重复出现，也不会作为基类存在，没有重用价值，因此不必class化，为其添加继承或重用的特性。
5.Class中变量类型的定义方法
```lua
public: Class.publicVar
private: Class._privateVar
inModule: local var = xxx
```
6.table引用特性
	在lua中，table之间通过等号传递只能是一种引用，即拷贝根源变量的内存地址，而非变量内容的深拷贝。

## 程序开发流程
### 需求分析
书写需求文档
确定功能函数
确定包含的数据
确定包含的单元(如：GameMgr包含GameMap HUD UI MonsterProducer……)
确定模块性质（如：GameMgr是游戏的核心单元，它是所有大型单元Update和Draw的场所）
使用astah pro 绘制UML图，理清各模块之间的关系（继承，组合……）

### 编程实现
定义初期策划好的所有接口
逐一编写接口内业务逻辑
Debug

80/20 rule 思考代码时间占80% 编写时间占20% 这是一种必要的思维方式

基础薄弱 勤能补拙
</font>
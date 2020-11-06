## 武器类equ文件分析
### 1.基本动画结构：
    这一块主要分析equ文件是如何组织其动画相关数据的以便实现自动化动态创建animation对象并加入avatar组保持正常层次更新绘制。

```html
    [animation job]
    `[swordman]`
    [variation]
    4	2	
    [layer variation]
    2790	`katanac`
    [equipment ani script]
    `equipment/character/swordman.lay`
    [layer variation]
    650	`katanab`
    [equipment ani script]
    `equipment/character/swordman.lay`
```


    1）[animation job]划分不同职业的动画数据

    2）[variation]为块内动画的资源编号数字部分
    
    3）[layer variation]和[equipment ani script]组成一个animation对象的数据块
    
    4）[layer variation]中第一个值为绘制层次(排序用)，第二个值为动画文件子路径名/资源分卷名，具体由装备类型决定，比如weapon需要和上一项[variation]编号组合(sswdc -> sswd800c)，growtype则不需要。也可以作为avatar组中的key使用。

    5）[equipment ani script]为animation对象的ani路径表文件的路径


### 2.攻击成功时附加的特殊效果

    这一块，equ似乎是使用了自定义的脚本语言来实现策划配置，程序自动解析执行达到相应效果。
    
    由于GOF由我自行开发，且lua本身就是脚本语言，因此考虑采用以下方案：
    
    1）每个武器都有一个独立的lua文件存放攻击时特殊效果的实现代码
    
    2）这些文件统一放在一个OnAttakcSuccess文件下
    
    3）每个文件里只包含实现效果需要的相关模块引用(refs)和一个callback = OnAttackSuccess()

    4）建立一个manager，负责与事件系统协作，在检测角色攻击到敌人时调用相应的callback

## 非道具类equ文件

    这类equ文件的特征是，不包括道具属性和特殊效果之类的东西，只是单纯的一个animation对象
    
    以Monster的为例，包含了monster的基本动作的ani路径( [xxx motion] )和层次信息( [layer] )
    
    Character的时装equ文件同理，本质上都是相同的东西，即只起装扮作用的equipment。
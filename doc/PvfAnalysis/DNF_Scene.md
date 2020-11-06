# DNF场景结构分析

## 1.纵向分为两层 
    1.第一层为大区域 如艾尔文防线 
    2.第二层为小区域 即具体的某一个地图 如艾尔文防线的洛兰过道

## 2.横向分为两种类型
    1.第一类 twn 城镇类  
    [enter title] 进入大区域时的标题
    [cutscene image] 进入大区域时的过场图片
    [area] 所包含的小区域 map

    2.第二类 dgn 地下城类 只提供了开始的小区域的序号
    [cutscene image] 进入地下城时的过场图片
    [mini required level] 最小要求等级
    [start map] 进入地下城时 开始房间的序号
    [boss map] 地下城boss的所在房间序号
    [explain] 选择地下城时的介绍信息

### [extended tile]功能分析
    [tile] 中包含基本的地表图块，而[extended tile]则是对纵向宽度大于600的地图进行补充的地表图块数据，基本结构如下：

    [tile]
    `Tile/tile_ex_base01.til`	`Tile/tile_ex_base03.til`	`Tile/tile_ex_base03.til`	`Tile/tile_ex_base02.til`	`Tile/tile_ex_base01.til`	
    [/tile]

    [extended tile]

        [tile files]
            0	`Tile/tile_ex_sub01.til`	1	`Tile/tile_ex_sub02.til`	2	`Tile/tile_ex_sub05.til`	3	`Tile/tile_ex_sub06.til`	
        [/tile files]

        [tile map]
            0	1	0	1	1	2	3	2	3	3	
        [/tile map]
    [/extended tile]

    可以看出 [tile files] 定义了基本的extended图块及其ID，而[tile map]则是由extended tile图块id组成的数据表，
    具体拆分规则是：按基本图块数据[tile]中的图块数进行拆分，可以看出示例中[tile]有5个图块，
    那么[tile map]即可5个分一组，每一组就是一行，分行拼接绘制即可达到预期的extended tile效果。
    示例：
    ["tile"] = {1, 3, 3, 2, 1}
    ["tile map"]  = {
                0, 1, 0, 1, 1, 
                2, 3, 2, 3, 3,
    }




    

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

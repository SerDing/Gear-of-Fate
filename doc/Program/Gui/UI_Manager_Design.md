# Gear of Fate -- UI_Manager设计

## 基本构成

    UI = {Panel_HUD, Panel_Inventory, Panel_Skill}

    Panel_HUD = {ProcessBar, Image, Grid_Skill}

    Panel_Inventory = {Grid_Item, Image, Button, Label}

    Panel_Skill = {Grid_Skill, label}

## 需求分析

    数据结构: 栈
    存储对象: Panels (面板引用)
    
    主要功能:
    1.页面导航: 打开新页面(进栈)、返回上一页面(出栈)、弹出小消息窗(模态popup)
    2.层级管理: 与栈的层级结构一致，从栈顶到栈底，依次为最上层页面到最底层页面.
    3.集中处理页面操作: 控件发出请求，UI_Mgr通过消息流，在一个函数中集中处理.

## 具体设计

    1.Stack_Draw: 负责存储各个Panel的绘制层级关系
    2.Stack_Update: 负责存储各个Panel间的Update顺序关系


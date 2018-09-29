# Gear of Fate -- UI_Manager设计

## 基本构成

    UI = {Panel_HUD, Panel_Inventory, Panel_Skill}

    Panel_HUD = {ProcessBar, Image, Grid_Skill}

    Panel_Inventory = {Grid_Item, Image, Button, Label}

    Panel_Skill = {Grid_Skill, label}

## 需求分析

    数据结构: 栈
    存储对象: Panel
    
    主要功能:
    1.页面导航: 打开新页面(进栈)、返回上一页面(出栈)
    2.层级管理: 与栈的层级结构一致，从栈顶到栈底，依次为最上层页面到最底层页面

## 具体设计

    1.Stack_Draw: 负责存储各个Panel的绘制层级关系
    2.Stack_Update: 负责存储各个Panel间的Update顺序关系


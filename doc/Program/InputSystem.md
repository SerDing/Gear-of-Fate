# Input Manager
## 1.Input Mapping
输入映射，负责将原始硬件输入信息转换为游戏内定义的输入事件（Input Event）。

映射结构为InputControl->InputEvent

InputEvent定义了所触发的输入事件，它有两个字段：name，type。

name为事件名，type代表实际的事件类型（按钮事件/轴事件）。

InputControl定义了InputEvent的输入源，它有三个字段：device，type，code。

device代表操控设备，type代表具体输入类型（按钮/轴），code代表键或轴的标识符。

## 2.Input Device

为各种输入设备实现类，使它们都继承InputState来管理原始输入的状态。

由InputSystem向其注册control对象，接收到原始输入后，通过control转换为具体的InputEvent数据，传回InputSystem。

同时它们还拥有InputSystem的引用，便于

## 3.Input Component


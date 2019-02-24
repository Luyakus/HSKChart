# 简洁统一的图表

### 架构思路
* ContextModel 包含图表单元的数据信息
* Layout 计算图表单元坐标
* PrintModel 粒度更小的图表单元, 由 ContextModel 产生, 包含图表单元需要的  layer, 动画, layer层级优先级, 动画优先级
* CALayer+HSKCMAnalysePrinter 绘制分类, 将 ContextModel 产生的 PrintModel 根据layer优先级和动画优先级, 分时段绘制到父视图上

### 示例
![图表示例](1551002649649.gif)
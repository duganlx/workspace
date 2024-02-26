# 工作台二期设计与实现

工作台二期将主要对创建新方案的过程进行优化，并且多添加一个组件“四分图”。

在工作台优化二期处理卡片布局相关问题的时候，发现目前工作台的设计方面存在缺陷：

布局中存在“行” 和 “列”，他们在页面布局中的行为是类似（添加删除一行/列，设置高/宽），但是代码实现上并不统一，存在很大的差别（行是用像素来进行设计，列是用 calc 函数设置）
函数的封装复用性差，所封装的函数并非“纯函数”，处理过程会引用函数以外的变量。

## 附录

### 工作台一期

在一期设计实现中，工作台是 QuantWeb 平台中单独的模块。打开工作台页面首先能看到全部方案的列表，其中包含的列有：方案 ID、方案名称、状态、创建用户、创建时间、更新时间、操作。操作包括修改和删除操作。另外右上角还有一个创建方案的按钮。

点击创建方案，会弹出一个小弹窗要求输入新工作台方案的名称，之后就开始设计方案了，一共包含三个步骤：设计布局、配置内容、预览方案；具体每一步骤的操作内容如下所示。

- 在设计布局中，可以添加行和列，而*卡片区域*是行和列交叉之后形成的矩形区域。卡片区域的宽高支持使用 px 像素和百分比两种方式进行设定。最多支持九行九列共八十一个卡片区域。
- 配置内容，即对卡片区域中展示的内容进行配置，配置参数包括两个部分*通用参数*和*数据参数*。通用参数包括标题和组件，其中组件有三种选择，分别为表格、时序图、文本框。数据参数根据组件不同有不同的配置。表格和时序图组件的数据参数有 来源、库名、表名；文本无数据参数配置项。
- 在预览方案中，可以看到实际的布局和卡片内容了，此时可以对卡片配置其组件参数，比如，表格组件有三个配置项：SELECT、WHERE、ORDER BY；文本组件有一个配置项：内容；时序图组件配置可以分为*图标配置*和*系列配置*。图标配置包含的配置项有：图表类型、Y 轴名称、X 轴名称、X 轴字段，图表类型有两种选择：折线图和柱状图，当选择为折线图时，会多一项配置：是否显示面积。系列配置是配置 Y 轴显示的数据。

当完整经过创建方案的全过程后，在全部方案的列表中，状态就会是上线，否则状态就是下线状态。可以双击列表中的方案可以打开查看方案的内容（与预览方案页内容一致）。

在该设计实现上，目前存在以下问题

1. 在设计布局中，对卡片的宽高支持两种：像素值和百分比。在使用百分比设定时，卡片的大小不会跟随着页面大小的改变而改变，即百分比设定实际上的也是指定像素值。而预期的百分比设定就是参考于整个页面大小的比例，当页面大小变化时，应该也会跟着变化。
1. 卡片的数量最多为九行九列，所以卡片的最小宽高就是在这种情况下的宽高，目前在限制上会存在一个像素的偏差（边界问题）。
1. 当配置的卡片数量过多时，进入配置内容页面时会有明显的渲染缓慢问题。
1. 创建工作台方案时，如果没有进行到最后一步，也会产生一个“下线”的工作台方案
%！！！！！！仿真UI入口
clear; 
close all;

% %%
% 运行前请确认已经完成以下配置，然后依次删除以下几行：
% 1 安装 Matlab Simulink 3D Animation 工具箱
% 2 安装 Matlab Aerospace Toolbox 工具箱
% 3 在MATLAB快捷方式中选中属性 -> 兼容性 -> 更改高DPI设置 -> 勾选替代高DPI缩放行为
% 4 视角控制面板用法：在“空白figure”上拖动鼠标移动视角，按A W S D 和 R F 移动位置
% 5 地面图像的名字是 20203.png，在替换成其他图像时，为了防止长宽比例错乱图像必须是正方形，即 行数=列数
% %%

set(0,'DefaultFigureMenu','none')
global fig viewpoint_access world

nav     %视角控制面板接入
        %视角控制面板用法：在空白figure上拖动鼠标移动视角，按A W S D 和 R F 移动位置
world=vrworld('UI_earth2.wrl', 'new'); 
open(world); 
fig=vrfigure(world); 
set(fig, 'Viewpoint', 'zero'); 
set(fig, 'NavMode', 'none'); 
set(fig, 'NavPanel', 'none');
set(fig, 'NavZones', 'on');
set(fig,'CameraPosition',[0,200,200]);
set(fig,'CameraDirection',[0,-1,-1]);
set(fig,'ToolBar','off');
set(fig,'Tooltips','off');
set(fig,'StatusBar','off');
set(fig,'CaptureFileFormat','bmp');
set(fig,'CaptureFileName','%f_anim_%n.bmp');
set(fig,'Position',[0 40 500 500]);%！！！改变主窗口的大小和位置
set(fig,'Name','<------输入该界面对应的数字');
vrdrawnow; 
viewpoint_access=vrnode(world, 'zero'); 
vrdrawnow; 



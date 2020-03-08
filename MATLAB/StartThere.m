%����������������UI���
clear; 
close all;

% %%
% ����ǰ��ȷ���Ѿ�����������ã�Ȼ������ɾ�����¼��У�
% 1 ��װ Matlab Simulink 3D Animation ������
% 2 ��װ Matlab Aerospace Toolbox ������
% 3 ��MATLAB��ݷ�ʽ��ѡ������ -> ������ -> ���ĸ�DPI���� -> ��ѡ�����DPI������Ϊ
% 4 �ӽǿ�������÷����ڡ��հ�figure�����϶�����ƶ��ӽǣ���A W S D �� R F �ƶ�λ��
% 5 ����ͼ��������� 20203.png�����滻������ͼ��ʱ��Ϊ�˷�ֹ�����������ͼ������������Σ��� ����=����
% %%

set(0,'DefaultFigureMenu','none')
global fig viewpoint_access world

nav     %�ӽǿ���������
        %�ӽǿ�������÷����ڿհ�figure���϶�����ƶ��ӽǣ���A W S D �� R F �ƶ�λ��
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
set(fig,'Position',[0 40 500 500]);%�������ı������ڵĴ�С��λ��
set(fig,'Name','<------����ý����Ӧ������');
vrdrawnow; 
viewpoint_access=vrnode(world, 'zero'); 
vrdrawnow; 



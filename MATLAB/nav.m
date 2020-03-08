%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%视角控制%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure('position',[100 100 200 200]);
axis([-1,1,-1,1]);
box on;

set(gcf,'WindowButtonDownFcn',@ButttonDownFcn);
set(gcf,'WindowButtonUpFcn',@ButttonUpFcn);
set(gcf,'KeyPressFcn',@myKeyPressFcn);


global init_point current_point
init_point=[0,0];
current_point = [0,0];
% 回调函数

function ButttonDownFcn(src,event)
global init_point init_direction fig init_cam_up
global ui_stick_ ui_stick_orig
    pt = get(gca,'CurrentPoint');
    init_point=[ pt(1,1),pt(1,2)];
    init_direction=get(fig,'CameraDirection');
    init_cam_up =get(fig,'CameraUpVector');
    src.WindowButtonMotionFcn = @ButttonMov;
    ui_stick_orig = ui_stick_;
    ui_stick_ = 0;
end

function ButttonUpFcn(src,event)
    global ui_stick_   ui_stick_orig
    ui_stick_ = ui_stick_orig;
    src.WindowButtonMotionFcn = '';
end

function ButttonMov(src,event)
global init_point current_point
    
    pt = get(gca,'CurrentPoint');
    current_point=[ pt(1,1),pt(1,2)];
    shift = current_point-init_point;
    rotate_vrfigure(shift);
%     plot(pt(1,1),pt(1,2),'*');
%     hold on
end


function myKeyPressFcn(src,event)
    global fig
    cam_d=get(fig,'CameraDirection');
    cam_u=get(fig,'CameraUpVector');
    cam_p=get(fig,'CameraPosition');
    sp = 10;
    filter = [1 0 0; 0 0 0; 0 0 1];
    if event.Key == 'w'
        cam_p = cam_p + sp*cam_d*filter;
    elseif event.Key == 's'
        cam_p = cam_p - sp*cam_d*filter;
    elseif event.Key == 'd'
        cam_p = cam_p + sp*cross(cam_d,cam_u)*filter;
    elseif event.Key == 'a'
        cam_p = cam_p - sp*cross(cam_d,cam_u)*filter;
    elseif event.Key == 'r'
        nn = norm(cam_d);
        cam_p = cam_p + sp*(cam_u-cam_u*cam_d'/(nn*nn)*cam_d);
    elseif event.Key == 'f'
        nn = norm(cam_d);
        cam_p = cam_p - sp*(cam_u-cam_u*cam_d'/(nn*nn)*cam_d);
    else 
        return
    end
    
    set(fig, 'CameraPosition', cam_p);


end


function rotate_vrfigure(shift)
global fig init_direction init_cam_up
    % ！degree used instead of rad！
    ratio = 20;
    shift = shift*1;
    norm_theta = norm(shift);          
    
    roll_axis1 = cross(init_direction,init_cam_up);
    roll_axis2 = init_cam_up;
    n_v = roll_axis1*(-shift(2)) + roll_axis2*shift(1);
    n_v = n_v/norm(n_v);
    
    norm_theta = norm_theta *ratio;                     %四元数转角
    q = [cosd(norm_theta/2) sind(norm_theta/2)*n_v];    %四元数
    new = quatrotate(q,init_direction);                 %这个函数用错了，这个是转坐标轴，向量固定情况用的，方向恰恰相反
                                                        %碰巧的是前面方向负号也加错了，错错成对
    set(fig, 'CameraDirection', new');
end
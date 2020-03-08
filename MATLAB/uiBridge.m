function uiBridge(state,time)
global Fighter world

%state �������У�ÿ��һ����������Ŀǰֻ��һ��

state = state(1,:);

vehicle_class = state(1);
vehicle_id  = state(2);

E_pos    = state(3);
N_pos   = state(4);
S_pos   = state(5);

head    = state(6);
pitch   = state(7);
roll    = state(8);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% ENS ��-��-�� ����ϵ %%%%%%%%%%%%%%%%%%%%%%%%%%
qmodel =    [cosd(0/2)   sind(0/2)*[ 0  0  1]];       %ģ�ߵĻ�ͷָ��У��
qhd=        [cosd(head/2)  sind(head/2)*[  0  0  1]];
qpt=        [cosd(pitch/2) sind(pitch/2)*[ 1  0  0]];
qrl=        [cosd(roll/2)  sind(roll/2)*[  0  1  0]];
quat_Body_to_ENS = quatmultiply(quatmultiply(quatmultiply(qhd,qpt),qrl),qmodel);%��Ԫ���ĳ˷��������������������,�����㽻����
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%****************************************************************************
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% VR UI ����ϵ %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%  1  translation
VR_position = ENS_to_VR([E_pos,N_pos,S_pos]);%�Ӷ���������ϵ ת�� VR ����ϵ����y��ȡ����Ȼ�󽻻�y���z�ᣩ
VR_position_orig = [0,10,-0];


%  2  rotation
quat_Body_to_VR = ENS_to_VR_quat_change(quat_Body_to_ENS);
Fighter.rotation = quat2SFRotation(quat_Body_to_VR);
Fighter.translation=VR_position'+VR_position_orig;
global ui_stick_
if ui_stick_==1
ui_stick(Fighter);
end
show_track(time,Fighter.translation);

set(world, 'Time', time)
vrdrawnow; 

end

function show_track(time,translation_p)
    global ball world
    global cnt_track ;
    if isempty(cnt_track)
        cnt_track=0;
    end
    cnt_track=cnt_track+1;
    ball2 = vrnode(world, 'time'+string(cnt_track) , 'Transform');
    vrnode(ball2,'children', 'USE', ball.children);

    ball2.translation=translation_p;
    ball2.scale=[1,1,1];
end


function ui_stick(plane)
global fig viewpoint_access
quat = SFRotation2quat(plane.rotation);
dir_new = quatrotate(quatinv(quat), [0 -1 2]);%�ڶ��������ϣ�����������ǰ
plane_forward = quatrotate(quatinv(quat), [0 0 1]); %��ȡ��ָ��ɻ�ǰ��������

quat_cam = quatmultiply(quat,[cosd(-180/2) sind(-180/2)*[0 1 0]]);
orientation = quat2SFRotation(quat_cam);


viewpoint_access.position = plane.translation + dir_new*(-10) + plane_forward*(-20);
viewpoint_access.orientation = orientation;

set(fig, 'Viewpoint', 'zero');


end


function sr = quat2SFRotation(quat)
    quat = quatnormalize(quat);
    theta = acos(quat(1))*2;
    vec_n = quat(2:4)./sin(theta/2);
    sr = [vec_n,theta];
end
function quat = SFRotation2quat(SFR)
    quat = [cos(SFR(4)/2) sin(SFR(4)/2)*SFR(1:3)];

end
function new_coodinate = ENS_to_VR(coodinate)
    q = size(coodinate);
    if q(1)==1
        coodinate = coodinate';
    end
    new_coodinate = [ 1 0  0; ...
                      0 0  1; ...
                      0 -1 0;
                    ]*coodinate;
end

function new_coodinate = ENS_to_VR2(coodinate)
    q = size(coodinate);
    if q(1)>1   %Ҫ��������
        coodinate = coodinate';
    end

    q = [cosd(45) sind(45)*[1 0 0]];
    new_coodinate = quatrotate(q,coodinate);    %�����������궯
    %new_coodinate = quatmultiply(quatmultiply(q,[0 coodinate]),quatinv(q));    %���궨,������,��׼д��
    %new_coodinate = quatrotate(quatinv(q), coodinate);    %���궨,������,д��2
end

function new_quat_VR = ENS_to_VR_quat_change(quat_ENS)
    qq = size(quat_ENS);
    if qq(1)>1   %Ҫ��������
        quat_ENS = quat_ENS';
    end
    quat_ENS = quatnormalize(quat_ENS);
    q = [cosd(45) sind(45)*[1 0 0]];
    new_quat_VR = quatmultiply(quatmultiply(quatinv(q),quat_ENS),q);    %�����������궯
    %new_coodinate = quatmultiply(quatmultiply(q,[0 coodinate]),quatinv(q));    %���궨,������,��׼д��
    %new_coodinate = quatrotate(quatinv(q), coodinate);    %���궨,������,д��2
end

% % Define the parameter t 
% n=10; 
% t=0:0.02:n*pi; 
%  
% % Define a and b 
% a=8; 
% b=8; 
%  
% for i=1:length(t) 
%     pause (0.01); 
%     vector_position=[a*cos(t(i))*10  b*sin(t(i))*10  3]; 
%     % Translation setting for the Plane node 
%     uiBridge([0 0    ,vector_position,   t(i)*180/pi  0  t(i)*180/pi]) ;
%     
% 
% end 
global world cnt_track
cnt_track = 0
for  i = 1:50000
    time = i;
    try
        ballx = vrnode(world, 'time'+string(time));
        delete(ballx)
    catch err
         break
    end

end
global ui_stick_
ui_stick_ = 0
% load('ScopeData1.mat')
y=ScopeData1;
x_data_record = y.signals(1).values;
y_data_record = y.signals(2).values;
z_data_record = y.signals(3).values;
phi_data_record = y.signals(4).values;
theta_data_record = y.signals(5).values;
psi_data_record = y.signals(6).values;
time_record = y.time;


for i = 1:length(time_record)
    
    roll = phi_data_record(i);
    pitch = theta_data_record(i);
    yaw = -psi_data_record(i);
    

    x_earth = x_data_record(i)*10;
    y_earth = y_data_record(i)*10;
    z_earth = z_data_record(i)*10;
    WTF2ENS = [0 1 0; 1 0 0; 0 0 1];%Ωªªªx y£¨ z»°∏∫
    vector_position = WTF2ENS*[x_earth;y_earth;z_earth];
    
    WTF2ENS_YawRollPitch = [-1 0 0; 0 1 0; 0 0 1];
    Head_Pitch_Roll = WTF2ENS_YawRollPitch*([yaw, pitch, roll])';
    
    time=time_record(i);
    uiBridge([0 0  ,vector_position' , Head_Pitch_Roll'],time);
    pause(0.01)
end



















function [r1 ,r2 ,r3] = my_quat2angle(qq)
qin = ( qq );
[r1,r2,r3] = threeaxisrot( 2.*(qin(:,2).*qin(:,3) + qin(:,1).*qin(:,4)), ...
                                   qin(:,1).^2 + qin(:,2).^2 - qin(:,3).^2 - qin(:,4).^2, ...
                                  -2.*(qin(:,2).*qin(:,4) - qin(:,1).*qin(:,3)), ...
                                   2.*(qin(:,3).*qin(:,4) + qin(:,1).*qin(:,2)), ...
                                   qin(:,1).^2 - qin(:,2).^2 - qin(:,3).^2 + qin(:,4).^2);

end
function [r1,r2,r3] = threeaxisrot(r11, r12, r21, r31, r32)
    % find angles for rotations about X, Y, and Z axes
    r1 = atan2( r11, r12 );
    r2 = asin( r21 );
    r3 = atan2( r31, r32 );
end
function qqq = my_quatinv(qq)
    qq(2:4)=-qq(2:4);
    qqq=qq;
end

function qout = my_quatrotate(q, r)
    dcm = my_quat2dcm(q);
    if ( size(q,1) == 1 ) 
        % Q is 1-by-4
        qout = (dcm*r')';
    end
end

function dcm = my_quat2dcm( q )
qin =  q ;
dcm = zeros(3,3,size(qin,1));
dcm(1,1,:) = qin(:,1).^2 + qin(:,2).^2 - qin(:,3).^2 - qin(:,4).^2;
dcm(1,2,:) = 2.*(qin(:,2).*qin(:,3) + qin(:,1).*qin(:,4));
dcm(1,3,:) = 2.*(qin(:,2).*qin(:,4) - qin(:,1).*qin(:,3));
dcm(2,1,:) = 2.*(qin(:,2).*qin(:,3) - qin(:,1).*qin(:,4));
dcm(2,2,:) = qin(:,1).^2 - qin(:,2).^2 + qin(:,3).^2 - qin(:,4).^2;
dcm(2,3,:) = 2.*(qin(:,3).*qin(:,4) + qin(:,1).*qin(:,2));
dcm(3,1,:) = 2.*(qin(:,2).*qin(:,4) + qin(:,1).*qin(:,3));
dcm(3,2,:) = 2.*(qin(:,3).*qin(:,4) - qin(:,1).*qin(:,2));
dcm(3,3,:) = qin(:,1).^2 - qin(:,2).^2 - qin(:,3).^2 + qin(:,4).^2;
end
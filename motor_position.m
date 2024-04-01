J = 3.2284E-6;
b = 3.5007E-6;
K = 0.0274;
R = 4;
L = 2.75E-6;
s = tf('s');
P_motor = K / (s*((J*s+b)*(L*s+R)+K^2));
zpk(P_motor);
Ts = 0.001;
dp_motor = c2d(P_motor,Ts,'zoh');
zpk(dp_motor);
dp_motor = minreal(dp_motor,0.001);
zpk(dp_motor);
sys_cl = feedback(dp_motor,1);
[x1,t] = step(sys_cl, 0.5);
stairs(t,x1)
xlabel('Time (seconds)')
ylabel('Position (radians)')
title('Stairstep response (original)')
grid
%controlSystemDesigner('rlocus',dp_motor)
%dist_cl = feedback(dp_motor,C);
%[x2,t] = step(dist_cl, 0.25);
%stairs(t,x2)
%xlabel('Time (seconds)')
%ylabel('Position (rad)')
%title('Stairstep Disturbance response with compensation')
%grid

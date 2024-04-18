N = 100;
T = 1000;
x = linspace(-50, 50, N);
t = linspace(0, T, N);

m = 0;
sol = pdepe(m,@pdefun,@pdeic,@pdebc,x,t);

u1 = sol(:,:,1);
u2 = sol(:,:,2);

figure
subplot(1,2,1), surf(x,t,u1); colorbar;
title('u_1(x,t)')
xlabel('Distance x'); ylabel('Time t'); grid on
subplot(1,2,2), surf(x,t,u2); colorbar;
title('u_2(x,t)')
xlabel('Distance x'); ylabel('Time t'); grid on

figure
surf(x,t,u1); title('u_1(x,t)'); colorbar
xlabel('Distance x'); ylabel('Time t'); grid on
hold on
surf(x,t,u2); title('u_1(x,t) and u_2(x,t)'); colorbar
xlabel('Distance x'); ylabel('Time t'); grid on
legend('u(x,t)', 'v(x,t)', Location='best');

function [c,f,s] = pdefun(x,t,u,dudx) % Equation to solve
c = [1; 1];
f = [1; 0.01] .* dudx;
y1 = u(1);
y2 = u(2);
F = -y1*y2^2 + 0.09*(1-y1);
G = y1*y2^2 - 0.0862*y2;
s = [F; G];
end
% ---------------------------------------------
function u0 = pdeic(x) % Initial Conditions
u1 = 1 - 1/2*(sin(pi*(x-50)/100))^100;
u2 = 1/4*(sin(pi*(x-50)/100))^100;
u0 = [u1; u2];
end
% ---------------------------------------------
function [pl,ql,pr,qr] = pdebc(xl,ul,xr,ur,t) % Boundary Conditions
pl = [0; ul(2)];
ql = [1; 0];
pr = [ur(1); 0];
qr = [0; 1];
end
% Gray-Scott Reaction-Diffusion Model
% Implementation in MATLAB

% Parameters
L = 1000; % size of grid
Du = 0.16; % diffusion rate of u
Dv = 0.08; % diffusion rate of v
F = 0.04; % feed rate
k = 0.06; % kill rate
frame_rate = 10; % Set the frame rate (frames per second) 

r=(1-((4*(F+k)*(F+k))/F))^0.5;
v1=(F/(2*(F+k)))*(1+r);
v2=(F/(2*(F+k)))*(1-r);
check1=(((Dv*(v1*v1+F)-Du*(F+k))^2)/(4*Du*Dv)) + (F+k)*(-1*v1*v1 +F);
check2=(((Dv*(v2*v2+F)-Du*(F+k))^2)/(4*Du*Dv)) + (F+k)*(-1*v2*v2 +F);

if(check1>0)
    disp("Point u1,v1 is unstable");
end
if(check2>0)
    disp("point u2,v2 is unstable");
end

% Initialize concentrations
[u, v] = meshgrid(linspace(0, 1, L), linspace(0, 1, L));

% Set initial conditions (stripes-like pattern)
stripe_width = 0.1; % adjust the width of the stripes as needed
stripe_frequency = 6; % adjust the frequency of the stripes as needed
u = 0.5 + 0.5 * sin(2 * pi * stripe_frequency * u);
v = 0.25 + 0.25 * sin(2 * pi * stripe_frequency * v);

% Create VideoWriter object with specified frame rate
writerObj = VideoWriter('dotted_animation.mp4', 'MPEG-4');
writerObj.FrameRate = frame_rate; % Set the frame rate
open(writerObj);

% Initialize figure
figure;

% Visualization
figure;
subplot(1,3,1);
initial_u_image = cat(3, u, zeros(size(u)), zeros(size(u))); % Red channel for u
imshow(initial_u_image);
title('Initial Concentration of u');
subplot(1,3,2);
initial_v_image = cat(3, zeros(size(v)), v, zeros(size(v))); % Green channel for v
imshow(initial_v_image);
title('Initial Concentration of v');

% Simulation
dt = 1; % time step
T = 80; % total simulation time
for t = 1:T
    % Compute Laplacian
    laplacian_u = del2(u);
    laplacian_v = del2(v);
    
    % Update concentrations
    u_next = u + (Du * laplacian_u - u .* v.^2 + F * (1 - u)) * dt;
    v_next = v + (Dv * laplacian_v + u .* v.^2 - (F + k) * v) * dt;
    
    % Boundary conditions (periodic boundary conditions)
    u_next(:,1) = u_next(:,end-1);
    u_next(:,end) = u_next(:,2);
    u_next(1,:) = u_next(end-1,:);
    u_next(end,:) = u_next(2,:);
    
    v_next(:,1) = v_next(:,end-1);
    v_next(:,end) = v_next(:,2);
    v_next(1,:) = v_next(end-1,:);
    v_next(end,:) = v_next(2,:);
    
    % Update concentrations for next iteration
    u = u_next;
    v = v_next;
    
    % Display current iteration every 1000 steps
    if mod(t,1) == 0
        disp(['Iteration: ', num2str(t)]);
        subplot(1,3,3);
        combined_image = cat(3, u, v, zeros(size(u))); % Superimpose u and v
        imshow(combined_image);
        title(['Superimposed at t = ', num2str(t)]);
        drawnow;
    end
     % Write frame to video
    writeVideo(writerObj, getframe(gcf));
end
% Close VideoWriter object
close(writerObj);
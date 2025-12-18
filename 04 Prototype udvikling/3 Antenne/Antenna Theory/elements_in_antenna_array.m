% close all
% clear all
% clc

% --- 1. Define Constants ---
f = 2441.75e6;             % Frequency in Hz
c = 3e8;                % Speed of light in m/s
lambda = c / f;         % Wavelength
k = 2 * pi / lambda;    % Wavenumber
d = lambda*0.99;         % Element spacing (Half-wavelength)
N = 4;                  % Number of elements
Gain_of_1_antenna = 10^(2.81/10); %gain of subarray: 5.776
                           %gain of single antenna: 2.81
% Beta calculation from your screenshot: beta = -k*d
beta = 0; 
disp('d')
disp(d)

% --- 2. Define the Angle (Theta) ---
% We go from 0 to 2*pi to create the full "Unit Circle"
theta = linspace(0, 2*pi, 1000); 
% --- 3. Define the Cut (PHI) ---
% Choose your view!
% phi_cut = 0;          % H-Plane Cut (XZ plane)
phi_cut = 90 * pi/180;  % E-Plane Cut (YZ plane) - Standard for this formula

% --- 4. Calculate Psi (Array Factor of the Array) ---
% Assumes array elements are stacked along the Z-axis
psi = k * d * cos(theta) + beta;

numerator = sin((N / 2) * psi);
denominator = sin((1 / 2) * psi) + eps; 
AF = numerator ./ denominator;
 
% --- 5. Calculate Patch Element Factor (Single Element) ---
% Using the formula: 2*cos( (k*Le/2) * sin(theta) * sin(phi) )
% % Note: We use 'Le' here, which is the patch length. Your previous code used 'd'.
% AF_patch = 2 * cos( (k * d / 2) * sin(theta) * sin(phi_cut) );
% 
% % Total Pattern = Element Pattern * Array Factor
% AF_patch_array = AF_patch .* AF .* Gain_of_1_antenna;

% --- Magnitude for Plotting ---
AF_mag = Gain_of_1_antenna/N * AF.^2;

%AF_patch_mag = abs(AF_patch_array); % Already includes gain from line above

%% 2D plot---
figure;
% 'polarplot' is the modern MATLAB function for this (requires R2016a or newer)
h = polarplot(theta, (abs(AF_mag)));
hold on;
% g = polarplot(theta, AF_patch_array);
% hold off;
% --- Customize the Axes ---
% pax = gca; % Get Current Axes
% pax.ThetaZeroLocation = 'top';  % Rotates the grid so 0 is at the top
% pax.ThetaDir = 'clockwise';     % Optional: Makes angles go 0 -> 90 -> 180 like a clock
%                                 % (Remove this line if you want standard math direction)
% pax.ThetaLim = [-90 90];
                                % Styling the plot
set(h, 'LineWidth', 1, 'Color', 'b');
% set(g, 'LineWidth', 1, 'Color', 'r');
title('Radiation Pattern');
grid on;

disp('Isotropic antenna array gain (dB):')
disp(10*log10(max(AF_mag)))
disp('Linear gain')
disp(max(AF_mag))
%disp(10*log10(max(AF_patch_array)))
% If you are using an older version of MATLAB that doesn't have 'polarplot',
% use the command below instead:
% polar(theta, AF_norm)

%% 3D plot

% --- 2. Create a 3D Grid (Theta and Phi) ---
% Theta: Angle from the Z-axis (0 to 180 degrees / Pi)
% Phi:   Azimuth angle around the Z-axis (0 to 360 degrees / 2*Pi)
theta_1d = linspace(0, pi, 300);      % Use enough points for smoothness
phi_1d   = linspace(0, 2*pi, 300);
[theta, phi] = meshgrid(theta_1d, phi_1d);

% --- 3. Calculate AF on the 3D Grid ---
psi = k * d * cos(theta) + beta;

numerator = sin((N / 2) * psi);
denominator = sin((1 / 2) * psi) + eps;
AF = numerator ./ denominator;

% Magnitude (Radius in spherical coordinates)
R = abs(AF);
% Normalize
%R = R / max(max(R));

% --- 4. Convert Spherical to Cartesian (X, Y, Z) ---
% MATLAB's standard antenna conversion:
% Z is the axis of the array.
X = R .* sin(theta) .* cos(phi);
Z = R .* sin(theta) .* sin(phi);
Y = R .* cos(theta);

% --- 5. Plot in 3D ---
figure;
surf(X, Y, Z, 'EdgeColor', 'none'); % 'none' removes grid lines for a smooth look

% --- Visual Styling ---
colormap(jet);          % 'jet' or 'parula' gives nice heat map colors
colorbar;               % Shows the color scale (Intensity)
axis equal;             % Essential so the shape isn't squashed
xlabel('X'); ylabel('Y'); zlabel('Z');
title('3D Radiation Pattern (Linear Array)');

% Add a light to make it look 3D and shiny
 camlight;
 lighting gouraud;
view(3); % Set default 3D view
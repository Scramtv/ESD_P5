clc;
clear all;
close all;

load("Big_Motor_Data.mat");

%%%Big motor
disp("Big ass motor")

%% Step 1 (R)
disp("Step 1 (R)")

%Keeping the motor physical still
R_Big = ((mean(BigR.V_In)/((-1*mean(BigR.V_Ammeter))/(100*10^-3))));
disp(R_Big);

figure;
yyaxis left
ylabel("Voltage [V]")
plot(BigR.Time, BigR.V_In, DisplayName="Voltage"),
ylim([0 3.5])
hold on;
yyaxis right
ylabel("Current [A]")
plot(BigR.Time, (BigR.V_Ammeter*-1)/(100*10^-3), DisplayName="Current")
ylim([0 4.5])
grid on;
legend;
xlabel("Time [s]")
title("Current and voltage into the motor")
hold off

%% Step 2 (L)
disp("Step 2 (L)")
%Keeping the motor still
figure;
yyaxis left
plot(BigL.Time, BigL.V_In, 'DisplayName', "Voltage");
ylabel('Voltage [V]');
hold on;
yyaxis right
ylabel('Current [A]');
plot(BigL.Time, (BigL.V_Ammeter * -1) / (100 * 10^-3), 'DisplayName', "Current");
xlabel('Time [s]');
xlim([0.08 0.099])
grid on;
legend;
title('Inductor step response');

IMax = max((BigL.V_Ammeter * -1) / (100 * 10^-3));
Itau = IMax * 0.632;
yline(Itau, 'm--', {strcat("63.2% of "), strcat(string(round(IMax, 2)), ' A')}, ...
    'LabelVerticalAlignment', 'bottom', 'LabelHorizontalAlignment', 'left', 'HandleVisibility', 'off');

Xtau = 0.08442;
xline(Xtau, 'm--', {strcat(string(round(Xtau*10^3,2)), ' ms')}, 'LabelVerticalAlignment','bottom','HandleVisibility','off');

% Calculate the intersection point
current_at_Xtau = (BigL.V_Ammeter(find(BigL.Time == Xtau)) * -1) / (100 * 10^-3);
hold off;

L_Big = (Xtau-0.08183) * R_Big;
disp(L_Big)


%% Step 3 (Ke)
disp("Step 3 (Ke)")
%Let the motor run at a constant angular velocity
figure;
yyaxis left
plot(BigKe.Time, BigKe.V_In, "Blue", DisplayName="Voltage")
ylim([3 6.5])
ylabel("Voltage [V]")
hold on;
yyaxis right
plot(BigKe.Time, (-1*BigKe.V_Ammeter)/(100*10^-3), "red", DisplayName="Current")
ylim([0 2.6])
ylabel("Current [A]")
xlabel("Time [s]")
grid on;
legend;
hold off;


omega_Big = 15.75*2*pi;
Ke_Big = (((mean(BigKe.V_In)-R_Big*mean(-1*BigKe.V_Ammeter))/(100*10^-3))/omega_Big);
disp(Ke_Big)

%% Step 4 (Kt)
disp("Step 4 (Kt)")

%The motor is locked

figure;
yyaxis left
plot(BigKt.Time, -BigKt.V_Torque*(1/5), DisplayName="Torque")
ylim([0 0.5])
hold on
ylabel("Torque [Nm]")
yyaxis right
plot(BigKt.Time, (-1*BigKt.V_Ammeter)/(100*10^-3), DisplayName="Current")
ylim([0 4])
ylabel("Current [A]")
xlabel("Time [s]")
xlim([0.2576 0.258])
grid on;
legend;
title("Torque Response of the Locked Motor")
hold off;

Kt_Big = ((-mean(BigKt.V_Torque*(1/5)))/(mean((-1*BigKt.V_Ammeter)/(100*10^-3))));
disp(Kt_Big);

%% Step 5 Friction constant
disp("Friction constant")
%Let the motor run at a constant velocity
AngularMomentum = ([844, 1214, 1596, 2010, 2370, 2640, 2100, 3670, 4010, 4410]/9.549);
Torque_Data = [Kt_Big*mean(((-1*BigB_3V.V_Ammeter)/(100*10^-3))), Kt_Big*mean(((-1*BigB_4V.V_Ammeter)/(100*10^-3))), Kt_Big*mean(((-1*BigB_5V.V_Ammeter)/(100*10^-3))), Kt_Big*mean(((-1*BigB_6V.V_Ammeter)/(100*10^-3))), Kt_Big*mean(((-1*BigB_7V.V_Ammeter)/(100*10^-3))), Kt_Big*mean(((-1*BigB_8V.V_Ammeter)/(100*10^-3))), Kt_Big*mean(((-1*BigB_9V.V_Ammeter)/(100*10^-3))), Kt_Big*mean(((-1*BigB_10V.V_Ammeter)/(100*10^-3))), Kt_Big*mean(((-1*BigB_11V.V_Ammeter)/(100*10^-3))), Kt_Big*mean(((-1*BigB_12V.V_Ammeter)/(100*10^-3)))];


p = polyfit(AngularMomentum, Torque_Data, 1);

figure;
hold on;
plot(AngularMomentum, p(1)*AngularMomentum + p(2)); % Use the original x-values for plotting the fitted line
plot(AngularMomentum, Torque_Data, 'o');        % Optionally plot the original data points as well
xlabel('Angular momentum (\omega)');
ylabel('Torque (\tau)');
title('Linear Regression of \tau_{fric}  -  \omega');
grid on;

% R^2 script taken directly from chat GPT
% Calculate the predicted y-values based on the linear fit
y_predicted = polyval(p, AngularMomentum);

% Calculate the residuals (the difference between the actual and predicted y-values)
residuals = Torque_Data - y_predicted;

% Calculate the Total Sum of Squares (SST)
y_mean = mean(Torque_Data);
SST = sum((Torque_Data - y_mean).^2);

% Calculate the Residual Sum of Squares (SSR)
SSR = sum(residuals.^2);

% Calculate R-squared
R_squared = 1 - (SSR / SST);

% Display the R-squared value
text(150,0.04,{strcat('f(\omega)=',sprintf('%0.3e', p(1)),' * \omega','+',sprintf('%0.3e', p(2))), strcat('R^2=', string(R_squared))})

%%%Small motor
%%
clear all;
load("Small_Motor_Data.mat");

disp("Small ass motor")


%% Step 1 (R)
disp("Step 1 (R)")

%Keeping the motor physical still
R_Small = ((mean(SmallR.V_In)/((-1*mean(SmallR.V_Ammeter))/(100*10^-3))));
disp(R_Small);

figure;
yyaxis left
ylabel("Voltage [V]")
plot(SmallR.Time, SmallR.V_In, DisplayName="Voltage")
ylim([2 6.5])
hold on;
yyaxis right
ylabel("Current [A]")
plot(SmallR.Time, (SmallR.V_Ammeter*-1)/(100*10^-3), DisplayName="Current")
ylim([0 1])
xlabel("Time [s]")
xlim([0.25755 0.258])
grid on;
legend;
title("Current and voltage into the motor")
hold off

%% Step 2 (L)
disp("Step 2 (L)")
%Keeping the motor still
figure;
yyaxis left
plot(SmallL.Time, SmallL.V_In, 'DisplayName', "Voltage");
ylabel('Voltage [V]');
hold on;
yyaxis right
ylabel('Current [A]');
plot(SmallL.Time, (SmallL.V_Ammeter * -1) / (100 * 10^-3), 'DisplayName', "Current");
xlabel('Time [s]');
xlim([0.456 0.465])
grid on;
legend;
title('Inductor step response');

IMax = max((SmallL.V_Ammeter * -1) / (100 * 10^-3));
Itau = IMax * 0.632;
yline(Itau, 'm--', {strcat("63.2% of "), strcat(string(round(IMax, 2)), ' A')}, ...
    'LabelVerticalAlignment', 'bottom', 'LabelHorizontalAlignment', 'left', 'HandleVisibility', 'off');

Xtau = 0.4595;
xline(Xtau, 'm--', {strcat(string(round(Xtau*10^3,2)), ' mS')}, 'LabelVerticalAlignment','bottom','HandleVisibility','off');

% Calculate the intersection point
current_at_Xtau = (SmallL.V_Ammeter(find(SmallL.Time == Xtau)) * -1) / (100 * 10^-3);
hold off;

L_Small = (Xtau-0.4458925) * R_Small;
disp(L_Small)


%% Step 3 (Ke)
disp("Step 3 (Ke)")
%Let the motor run at a constant angular velocity
figure;
yyaxis left
plot(SmallKe.Time, SmallKe.V_In, "Blue", DisplayName="Voltage")
ylim([3 6.5])
ylabel("Voltage [V]")
hold on;
yyaxis right
plot(SmallKe.Time, (-1*SmallKe.V_Ammeter)/(100*10^-3), "red", DisplayName="Current")
ylim([0 1])
ylabel("Current [A]")
xlabel("Time [s]")
xlim([0.456 0.465])
grid on;
legend;
hold off;


omega_Small = 15.75*2*pi;
Ke_Small = ((mean(SmallKe.V_In)-R_Small*mean((-1*SmallKe.V_Ammeter)/(100*10^-3)))/omega_Small);
disp(Ke_Small)

%% Step 4 (Kt)
disp("Step 4 (Kt)")

%The motor is locked
figure;
yyaxis left
plot(SmallKt.Time, SmallKt.V_Torque*(1/5), DisplayName="Torque")
ylim([0.0 0.050])
hold on
ylabel("Torque [Nm]")
yyaxis right
plot(SmallKt.Time, (-1*SmallKt.V_Ammeter)/(100*10^-3), DisplayName="Current")
ylim([0 1.1])
ylabel("Current [A]")
xlabel("Time [s]")
grid on;
legend;
title("Torque Response of the Locked Motor")
hold off;

Kt_Small = ((mean(SmallKt.V_Torque*(1/5)))/(mean((-1*SmallKt.V_Ammeter)/(100*10^-3))));
disp(Kt_Small);

%% Step 5 Friction constant
disp("Friction constant")
%Let the motor run at a constant velocity
AngularMomentum = ([486, 657, 982, 1220, 1584]/9.549);
Torque_Data = [Kt_Small*mean(((-1*SmallB_6V.V_Ammeter)/(100*10^-3))), Kt_Small*mean(((-1*SmallB_7V.V_Ammeter)/(100*10^-3))), Kt_Small*mean(((-1*SmallB_8V.V_Ammeter)/(100*10^-3))), Kt_Small*mean(((-1*SmallB_9V.V_Ammeter)/(100*10^-3))), Kt_Small*mean(((-1*SmallB_10V.V_Ammeter)/(100*10^-3)))];



p = polyfit(AngularMomentum, Torque_Data, 1);

figure;
hold on;
plot(AngularMomentum, p(1)*AngularMomentum + p(2)); % Use the original x-values for plotting the fitted line
plot(AngularMomentum, Torque_Data, 'o');        % Optionally plot the original data points as well
xlabel('Angular momentum (\omega)');
ylabel('Torque (\tau)');
title('Linear Regression of \tau_{fric}  -  \omega');
grid on;

% R^2 script taken directly from chat GPT
% Calculate the predicted y-values based on the linear fit
y_predicted = polyval(p, AngularMomentum);

% Calculate the residuals (the difference between the actual and predicted y-values)
residuals = Torque_Data - y_predicted;

% Calculate the Total Sum of Squares (SST)
y_mean = mean(Torque_Data);
SST = sum((Torque_Data - y_mean).^2);

% Calculate the Residual Sum of Squares (SSR)
SSR = sum(residuals.^2);

% Calculate R-squared
R_squared = 1 - (SSR / SST);

% Display the R-squared value
text(110,0.016,{strcat('f(\omega)=',sprintf('%0.3e', p(1)),' * \omega','+',sprintf('%0.3e', p(2))), strcat('R^2=', string(R_squared))})

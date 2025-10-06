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
hold on;
yyaxis right
ylabel("Current [A]")
plot(BigR.Time, (BigR.V_Ammeter*-1)/(100*10^-3), DisplayName="Current")
grid on;
legend;
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
grid on;
legend;
title('Inductor step response');

IMax = max((BigL.V_Ammeter * -1) / (100 * 10^-3));
Itau = IMax * 0.632;
yline(Itau, 'm--', {strcat("63.2% of "), strcat(string(round(IMax, 2)), ' A')}, ...
    'LabelVerticalAlignment', 'bottom', 'LabelHorizontalAlignment', 'left', 'HandleVisibility', 'off');

Xtau = 0.08442;
xline(Xtau, 'm--', {strcat(string(round(Xtau*10^3,2)), ' mS')}, 'LabelVerticalAlignment','bottom','HandleVisibility','off');

% Calculate the intersection point
current_at_Xtau = (BigL.V_Ammeter(find(BigL.Time == Xtau)) * -1) / (100 * 10^-3);
hold off;

L_Big = Xtau * R_Big;
disp(L_Big)



%% Step 3 (Ke)
disp("Step 3 (Ke)")
%Let the motor run at a constant angular velocity
figure;
yyaxis left
plot(BigKe.Time, BigKe.V_In, "Blue", DisplayName="Voltage")
ylabel("Voltage [V]")
hold on;
yyaxis right
plot(BigKe.Time, (-1*BigKe.V_Ammeter)/(100*10^-3), "red", DisplayName="Current")
ylabel("Current [A]")
xlabel("Time [s]")
grid on;
legend;
hold off;


omega_Big = 15.75*2*pi;
Ke_Big = ((mean(BigKe.V_In)-R_Big*mean((-1*BigKe.V_Ammeter)/(100*10^-3)))/omega_Big);
disp(Ke_Big)

%% Step 4 (Kt)
disp("Step 4 (Kt)")

%The motor is locked

figure;
yyaxis left
plot(BigKt.Time, -BigKt.V_Torque*(1/5), DisplayName="Torque")
hold on
ylabel("Torque [Nm]")
yyaxis right
plot(BigKt.Time, (-1*BigKt.V_Ammeter)/(100*10^-3), DisplayName="Current")
ylabel("Current [A]")
xlabel("Time [s]")
grid on;
legend;
title("Torque Response of the Locked Motor")
hold off;

Kt_Big = ((-mean(BigKt.V_Torque*(1/5)))/(mean((-1*BigKt.V_Ammeter)/(100*10^-3))));
disp(Kt_Big);

%% Step 5 Friction constant
disp("Friction constant")
Tau_Data = ([450, 945, 1308, 1707, 2160, 2570, 2930, 3350, 3780, 4220, 4550]/9.549);
Current = [mean((-1*BigB_2V.V_Ammeter)/(100*10^-3)), mean((-1*BigB_3V.V_Ammeter)/(100*10^-3)), mean((-1*BigB_4V.V_Ammeter)/(100*10^-3)), mean((-1*BigB_5V.V_Ammeter)/(100*10^-3)), mean((-1*BigB_6V.V_Ammeter)/(100*10^-3)), mean((-1*BigB_7V.V_Ammeter)/(100*10^-3)), mean((-1*BigB_8V.V_Ammeter)/(100*10^-3)), mean((-1*BigB_9V.V_Ammeter)/(100*10^-3)), mean((-1*BigB_10V.V_Ammeter)/(100*10^-3)), mean((-1*BigB_11V.V_Ammeter)/(100*10^-3)), mean((-1*BigB_12V.V_Ammeter)/(100*10^-3))];

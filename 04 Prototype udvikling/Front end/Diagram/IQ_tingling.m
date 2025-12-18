% plot_sin_cos.m
x = linspace(0, 2*pi, 500);    % x from 0 to 2π
y1 = sin(x);                   % sine
y2 = cos(x);                   % cosine

figure;
plot(x, y1, 'LineWidth', 1.5, DisplayName="I component")
hold on
plot(x, y2, 'LineWidth', 1.5, DisplayName="Q component")
hold off
xlabel('Time');
ylabel('Amplitude');
title('I and Q components');
legend
xlim([0 6.28])
ylim([-1.5 1.5])
grid on;

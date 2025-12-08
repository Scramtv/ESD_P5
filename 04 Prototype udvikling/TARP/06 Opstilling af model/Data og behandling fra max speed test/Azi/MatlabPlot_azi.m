clc;
clear all;
close all;

current = '200_azi_current.txt';
motor = '200_azi_motor.txt';

table_motor = readtable(motor);
table_current = readtable(current);

% Syncer current op med motor målinger I.e. der hvor motoren startes = t0
    tick_current = table_current{:,3};
    
    % 1. Find the indices where the tick value is greater than 2.
    % 'start_indices' will be a list of all row numbers that satisfy the condition.
    start_indices = find(tick_current > 2, 1, 'first');
    
    % 2. Check if a valid starting point was found.
    if isempty(start_indices)
        % If no row is greater than 2, you might want to handle this error 
        % or just keep all data (depending on your requirement).
        warning('No row found where tick_current is greater than 2.');
    else
        % Get the row number of the FIRST occurrence.
        start_row = start_indices(1);
    end
    
    idle_current=mean(table_current{:,2}(1:start_row))*10

    % 3. Extract the desired data subset (from start_row to the end).
    time_current = table_current{:,1}(start_row:end);
    value_current = table_current{:,2}(start_row:end);

    value_current=value_current*10;

    time_current = time_current*1000; %Sikre samme tidsenhed (ms)
    time_current = time_current-time_current(1,1); %Sikre starttidspunkt = 0


value_current_smoothed = sgolayfilt(value_current, 3, 51);



time_motor = table_motor{:,1}-table_motor{1,1};

%Because direction was wrong, a minus is added
value_motor = -table_motor{:,2};


%Fit to smooth HF noise
value_motor_smooth = sgolayfilt(value_motor, 3, 51);


vel_motor = gradient(value_motor_smooth, time_motor);
figure;
yyaxis left;
plot(time_motor, vel_motor, 'DisplayName', 'Motor Speed (pulse/ms)')

hold on

plot(time_current, value_current_smoothed, 'DisplayName', 'Motor current (A)')

ylabel('Speed/current')

yyaxis right;

vel_motor_smoothed = sgolayfilt(vel_motor, 3, 51);

acc = gradient(vel_motor_smoothed, time_motor);
plot(time_motor, acc,'DisplayName', 'Motor acceleration d/dt(pulse/ms)')
ylabel('acceleration')
legend("motor speed", "current", "motor acc", 'Location', 'best')
xlabel('time in ms');
xlim([0 10e3])
hold off

% --- INTERACTIVE MEAN CALCULATION LOOP (Automated) ---

% FIX: Get the handle to the current figure (gcf) right before the loop.
figureHandle = gcf; 

disp('Click TWICE on the graph to define the start and end of the averaging window.');
disp('Press any key or close the figure window to stop.');



% Loop until the figure is closed
while ishandle(figureHandle)
    try
        % Get x, y coordinates of TWO clicks
        % NOTE: ginput(2) will wait for two mouse button presses
        [x_clicks, y_clicks, buttons] = ginput(2);
        
        % Break the loop if the figure is closed or a key is pressed
        if isempty(x_clicks) || length(x_clicks) < 2
            break; 
        end
        
        % Get the two time points and ensure they are sorted
        time_points = sort(x_clicks(1:2));
        time_start = time_points(1);
        time_end = time_points(2);
        
        % --- Core Logic: Find the data indices between the two times ---
        
        % 1. Find the index where time_motor is greater than or equal to time_start (start_idx)
        % 2. Find the index where time_motor is less than or equal to time_end (end_idx)
        
        % The 'true' is to ensure we get a list of logical indices, not the value 1.
        % The 'find' function is used to convert the logical indices to numerical row indices.
        
        % Find all indices between the start and end times
        start_idx = find(time_motor >= time_start, 1, 'first');
        end_idx = find(time_motor <= time_end, 1, 'last');
        
        % Check if a valid range was found (optional but good practice)
        if isempty(start_idx) || isempty(end_idx) || start_idx > end_idx
             disp('Error: Selected range is outside the data boundaries.');
             continue;
        end
        
        % --- 3. Calculate Means for the Sliced Data ---
        
        % 1. Slice and Mean Motor Speed
        speed_mean = mean(vel_motor(start_idx:end_idx));
        
        % 2. Slice and Mean Current Value
        % NOTE: Assuming time_current aligns closely enough with time_motor for these indices
        current_mean = mean(value_current_smoothed(start_idx:end_idx));
        
        % 3. Slice and Mean Acceleration
        acc_mean = mean(acc(start_idx:end_idx));
        
        % --- 4. Display Results ---
        fprintf('\n--- Mean Values Between %.3f ms and %.3f ms ---\n', time_start, time_end);
        fprintf('Avg. Speed: %.3f pulse/ms\n', speed_mean);
        fprintf('Avg. Current: %.3f A\n', current_mean);
        fprintf('Avg. Acceleration: %.10f pulse/ms²\n', acc_mean);
        
        % Optional: Add a visual marker for the selected area
        % We plot the mean value as a horizontal line segment
        line([time_start, time_end], [speed_mean, speed_mean], 'Color', 'k', 'LineWidth', 2, 'LineStyle', '--', 'Parent', findobj(figureHandle, 'YAxisLocation', 'left'));
        
    catch ME
        % Handle potential errors (e.g., figure closed unexpectedly)
        if strcmp(ME.identifier, 'MATLAB:ginput:FigureDeleted')
            break; 
        else
            disp(['An error occurred: ' ME.message]);
            break;
        end
    end
end

disp('Interactive mode stopped.');

load('elevator_data.mat');
figure;
plot(time_log, elevator1_positions, '-o', 'DisplayName', 'Elevator 1');
hold on;
plot(time_log, elevator2_positions, '-x', 'DisplayName', 'Elevator 2');
xlabel('Time (s)');
ylabel('Floor Position');
title('CCC Elevator Position vs Time');
legend;
grid on;
hold off;

data1 = load('elevator1_log.txt');
data2 = load('elevator2_log.txt');

% Separar tiempo y posiciones
time1 = data1(:, 1);
positions1 = data1(:, 2);

time2 = data2(:, 1);
positions2 = data2(:, 2);
figure;
plot(time1, positions1, '-o', 'DisplayName', 'Elevator 1');
hold on;
plot(time2, positions2, '-x', 'DisplayName', 'Elevator 2');
xlabel('Time (s)');
ylabel('Floor');
title('FCC Elevator Positions vs. Time');
legend show;
grid on;
hold off;

data_opt1 = load('elevator1_optimizedlog.txt');
data_opt2 = load('elevator2_optimizedlog.txt');

% Separar tiempo y posiciones
time_opt1 = data_opt1(:, 1);
positions_opt1 = data_opt1(:, 2);

time_opt2 = data_opt2(:, 1);
positions_opt2 = data_opt2(:, 2);
figure;
plot(time_opt1, positions_opt1, '-o', 'DisplayName', 'Elevator 1');
hold on;
plot(time_opt2, positions_opt2, '-x', 'DisplayName', 'Elevator 2');
xlabel('Time (s)');
ylabel('Floor');
title('OPTIMIZED Elevator Positions vs. Time');
legend show;
grid on;
hold off;

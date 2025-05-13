% Inicialization
initial_positions = [1, 10]; % Elevator 1 in floor 1, Elevator 2 in floor 10
elevator_speed = 2;
fprintf('Launching elevator simulations in parallel...\n');

% Starting parfeval for 2 elevators
pool = gcp(); % Creating a pool with 2 workers
futures = cell(1, 2);

for i = 1:2
    futures{i} = parfeval(pool, @Elevator_FCC_simulation, 0, i, initial_positions(i), elevator_speed);
end

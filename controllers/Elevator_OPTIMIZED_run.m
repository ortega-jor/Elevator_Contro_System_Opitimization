% Initialization of the variables
initial_positions = [1, 10]; % Elevator 1 in floor 1, Elevator 2 in floor 10
elevator_speed = 2;          
fprintf('Launching optimized elevator simulations in parallel...\n');

% Initialize Elevators with parfeval
pool = gcp(); % Creating a pool of 2 workers
futures = cell(1, 2);

for i = 1:2
    futures{i} = parfeval(pool, @Elevator_OPTIMIZED_simulation, 0, i, initial_positions(i), elevator_speed);
end
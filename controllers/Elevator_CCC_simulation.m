% Building characteristics
pos_elevator1 = 1;      % Current floor of elevator 1
pos_elevator2 = 10;     % Current floor of elevator 2
elevator_speed = 2;     % Time between floors in seconds
elevator1_busy = false; % Elevator 1 availability
elevator2_busy = false; % Elevator 2 availability

% Initialize position tracking arrays
time_log = []; % Shared time array
elevator1_positions = []; % Positions for Elevator 1
elevator2_positions = []; % Positions for Elevator 2

start_time = tic; % Start timer for logging

fprintf('Elevator Simulation Started.\n');

while true
    % Load the queue
    if exist('requests_queue.mat', 'file')
        load('requests_queue.mat', 'requests_queue');
    else
        requests_queue = [];
    end

    % Skip iteration if no requests
    if isempty(requests_queue)
        current_time = toc(start_time); % Current elapsed time
        time_log = [time_log; current_time]; % Log time
        elevator1_positions = [elevator1_positions; pos_elevator1]; % Log Elevator 1
        elevator2_positions = [elevator2_positions; pos_elevator2]; % Log Elevator 2

        if ~elevator1_busy
            fprintf('Elevator 1 is idle at floor %d.\n', pos_elevator1);
        end
        if ~elevator2_busy
            fprintf('Elevator 2 is idle at floor %d.\n', pos_elevator2);
        end
        pause(1);
        continue;
    end

    % Process the first request
    origin = requests_queue(1, 1);
    destination = requests_queue(1, 2);
    requests_queue(1, :) = []; % Remove the request from the queue
    save('requests_queue.mat', 'requests_queue'); % Update queue

    % Calculate distances to the origin
    dist_elevator1 = abs(pos_elevator1 - origin);
    dist_elevator2 = abs(pos_elevator2 - origin);

    if ~elevator1_busy && ~elevator2_busy
        % Assign to the closest idle elevator
        if dist_elevator1 <= dist_elevator2
            fprintf('Assigning request to Elevator 1 (closer: %d floors away).\n', dist_elevator1);
            
            % MOVEMENT OF ELEVATOR 1
            fprintf('Elevator 1: Moving to floor %d to pick up the client.\n', origin);
            % Move to the origin
            while pos_elevator1 ~= origin
                fprintf('Elevator 1: At floor %d.\n', pos_elevator1);
                current_time = toc(start_time);
                time_log = [time_log; current_time]; % Log time
                elevator1_positions = [elevator1_positions; pos_elevator1];
                elevator2_positions = [elevator2_positions; pos_elevator2];

                pos_elevator1 = pos_elevator1 + sign(origin - pos_elevator1);
                pause(elevator_speed);
            end
            fprintf('Elevator 1: Picked up the client at floor %d.\n', origin);
            pause(3);
        
            % Move to the destination
            fprintf('Elevator 1: Moving to floor %d to drop off the client.\n', destination);
            while pos_elevator1 ~= destination
                fprintf('Elevator 1: At floor %d.\n', pos_elevator1);   
                current_time = toc(start_time);
                time_log = [time_log; current_time]; % Log time
                elevator1_positions = [elevator1_positions; pos_elevator1];
                elevator2_positions = [elevator2_positions; pos_elevator2];

                pos_elevator1 = pos_elevator1 + sign(destination - pos_elevator1); 
                pause(elevator_speed);
            end
            fprintf('Elevator 1: Dropped off the client at floor %d.\n', destination);
            pause(3);
            % Mark the elevator as idle
            busy = false;

        else
            fprintf('Assigning request to Elevator 2 (closer: %d floors away).\n', dist_elevator2);
            
            % MOVEMENT OF ELEVATOR 2
            fprintf('Elevator 2: Moving to floor %d to pick up the client.\n', origin);
            % Move to the origin
            while pos_elevator2 ~= origin
                fprintf('Elevator 2: At floor %d.\n', pos_elevator2);
                current_time = toc(start_time);
                time_log = [time_log; current_time]; % Log time
                elevator2_positions = [elevator2_positions; pos_elevator2];
                elevator1_positions = [elevator1_positions; pos_elevator1];
                
                pos_elevator2 = pos_elevator2 + sign(origin - pos_elevator2);
                pause(elevator_speed);
            end
            fprintf('Elevator 2: Picked up the client at floor %d.\n', origin);
            pause(3);

            % Move to the destination
            fprintf('Elevator 2: Moving to floor %d to drop off the client.\n', destination);
            while pos_elevator2 ~= destination
                fprintf('Elevator 2: At floor %d.\n', pos_elevator2);
                current_time = toc(start_time);
                time_log = [time_log; current_time]; % Log time
                elevator2_positions = [elevator2_positions; pos_elevator2];
                elevator1_positions = [elevator1_positions; pos_elevator1];

                pos_elevator2 = pos_elevator2 + sign(destination - pos_elevator2);               
                pause(elevator_speed);
            end
            fprintf('Elevator 2: Dropped off the client at floor %d.\n', destination);
            pause(3);
            % Mark the elevator as idle
            busy = false;
        end

    elseif ~elevator1_busy
        % Assign to Elevator 1 if Elevator 2 is busy
        fprintf('Elevator 1 is free. Assigning request to Elevator 1.\n');
        % MOVEMENT OF ELEVATOR 1
            fprintf('Elevator 1: Moving to floor %d to pick up the client.\n', origin);
            % Move to the origin
            while pos_elevator1 ~= origin
                fprintf('Elevator 1: At floor %d.\n', pos_elevator1);
                current_time = toc(start_time);
                time_log = [time_log; current_time]; % Log time
                elevator1_positions = [elevator1_positions; pos_elevator1];
                elevator2_positions = [elevator2_positions; pos_elevator2];

                pos_elevator1 = pos_elevator1 + sign(origin - pos_elevator1);
                pause(elevator_speed);
            end
            fprintf('Elevator 1: Picked up the client at floor %d.\n', origin);
            pause(3);
        
            % Move to the destination
            fprintf('Elevator 1: Moving to floor %d to drop off the client.\n', destination);
            while pos_elevator1 ~= destination
                fprintf('Elevator 1: At floor %d.\n', pos_elevator1);   
                current_time = toc(start_time);
                time_log = [time_log; current_time]; % Log time
                elevator1_positions = [elevator1_positions; pos_elevator1];
                elevator2_positions = [elevator2_positions; pos_elevator2];

                pos_elevator1 = pos_elevator1 + sign(destination - pos_elevator1); 
                pause(elevator_speed);
            end
            fprintf('Elevator 1: Dropped off the client at floor %d.\n', destination);
            pause(3);
            % Mark the elevator as idle
            busy = false;

    elseif ~elevator2_busy
        % Assign to Elevator 2 if Elevator 1 is busy
        fprintf('Elevator 2 is free. Assigning request to Elevator 2.\n');
        % MOVEMENT OF ELEVATOR 2
            fprintf('Elevator 2: Moving to floor %d to pick up the client.\n', origin);
            % Move to the origin
            while pos_elevator2 ~= origin
                fprintf('Elevator 2: At floor %d.\n', pos_elevator2);
                current_time = toc(start_time);
                time_log = [time_log; current_time]; % Log time
                elevator2_positions = [elevator2_positions; pos_elevator2];
                elevator1_positions = [elevator1_positions; pos_elevator1];
                
                pos_elevator2 = pos_elevator2 + sign(origin - pos_elevator2);
                pause(elevator_speed);
            end
            fprintf('Elevator 2: Picked up the client at floor %d.\n', origin);
            pause(3);

            % Move to the destination
            fprintf('Elevator 2: Moving to floor %d to drop off the client.\n', destination);
            while pos_elevator2 ~= destination
                fprintf('Elevator 2: At floor %d.\n', pos_elevator2);
                current_time = toc(start_time);
                time_log = [time_log; current_time]; % Log time
                elevator2_positions = [elevator2_positions; pos_elevator2];
                elevator1_positions = [elevator1_positions; pos_elevator1];

                pos_elevator2 = pos_elevator2 + sign(destination - pos_elevator2);               
                pause(elevator_speed);
            end
            fprintf('Elevator 2: Dropped off the client at floor %d.\n', destination);
            pause(3);
            % Mark the elevator as idle
            busy = false;
    else
        % Both elevators are busy; skip the iteration
        fprintf('Both elevators are busy. Waiting...\n');
        pause(1);
    end
end


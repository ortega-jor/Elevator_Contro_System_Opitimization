% Building characteristics
pos_elevator1 = 1;      % Current floor of elevator 1
elevator_speed = 2;     % Time between floors in seconds
fprintf('Elevator Simulation Started.\n');

while true
    % Load the queue
    if exist('requests_queue.mat', 'file')
        load('requests_queue.mat', 'requests_queue');
    else
        requests_queue = [];
    end

    if isempty(requests_queue)
        fprintf('No requests in the queue. Elevator is idle at floor %d.\n', pos_elevator1);
        pause(1);
        continue;
    end

% Process the first request
    origin = requests_queue(1, 1);
    destination = requests_queue(1, 2);
    fprintf('Request received: Moving to floor %d to go to the destination: floor %d\n', origin, destination);
    requests_queue(1, :) = [];  % Remove the request from the queue
    save('requests_queue.mat', 'requests_queue');  % Update the queue in the .mat file

    % Move to the origin
    fprintf('Moving to floor %d to pick up the client.\n', origin);
    while pos_elevator1 ~= origin
        pos_elevator1 = pos_elevator1 + sign(origin - pos_elevator1);
        fprintf('Elevator at floor %d.\n', pos_elevator1);
        pause(elevator_speed);
    end
    fprintf('Picked up the client at floor %d.\n', pos_elevator1);

    % Move to the destination
    fprintf('Moving to floor %d to drop off the client.\n', destination);
    while pos_elevator1 ~= destination
        pos_elevator1 = pos_elevator1 + sign(destination - pos_elevator1);
        fprintf('Elevator at floor %d.\n', pos_elevator1);
        pause(elevator_speed);
    end
    fprintf('Dropped off the client at floor %d.\n', pos_elevator1);
end
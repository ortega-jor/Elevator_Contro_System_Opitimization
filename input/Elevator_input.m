% Initialize requests_queue if not present
if exist('requests_queue.mat', 'file')
    load('requests_queue.mat', 'requests_queue');
else
    requests_queue = [];
end

% Simulation loop
while true
    fprintf('=== Solicitar un ascensor ===\n');   
    origin = input('In what floor is the client? (1-10, Type 0 to exit): ');   
    if origin == 0
        fprintf('End of Input Script.\n');
        break;
    end
    if origin < 1 || origin > 10
        fprintf('Number not valid. Try again.\n');
        continue;
    end  
    destination = input('What floor are you heading to? (1-10): ');
    if destination < 1 || destination > 10 || destination == origin
        fprintf('Destination not valid. Try again.\n');
        continue;
    end   

    % Load again the .mat file to add the request in the updated queue
    if ~exist('requests_queue.mat', 'file')
        requests_queue = [];
    else
        load('requests_queue.mat', 'requests_queue');
    end
    
    % Append the new request
    requests_queue = [requests_queue; origin, destination]; %#ok<AGROW>
    save('requests_queue.mat', 'requests_queue');  % Save the queue to a .mat file
    fprintf('Updated requests_queue:\n');
    disp(requests_queue);
    pause(1);  % Allow for smoother operation
end
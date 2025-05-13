                                function Elevator_FCC_simulation(elevator_id, pos_initial, speed)
    pos_elevator = pos_initial;

    log_file = sprintf('elevator%d_log.txt', elevator_id);
    fid = fopen(log_file, 'w'); % Output file

    start_time = tic; % Inicia el temporizador
    pause(elevator_id*0.1); % Initial delay different for each elevator

    while true
        % Checks if there is another elevator opening the queue
        while exist('lock.mat', 'file')
            pause(0.1);
        end

        % Create lock
        save('lock.mat', 'elevator_id');

        % Cargar la cola
        if exist('requests_queue.mat', 'file')
            load('requests_queue.mat', 'requests_queue');
        else
            requests_queue = [];
        end

        if isempty(requests_queue)
            current_time = toc(start_time);
            fprintf(fid, '%f %d\n', current_time, pos_elevator);
            fprintf(fid, '%% Elevator %d: No requests. Elevator idle at floor %d.\n', elevator_id, pos_elevator);
            delete('lock.mat'); % Free the lock
            pause(1);
            continue;
        end

        % Tomar la primera solicitud
        origin = requests_queue(1, 1);
        destination = requests_queue(1, 2);
        requests_queue(1, :) = [];
        save('requests_queue.mat', 'requests_queue'); % Update the requests queue

        % Liberar el bloqueo
        delete('lock.mat');

        % Simular el movimiento del ascensor
        fprintf(fid, '%% Elevator %d: Request received: Origin = %d, Destination = %d.\n', elevator_id, origin, destination);
        fprintf(fid, '%% Elevator %d: Moving to floor %d to pick up client.\n', elevator_id, origin);

        % Movimiento al origen
        while pos_elevator ~= origin
            fprintf(fid, '%% Elevator %d: Elevator at floor %d.\n', elevator_id, pos_elevator);
            current_time = toc(start_time);
            fprintf(fid, '%f %d\n', current_time, pos_elevator); % Guardar tiempo y posición

            pos_elevator = pos_elevator + sign(origin - pos_elevator);           
            pause(speed);
        end
        fprintf(fid, '%% Elevator %d: Picked up client at floor %d.\n', elevator_id, origin);
        pause(3);

        % Movimiento al destino
        while pos_elevator ~= destination
            fprintf(fid, '%% Elevator %d: Elevator at floor %d.\n', elevator_id, pos_elevator);
            current_time = toc(start_time);
            fprintf(fid, '%f %d\n', current_time, pos_elevator); % Guardar tiempo y posición

            pos_elevator = pos_elevator + sign(destination - pos_elevator);
            pause(speed);
        end
        fprintf(fid, '%% Elevator %d: Dropped off client at floor %d.\n', elevator_id, destination);
        pause(3);
    end
end
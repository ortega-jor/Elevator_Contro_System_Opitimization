function Elevator_OPTIMIZED_simulation(elevator_id, pos_initial, elevator_speed)
    pos_elevator = pos_initial;
    
    log_file = sprintf('elevator%d_optimizedlog.txt', elevator_id);
    fid = fopen(log_file, 'w'); % Archivo para registrar mensajes

    start_time = tic; % Inicia el temporizador
    fprintf(fid, '%% Elevator %d: Optimization Simulation Started.\n', elevator_id);
    pause(elevator_id*0.1); % Retraso inicial proporcional al ID del ascensor

    while true
        % Espera si otro ascensor está accediendo a la cola
        while exist('lock.mat', 'file')
            pause(0.1); % Espera breve
        end

        % Crear el archivo de bloqueo
        save('lock.mat', 'elevator_id');

        % Cargar la cola de solicitudes
        if exist('requests_queue.mat', 'file')
            load('requests_queue.mat', 'requests_queue');
        else
            requests_queue = [];
        end

        % Liberar el bloqueo si no hay solicitudes
        if isempty(requests_queue)
            current_time = toc(start_time);
            fprintf(fid, '%f %d\n', current_time, pos_elevator);
            fprintf(fid, '%% Elevator %d: No requests. Elevator idle at floor %d.\n', elevator_id, pos_elevator);
            delete('lock.mat');
            pause(1);
            continue;
        end

        % Tomar la primera solicitud de la lista
        origin = requests_queue(1, 1);
        destination = requests_queue(1, 2);
        direction = sign(destination - origin);
        fprintf(fid, '%% Processing request: [%d -> %d] (Direction: %d).\n', origin, destination, direction);

        % Searching for additional requests in the same direction
        additional_requests = [];
        for i = 2:size(requests_queue, 1)
            req_origin = requests_queue(i, 1);
            req_destination = requests_queue(i, 2);

            if direction == 1 % Going up
                if req_origin >= origin && req_origin <= destination && req_destination > req_origin
                    additional_requests = [additional_requests; requests_queue(i, :)];
                end
            elseif direction == -1 % Going down
                if req_origin <= origin && req_origin >= destination && req_destination < req_origin
                    additional_requests = [additional_requests; requests_queue(i, :)];
                end
            end
        end

        % Grouping requests and deleting from queue
        all_requests = [origin, destination; additional_requests];
        requests_queue(ismember(requests_queue, all_requests, 'rows'), :) = [];
        save('requests_queue.mat', 'requests_queue');   % Actualizar la cola

        % Liberar el bloqueo
        delete('lock.mat');

        % Simular el movimiento del ascensor en un trayecto continuo
        fprintf(fid, '%% Elevator starts processing for grouped requests: \n');
        fprintf(fid, '%% Total requests: \n');
        for i = 1:size(all_requests, 1)
            fprintf(fid, '%% [%d -> %d]\n', all_requests(i, 1), all_requests(i, 2));
        end

        % Simular el movimiento
        all_floors = unique(all_requests(:));
        if direction == 1
            all_floors = sort(all_floors);
        else
            all_floors = sort(all_floors, 'descend');
        end

        % Elevator movement in relevant floors
        for floor = all_floors'
            while pos_elevator ~= floor
                fprintf(fid, '%% Elevator %d: Elevator at floor %d.\n', elevator_id, pos_elevator);
                current_time = toc(start_time);
                fprintf(fid, '%f %d\n', current_time, pos_elevator); % Guardar tiempo y posición

                pos_elevator = pos_elevator + sign(floor - pos_elevator);
                pause(elevator_speed);
            end

            % Verify if there is a pick up or a drop off
            pickups = find(all_requests(:, 1) == floor);
            dropoffs = find(all_requests(:, 2) == floor);
            for p = pickups'
                fprintf(fid, '%% Elevator %d: Picked up client at floor %d.\n', elevator_id, floor);
                pause(3);
            end
            for d = dropoffs'
                fprintf(fid, '%% Elevator %d: Dropped off client at floor %d.\n', elevator_id, floor);
                pause(3);
            end
        end
        fprintf(fid, '%% Elevator %d: Completed grouped requests.\n', elevator_id);
    end
end

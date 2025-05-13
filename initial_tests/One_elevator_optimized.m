function One_elevator_optimized(pos_initial, elevator_speed)
    % Inicialización
    pos_elevator = pos_initial; % Posición inicial del ascensor
    fprintf('Elevator Optimization Simulation Started.\n');

    while true
        % Cargar la cola de solicitudes
        if exist('requests_queue.mat', 'file')
            load('requests_queue.mat', 'requests_queue');
        else
            requests_queue = [];
        end

        if isempty(requests_queue)
            % Si no hay solicitudes, el ascensor está inactivo
            fprintf('No requests. Elevator is idle at floor %d.\n', pos_elevator);
            pause(1);
            continue;
        end

        % Tomar la primera solicitud de la lista
        origin = requests_queue(1, 1);
        destination = requests_queue(1, 2);
        direction = sign(destination - origin); % Dirección: 1 (subir), -1 (bajar)
        fprintf('Processing request: [%d -> %d] (Direction: %d).\n', origin, destination, direction);

        % Encontrar solicitudes adicionales que coincidan en dirección y trayecto
        additional_requests = [];
        for i = 2:size(requests_queue, 1)
            req_origin = requests_queue(i, 1);
            req_destination = requests_queue(i, 2);

            % Verificar si está en el trayecto y la misma dirección
            if direction == 1 % Subiendo
                if req_origin >= origin && req_origin <= destination && req_destination > req_origin
                    additional_requests = [additional_requests; requests_queue(i, :)];
                end
            elseif direction == -1 % Bajando
                if req_origin <= origin && req_origin >= destination && req_destination < req_origin
                    additional_requests = [additional_requests; requests_queue(i, :)];
                end
            end
        end

        % Eliminar las solicitudes agrupadas de la matriz
        all_requests = [origin, destination; additional_requests];
        requests_queue(ismember(requests_queue, all_requests, 'rows'), :) = [];
        save('requests_queue.mat', 'requests_queue');

        % Simular el movimiento del ascensor en un trayecto continuo
        fprintf('Elevator starts processing for grouped requests: \n');
        fprintf('Total requests: \n');
        disp(all_requests);

        % Obtener los pisos involucrados en el trayecto (orígenes y destinos)
        all_floors = unique(all_requests(:));

        % Ordenar pisos en la dirección del trayecto
        if direction == 1
            all_floors = sort(all_floors);
        else
            all_floors = sort(all_floors, 'descend');
        end

        % Mover el ascensor por los pisos relevantes
        for floor = all_floors'
            % Simular el movimiento al piso actual
            while pos_elevator ~= floor
                pos_elevator = pos_elevator + sign(floor - pos_elevator);
                fprintf('Elevator at floor %d.\n', pos_elevator);
                pause(elevator_speed); % Simular tiempo entre pisos
            end
    
            % Verificar si hay recogidas o entregas en este piso
            pickups = find(all_requests(:, 1) == floor);
            dropoffs = find(all_requests(:, 2) == floor);
            
            % Registrar recogidas
            for p = pickups'
                fprintf('Picked up client at floor %d.\n', floor);
            end
            % Registrar entregas
            for d = dropoffs'
                fprintf('Dropped off client at floor %d.\n', floor);
            end
        end
        fprintf('Elevator completed grouped requests.\n');
    end

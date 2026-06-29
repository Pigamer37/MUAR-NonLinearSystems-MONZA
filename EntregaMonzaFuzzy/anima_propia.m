function anima_propia(dif)
%ANIMA_PROPIA  Animación de la moneda bajando por la pista con nuestra planta (MONZABlock).
%   anima_propia(d)  ->  dificultad d (1..4). Por defecto 1.
%
%   Se lanza MONZA_fuzzy_PROPIA.slx con el fuzzy fisController_simulink_dif{d}.fis y
%   se dibuja la animacion en el marco inercial: las pistas giran con el tablero y
%   la moneda va en su posicion real.

    if nargin < 1 || isempty(dif), dif = 1; end
    dif = min(max(round(dif), 1), 4);

    mdl      = "MONZA_fuzzy_PROPIA";
    fisFile  = sprintf('fisController_simulink_dif%d.fis', dif);
    matFile  = sprintf('dificultad%d.mat', dif);     % geometria de la pista
    Ts       = 0.033;
    stopTime = 20;

    % El bloque Fuzzy lee la variable 'fisController' del workspace; la cargo a
    % mano para asegurarme de que uso el .fis de esta dificultad.
    assignin('base', 'fisController', readfis(fisFile));
    assignin('base', 'Ts', Ts);
    fprintf('Fuzzy cargado: %s (dif %d)\n', fisFile, dif);

    % Simulacion (paso fijo a Ts) 
    load_system(mdl);
    simIn = Simulink.SimulationInput(mdl);
    simIn = setModelParameter(simIn, 'SolverType', 'Fixed-step');
    simIn = setModelParameter(simIn, 'Solver', 'FixedStepDiscrete');
    simIn = setModelParameter(simIn, 'FixedStep', num2str(Ts));
    simIn = setModelParameter(simIn, 'StopTime', num2str(stopTime));
    simIn = setModelParameter(simIn, 'ReturnWorkspaceOutputs', 'on');
    simIn = setBlockParameter(simIn, char(mdl + "/Constant3"), 'Value', num2str(dif));

    fprintf('Simulando %s en dif %d...\n', mdl, dif);
    out = sim(simIn);

    % Señales: giro del tablero y pose inercial de la moneda 
    giro_m = colData(getVar(out, 'giro_m'),  1);
    xs     = colData(getVar(out, 'pose_in'), 1);
    ys     = colData(getVar(out, 'pose_in'), 2);

    % Remuestreo a N frames para que la animacion vaya suave
    n0 = min([numel(xs), numel(ys), numel(giro_m)]);
    N  = 150;
    t0 = linspace(1, n0, n0);
    t1 = linspace(1, n0, N);
    xs     = interp1(t0, xs(1:n0),     t1)';
    ys     = interp1(t0, ys(1:n0),     t1)';
    giro_m = interp1(t0, giro_m(1:n0), t1)';
    n = numel(xs);

    reportaResultado(out, Ts);

    % Geometria de las pistas y borde de la plataforma 
    load(matFile);             % xl1..xl4, yl1..yl4, xp,xp1..xp7, yp,yp1..yp7
    load('circulos.mat');      % r1..r4 (borde de la plataforma)

    % anim_giro_pistas rota las pistas por el giro y deja la moneda en su pose
    % inercial. Usa giro_simu, ma, mb, xs, ys y la geometria que acabo de cargar.
    giro_simu = giro_m;
    ma = cos(giro_simu);
    mb = sin(giro_simu);
    anim_giro_pistas;          % -> mxl1..mxl4, mx,mx1..mx7, mxp, myp

    % Animacion: en cada frame se limpia (clf) y redibuja todo; ejes fijos 
    fprintf('Animacion (%d frames)...\n', n);
    figure('Name', sprintf('MONZA - planta propia, dif %d', dif), 'Color', 'w');
    estilo = {'b.-', 'LineWidth', 1.5, 'MarkerSize', 4};
    for j = 1:n
        clf; hold on;

        % pistas giradas con el tablero
        plot(mxl1(j,:), myl1(j,:), estilo{:});
        plot(mxl2(j,:), myl2(j,:), estilo{:});
        plot(mxl3(j,:), myl3(j,:), estilo{:});
        plot(mxl4(j,:), myl4(j,:), estilo{:});
        plot(mx(j,:),   my(j,:),   estilo{:});
        plot(mx1(j,:),  my1(j,:),  estilo{:});
        plot(mx2(j,:),  my2(j,:),  estilo{:});
        plot(mx3(j,:),  my3(j,:),  estilo{:});
        plot(mx4(j,:),  my4(j,:),  estilo{:});
        plot(mx5(j,:),  my5(j,:),  estilo{:});
        plot(mx6(j,:),  my6(j,:),  estilo{:});
        plot(mx7(j,:),  my7(j,:),  estilo{:});

        % borde de la plataforma
        plot(r1, r2, 'r');
        plot(r3, r4, 'r');

        % rastro y moneda en su pose inercial
        plot(mxp(1:j), myp(1:j) + 0.01, 'm-', 'LineWidth', 1.2);
        plot(mxp(j),   myp(j)   + 0.01, 'r*', 'MarkerSize', 12, 'LineWidth', 2);

        hold off;
        axis([-0.25 0.25 -0.25 0.25]);   % vista fija para que se vea el giro
        title(sprintf('SIMULADOR GRAFICO PLATAFORMA - MONZA propia (dif %d)', dif));
        drawnow;
        F(j) = getframe(gcf);            % guardo el frame para el video
    end
    fprintf('Animacion completa.\n');

    % --- Grabo el video (como hace mi compañero) ---
    writerObj = VideoWriter(sprintf('%s_dif%d.avi', char(mdl), dif));
    writerObj.FrameRate = 1/Ts;          % framerate segun Ts
    open(writerObj);
    for i = 1:numel(F)
        writeVideo(writerObj, F(i));
    end
    close(writerObj);
    fprintf('Video guardado: %s_dif%d.avi\n', char(mdl), dif);
end

% Sacamos la variable 'name' de la salida de la simulacion.
function v = getVar(out, name)
    v = [];
    if any(strcmp(out.who, name))
        v = out.get(name);
    end
end

% Extrae la columna k de una señal (double, timeseries, struct-Data o 3D).
function v = colData(sig, k)
    v = [];
    if isempty(sig), return; end
    if isa(sig, 'timeseries')
        D = sig.Data;
    elseif isstruct(sig) && isfield(sig, 'Data')
        D = sig.Data;
    else
        D = sig;
    end
    if isempty(D), return; end
    if ndims(D) == 3
        v = squeeze(D(1, k, :));
    elseif size(D, 2) >= k
        v = D(:, k);
    else
        v = D(:);
    end
    v = v(:);
end

% Aviso del resultado leyendo estado_m (5a salida de MONZABlock):
%   2 = GANO (pista completa), 3 = PERDIO (se sale).
function reportaResultado(out, Ts)
    E = colData(getVar(out, 'estado_m'), 1);
    if isempty(E), return; end
    switch E(end)
        case 2
            fprintf('Resultado: la moneda GANA (pista completa) en ~%.2f s.\n', numel(E) * Ts);
        case 3
            fprintf('Resultado: la moneda PIERDE (se sale) en ~%.2f s.\n', numel(E) * Ts);
        otherwise
            fprintf('Resultado: estado final = %d.\n', E(end));
    end
end

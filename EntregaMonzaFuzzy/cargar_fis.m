function cargar_fis()
%CARGAR_FIS  Carga el .fis de la dificultad que tenga puesta el bloque Constant3.
%   La idea es llamarla desde el callback InitFcn del modelo, para que con un
%   solo .slx me valgan las 4 dificultades.
% 
%   El bloque Fuzzy Logic Controller lee la variable 'fisController'
%   del workspace.
%
%   Dificultad -> fichero:
%       1 -> fisController_simulink_dif1.fis
%       2 -> fisController_simulink_dif2.fis
%       3 -> fisController_simulink_dif3.fis
%       4 -> fisController_simulink_dif4.fis.

    mdl = bdroot;

    % Leemos la dificultad del bloque Constant3 
    v = get_param([mdl '/Constant3'], 'Value');
    d = str2double(v);
    if isnan(d)                      % Constant3 tiene el nombre de una variable
        d = evalin('base', v);
    end
    d = min(max(round(d), 1), 4);

    % Cargamos el .fis que toca en la variable que lee el bloque Fuzzy 
    fisFile = sprintf('fisController_simulink_dif%d.fis', d);
    if exist(fisFile, 'file') ~= 2
        error('cargar_fis:falta', ...
            ['No se encuentra "%s". La dificultad %d aún no tiene .fis ganador ' ...
             '(genéralo con genera_fis_PROFE(%d)).'], fisFile, d, d);
    end
    assignin('base', 'fisController', readfis(fisFile));

    % Ts
    if ~evalin('base', 'exist(''Ts'',''var'')')
        assignin('base', 'Ts', 0.033);
    end

    fprintf('[cargar_fis] Dificultad %d  ->  %s  cargado en fisController.\n', d, fisFile);
end

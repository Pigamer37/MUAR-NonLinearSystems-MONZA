controller = nlmpc(4,4,1); % estados: posición y velocidades, salidas: posición, input: ángulo
controller.States(1).Units = "m";controller.States(2).Units = "m";
controller.States(3).Units = "m/s";controller.States(4).Units = "m/s";
controller.Ts = Ts;
controller.Model.IsContinuousTime = false;
controller.PredictionHorizon = 12;
controller.ControlHorizon = 3;
controller.Model.NumberOfParameters = 3; % Ts, piso, friction_coef
controller.Model.StateFcn = @modelFcn;
%controller.Jacobian.StateFcn = @modelJacobian;
controller.Model.OutputFcn = @(x,u,mTs,piso,fric) [ x(1); x(2); x(3); x(4) ];
controller.ManipulatedVariables.Min = -pi/2;
controller.ManipulatedVariables.Max = pi/2;
if(strcmp(mdl,'MONZA'))
    controller.Weights.OutputVariables = [1 0 0.9 0];
    fric = 0;
else
    switch difficulty
        case 1
            controller.Weights.OutputVariables = [1.2 0 0.12 0];
        case 2
            controller.Weights.OutputVariables = [1 0 0.12 0];
        case 3
            controller.Weights.OutputVariables = [0.95 0 0.135 0];
        case 4
            controller.Weights.OutputVariables = [1 0 0.16 0];
        otherwise
            warning('Unexpected difficulty.')
            return
    end
    controller.Weights.ManipulatedVariablesRate = 0.5;
    controller.ControlHorizon = 1;
    controller.PredictionHorizon = 3;
    fric=0.0223;
end
assert(isa(controller,'nlmpc'),"Wrong type of object")
%mdl = 'MONZA';
createParameterBus(controller,[mdl '/Nonlinear MPC Controller'],'myBusObject',{Ts,1,fric})
%% Validation
validateFcns(controller,rand(4,1),rand(1,1),[],{Ts,1,0});

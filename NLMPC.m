controller = nlmpc(4,4,1); % estados: posición y velocidades, salidas: posición, input: ángulo
controller.Ts = Ts;
controller.PredictionHorizon = 10;
controller.ControlHorizon = 5;
controller.Model.NumberOfParameters = 3; % Ts, piso, friction_coef
controller.Model.StateFcn = @modelFcn;
%controller.Jacobian.StateFcn = @modelJacobian;
mdl = 'MONZA';
createParameterBus(controller,[mdl '/Nonlinear MPC Controller'],'myBusObject',{Ts,1,0})
%% Validation
validateFcns(controller,rand(4,1),rand(1,1),[],{Ts,1,0});

function z = modelFcn(x,u,mTs,piso,fric)
    g=9.81;
    z = zeros(4,1); %x1 = x; x2 = y; x1dot = vx; x2dot = vy
    [x(3),x(4)] = rotate(u,x(3),x(4)); %de vel referencial a absoluta
    if u > pi/2
        u = pi/2;
    elseif u < -pi/2
        u = -pi/2;
    end
    if u > 0
        correction = -1;
    else
        correction = 1;
    end

    trackNormalAngle = u;

    a_tangent = g*(abs(sin(trackNormalAngle))-abs(cos(trackNormalAngle))*fric);
    ax = a_tangent * cos(trackNormalAngle) * correction;
    ay = a_tangent * sin(trackNormalAngle) * correction;
    z(3) = x(3) + ax * mTs;
    z(4) = x(4) + ay * mTs;
    z(1) = x(1) + z(3) * mTs + ax /2 * mTs * mTs; %x0 + vx*t +1/2*ax*t^2
    z(2) = x(2) + z(4) * mTs + ay /2 * mTs * mTs;

    [xRot,~] = rotate(-u,z(1),z(2));
    switch piso
    case 2
        yRot = -0.54 * (xRot * xRot) + 0.0686;
    case 3
        yRot = -0.54 * (xRot * xRot) + 0.03;
    case 4
        yRot = -0.54 * (xRot * xRot) -0.03;
    case 5
        yRot = -0.54 * (xRot * xRot) - 0.0686;
    case 6
        yRot = -0.54 * (xRot * xRot) - 0.1143;
    case 7
        yRot = -0.54 * (xRot * xRot) - 0.16;
    otherwise
        yRot = -0.54 * (xRot * xRot) + 0.1143;
    end
    [~, z(2)] = rotate(u,xRot,yRot);
end

function [xo,yo] = rotate(giro,x,y)
    xo=x*cos(giro)-y*sin(giro);
    yo=x*sin(giro)+y*cos(giro);
end
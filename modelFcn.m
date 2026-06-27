function z = modelFcn(x,u,mTs,piso,fric)
    g=9.81;
    z = zeros(4,1); %x1 = x; x2 = y; x1dot = vx; x2dot = vy
    u = max(min(u, pi/2), -pi/2); %saturate u
    if u > 0
        correction = -1;
    else
        correction = 1;
    end

    trackNormalAngle = u;

    a_tangent = g*(abs(sin(trackNormalAngle))-abs(cos(trackNormalAngle))*fric);
    ax = a_tangent * cos(trackNormalAngle) * correction;
    ay = a_tangent * sin(trackNormalAngle) * correction;
    vx = x(3) + ax * mTs;
    vy = x(4) + ay * mTs;
    xpos = x(1) + z(3) * mTs + ax*0.5 * mTs^2; %x0 + vx*t +1/2*ax*t^2
    ypos = x(2) + z(4) * mTs + ay*0.5 * mTs^2;

    [xRot,~] = rotate(-u,xpos,ypos);
    switch piso
    case 2, yRot = -0.54 * (xRot * xRot) + 0.0686;
    case 3, yRot = -0.54 * (xRot * xRot) + 0.03;
    case 4, yRot = -0.54 * (xRot * xRot) -0.03;
    case 5, yRot = -0.54 * (xRot * xRot) - 0.0686;
    case 6, yRot = -0.54 * (xRot * xRot) - 0.1143;
    case 7, yRot = -0.54 * (xRot * xRot) - 0.16;
    otherwise, yRot = -0.54 * (xRot * xRot) + 0.1143;
    end
    [~, ypos] = rotate(u,xRot,yRot);

    z = [xpos; ypos; vx; vy];
end
function [xo,yo] = rotate(giro,x,y)
    xo=x*cos(giro)-y*sin(giro);
    yo=x*sin(giro)+y*cos(giro);
end

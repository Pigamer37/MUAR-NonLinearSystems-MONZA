function utils(giro,dificultad)
    xs = calcPista(giro,dificultad);

    plot(xs.x1d,xs.y1d,'g*');
    plot(xs.x2d,xs.y2d,'g*');
    plot(xs.x3d,xs.y3d,'g*');
    plot(xs.x4d,xs.y4d,'g*');
    plot(xs.x5d,xs.y5d,'g*');
    plot(xs.x6d,xs.y6d,'g*');
    plot(xs.x7d,xs.y7d,'g*');
    plot(xs.x1i,xs.y1i,'g*');
    plot(xs.x2i,xs.y2i,'g*');
    plot(xs.x3i,xs.y3i,'g*');
    plot(xs.x4i,xs.y4i,'g*');
    plot(xs.x5i,xs.y5i,'g*');
    plot(xs.x6i,xs.y6i,'g*');
    plot(xs.x7i,xs.y7i,'g*');
end
function [xs] = calcPista(giro,dificultad)
    a=cos(giro); 
    b=sin(giro);
    
    switch dificultad
    case 1
        [xs.x1d, xs.y1d]=rotate(giro,0,0.11429);
        [xs.x1i, xs.y1i]=rotate(giro,-0.11,0.1092);
        
        [xs.x2d, xs.y2d]=rotate(giro,0.20646,0.04555);
        [xs.x2i, xs.y2i]=rotate(giro,0,0.06857);
        
        [xs.x3d, xs.y3d]=rotate(giro,0,0.02286);
        [xs.x3i, xs.y3i]=rotate(giro,-0.21142,-0.00198);
        
        [xs.x4d, xs.y4d]=rotate(giro,0.20639,-0.04587);
        [xs.x4i, xs.y4i]=rotate(giro,0,-0.02286);
        
        [xs.x5d, xs.y5d]=rotate(giro,0,-0.06857);
        [xs.x5i, xs.y5i]=rotate(giro,-0.19203,-0.08846);
        
        [xs.x6d, xs.y6d]=rotate(giro,0.16726,-0.12936);
        [xs.x6i, xs.y6i]=rotate(giro,0,-0.11429);
        
        [xs.x7d, xs.y7d]=rotate(giro,-0.02554,-0.16035);
        [xs.x7i, xs.y7i]=rotate(giro,-0.12744,-0.16871);
        
    case 2
        [xs.x1d, xs.y1d]=rotate(giro,0.06211,0.11223);
        [xs.x1i, xs.y1i]=rotate(giro,-0.11,0.1092);
        
        [xs.x2d, xs.y2d]=rotate(giro,0.20646,0.04555);
        [xs.x2i, xs.y2i]=rotate(giro,-0.04758,0.06799);
        
        [xs.x3d, xs.y3d]=rotate(giro,0.04969,0.02154);
        [xs.x3i, xs.y3i]=rotate(giro,-0.21142,-0.00198);
        
        [xs.x4d, xs.y4d]=rotate(giro,0.20639,-0.04587);
        [xs.x4i, xs.y4i]=rotate(giro,-0.04847,-0.02411);
        
        [xs.x5d, xs.y5d]=rotate(giro,0.04406,-0.06961);
        [xs.x5i, xs.y5i]=rotate(giro,-0.19203,-0.08846);
        
        [xs.x6d, xs.y6d]=rotate(giro,0.16726,-0.12936);
        [xs.x6i, xs.y6i]=rotate(giro,-0.05409,-0.11585);
        
        [xs.x7d, xs.y7d]=rotate(giro,-0.02554,-0.16035);
        [xs.x7i, xs.y7i]=rotate(giro,-0.12744,-0.16871);
    
    case 3
        [xs.x1d, xs.y1d]=rotate(giro,0.12394,0.10605);
        [xs.x1i, xs.y1i]=rotate(giro,-0.1,0.1092);
        
        [xs.x2d, xs.y2d]=rotate(giro,0.20646,0.04555);
        [xs.x2i, xs.y2i]=rotate(giro,-0.09503,0.06374);
        
        [xs.x3d, xs.y3d]=rotate(giro,0.09924,0.01759);
        [xs.x3i, xs.y3i]=rotate(giro,-0.21142,-0.00198);
        
        [xs.x4d, xs.y4d]=rotate(giro,0.20639,-0.04587);
        [xs.x4i, xs.y4i]=rotate(giro,-0.0968,-0.02787);
        
        [xs.x5d, xs.y5d]=rotate(giro,0.08803,-0.07271);
        [xs.x5i, xs.y5i]=rotate(giro,-0.19203,-0.08846);
        
        [xs.x6d, xs.y6d]=rotate(giro,0.16726,-0.12936);
        [xs.x6i, xs.y6i]=rotate(giro,-0.108,-0.12053);
        
        [xs.x7d, xs.y7d]=rotate(giro,-0.02554,-0.16035);
        [xs.x7i, xs.y7i]=rotate(giro,-0.12744,-0.16871);
        
     case 4
        [xs.x1d, xs.y1d]=rotate(giro,0.12394,0.10605);
        [xs.x1i, xs.y1i]=rotate(giro,-0.1,0.1092);
        
        [xs.x2d, xs.y2d]=rotate(giro,0.20646,0.04555);
        [xs.x2i, xs.y2i]=rotate(giro,-0.14224,0.05771);
        
        [xs.x3d, xs.y3d]=rotate(giro,0.14851,0.01102);
        [xs.x3i, xs.y3i]=rotate(giro,-0.21142,-0.00198);
        
        [xs.x4d, xs.y4d]=rotate(giro,0.20639,-0.04587);
        [xs.x4i, xs.y4i]=rotate(giro,-0.14488,-0.03412);

        [xs.x5d, xs.y5d]=rotate(giro,0.1318,-0.07789);
        [xs.x5i, xs.y5i]=rotate(giro,-0.19203,-0.08846);
        
        [xs.x6d, xs.y6d]=rotate(giro,0.16726,-0.12936);
        [xs.x6i, xs.y6i]=rotate(giro,-0.108,-0.12053);
        
        [xs.x7d, xs.y7d]=rotate(giro,-0.02554,-0.16035);
        [xs.x7i, xs.y7i]=rotate(giro,-0.12744,-0.16871);
    end
end 
function [xo,yo] = rotate(giro,x,y)
    xo=x*cos(giro)-y*sin(giro);
    yo=x*sin(giro)+y*cos(giro);
end
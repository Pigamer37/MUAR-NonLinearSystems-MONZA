function utils(giro,dificultad)
    xs = calcPista(giro,dificultad);

    plot(xs.x1d,xs.y1d,'r*');
    plot(xs.x2d,xs.y2d,'g*');
    plot(xs.x3d,xs.y3d,'r*');
    plot(xs.x4d,xs.y4d,'g*');
    plot(xs.x5d,xs.y5d,'r*');
    plot(xs.x6d,xs.y6d,'g*');
    plot(xs.x7d,xs.y7d,'r*');
    plot(xs.x1i,xs.y1i,'g*');
    plot(xs.x2i,xs.y2i,'r*');
    plot(xs.x3i,xs.y3i,'g*');
    plot(xs.x4i,xs.y4i,'r*');
    plot(xs.x5i,xs.y5i,'g*');
    plot(xs.x6i,xs.y6i,'r*');
    plot(xs.x7i,xs.y7i,'g*');
end
%%
clear,clc,close all;
Ts = 0.033;
difficulty=1;
mdl = 'MONZA';%'Monza_simulacion_NLMPC';
NLMPC
%% Sim
simIn = Simulink.SimulationInput(mdl);
simIn = setModelParameter(simIn,"StopTime","40");
if(strcmp(mdl,'MONZA'))
    simIn = setBlockParameter(simIn,strcat(mdl,"/MONZABlock"),"Ts","Ts");
end
out = sim(simIn);
giro_m = out.giro_m;
xs = out.xs;
ys = out.ys;
xRef = out.xRef;
yRef = out.yRef;
clear out;clc;fprintf('Sim complete\n');
%% Draw
switch difficulty
    case 1
        load('dificultad1.mat');
    case 2
        load('dificultad2.mat');
    case 3
        load('dificultad3.mat');
    case 4
        load('dificultad4.mat');
    otherwise
        warning('Unexpected difficulty.')
        return
end
load('circulos.mat');
giro_simu=giro_m;
ma=cos(giro_simu);
mb=sin(giro_simu);

anim_giro_pistas;


%**************************************************************************
%***************GR�FICAS DE LAS CURVAS DE LA SIMULACI�N********************
%**************************************************************************
theme('light');
fig=figure(1);
for j=1:length(xs)
    lineLength = fprintf('Animation %3.2f%% complete',j/length(xs)*100);
    plot(mxp(j),myp(j)+0.01,'r*','LineWidth',15)
    
    %*********RECTAS*********
    plot(mxl1(j,:),myl1(j,:),'b','LineWidth',2);
    plot(mxl2(j,:),myl2(j,:),'b','LineWidth',2);
    plot(mxl3(j,:),myl3(j,:),'b','LineWidth',2);
    plot(mxl4(j,:),myl4(j,:),'b','LineWidth',2); 
    %*******PARABOLAS***********
    plot(mx(j,:),my(j,:),'b');
    plot(mx1(j,:),my1(j,:),'b');
    plot(mx2(j,:),my2(j,:),'b');
    plot(mx3(j,:),my3(j,:),'b');
    plot(mx4(j,:),my4(j,:),'b');
    plot(mx5(j,:),my5(j,:),'b');
    plot(mx6(j,:),my6(j,:),'b');
    plot(mx7(j,:),my7(j,:),'b');
    
    utils(giro_simu(j),difficulty);
    plot(xRef(j),yRef(j),'ko');

    % yParab = -0.54 * (mxp(j) * mxp(j)) + 0.1143;
    % xParab=mxp(j)*cos(giro_simu(j))-yParab*sin(giro_simu(j));
    % yParab=mxp(j)*sin(giro_simu(j))+yParab*cos(giro_simu(j));
    % plot(xParab,yParab,'k*');

    hold off;
    MM = getframe(fig);
    F(j) = MM;
    figure(1)
    plot(r1,r2,'r');
    hold on;
    plot(r3,r4,'r');
    hold on;
    axis equal;
    title(['SIMULADOR GRÁFICO PLATAFORMA PARA PRUEBA Y ENSAYO DE CONTROLADORES ' num2str(j/length(xs)*100) '%'])
    fprintf(repmat('\b',1,lineLength));
end
fprintf('Animation complete!\n');
close all;

writerObj = VideoWriter([mdl num2str(difficulty) '.avi']);
writerObj.FrameRate = 1/Ts; %calc framerate based on Ts
% open the video writer
open(writerObj);
% write the frames to the video
for i=1:length(F)
    % convert the image to a frame
    frame = F(i) ;    
    writeVideo(writerObj, frame);
end
writeVideo(writerObj, F(length(F)));
% close the writer object
close(writerObj);

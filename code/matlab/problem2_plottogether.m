% plot all together

close all;
clear all;
clc;

%f=figure;

[x1, y1] = loadfromfig('problem2.fig');
[x2, y2] = loadfromfig('problem2_1.fig');
[x3, y3] = loadfromfig('problem2_2.fig');

xx = [x1 x2 x3];
yy = [y1 y2 y3];


figure;
plot(x1, y1, 'b')
hold on
plot(x2, y2, 'r')
plot(x3, y3, 'g')

grid on
xlim([-90 90])
ylim([-140, 0])

xlabel('Normal Angle (deg)')
ylabel('Array Response (dB)')

legend('10^\circ - 30^\circ Beam', ...
    '15^\circ - 25^\circ Beam', ...
    '0^\circ - 40^\circ Beam')
hold off

saveas(gca, 'problem2together.png')


function [x1_, y1_] = loadfromfig(filename)
    f1 = openfig(filename);
    lineHandle = findobj(f1, 'Type', 'line');
    
    x1_ = get(lineHandle, 'XData');
    y1_ = get(lineHandle, 'YData');

    close(f1);
end

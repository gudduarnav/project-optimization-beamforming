clear all;
clc;
close all;

% for part 3(a), set NUM_ANA=20
NUM_ANA= 20;%antenna number

% setup
CARR_FREQ= 2.4e9; % Hz. carrier frequency
WAVE_LEN= physconst("LightSpeed") / CARR_FREQ; % m. wavelength
ANTENNA_DIS= WAVE_LEN/2; % distance between two antennas

% beam width (from theta_l to theta_u)
theta_l=10;
theta_u=30;

% beam center (at the middle of theta_l to theta_u)
ANGLE_DES= (theta_l + theta_u)/2; % propogation direction of the desired signal 

% Beam steering vector a(theta)
Steering_des=  [exp(-j*[0:NUM_ANA-1].'*2*pi*ANTENNA_DIS*sin(ANGLE_DES*pi/180)/WAVE_LEN)];%steering vector of the desired signal



% Minimize worst-case sidelobe 
P_matrix= zeros(NUM_ANA, NUM_ANA);

% optimal problem
cvx_begin
    variable t
    variable w(NUM_ANA,1) complex
    expression Match_output
    minimize(t);
    subject to
    for i=-90:1:theta_l
        P_matrix= exp(-j*[0:NUM_ANA-1]' *2*pi*ANTENNA_DIS*sin(i*pi/180)/WAVE_LEN) * ...
                  exp(-j*[0:NUM_ANA-1]'*2*pi*ANTENNA_DIS*sin(i*pi/180)/WAVE_LEN)';
        match_output=quad_form(w, P_matrix);
        match_output<=t;
   end
   for i=theta_u:1:90
        P_matrix= exp(-j*[0:NUM_ANA-1]'*2*pi*ANTENNA_DIS*sin(i*pi/180)/WAVE_LEN) * ...
                  exp(-j*[0:NUM_ANA-1]'*2*pi*ANTENNA_DIS*sin(i*pi/180)/WAVE_LEN)';
        match_output=quad_form(w, P_matrix);
        match_output<=t;
   end

   w'*Steering_des==1;
cvx_end

% plot angle spectrum
steering_vec_plot=[];
for i=-90:1:90
    steering_vec_plot=[steering_vec_plot; exp(-j*[0:NUM_ANA-1]*2*pi*ANTENNA_DIS*sin(i*pi/180)/WAVE_LEN)];
end

% plot
f=figure;
plot([-90:1:90], 10*log10(abs(w'*steering_vec_plot.').^2));
title('Minimizing the Worst-case Sidelobe')

hold on
grid on
xlabel('Angle(degree)');
ylabel('Angle Response(db)');
xlim([-90, 90])
%ylim([-120, 0])
hold off

saveas(f, 'problem3a.png')
savefig(f, 'problem3a.fig')

% Set clear & Initialization
clear variables; close all; clc;

syms r 

R = 2000;   % radius of the cell in metres
e = 5.2e-7; % TA margin error in seconds
c = 3e8;  % speed of light in m/s
k = 2:10; % RA attempts

% For M number of Preambles

%..........Conventional & Proposed Procedure(Analytical).........................


for M = 5
    for i = k
        f_1 = r*(1 -(R^2 -(r - e*c/2)^2)/(M*R^2)).^k;
        f_2 = r*(1 -((r + (e*c/2))^2)/(M*R^2)).^k;
        f_3 = r*(1 -((4*e*c/2)^2)/(M*R^2)).^k;
        intg1 = (1-(2/R^2)*(int(f_1,r,[(R-e*c/2) R]) + int(f_2,r,[0 e*c/2]) + int(f_3,r,[e*c/2 R-e*c/2])));
        
        p_conv1 = 1-(1-(1/M)).^(k-1);
        p_prop1 = round(vpa(intg1),6);
    end   
end

for M = 20
    f_1 = r*(1 -(R^2 -(r - e*c/2)^2)/(M*R^2)).^k;
    f_2 = r*(1 -((r + (e*c/2))^2)/(M*R^2)).^k;
    f_3 = r*(1 -((4*e*c/2)^2)/(M*R^2)).^k;
    intg2 = (1-(2/R^2)*(int(f_1,r,[(R-e*c/2) R]) + int(f_2,r,[0 e*c/2]) + int(f_3,r,[e*c/2 R-e*c/2])));
   
    p_conv2 = 1-(1-(1/M)).^(k-1);
    p_prop2 = round(vpa(intg2),6);
    
end

figure(1);
semilogy(k, p_conv1,'k-'); hold on; semilogy(k, p_conv2, 'r-');
hold on; semilogy(k,p_prop1,'k-.'); hold on; semilogy(k,p_prop2,'k--')
grid on;

xlim([2 10]); ylim([10^-3 10^0]);

xlabel('Number of RA attempts from machine devices on a single RA slot (k+1)'); ylabel("Collision Probability P_c'ue");
legend('M = 5 Conv.(anal)','M = 20 conv.(anal)','M = 5 prop.(anal)','M = 5 Prop.(anal)','M = 20 Prop.(anal)','Location','southeast');


%.........Conventional & Proposed Procedure(Simulated)..............................



















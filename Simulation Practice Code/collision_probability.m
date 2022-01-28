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
        f_3 = r*(1 -((4*e*r*c/2))/(M*R^2)).^k;
        intg1 = (1-(2/R^2)*(int(f_1,r,[(R-e*c/2) R]) + int(f_2,r,[0 e*c/2]) + int(f_3,r,[e*c/2 R-e*c/2])));
        
        p_conv1 = 1-(1-(1/M)).^(k-1);
        p_prop1 = round(vpa(intg1),6);
    end   
end

for M = 20
    f_1 = r*(1 -(R^2 -(r - e*c/2)^2)/(M*R^2)).^k;
    f_2 = r*(1 -((r + (e*c/2))^2)/(M*R^2)).^k;
    f_3 = r*(1 -((4*e*r*c/2))/(M*R^2)).^k;
    intg2 = (1-(2/R^2)*(int(f_1,r,[(R-e*c/2) R]) + int(f_2,r,[0 e*c/2]) + int(f_3,r,[e*c/2 R-e*c/2])));
   
    p_conv2 = 1-(1-(1/M)).^(k-1);
    p_prop2 = round(vpa(intg2),6);
    
end

figure(1);
semilogy(k, p_conv1,'k-'); hold on; semilogy(k, p_conv2, 'k-');
hold on; semilogy(k,p_prop1,'k-.'); hold on; semilogy(k,p_prop2,'k--')
grid on;

xlim([2 10]); ylim([10^-3 10^0]);

%.........Conventional & Proposed Procedure(Simulated)..............................

n_itr = 10000;
RA_attempt = linspace(2,10,9);
other_selec = zeros(1,length(RA_attempt));
col_prob1 = zeros(1,length(RA_attempt));
M_1 = 1:5;
prem = randperm(numel(M_1)); % Generation of random preambles

for M_1 = 5
    for i1 = 1:length(RA_attempt)
         k = RA_attempt(i1);
      
      col_event =  0;
      for i2= 1:n_itr
            device_k = M_1(randperm(numel(M_1),1)); % preamble selection by device k

          for i3 = 1:(k-1)         % preamble selection procedure by (k-1) devices
               other_selec(i3) = randsample(prem,1);
               other_dev = other_selec(:,:);  % Selected preambles by (k-1) devices
               check = sum(logical(other_dev == device_k)); % preamble comparison procedure
          end

          if (check > 1||check == 1)
               col_event = col_event + 1;
               continue;
          end
      end  
            col_prob1(i1) = (col_event/n_itr); % Probability of collision computation
   end    
end

hold on;

% M = 20
n_itr = 10000;
RA_attempt = linspace(2,10,9);
other_selec = zeros(1,length(RA_attempt));
col_prob2 = zeros(1, length(RA_attempt));
M_2 = 1:20;
prem = randperm(numel(M_2)); % Generation of random preambles

for i1 = 1:length(RA_attempt)
     k = RA_attempt(i1);

     col_event =  0;
     for i2 = 1:n_itr
         device_k = M_2(randperm(numel(M_2),1)); % preamble selection by device k

          for i3 = 1:(k-1)         % preamble selection procedure by (k-1) devices
               other_selec(i3) = randsample(prem,1);
               other_dev = other_selec(:,:);  % Selected preambles by (k-1) devices
               check = sum(logical(other_dev == device_k)); % preamble comparison procedure
          end
    
          if (check > 1||check == 1)
               col_event = col_event + 1;
               continue;
          end
      end  
            col_prob2(i1) = (col_event/n_itr); % Probability of collision computation
end    

hold on;
figure(1);
semilogy(RA_attempt, col_prob1, 'ko'); hold on; semilogy(RA_attempt, col_prob2, 'ks');
ylim([10^-3 10^0])
grid on;

xlim([2 10]); ylim([10^-3 10^0]);

xlabel('Number of RA attempts from machine devices on a single RA slot (k+1)'); ylabel("Collision Probability P_c'ue");
legend('M = 5 conv.(anal)','M = 20 conv.(anal)','M = 5 prop.(anal)','M = 20 Prop.(anal)','M = 5 conv.(sim)','M = 20 conv.(sim)','Location','southeast');


%..................Proposed procedure (simulated)....................................................................

% dev_k_dis = dis(randperm(numel(dis),1));
% dev_k_pream = M(randperm(numel(M),1));
% dev_k_TA = ((dev_k_dis)*2)/(c);
% 
% dev_k = [dev_k_pream;dev_k_dis;dev_k_TA];
% const = (e*c/2);
% intval_1 = abs(dis-const);
% intval_2 = abs(dis+const);



% for i1 = 1:length(RA_attempt)
%       RA_sample = RA_attempt(i1);
%      
%       col_event =  0;
%       for i2 = 1:n_iter
%           dev_k_pre = M(randperm(numel(M),1));
%           dev_k_dis = dis(randperm(numel(dis),1));
% 
%           for i3 = 1:(RA_sample-1)   % (k-1) device selection         
%                pre_select(i3) = randsample(prem,1);
%                other_dis(i3) = dis(randperm(numel(dis),1));
% 
%                
%                other_devs_dis = other_dis(:,:);
%                other_devs_pre = pre_select(:,:);
% 
%                check1 = sum(logical(other_devs_pre == dev_k_pre));
%                check2 = sum(ismember(other_devs_dis,intval_1));
%                check3 = sum(ismember(other_devs_dis,intval_2));
% 
%           end
%             
%           if (check1 > 1 || check1 == 1) && (check2 >= 1 || check3 >= 1)
%                col_event = col_event + 1;
%           end
%  
%      end  
% 
%             col_prob(i1) = (col_event/n_iter);
% end 
% 
% % figure(1);
% semilogy(RA_attempt, col_prob, 'ko');
% ylim([10^-3 10^0])













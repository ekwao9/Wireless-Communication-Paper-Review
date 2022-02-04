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

hold on;

%.........Proposed Procedure(simulated).................................

M = 5; % number of preambles
RA_attempts = (2:10);
R = 2000;
e = 0.52e-6;
c = 3e8;

eNB = [0,0];
machines = 9;

col_prob = zeros(1,9);


for l1 = 1:9
      RA_sample = RA_attempts(l1);

      ang1 = rand*(2*pi);
      
      preams = randperm(M);
      dev_k = machines(randperm(numel(machines),1));
      
      d1 = sqrt(rand)*R;
      dev_kx = dev_k + d1.*cos(ang1);
      dev_ky = dev_k + d1.*sin(ang1);

          coll_event =  0;
          for l2 = 1:n_itr 

                ang2 = rand(1,RA_sample)*(2*pi);
                d2 = sqrt(rand(1,RA_sample))*R;
                o_devx = 0 + d2.*cos(ang2);
                o_devy = 0 + d2.*sin(ang2);

                ro = sqrt(((dev_kx-eNB(1))^2) + ((dev_ky-eNB(2))^2)); % distance btn tagged device and eNB

                range1 = (ro-e*c/2); range2 = (ro+e*c/2);  % collision zones
                To = (2*ro)/c; % Tagged device TA value

                devk_pre = randsample(preams,1);
                otherdev_pre = randsample(preams,1);

                     for l3 = 1:RA_sample-1
                         check1 = sqrt((o_devx(l3)-eNB(1))^2 + (o_devy(l3)-eNB(2))^2);
                         
                         loc_comp = 0;
                        if check1 >= range1 && check1 <= range2
                           loc_comp = loc_comp + 1;

                           check2 = logical(otherdev_pre == devk_pre);
                           if ((check2 == 1) && (loc_comp == 1))
                                coll_event = coll_event + 1;
                            
                          end
                        end

                     end

          end

                 col_prob(l1) = coll_event/n_itr;
end     

semilogy(k, col_prob,'ko')
grid on
ylim([10^-4 1])

hold on;

M = 20; % number of preambles
RA_attempts = (2:10);
R = 2000;
e = 0.52e-6;
c = 3e8;

eNB = [0,0];

machines = 9;

col_prob = zeros(1,9);


for l1 = 1:9
      RA_sample = RA_attempts(l1);

      ang1 = rand*(2*pi);
      
      preams = randperm(M);
      dev_k = machines(randperm(numel(machines),1));
      
      d1 = sqrt(rand)*R;
      dev_kx = dev_k + d1.*cos(ang1);
      dev_ky = dev_k + d1.*sin(ang1);

          coll_event =  0;
          for l2 = 1:n_itr 

                ang2 = rand(1,RA_sample)*(2*pi);
                d2 = sqrt(rand(1,RA_sample))*R;
                o_devx = 0 + d2.*cos(ang2);
                o_devy = 0 + d2.*sin(ang2);

                ro = sqrt(((dev_kx-eNB(1))^2) + ((dev_ky-eNB(2))^2)); % distance btn tagged device and eNB

                range1 = (ro-e*c/2); range2 = (ro+e*c/2);  % collision zones
                To = (2*ro)/c; % Tagged device TA value

                devk_pre = randsample(preams,1);
                otherdev_pre = randsample(preams,1);

                     for l3 = 1:RA_sample-1
                         check1 = sqrt((o_devx(l3)-eNB(1))^2 + (o_devy(l3)-eNB(2))^2);
                         
                         loc_comp = 0;
                        if check1 >= range1 && check1 <= range2
                           loc_comp = loc_comp + 1;

                           check2 = logical(otherdev_pre == devk_pre);
                           if ((check2 == 1) && (loc_comp == 1))
                                coll_event = coll_event + 1;
                            
                          end
                        end

                     end

          end

                 col_prob(l1) = coll_event/n_itr;
end     

semilogy(k, col_prob,'ks')
grid on
ylim([10^-3 1])

xlabel('Number of RA attempts from machine devices on a single RA slot (k+1)'); ylabel("Collision Probability P_c'ue");
legend('M = 5 conv.(anal)','M = 20 conv.(anal)','M = 5 prop.(anal)','M = 20 Prop.(anal)','M = 5 conv.(sim)','M = 20 conv.(sim)','M = 5 Prop.(sim)','M = 20 Prop.(sim)','Location','southeast');




















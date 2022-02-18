
% Set clear & Initialization
clear variables; close all; clc;

SNR_dB = 1:1:20; 
SNR = 10.^(SNR_dB/10);
iters = 2; 
NT = 20:-10:10;
ray_fc = sqrt(0.5);
erg_capa = zeros(1,20);

for k = 1:length(NT)

    if k==1 
        nR = 4; nT = 20; 
    else 
        nR = 4; nT = 10;
    end
    
    rk = min(nT,nR); % number of parallel channels 
    I = eye(rk);
    
    erg_capa(k,:) = zeros(1,length(SNR_dB));
    for i1 = 1:iters
        H = ray_fc*(randn(nR,nT)+1j*randn(nR,nT));
        SV = svd(H*H');
       
        for i2 = 1:length(SNR_dB) % Random channel generation
            p_optimum = power_allocation(SV,SNR(i2),nT);

            erg_capa(k,i2) = erg_capa(k,i2) + log(real(det(I + SNR(i2)/nT*diag(p_optimum)*diag(SV)))); 
        end
    end
end

erg_capa = real(erg_capa)/iters;

plot(SNR_dB,erg_capa(1,:),'b:x');
hold on;
plot(SNR_dB,erg_capa(2,:),'b:d');

xlim([5 20]);
ylim([0 30]);

xlabel('SNR = P_{0}/\sigma^2 (dB)')
ylabel('C^{a}{_s_e_c,_m_g}(nats/symbol)')
title('Fig.6')
legend('\color{black}\bf E[Capacity] (N_T = 20)','\color{black}\bf E[Capacity] (N_T = 10)','Location','northwest');
grid on;
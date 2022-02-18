
% Set clear & Initialization
clear variables; close all; clc;


SNR_dB = 10; 
SNR = 10.^(SNR_dB/10);
iters = 1000; 
nT = 10;
NR = 1:10;
ray_fc = sqrt(0.5);
erg_capa = zeros(1,10);

for k = 1:length(NR)
    nR_sample = NR(k);

    rk = min(nT,nR_sample); % number of parallel channels 
    I = eye(rk);
    
    erg_capa(k) = zeros(1,length(SNR_dB));
    for i1 = 1:iters
        H = ray_fc*(randn(nR_sample,nT)+1j*randn(nR_sample,nT));
        SV = svd(H*H');
       
        for i2 = 1:length(SNR_dB) 
            p_optimum = power_allocation(SV,SNR(i2),nT);

            erg_capa(k) = erg_capa(k) + log(real(det(I + SNR(i2)/nT*diag(p_optimum)*diag(SV)))); 
        end
    end
end

erg_capa = real(erg_capa)/iters;

plot(NR,erg_capa(1,:),'b:d');

xlim([1 10]);
ylim([0 30]);

xlabel('Number of receive antennas, N_R')
ylabel('C{_s_e_c,_m_g}(nats/symbol)')
title('Fig.8. ')
legend('E[Capacity]','Location','northwest');
grid on;
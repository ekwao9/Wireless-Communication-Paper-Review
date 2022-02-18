
function [p_optm] = wfpaa(ch_resp,SNR,nT)

p_optm = zeros(1,length(ch_resp));
r = length(ch_resp); 
i1 = 1:r; 
tempIdx_1 = i1;

p = 1;
while p<r
    i2 = 1:r-p+1; 
    t1 = sum(1./ch_resp(tempIdx_1(i2)));
    mu = nT/(r-p+1)*(1+1/SNR*t1);
    p_optm(tempIdx_1(i2)) = mu - nT./(SNR*ch_resp(tempIdx_1(i2)));

    if min(p_optm(tempIdx_1))<0

        i = find(p_optm == min(p_optm));
        ii = find(tempIdx_1 == i);
        tempIdx_2 = [tempIdx_1([1:ii-1]) tempIdx_1([ii+1:end])];
        
        clear tempIdx_1;
        tempIdx_1 = tempIdx_2;
        
        p = p + 1;
        clear p_optm;
    else
        p = r;
    end
end
optP_new = zeros(1,length(ch_resp));
optP_new(tempIdx_1) = p_optm(tempIdx_1);
p_optm = optP_new;
end

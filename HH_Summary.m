% Auther: Will
% Email: weiliangzhou93@gmail.com

% start timing
tic;
% clear;

% In this case, we use data from 1-Jan-19 00:00:00 to 5-Jan-20 00:00:00
% to make sure the last week is a complete week. 48*4=192 HHs.
% 17520+192=17712
% 1st week starts from 6-Jan-19 00:00:00 (HH index 241), 
% ends 5-Jan-20 00:00:00, complete index: 241~17712

% load('HH_Sim_Spot_1000_NSW1_2018-04-21.mat', 'Spot_Sims', 'NewGen');
% load('StressTest_Output_300_6_2.mat');
% load('spot_prices_adj_withCap.mat');
time_vector = NewGen.TV(1:17712,:);
% spot_prices = Spot_Sims(1:17712,1:300);
wind_gen = NewGen.Output_Sapphire(1:17712,1:300);
spot_prices_adj = getfield(StressTest_Output_300_6_2, 'spot_prices_adj'); 
spot_prices_adjadj_withCap = spot_prices_adjadj;

HH_datetime_start = datetime(time_vector)-1/48;
HH_date = datetime(time_vector)-1/48;
HH_datetime_end = datetime(time_vector);
HH_date.Format = 'dd-MM-yyyy';

PPA_Qty = zeros(17712,300);
for i = 1:300
    % Period 1: 1-Jan-19 ~ 31-Mar-19; Period 2: 1-Apr-19 ~ 
    for n = 1:4320
        PPA_Qty(n,i) = (193/273).*wind_gen(n,i);
    end
    for n = 4321:17712
        PPA_Qty(n,i) = (152/273).*wind_gen(n,i);
    end
end
% original_spot_prices = zeros(17712,300);
% stressed_spot_prices = zeros(17712,300);
% Using hedging scenario 4, which is -30 MW
original_spot_prices = spot_prices_adj(1:17712,:,4,1);
stressed_spot_prices = spot_prices_adjadj_withCap(1:17712,:,4);

% For table 2, we use 
% 1st week starts from 6-Jan-19 00:00:00 (HH index 241), 
% ends 5-Jan-20 00:00:00, complete index: 241~17712
original_spot_prices_table2 = spot_prices_adj(241:17712,:,:,1);
stressed_spot_prices_table2 = spot_prices_adjadj_withCap(241:17712,:,:);
wind_gen_table2 = wind_gen(241:17712,:);
weekly_avg_ospt2 = zeros(52,300,6);
weekly_avg_sspt2 = zeros(52,300,6);
weekly_wgt2 = zeros(52,300);
for i = 1:300
    for j = 1:6
        for k = 1:52
            weekly_avg_ospt2(k,i,j) = mean(original_spot_prices_table2(1+336*(k-1):336+336*(k-1),i,j));
            weekly_avg_sspt2(k,i,j) = mean(stressed_spot_prices_table2(1+336*(k-1):336+336*(k-1),i,j));
            weekly_wgt2(k,i) = sum(wind_gen_table2(1+336*(k-1):336+336*(k-1),i))/2;
        end
    end
end

% end timing
toc;
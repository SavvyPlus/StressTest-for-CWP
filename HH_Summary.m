% Auther: Will
% Email: weiliangzhou93@gmail.com

% start timing
tic;
% clear;

% In this case, we use data from 1-Jan-19 00:00:00 to 5-Jan-20 00:00:00
% to make sure the last week is a complete week. 48*4=192 HHs.
% 17520+192=17712

% load('HH_Sim_Spot_1000_NSW1_2018-04-21.mat', 'Spot_Sims', 'NewGen');
% load('StressTest_Output_300_6_2.mat');
time_vector = NewGen.TV(1:17712,:);
spot_prices = Spot_Sims(1:17712,1:300);
wind_gen = NewGen.Output_Sapphire(1:17712,1:300);
spot_prices_adj = getfield(StressTest_Output_300_6_2, 'spot_prices_adj');

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
% end timing
toc;
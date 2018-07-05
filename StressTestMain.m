% Auther: Will
% Email: weiliangzhou93@gmail.com

% start timing
tic;
% Load the data into workspace, then comment the line below.
% Do not need to load repeatedly so the script can be run quicker. 
% load('HH_Sim_Spot_1000_NSW1_2018-04-21.mat', 'Spot_Sims', 'NewGen');
% To calculate the rolling 4 weeks data, we need simulations data
% from 1-Jan-19 00:30 to 26-Jan-20 00:00 (Sunday) 17520+1200=18720 HHs.
spot_prices = Spot_Sims(1:18720,1:300);
wind_gen = NewGen.Output_Sapphire(1:18720,1:300);
% Set some constants
mlf=0.9; 
% sold swap price($/MWh) (fixed block)
ssp=85;
% flat swap sold(MW): 0; -9; -20; -30
fss = [0 -9 -20 -30];
% PPA price($/MWh)
PPA_price = 80.95;

%x1 = lpfunction(wind_gen(:,1),mlf,fss,spot_prices(:,1));
% As we have 300 simulations * 4 fss * 2(adjusted/original) situations, so
% here using 4 dimensional arrays to store the results
x = zeros(18720,300,4,2);
spot_prices_adj = zeros(18720,300,4,2);
spot_revenue = zeros(18720,300,4,2);
cfd_fb = zeros(18720,300,4,2);
cfd_ppa = zeros(18720,300,4,2);
net_revenue = zeros(18720,300,4,2);
for i = 1:300
    for j = 1:4
        fss_temp = fss(j);
        x(:,i,j) = lpfunction(wind_gen(:,i),mlf,fss_temp,spot_prices(:,i));
        for k = 1:2 % 1: Original spot price, 2: Ajusted spot price
            spot_prices_adj(:,i,j,k) = spot_prices(:,i) + x(:,i,j,k)*(k-1);
            % spot_revenue
            spot_revenue(:,i,j,k) = mlf.*wind_gen(:,i).*spot_prices_adj(:,i,j,k)/2;
            % contract for difference (fixed block)
            cfd_fb(:,i,j,k) = (ssp - spot_prices_adj(:,i,j,k)).*fss_temp/2;
            % contract for difference (PPA)
            cfd_ppa(:,i,j,k) = (PPA_price-spot_prices_adj(:,i,j,k))*183/273.*wind_gen(:,i)/2;
            %net revenue
            net_revenue(:,i,j,k) = spot_revenue(:,i,j,k)+cfd_fb(:,i,j,k)+cfd_ppa(:,i,j,k);
            % weekly revenue
            weekly_revenue = zeros(55,i,j,k);
            for p = 1:length(weekly_revenue)
                weekly_revenue(p,i,j,k) = sum(net_revenue(241+336*(p-1):241+336*p-1,i,j,k));
            end
            % rolling 4-weeks revenue
            monthly_revenue = zeros(52,i,j,k);
            for q = 1:length(monthly_revenue)
                monthly_revenue(q,i,j,k) = sum(weekly_revenue((q:q+3),i,j,k));
            end

        end
    end
end


%%% The code below is for one single situation. %%%

%spot_prices_adj = spot_prices + x1;
%spot_revenue
%spot_revenue = wind_gen.*mlf.*spot_prices/2;
%spot_revenue_adj = wind_gen.*mlf.*spot_prices_adj/2;
%contract for difference (fixed block)
%cfd_fb = (ssp-spot_prices_adj).*fss./2;
%contract for difference (PPA)
%cfd_ppa = (PPA_price-spot_prices_adj)*183/273.*wind_gen/2;

%net revenue
%net_revenue = spot_revenue_adj+cfd_fb+cfd_ppa;

% weekly results
% First week ending in 2019 is 5-Jan-19 Sat, it's not a complete week, so
% the start week for weekly revenue is
% 6-Jan-19 00:30 (Sun) ~ 13-Jan-19 00:00 (Sun)
% The last week in 2019 for weekly revenue is 
% 29-Dec-19 00:00 (Sun) ~ 5-Jan-20 00:00 (Sun)
% And there are 3 more weeks.
% And to calculate the rolling 4 weeks revenue, we need weekly data
% from 6-Jan-19 00:30 (Sun) to 26-Jan-20 00:00 (Sunday). 
% 52&55 weeks.

% weekly revenue
% weekly_revenue = zeros(55,1);
% for i = 1:length(weekly_revenue)
%     weekly_revenue(i) = sum(net_revenue(241+336*(i-1):241+336*i-1));
% end
% 
% rolling 4-weeks revenue
% monthly_revenue = zeros(52,1);
% for i = 1:length(monthly_revenue)
%     monthly_revenue(i) = sum(weekly_revenue(i:i+3));
% end

% end timing
toc;
% Auther: Will
% Email: weiliangzhou93@gmail.com

% start timing
tic;

% load('HH_Sim_Spot_1000_NSW1_2018-04-21.mat', 'Spot_Sims', 'NewGen');
% load('StressTest_Output_300_6_2.mat');
% spot_prices = Spot_Sims(1:18720,1:300); % original spot price
spot_prices_adj = getfield(StressTest_Output_300_6_2, 'spot_prices_adj'); % adjusted spot price
spot_prices_adjadj = spot_prices_adj(:,:,:,2);  % adjusted according to Cap price
wind_gen = NewGen.Output_Sapphire(1:18720,1:300);
% Set some constants
mlf=0.9; 
% sold swap price($/MWh) (fixed block)
ssp=85;
% flat swap sold(MW): 0; -9; -20; -30; -40; -50
fss = [0 -9 -20 -30 -40 -50];
% PPA price($/MWh)
%PPA_price = 80.95;
PPA_price_1 = 80.33;
PPA_price_2 = 84.73;

% adjustment = x_test(:,:,:,1);
% spot_prices_adj = zeros(18720,300,6,2);
spot_revenue = zeros(18720,300,6,2);
cfd_fb = zeros(18720,300,6,2);
cfd_ppa = zeros(18720,300,6,2);
net_revenue = zeros(18720,300,6,2);
weekly_revenue = zeros(55,300,6,2);
monthly_revenue = zeros(52,300,6,2);

% CPT in adjusted simulation
CPT = zeros(18720,300,6);
CPT(1,:,:) = 26880;
for i = 2:336
    CPT(i,:,:) = 26880*(336-i)/336 + sum(spot_prices_adjadj(1:i,:,:));
end
for i = 337:18720
    CPT(i,:,:) = sum(spot_prices_adjadj(i-335:i,:,:));
end

% Set up AEMO admin spot price cap ($300) and update CPT
count_position = zeros(18720,300,6);
% admin_spot_prices = zeros(18720,300,6);
for i = 1:300
    for j = 1:6
        for k = 1:18720-336

            if count_position(k,i,j) ~= 0
%                 continue
                adjust = false;
            else
                adjust = true;
            end
            if CPT(k,i,j)-216900<0.0000001 && 216900-CPT(k,i,j)<0.0000001 && adjust
                for m = 1:336
                    if spot_prices_adjadj(k+m,i,j) >= 300
                        count_position(k+m,i,j) = 1;
                        spot_prices_adjadj(k+m,i,j) = 300;
                    else
                        count_position(k+m,i,j) = 2;
                    end
                end
            end
            if k > 335
                CPT(k,i,j) = sum(spot_prices_adjadj(k-335:k,i,j));
            end
        end
    end
end
for i = 18385:18720
    CPT(i,:,:) = sum(spot_prices_adjadj(i-335:i,:,:));
end
% Calculate the revenue
for i = 1:300
    for j = 1:6
        fss_temp = fss(j);
        for k = 1:2 % 1: Original spot price, 2: Ajusted spot price
            if k == 1
                spot_prices_adj(:,i,j,k) = spot_prices(:,i);
            elseif k == 2
                spot_prices_adj(:,i,j,k) = spot_prices_adjadj(:,i);
            end
            % spot_revenue
            spot_revenue(:,i,j,k) = mlf.*wind_gen(:,i).*spot_prices_adj(:,i,j,k)/2;
            % contract for difference (fixed block)
            cfd_fb(:,i,j,k) = (spot_prices_adj(:,i,j,k) - ssp).*fss_temp/2;
            % contract for difference (PPA)
            % Period 1: 1-Jan-19 ~ 31-Mar-19; Period 2: 1-Apr-19 ~ 
            for n = 1:4320
                cfd_ppa(n,i,j,k) = (spot_prices_adj(n,i,j,k)-PPA_price_1)*(-193/273).*wind_gen(n,i)/2;
            end
            for n = 4321:18720
                cfd_ppa(n,i,j,k) = (spot_prices_adj(n,i,j,k)-PPA_price_2)*(-152/273).*wind_gen(n,i)/2;
            end
            %net revenue
            net_revenue(:,i,j,k) = spot_revenue(:,i,j,k)+cfd_fb(:,i,j,k)+cfd_ppa(:,i,j,k);
            % weekly revenue
            %weekly_revenue = zeros(55,i,j,k);
            for p = 1:55
                weekly_revenue(p,i,j,k) = sum(net_revenue(241+336*(p-1): 241+336*p-1,  i,j,k));
            end
            % rolling 4-weeks revenue
            %monthly_revenue = zeros(52,i,j,k);
            for q = 1:52
                monthly_revenue(q,i,j,k) = sum(weekly_revenue((q:q+3),i,j,k));
            end
        end
    end
end

% end timing
toc;


% For single one simulation, one scenario

% admin_spot_prices = zeros(18720,1);
% for i=1:length(CPT)-336
%     if count_position(i) ~= 0
%         continue
%     end
%     if ~(CPT(i)<106500&&CPT(i)>106500)
%         for j = 1:336
%             if spot_prices(i+j,1)+adjustment(i+j) >= 300
%                 count_position(i+j) = 1;
%                 admin_spot_prices(i+j) = 300;
%             else
%                 count_position(i+j) = 2;
%             end
%         end
%     end
% end

% count = 0;
% count_position = zeros(18720,1);
% for i=1:length(CPT)
%     if CPT(i) == 106500 && (spot_prices(i,1)+adjustment(i))>= 300
%         count = count + 1;
%         count_position(i) = 1;
%     end
% end

% CPT in original simulation, initial value of CPT is $80*336=26880
% CPT_original = zeros(18720,1);
% CPT_original(1,1) = 26880;
% for i = 2:336
%     CPT_original(i,1) = 26880*(336-i)/336 + sum(spot_prices(1:i,1));
% end
% for i = 337:18720
%     CPT_original(i,1) = sum(spot_prices(i-335:i,1));
% end
% count_original = 0;
% for i=1:length(CPT_original)
%     if CPT_original(i) == 106500 && (spot_prices(i,1))>= 300
%         count_original = count_original + 1;
%     end
% end
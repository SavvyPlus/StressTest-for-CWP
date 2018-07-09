% Auther: Will
% Email: weiliangzhou93@gmail.com

% start timing
tic;

% load('HH_Sim_Spot_1000_NSW1_2018-04-21.mat', 'Spot_Sims', 'NewGen');
x_test = getfield(StressTest_Output_300_6_2, 'x_test');
spot_prices = Spot_Sims(1:18720,1:300);
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


adjustment = x_test(:,:,:,1);
spot_revenue = zeros(18720,300,6);
cfd_fb = zeros(18720,300,6);
cfd_ppa = zeros(18720,300,6);
net_revenue = zeros(18720,300,6);
weekly_revenue = zeros(55,300,6);
monthly_revenue = zeros(52,300,6);

% CPT in adjusted simulation
CPT = zeros(18720,300,6);
CPT(1,:,:) = 26880;
for i = 2:336
    CPT(i,:,:) = 26880*(336-i)/336 + sum(spot_prices(1:i,:,:)) + sum(adjustment(i,:,:));
end
for i = 337:18720
    CPT(i,:,:) = sum(spot_prices(i-335:i,:,:)) + sum(adjustment(i-335:i,:,:));
end

count_position = zeros(18720,300,6);
admin_spot_prices = zeros(18720,1);
for i=1:length(CPT)-336
    if count_position(i) ~= 0
        continue
    end
    if ~(CPT(i)<106500&&CPT(i)>16500)
        for j = 1:336
            if spot_prices(i+j,1)+adjustment(i+j) >= 300
                count_position(i+j) = 1;
                admin_spot_prices(i+j) = 300;
            else
                count_position(i+j) = 2;
            end
        end
    end
end



% end timing
toc;


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
% Write to csv file

% start timing
tic;
% table 2: SimNo, WeekNo, AvgSpotPrice, AvgStressedSpotPrice,
% HedgingScenario, WindGen(MWh)
% 52*300*6=93600
Output2 = zeros(93600,6);
% Col 1: Simulation numbers
SimNo_T2 = zeros(93600,1);
temp1 = zeros(312,300);
for i = 1:300
    temp1(:,i) = i;
end
for i = 1:300
    SimNo_T2(1+312*(i-1):312+312*(i-1)) = temp1(:,i);
end

% Col 2: Week numbers
WeekNo_T2 = zeros(93600,1);
temp2 = zeros(52,1);
temp3 = zeros(312,1);
for i = 1:52
    temp2(i) = i;
end
for i = 1:6
    temp3(1+52*(i-1):52+52*(i-1)) = temp2(:);
end
for i = 1:300
    WeekNo_T2(1+312*(i-1):312+312*(i-1)) = temp3(:);
end

% Col 3: Weekly Average Spot Price
AvgSpotPrice = zeros(93600,1);
count = 0;
for i = 1:300
    for j = 1:6
        AvgSpotPrice(1+52*count : 52+52*count) = weekly_avg_ospt2(:,i,j);
        count = count + 1;
    end
end

% Col 4: Weekly Average Stressed Spot Price
AvgStressedSpotPrice = zeros(93600,1);
count = 0;
for i = 1:300
    for j = 1:6
        AvgStressedSpotPrice(1+52*count : 52+52*count) = weekly_avg_sspt2(:,i,j);
        count = count + 1;
    end
end

% Col 5: Hedging Scenario
% It's easier to do this in excel. 

% Col 6: Weekly Wind Generation
WeeklyWindGen = zeros(93600,1);
count = 0;
for i = 1:300
    for j = 1:6
        WeeklyWindGen(1+52*count : 52+52*count) = weekly_wgt2(:,i);
        count = count + 1;
    end
end

% Write Data to Excel
Output2(:,1:5) = [SimNo_T2 WeekNo_T2 AvgSpotPrice AvgStressedSpotPrice WeeklyWindGen];

filename = 'OutputTabel2_Avg.xlsx';
xlswrite(filename, Output2);
% end timing
toc;
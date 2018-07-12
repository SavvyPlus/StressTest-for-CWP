% Auther: Will
% Email: weiliangzhou93@gmail.com
% start timing
tic;
% Table rows: 52*11*6=3432
Output = zeros(3432,4);
% load('StressTest_Output_300_6_2.mat');
% weekly_revenue = getfield(StressTest_Output_300_6_2, 'weekly_revenue');

% Find SimNo for certain percentile
p = [100 95 75 50 25 5 4 3 2 1 0]; % percentiles we are interested in.
Sim_No = zeros(52,6,11);
for i = 1:52
    for j = 1:6
        week_temp = weekly_revenue(i,:,j,2);
        Y = prctile(week_temp,p);
        for k = 1:length(p)
            [c index] = min(abs(week_temp-Y(k)));
            Sim_No(i,j,k) = index;
        end
    end
end

% WeekNo 1~52, 11*6=66
WeekNo = zeros(3432,1);
temp_WeekNo = zeros(66,52);
for i = 1:52
    temp_WeekNo(:,i) = i;
end
for i = 1:52
    WeekNo(1+66*(i-1):66+66*(i-1)) = temp_WeekNo(:,i);
end

% SimNo (11) 
SimNo = zeros(3432,1);
count = 0;
for i = 1:52
    for j = 1:6
        SimNo(1+11*count:11+11*count) = Sim_No(i,j,:);
        count = count + 1;
    end
end

% Write Data to Excel
Output(:,1:2) = [WeekNo SimNo];

filename = 'PercentileSimulation.xlsx';
xlswrite(filename, Output);

% end timing
toc;
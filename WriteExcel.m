% The whole data is 55*300*4*2=132000 rows and 7 columns
% Columns: SimNo,WeekNo,WeeklyRevenue,4WeekRollingWeekNo,MonthlyRevenue,ScenarioNo,SpotNo

Output = zeros(132000,7);

% Simulation numbers
SimNo = zeros(132000,1);
temp1 = zeros(440,300);
for i = 1:300
    temp1(:,i) = i;
end
for i = 1:300
    SimNo(1+440*(i-1):440+440*(i-1)) = temp1(:,i);
end
% Week numbers
WeekNo = zeros(132000,1);
temp2 = zeros(55,1);
temp = zeros(440,1);
for i = 1:55
    temp2(i) = i;
end
for i = 1:8
    temp(1+55*(i-1):55+55*(i-1)) = temp2(:);
end
for i = 1:300
    WeekNo(1+440*(i-1):440+440*(i-1)) = temp(:);
end
% Weekly Revenue
WeekRevenue = zeros(132000,1);
count = 0;
for i = 1:300
    for j = 1:4
        for k = 1:2
            WeekRevenue(1+55*count : 55+55*count) = weekly_revenue(:,i,j,k);
            count = count + 1;
        end
    end
end
% Monthly Revenue
MonthRevenue = zeros(132000,1);
count = 0;
for i = 1:300
    for j = 1:4
        for k = 1:2
            MonthRevenue(1+55*count : 52+55*count) = monthly_revenue(:,i,j,k);
            MonthRevenue(53+55*count : 55+55*count) = 0;
            count = count + 1;
        end
    end
end
% Write Data to Excel
Output(:,1:4) = [SimNo WeekNo WeekRevenue MonthRevenue];

filename = 'testdata.xlsx';
xlswrite(filename, Output);

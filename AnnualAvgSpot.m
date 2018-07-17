% Auther: Will
% Email: weiliangzhou93@gmail.com
% start timing
tic;

%% Annual Average Summary
% Table rows: 300*6=1,800
% Table columns: 4
% SimNo, HedgingStrategy, AvgAnnualSpot, AvgAnnualStressedSpot

OutputAnnualAvg = zeros(1800,2);

% Col 1: Average Annual Spot Price
AvgAnnualSpot = zeros(1800,1);
AvgAnnualSpotPrice = zeros(300,1);
for i = 1:300
    AvgAnnualSpotPrice(i) = mean(spot_prices_adj(241:17712,i,1,1));
end
count = 0;
for i = 1:300
    AvgAnnualSpot(1+count*6:6+count*6) = AvgAnnualSpotPrice(i);
    count = count + 1;
end

% Col 2: Average Annual Stressed Spot Price
AvgAnnualStessedSpot = zeros(1800,1);
AvgAnnualStessedSpotPrice = zeros(300,6);
for i = 1:300
    for j = 1:6
        AvgAnnualStessedSpotPrice(i,j) = mean(spot_prices_adj(241:17712,i,j,2));
    end
end
for i = 1:300
    for j = 1:6
        AvgAnnualStessedSpot((i-1)*6+j) = AvgAnnualStessedSpotPrice(i,j);
    end
end

% Write Data to Excel
OutputAnnualAvg(:,1:2) = [AvgAnnualSpot AvgAnnualStessedSpot];

filename = 'OutputAnnualAvg.xlsx';
xlswrite(filename, OutputAnnualAvg);
% end timing
toc;
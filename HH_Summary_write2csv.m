% Write to csv file

% start timing
tic;
% table 1:
% SimNo,Date,HHStart,HHEnd,HHPeriod,OrigiSpot,StressedSpot,WindGen,PPAQty
% The whole data is 17712*300=5313600 rows and 9 columns
Output1 = zeros(5313600,9);

% Col 1: Simulation numbers
SimNo_T1 = zeros(5313600,1);
temp1 = zeros(17712,300);
for i = 1:300
    temp1(:,i) = i;
end
for i = 1:300
    SimNo_T1(1+17712*(i-1):17712+17712*(i-1)) = temp1(:,i);
end
% Col 2: Date
% Date_T1 = datetime(zeros(5313600,3));
Date_T1 = strings(5313600,1);
for i = 1:300
    Date_T1(1+17712*(i-1):17712+17712*(i-1)) = datestr(HH_date(:,1));
end
% Col 3: HH Start
% HHStart_T1 = datetime(zeros(5313600,6));
HHStart_T1 = strings(5313600,1);
for i = 1:300
    HHStart_T1(1+17712*(i-1):17712+17712*(i-1)) = datestr(HH_datetime_start(:,1));
end
% Col 4: HH End
% HHEnd_T1 = datetime(zeros(5313600,6));
HHEnd_T1 = strings(5313600,1);
for i = 1:300
    HHEnd_T1(1+17712*(i-1):17712+17712*(i-1)) = datestr(HH_datetime_end(:,1));
end
% Col 5: HH Period
HHPeriod_T1 = zeros(5313600,1);
temp2 = zeros(48,1);
for i = 1:48
    temp2(i) = i;
end
temp3 = zeros(17712,1);
for i = 1:369
    temp3(1+48*(i-1):48+48*(i-1)) = temp2(:);
end
for i = 1:300
    HHPeriod_T1(1+17712*(i-1):17712+17712*(i-1)) = temp3(:);
end
% Col 6: Original Spot Price
Original_SpotPrices_T1 = zeros(5313600,1);
for i = 1:300
    Original_SpotPrices_T1(1+17712*(i-1):17712+17712*(i-1)) = original_spot_prices(:,i);
end
% Col 7: Stressed Spot Price
Stressed_SpotPrices_T1 = zeros(5313600,1);
for i = 1:300
    Stressed_SpotPrices_T1(1+17712*(i-1):17712+17712*(i-1)) = stressed_spot_prices(:,i);
end
% Col 8: Wind Generation
Wind_Gen_T1 = zeros(5313600,1);
for i = 1:300
    Wind_Gen_T1(1+17712*(i-1):17712+17712*(i-1)) = wind_gen(:,i);
end
% Col 9: PPA Qty(MW)
PPA_Qtys_T1 = zeros(5313600,1);
for i = 1:300
    PPA_Qtys_T1(1+17712*(i-1):17712+17712*(i-1)) = PPA_Qty(:,i);
end
% Output for table 1
% Output1(:,1:9) = [SimNo_T1 Date_T1 HHStart_T1 HHEnd_T1 HHPeriod_T1 Original_SpotPrices_T1 Stressed_SpotPrices_T1 Wind_Gen_T1 PPA_Qtys_T1];
fid = fopen('OutputTable1.csv','w');
for jj = 1:5313600
    fprintf( fid, '%d,%s,%s,%s,%d,%f,%f,%f,%f\n',...
        SimNo_T1{jj}, Date_T1{jj}, HHStart_T1{jj}, HHEnd_T1{jj}, ...
        HHPeriod_T1{jj}, Original_SpotPrices_T1{jj}, ...
        Stressed_SpotPrices_T1{jj}, Wind_Gen_T1{jj}, PPA_Qtys_T1{jj});
end
fclose( fid );
% end timing
toc;
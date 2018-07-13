% Auther: Will
% Email: weiliangzhou93@gmail.com
% start timing
tic;
% Table rows: 336*11*6*52=1,153,152
% Table columns: 13
% WeekNo,Scenario,Percentile,SimNo,HH,HHStart,HHEnd,HHPeriod,OriSpot,
% StressedSpot,WindGen,PPAQty,CPT
Output_SimulationWeeklyHHs = zeros(1153152,13);

% load('HH_Sim_Spot_1000_NSW1_2018-04-21.mat', 'NewGen');
% load('StressTest_Output_300_6_2_PriceCap.mat');
% load('Sim_No.mat');
time_vector = NewGen.TV(1:17712,:);
wind_gen = NewGen.Output_Sapphire(1:17712,1:300);
spot_prices_adj = getfield(StressTest_Output_300_6_2_PriceCap, 'spot_prices_adj'); 

HH_start = datestr(datetime(time_vector)-1/48);
HH_date = datetime(time_vector)-1/48;
HH_end = datestr(datetime(time_vector));
HH_date.Format = 'dd-MM-yyyy';
HH_date = datestr(HH_date);

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

% Col 1: WeekNo
WeekNo = zeros(1153152,1);
WeekNo_temp = zeros(52,1);
for i = 1:52
    WeekNo_temp(i) = i;
end
for i = 1:52
    WeekNo(1+(i-1)*22176:22176+(i-1)*22176) = WeekNo_temp(i);
end
% Col 2: Scenario
Scenario = zeros(1153152,1);
ScenariosList = [0 -9 -20 -30 -40 -50];
Scenario_temp = zeros(22176,1);
for i = 1:6
    Scenario_temp(1+3696*(i-1):3696+3696*(i-1)) = ScenariosList(i);
end
for i = 1:52
    Scenario(1+22176*(i-1):22176+22176*(i-1)) = Scenario_temp(:);
end
% Col 3: Percentile
Percentile = zeros(1153152,1);
PercentilesList = [100 95 75 50 25 5 4 3 2 1 0];
Percentile_temp = zeros(3696,1);
for i = 1:11
    Percentile_temp(1+336*(i-1):336+336*(i-1)) = PercentilesList(i);
end
for i = 1:312
    Percentile(1+3696*(i-1):3696+3696*(i-1)) = Percentile_temp(:);
end
% Col 4: SimNo
SimNo = zeros(1153152,1);
count = 0;
for i = 1:52
    for j = 1:6
        for k = 1:11
            SimNo(1+336*count:336+336*count) = Sim_No(i,j,k);
            count = count + 1;
        end
    end
end
% Col 5: Half Hours
HalfHours = zeros(1153152,1);
HalfHours_temp = zeros(336,1);
for i = 1:336
    HalfHours_temp(i) = i;
end
for i = 1:3432
    HalfHours(1+336*(i-1):336+336*(i-1)) = HalfHours_temp(:);
end
% Col 6: HH Start
HHStart = strings(1153152,1);
for i = 1:52
    for j = 1:66
        HHStart(1+336*(j-1)+22176*(i-1):336+336*(j-1)+22176*(i-1))...
            = HH_start(240+1+336*(i-1):240+336+336*(i-1),:);
    end
end
% Col 7: HH End
HHEnd = strings(1153152,1);
for i = 1:52
    for j = 1:66
        HHEnd(1+336*(j-1)+22176*(i-1):336+336*(j-1)+22176*(i-1))...
            = HH_end(240+1+336*(i-1):240+336+336*(i-1),:);
    end
end
% Col 8: HH Period
HHPeriod = zeros(1153152,1);
HHPeriod_temp = zeros(48,1);
for i = 1:48
    HHPeriod_temp(i) = i;
end
for i = 1:24024
    HHPeriod(1+48*(i-1):48+48*(i-1)) = HHPeriod_temp(:);
end
% Col 9: Original Spot Price
OriginalSpotPrice = zeros(1153152,1); % 1: original; 2: stressed
count = 0;
for week = 1:52
    for hedging = 1:6
        for percentile = 1:11
            Sim_No_temp = Sim_No(week,hedging,percentile);
            OriginalSpotPrice(1+336*count:336+336*count,1) = spot_prices_adj(240+1+336*(week-1):240+336+336*(week-1),Sim_No_temp,hedging,1);
%             SpotPrice(1+336*count:336+336*count,2) = spot_prices_adj(240+1+336*(week-1):240+336+336*(week-1),Sim_No_temp,hedging,2);
            count = count + 1;
        end
    end
end
% Col 10: Stressed Spot Price
StessedSpotPrice = zeros(1153152,1); % 1: original; 2: stressed
count = 0;
for week = 1:52
    for hedging = 1:6
        for percentile = 1:11
            Sim_No_temp = Sim_No(week,hedging,percentile);
%             SpotPrice(1+336*count:336+336*count,1) = spot_prices_adj(240+1+336*(week-1):240+336+336*(week-1),Sim_No_temp,hedging,1);
            StessedSpotPrice(1+336*count:336+336*count,1) = spot_prices_adj(240+1+336*(week-1):240+336+336*(week-1),Sim_No_temp,hedging,2);
            count = count + 1;
        end
    end
end
% Col 11: Wind Generation
WindGen = zeros(1153152,1);
count = 0;
for week = 1:52
    for hedging = 1:6
        for percentile = 1:11
            Sim_No_temp = Sim_No(week,hedging,percentile);
            WindGen(1+336*count:336+336*count) = wind_gen(240+1+336*(week-1):240+336+336*(week-1),Sim_No_temp);
            count = count + 1;
        end
    end
end
% Col 12: PPA Qty
PPAQty = zeros(1153152,1);
count = 0;
for week = 1:52
    for hedging = 1:6
        for percentile = 1:11
            Sim_No_temp = Sim_No(week,hedging,percentile);
            PPAQty(1+336*count:336+336*count) = PPA_Qty(240+1+336*(week-1):240+336+336*(week-1),Sim_No_temp);
            count = count + 1;
        end
    end
end
% Col 13: CPT
CPT = zeros(1153152,1);

% WeekNo,Scenario,Percentile,SimNo,HH,HHStart,HHEnd,HHPeriod,OriSpot,
% StressedSpot,WindGen,PPAQty,CPT
fid = fopen('SimulationWeeklyHalfHours.csv','w');
for dt = 1:1153152
    fprintf( fid, '%d,%d,%d,%d,%d,%s,%s,%d,%f,%f,%f,%f,%f\n',...
        WeekNo(dt),Scenario(dt),Percentile(dt),SimNo(dt),HalfHours(dt),...
        HHStart(dt),HHEnd(dt),HHPeriod(dt),OriginalSpotPrice(dt),StessedSpotPrice(dt),...
        WindGen(dt),PPAQty(dt),CPT(dt));
end
fclose( fid );

% end timing
toc;
% Write to csv file

% start timing
tic;
% WeekNo, Start_HH_Ending, End_HH_Ending, Start_HH_Beginning, End_HH_Beginning
% For table 3, we use 
% 1st week starts from 6-Jan-19 00:00:00 (HH index 241), 
% ends 5-Jan-20 00:00:00, complete index: 241~17712. 52 weeks
Output3 = zeros(52,5);
% Col 1: Week numbers
WeekNo_T3 = zeros(52,1);
for i = 1:52
    WeekNo_T3(i) = i;
end

Start_HH_Ending = datetime(zeros(52,6));
End_HH_Ending = datetime(zeros(52,6));
Start_HH_Beginning = datetime(zeros(52,6));
End_HH_Beginning = datetime(zeros(52,6));

First_Start_HH_Ending = datetime(time_vector(241,:));
First_Start_HH_Beginning = datetime(time_vector(241,:))-1/48;
count = 0;
for w = 1:52
    Start_HH_Ending(w) = First_Start_HH_Ending + 7*count;
    End_HH_Ending(w) = First_Start_HH_Ending + 7*(count+1) - 1/48;
    Start_HH_Beginning(w) = First_Start_HH_Ending + 7*count - 1/48;
    End_HH_Beginning(w) = First_Start_HH_Ending + 7*(count+1) - 1/48 -1/48;
    count = count + 1;
end

% Change datetime to datestr
Start_HH_Ending_str = datestr(Start_HH_Ending);
End_HH_Ending_str = datestr(End_HH_Ending);
Start_HH_Beginning_str = datestr(Start_HH_Beginning);
End_HH_Beginning_str = datestr(End_HH_Beginning);
% Write Data to Excel
% Output3(:,1:5) = [WeekNo_T3 Start_HH_Ending End_HH_Ending Start_HH_Beginning End_HH_Beginning];
fid = fopen('OutputTable3.csv','w');
for dt = 1:52
    fprintf( fid, '%d,%s,%s,%s,%s\n',...
        WeekNo_T3(dt),Start_HH_Ending(dt),End_HH_Ending(dt),Start_HH_Beginning(dt),End_HH_Beginning(dt));
end
fclose( fid );

% filename = 'OutputTabel3_HHs.xlsx';
% xlswrite(filename, Output3);

% end timing
toc;
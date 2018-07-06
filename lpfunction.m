% Auther: Will
% Email: weiliangzhou93@gmail.com

function y = lpfunction(wind_gen,mlf,fss,spot_prices)
% Minimize the objective function
f4 = (273-152)/273.*(wind_gen-273)/2*mlf+fss/2;
f = transpose(f4);

A = eye(18720);
for i = 1:336
    A(i,1:i)=1;
end
for i = 337:18720
    A(i,(i-335):i)=1;
end

b = zeros(18720,1);
for i = 1:336
    b(i,1)=106500-26880*(336-i)/336-(sum(spot_prices(1:i)));
end
for i = 337:18720
    b(i,1)=106500-sum(spot_prices(i-335:i));
end

lb = zeros(18720,1);
ub = 14200-spot_prices;

y = linprog(f,A,b,[],[],lb,ub);
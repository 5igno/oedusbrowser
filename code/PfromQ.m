function P = PfromQ(Q)

for id_peak = 1:Q(1).value
    % peaks(id_peak).height = Q(2).value(id_peak);
    % peaks(id_peak).position = Q(3).value(id_peak);
    % peaks(id_peak).width = Q(4).value(id_peak);
    P(3*(id_peak-1)+(1:3)) = [ Q(2).value(id_peak) , Q(3).value(id_peak) , Q(4).value(id_peak) ]; %#ok<AGROW>

end

if length(Q) == 6 % Slope and Intercept of background are included!
   
    lenght_P = length(P);
    % Baseline.Slope = Q(5).value;
    P(lenght_P + 1) = Q(5).value;
    
    % Baseline.Intercept = Q(6).value;
    P(lenght_P + 2) = Q(6).value;
end
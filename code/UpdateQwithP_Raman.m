function Q = UpdateQwithP_Raman( Q, P, uncertainty_p )

% Get the new parameters in Q

N_peaks = Q(1).value;

for id_parameter=2:length(Q) % N_peaks should not be changed
    switch id_parameter
        case{2,3,4}
        indexes = (id_parameter-1)+3*(0:1:N_peaks-1);
        Q(id_parameter).value = P(indexes);
        Q(id_parameter).uncertainty = uncertainty_p(indexes);
        otherwise
        indexes = (id_parameter-1)+3*(N_peaks-1);
        Q(id_parameter).value = P(indexes);
        Q(id_parameter).uncertainty = uncertainty_p(indexes);
    end
end


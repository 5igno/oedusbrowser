function Intensity = PL_JDOS (Energy,peak)

[enne,emme] = size(peak); N_peaks = max(enne,emme);
[N_points,~] = size(Energy);

Intensity =zeros(N_points,1);

for k=1:N_peaks
    % Extracting current peak parameters
    Height = peak(k).height;
    Peak_position = peak(k).position;
    
    % Adding single Lorentian Component
    Intensity = Intensity + Height .* sqrt(Energy - Peak_position);
end
function Intensity = Lorentian (Energy,peak)

[enne,emme] = size(peak); N_peaks = max(enne,emme);
[N_points,~] = size(Energy);

Intensity =zeros(N_points,1);

for k=1:N_peaks
    % Extracting current peak parameters
    Height = peak(k).height;
    Line_broadening = peak(k).width;
    Peak_position = peak(k).position;
    
    % Adding single Lorentian Component
    Intensity = Intensity + Height .* (Line_broadening.^2)./(Line_broadening.^2+(Energy-Peak_position).^2);
end
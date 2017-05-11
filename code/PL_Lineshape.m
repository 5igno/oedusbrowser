function Intensity = PL_Lineshape (Energy,energy_gap,maximum_intensity,width,temperature)

Energy = Energy(:);

N_peaks = length(energy_gap);
N_points = length(Energy);

% Define the Boltzmann constant
KB = 8.617385E-5 ;%eV/K

%  Boltzmann distribiution

Intensity = zeros(length(Energy),1);

if width > 0 %#ok<*NODEF>

        % Enlarge the x domain by a 8 times the width:
        % this ensures that the convolution is accurate until the borders
        
        old_Energy = Energy;
        l_old_Energy = length(old_Energy);

        dEnergy = abs(diff(old_Energy));
        
        mean_dEnergy = mean(diff(Energy));

        MinEnergy = min(Energy);
        MaxEnergy = max(Energy);
        newEnergy_min = MinEnergy-width*4;
        newEnergy_max = MaxEnergy+width*4;
        
        below_Energy = [newEnergy_min:mean_dEnergy:MinEnergy-mean_dEnergy]'; 
        N_below = length(below_Energy);
        
        above_Energy = [MaxEnergy+mean_dEnergy:mean_dEnergy:newEnergy_max]';
        N_above = length(above_Energy);
        
        Energy = [below_Energy;old_Energy;above_Energy];
        dEnergy = abs(diff(Energy));
        % make the increment vector equal to the vector of the x (this is an approximation)
        dEnergy=[dEnergy;dEnergy(end)];
        
        
        Intensity = zeros(length(Energy),1);
        BroadenedPL = zeros(length(Energy),1);
       
end     
if width <= 0
    
        width = 0;
        
        MinEnergy = min(Energy);
        MaxEnergy = max(Energy);
end

Bolzmann = exp( -( (Energy-MinEnergy)./( KB .* temperature ) ) );

% Sum over the contributions of different peaks
for k=1:N_peaks
    JDOS = maximum_intensity(k).*(exp( ( (energy_gap(k)-MinEnergy+KB*temperature/2)./( KB .* temperature ) ) )).*(Energy > energy_gap(k)).*  sqrt(Energy - energy_gap(k)); 
    Intensity = Intensity + JDOS;
end

% Populate the transitions with the JDOS
Intensity = Intensity.*Bolzmann;

% Convolute with a Gaussian to take line width into account
if width > 0
    l = length(Energy);
    BroadenedPL = zeros(l,1);
    
    % I scan through all possible values of x:
    for k=1:l
        % The Lorentian has to be evaluated at point x(k)
        Gaussian = (1/sqrt(2.*pi.*width.^2)).*exp((-(Energy-Energy(k)).^2)./(2.*width.^2));
        
        % Evaluate the convolution integral;
        BroadenedPL(k) = (Intensity.*Gaussian)'*dEnergy;
    end

    Intensity = BroadenedPL;

end


% Return to the old x range:
if width > 0
    Intensity = Intensity(N_below+1:N_below+length(old_Energy));
end


% for k=1:N_peaks
%     % Extracting current peak parameters
%     Height = peak(k).height;
%     Peak_position = peak(k).position;
%     
%     % Adding single Lorentian Component
%     Intensity = Intensity + Height .* (Line_broadening.^2)./(Line_broadening.^2+(Energy-Peak_position).^2);
% end

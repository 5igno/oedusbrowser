function [FitResult, I_Fitted, I_Uncertainty] = RamanFitWithGuess(Spectrum)

% Prepare the parameter Structure P and the static structure Q for the fitting
FitParameters = Spectrum.FittingParameters;

FitResult = FitParameters{1,3};

[N_trial,ix_Q] = size(FitParameters{1,3});
Q = FitParameters{1,3}{N_trial,ix_Q};
P = PfromQ(Q);

% Get the x and y axis for the fitting
Range = Spectrum.RamanShift;
Intensity = Spectrum.Intensity;

% Execute the fitting
[I_Fitted, P, I_Uncertainty, uncertainty_p] = ...
    GIOleasqr(Range',Intensity', Q, P, 'Lorentzian_Lineshape_GUI');

% Update the Q structure with the updated fitting values
Q = UpdateQwithP_Raman( Q, P, uncertainty_p );

FitResult{N_trial,ix_Q} = Q; 


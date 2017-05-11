function selected_spectrum = OptimizeFit( selected_spectrum, roi_slct, method_switch )

if isfield(selected_spectrum,'FittingParameters')
    
    % Extract Fitting parameter cell array
    FittingParameters = selected_spectrum.FittingParameters;

    if ~isempty(FittingParameters)
        switch method_switch
            case 'Optimize'
                if ~isempty(FittingParameters{roi_slct,3})
                    selected_spectrum = ContinueOptimizeFit( selected_spectrum, roi_slct, method_switch );
                end
            case 'Define'
                selected_spectrum = ContinueOptimizeFit( selected_spectrum, roi_slct, method_switch );
        end
    end
end


function selected_spectrum = ContinueOptimizeFit( selected_spectrum, roi_slct, method_switch )

% Extract Fitting parameter cell array
FittingParameters = selected_spectrum.FittingParameters;

% Get ROI indexes and fitting type
ix = FittingParameters{roi_slct,2};
roi_type = FittingParameters{roi_slct,1};

% Fill up the temporary Spectrum structure
% Determine whether to perform backgroudn subtraction or not
ROI_type_sub_background = {'Raman', 'Photoluminescence'};
% Subtract Background to Intensity only if:
%    - background has been fitted 
%    - if you want the background to be subtracted from spectrum
if isfield( selected_spectrum, 'Background' ) && strcmp( roi_type, ROI_type_sub_background )*[1;1;1]  
    SpectrumInROI.Intensity = selected_spectrum.Intensity(ix) - selected_spectrum.Background(ix);
else
    SpectrumInROI.Intensity = selected_spectrum.Intensity(ix);
end
SpectrumInROI.Energy = selected_spectrum.Energy(ix);
SpectrumInROI.RamanShift = selected_spectrum.RamanShift(ix);
SpectrumInROI.Wavelength = selected_spectrum.Wavelength(ix);
SpectrumInROI.FittingParameters = FittingParameters(roi_slct,:);

% Perform the fitting
switch roi_type 
    case 'Raman'
        switch method_switch
            case 'Optimize'
                % Modify to accept initial guess
                [Fit_Results, I_Fitted, I_Uncertainty] = RamanFitWithGuess(SpectrumInROI);
            case 'Define'
                % Modify to accept initial guess
                [Fit_Results, I_Fitted, I_Uncertainty] = RamanGUI(SpectrumInROI);
        end
    case 'Photoluminescence'
        % Modify to accept initial guess
%         [Fit_Results, I_Fitted, I_Uncertainty] = PLGUI (SpectrumInROI);

    case 'Rayleigh line'
        switch method_switch
            case 'Optimize'
                % Modify to accept initial guess
                [Fit_Results, I_Fitted, I_Uncertainty] = RamanFitWithGuess(SpectrumInROI);
            case 'Define'
                % Modify to accept initial guess
                [Fit_Results, I_Fitted, I_Uncertainty] = RamanGUI(SpectrumInROI);
        end
    case 'Background'
        switch method_switch
            case 'Optimize'
                % Modify to make usable
                [Fit_Results,  I_Fitted, I_Uncertainty] = RamanFitWithGuess ( selected_spectrum, ix , fitwindow_handle);
                selected_spectrum.Background = Lorentzian_Lineshape_GUI(selected_spectrum.Energy,Q);

            case 'Define'
                % Modify to make usable
                [Fit_Results,  I_Fitted, I_Uncertainty] = RamanGUI( selected_spectrum, ix , fitwindow_handle);
                selected_spectrum.Background = Lorentzian_Lineshape_GUI(selected_spectrum.RamanShift,Q);
        end

end

% Populate the FitParameters cell array with the results of the fit
FittingParameters{roi_slct,3} = Fit_Results;
FittingParameters{roi_slct,4} = I_Fitted';
FittingParameters{roi_slct,5} = I_Uncertainty';

% Update the spectrum with the Fitting Parameters
selected_spectrum.FittingParameters = FittingParameters;

% % Plot Fitting, Check if it works !
% 
% figure(1), plot(SpectrumInROI.RamanShift, SpectrumInROI.Intensity,'k'), hold on;
% 
% if isfield(SpectrumInROI,'label')
%     SpectrumInROI.label = selected_spectrum.label;
% end
% SpectrumInROI.Energy = selected_spectrum.Energy(ix);
% SpectrumInROI.Wavelength = selected_spectrum.Wavelength(ix);
% SpectrumInROI.RamanShift = selected_spectrum.RamanShift(ix);
% SpectrumInROI.Fit = I_Fitted';
% SpectrumInROI.Uncertainty = I_Uncertainty';
% 
% PlotConfidenceInterval(SpectrumInROI, 'RamanShift', 'c', gca );
% hold off;
% pause
function PlotSpectraFitParameters(selected_spectrum, x_type, spectrum_axes, color)

roi_types = {'Background', 'Raman', 'Photoluminescence', 'Rayleigh line'};
ColorValues = lines(7);
colors = {'g',ColorValues(7,:),ColorValues(1,:),ColorValues(5,:)};

% Plot the raw data
PlotSingleSpectrum(selected_spectrum, x_type, spectrum_axes, color);

if ~isempty(selected_spectrum.FittingParameters)

    % Get used ROIs
    FittingParameters = selected_spectrum.FittingParameters;

    for id_type = 1:length(roi_types)

        % Define current ROI type
        selected_roi = WhereIsTheROI( FittingParameters, roi_types{id_type} );

        if ~isempty( selected_roi ) % Only plot if selected

            for id_slct = 1:length(selected_roi) % For all ROIs of the same type

                ROI = FittingParameters{selected_roi(id_slct), 2};

                if length( FittingParameters(selected_roi(id_slct), :) ) == 5

                    % Extract Fitting Results
                    ROI = FittingParameters{selected_roi(id_slct), 2};
                    Fit = FittingParameters{selected_roi(id_slct), 4};
                    Uncertainity = FittingParameters{selected_roi(id_slct), 5};

                    % Set Label
                    selected_spectrum.label = roi_types{id_type};

                    if isempty(Fit) || isempty(Uncertainity)
                        % No fitting: plot normally the Range
                        PlotSingleSpectrum(selected_spectrum, x_type, spectrum_axes, colors{id_type}, ROI);

                    else
                        % Fitting Available! Plot Fitting and Confidence Interval
                        spectrum_with_fits = MakeSpectrumFromFits(selected_spectrum, {Fit,Uncertainity}, ROI);
                        PlotConfidenceInterval(spectrum_with_fits, x_type, colors{id_type}, spectrum_axes );

                    end                
                else
                    % No fitting: plot normally the Range
                    PlotSingleSpectrum(selected_spectrum, x_type, spectrum_axes, colors{id_type}, ROI);

                end
            end
        end
    end
end
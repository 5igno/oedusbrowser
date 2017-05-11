function spectrum_axes = UpdateSpectrumPlot(selected_spectrum, spectrum_axes, varargin)
% UpdateSpectrumPlot( selected_spectrum, spectrum_axes, color, x_spectrum_type, y_spectrum_type )
        
font_size = 10;

switch length(varargin)
    case 1
        color = varargin{1};
        x_spectrum_type = 'RamanShift';
        y_spectrum_type = 'Linear';
        
    case 2
        color = varargin{1};
        x_spectrum_type = varargin{2};
        y_spectrum_type = 'Linear';
        
    case 3
        color = varargin{1};
        x_spectrum_type = varargin{2};
        y_spectrum_type = varargin{3};
        
    otherwise
        color = 'k';
        x_spectrum_type = 'RamanShift';
        y_spectrum_type = 'Linear';
end

set(spectrum_axes,'Visible','on');
cla(spectrum_axes);
hold(spectrum_axes, 'on');
    
%Plot data differently in case you have:
% - Fittings ;
if isfield(selected_spectrum,'FittingParameters')
    % Add code here to plot the data and the fittings
    PlotSpectraFitParameters(selected_spectrum, x_spectrum_type, spectrum_axes, color )

    hold(spectrum_axes, 'off');
    legend(spectrum_axes,'off');
% - just data ;
else
    % No fitting: plot normally the Range
    PlotSingleSpectrum(selected_spectrum, x_spectrum_type, spectrum_axes, color );
    hold(spectrum_axes, 'off');
    legend(spectrum_axes,'off');
    legend(spectrum_axes,'show');
end

% Axis Labels
switch x_spectrum_type
    case 'Energy'
        xlabel('Energy (eV)','FontSize',font_size);
    case 'Wavelength'
        xlabel('Wavelength (nm)','FontSize',font_size );
    case 'RamanShift'
        xlabel('Raman Shift (cm^{-1})','FontSize',font_size );
end
ylabel('Intensity (a.u.)');
switch y_spectrum_type
    case 'Linear'
        set(spectrum_axes,'YScale','linear','FontSize',font_size );
    case 'Logaritmic'
        set(spectrum_axes,'YScale','log','FontSize',font_size );
end

set(spectrum_axes,'FontSize',font_size);
axis tight;
box on;










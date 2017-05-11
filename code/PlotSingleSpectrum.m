function PlotSingleSpectrum(selected_spectrum, x_type, varargin )

switch length(varargin)
    case 1
        spectrum_axes = varargin{1};
        ix = (1:length(selected_spectrum.Energy));
        
    case 2
        spectrum_axes = varargin{1};
        color = varargin{2};
        ix = (1:length(selected_spectrum.Energy));
        
    case 3
        spectrum_axes = varargin{1};
        color = varargin{2};
        ix = varargin{3};
    
    otherwise
        spectrum_axes = gca;
        ix = (1:length(selected_spectrum.Energy));
        
end

% plot data and set x axis
switch x_type
    case 'Energy'
        hndl = plot( spectrum_axes, selected_spectrum.Energy(ix) , selected_spectrum.Intensity(ix) );

    case 'Wavelength'
        hndl = plot( spectrum_axes, selected_spectrum.Wavelength(ix) , selected_spectrum.Intensity(ix) );

    case 'RamanShift'
        hndl = plot( spectrum_axes, selected_spectrum.RamanShift(ix) , selected_spectrum.Intensity(ix) );

end

% Add legend to plot
if isfield(selected_spectrum, 'label')
	legend(hndl,selected_spectrum.label); % legend
elseif isfield(selected_spectrum, 'MotorPosition')
    	legend(hndl,num2str(selected_spectrum.MotorPosition)); % legend
end

% Set color
if exist('color','var')
    set(hndl,'Color',color)
end

set(hndl,'LineWidth',1);

box(spectrum_axes,'on');
axis(spectrum_axes,'tight');





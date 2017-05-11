function PlotConfidenceInterval(Spectrum, x_type, color, spectrum_axes )

% switch length(varargin)
%     case 1
%         spectrum_axes = varargin{1};
%         ix = (1:length(Spectrum.Energy));
%         
%     case 2
%         spectrum_axes = varargin{1};
%         ix = varargin{2};
%         
%     case 3
%         spectrum_axes = varargin{1};
%         ix = varargin{2};
%         color = varargin{3};
%     
%     otherwise
%         spectrum_axes = gca;
%         ix = (1:length(Spectrum.Energy));
%         
% end
ix = (1:length(Spectrum.Energy));
xi = ix(end:-1:1);
ix_close = [ix,xi];
I_close = [Spectrum.Fit(ix) + Spectrum.Uncertainty(ix), Spectrum.Fit(xi) - Spectrum.Uncertainty(xi)];

axes(spectrum_axes);

% Plot Shaded Area
switch x_type
    case 'Energy'
        hndl_area = fill( Spectrum.Energy(ix_close), I_close, color);

    case 'Wavelength'
        hndl_area = fill( Spectrum.Wavelength(ix_close), I_close, color);

    case 'RamanShift'
        hndl_area = fill( Spectrum.RamanShift(ix_close), I_close, color);

end
set(hndl_area,'FaceAlpha','0.4', 'Linestyle','none');
% plot data and set x axis
switch x_type
    case 'Energy'
        hndl_line = plot( spectrum_axes, Spectrum.Energy(ix) , Spectrum.Fit(ix) );

    case 'Wavelength'
        hndl_line = plot( spectrum_axes, Spectrum.Wavelength(ix) , Spectrum.Fit(ix) );

    case 'RamanShift'
        hndl_line = plot( spectrum_axes, Spectrum.RamanShift(ix) , Spectrum.Fit(ix) );

end

% Set color
if exist('color','var')
    set(hndl_line,'Color',color)
end
set(hndl_line,'LineWidth',2);

% % Add legend to plot
% if isfield(Spectrum, 'label')
% 	legend(hndl_area,Spectrum.label); % legend
% elseif isfield(Spectrum, 'MotorPosition')
% 	legend(hndl_area,num2str(Spectrum.MotorPosition)); % legend
% end
% legend(hndl_line,'_');


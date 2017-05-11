function spectrum_with_fits = MakeSpectrumFromFits(selected_spectrum, FitsAtType, ix)
                        
if isfield(selected_spectrum,'label')
    spectrum_with_fits.label = selected_spectrum.label;
end
spectrum_with_fits.Energy = selected_spectrum.Energy(ix);
spectrum_with_fits.Wavelength = selected_spectrum.Wavelength(ix);
spectrum_with_fits.RamanShift = selected_spectrum.RamanShift(ix);
spectrum_with_fits.Fit = FitsAtType{1,1};
spectrum_with_fits.Uncertainty = FitsAtType{1,2};
                        
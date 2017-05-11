function x_type = GetXaxis(selector)

switch get(selector,'Value');
    case 1
        x_type = 'RamanShift';
    case 2 
        x_type = 'Energy';
    case 3 
        x_type = 'Wavelength';
end

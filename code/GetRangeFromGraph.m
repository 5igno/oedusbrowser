function ix =  GetRangeFromGraph ( message_text_handle , message, x_type, spectrum )

set( message_text_handle , 'String', message );
[x_limits,~] = ginput(2);

switch x_type
    case 'RamanShift'
        ix = find(spectrum.RamanShift > min(x_limits) & spectrum.RamanShift < max(x_limits));
    case 'Energy'
        ix = find(spectrum.Energy > min(x_limits) & spectrum.Energy < max(x_limits));
    case 'Wavelength'
        ix = find(spectrum.Wavelength > min(x_limits) & spectrum.Wavelength < max(x_limits));
end
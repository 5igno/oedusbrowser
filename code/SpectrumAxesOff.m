function SpectrumAxesOff(spectrum_axes)

switch get(spectrum_axes,'Visible')
    case  'on'
        legend(spectrum_axes,'off');
        set(spectrum_axes,'Visible','off');
    case 'off'
end
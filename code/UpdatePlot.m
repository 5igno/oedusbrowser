function UpdatePlot( plotStr, data )

spectrum_options_panel_hndl = plotStr.optical.hndl.spectrum_options_panel;
spectrum_axes_hndl          = plotStr.optical.hndl.spectrum_axes;
iv_panel_hndl               = plotStr.electrical.hndl.iv_panel;

if isempty( data.target ) || isempty( data.selected ) || ~isinthe( data.type ,{'SingleSpectrum', 'SingleElectricalMeasurement', 'InstrumentSequence', 'StrainMeasurement'} )
%     Visibility( [ iv_panel_hndl , spectrum_options_panel_hndl ], 'off' );
    Visibility( plotStr.electrical.hndl, 'off' );
    Visibility( plotStr.optical.hndl, 'off' );
    
else
    switch GetDataType( data.selected ) % Use the data type of the final element
        case 'SingleSpectrum'
            Visibility( plotStr.electrical.hndl, 'off' );
            Visibility( plotStr.optical.hndl, 'on' );
%             Visibility( iv_panel_hndl, 'off' );
%             Visibility( [ spectrum_options_panel_hndl, spectrum_axes_hndl ], 'on' );
            UpdateSpectrumPlot( data.selected, spectrum_axes_hndl, data.color, plotStr.optical.x_type, plotStr.optical.y_type );
            
        case 'SingleElectricalMeasurement'
            Visibility( plotStr.electrical.hndl, 'on' );
            Visibility( plotStr.optical.hndl, 'off' );
%             Visibility( [spectrum_options_panel_hndl, spectrum_axes_hndl], 'off' );
%             Visibility( iv_panel_hndl, 'on' );
            UpdateElectricalPlot( data.selected, iv_panel_hndl, plotStr.electrical.type , data.color, plotStr.electrical.differential_range );
                        
        case 'SingleOptoelectronicMeasurement'
            Visibility( plotStr.electrical.hndl, 'off' );
            Visibility( plotStr.optical.hndl, 'off' );
%             Visibility( [ iv_panel_hndl , spectrum_options_panel_hndl ], 'off' );
            display('Code for SingleOptoelectronicMeasurement plot !!!!');
        
        otherwise
            display( ['Data type: ',data.type,'; Selected data type: ',GetDataType( data.selected ),'; plotting function missing !'] );

    end
end
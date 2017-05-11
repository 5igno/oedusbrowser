function UpdateElectricalPlot(selected_IV, iv_panel_hndl, varargin)
% UpdateElectricalPlot(selected_IV, iv_panel_hndl, MEASUREMENT_TYPE, COLOR, DIFFERENTIAL_RANGE);

% Define Extra Arguments
switch length(varargin)
    case 0 % PlotIV( selected_IV )
        MEASUREMENT_TYPE = '';
        COLOR = 'k';
        DIFFERENTIAL_RANGE = 5;

    case 1 % PlotIV( selected_IV , MeasurementType )
        MEASUREMENT_TYPE = varargin{1};
        COLOR = 'k';
        DIFFERENTIAL_RANGE = 5;

    case 2 % PlotIV( selected_IV , MeasurementType , COLOR_INDEX)
        MEASUREMENT_TYPE = varargin{1};
        COLOR = varargin{2};
        DIFFERENTIAL_RANGE = 5;

    otherwise % PlotIV( selected_IV , MeasurementType , COLOR_INDEX , DIFFERENTIAL_RANGE)
        MEASUREMENT_TYPE = varargin{1};
        COLOR = varargin{2};
        DIFFERENTIAL_RANGE = varargin{3};
end
    
% Extract current, voltage, two and four probe resistance
Current = selected_IV.Current';
Voltage = selected_IV.Voltage';
TimeSequence = selected_IV.TimeSequence';

%% Decide Measurement Type ... if not done already
if isempty(MEASUREMENT_TYPE)
    % Check if it's possible to get 4-probe resistance
    if isnan(Current(1,2)) && isnan(Current(1,3))
        % Two probe measurement
        MEASUREMENT_TYPE = 'TwoProbe';
    elseif isnan(Current(1,2)) || isnan(Current(1,3)) 
        % Transistor Measurement
        MEASUREMENT_TYPE = 'Transistor';
    else
        % Four probe measurement
        MEASUREMENT_TYPE = 'FourProbe';
    end
end

%% Get Differential Resistance Values
switch MEASUREMENT_TYPE
    case {'TwoProbe', 'Diode'}
        %Calculate 2-probe differential resistances
        TwoProbeResistance = ...
            Differential(Voltage(:,1)-Voltage(:,4),Current(:,1),DIFFERENTIAL_RANGE);
        
        selected_IV.Resistance2P = TwoProbeResistance;
        
    case 'FourProbe'
        %Calculate 2-probe differential resistances
        TwoProbeResistance = ...
            Differential(Voltage(:,1)-Voltage(:,4),Current(:,1),DIFFERENTIAL_RANGE);
        
        selected_IV.Resistance2P = TwoProbeResistance;

        % Calculate 4-probe differential resistance
        FourProbeResistance = ...
                Differential(Voltage(:,2)-Voltage(:,3),Current(:,1),DIFFERENTIAL_RANGE);
        selected_IV.Resistance4P = FourProbeResistance;
        
end

% Plot the data
switch MEASUREMENT_TYPE
    case 'FourProbe' % IV, Kelvinprobe voltage IV, differential resistance 2P and 4P

        VoltageDrop = Voltage(:,2) - Voltage(:,3);
%             VoltageDrop = VoltageDrop - mean(VoltageDrop);
%             Current(:,1) = Current(:,1) - mean(Current(:,1));

        labels = {'Voltage (V)';'Current (A)'};
        
        % PlotElectrical(X, Y, [labels, colorIndex, axes_hndl, plot_type, title_label] )
        GenericPlot(Voltage(:,1), Current(:,1), labels, COLOR, [2,2,1]);

        labels = {'Kelvin Probe Voltage (V)';'Current (A)'};
        % PlotElectrical(X, Y, [labels, colorIndex, axes_hndl, plot_type, title_label] )
        GenericPlot( VoltageDrop , Current(:,1),...
            labels, COLOR, [2,2,3]);

        labels = {'Voltage (V)';'Two Probe Resistance (\Omega)'};
        % PlotElectrical(X, Y, [labels, colorIndex, axes_hndl, plot_type, title_label] )
        GenericPlot( Voltage(:,1), TwoProbeResistance, labels, COLOR, [2,2,2],'semilogy');

        labels = {'Voltage (V)';'Four Probe Resistance (\Omega)'};
        % PlotElectrical(X, Y, [labels, colorIndex, axes_hndl, plot_type, title_label] )
        GenericPlot( VoltageDrop, FourProbeResistance, labels, COLOR, [2,2,4],'semilogy');

    case 'Diode' % IV, semilog y IV, differential resistance 2P

        labels = {'Voltage (V)';'Current (A)'};
        % PlotElectrical(X, Y, [labels, colorIndex, axes_hndl, plot_type, title_label] )
        GenericPlot(Voltage(:,1), Current(:,1), labels, COLOR, [2,2,1]);

        labels = {'Voltage (V)';'Current (A)'};
        % PlotElectrical(X, Y, [labels, colorIndex, axes_hndl, plot_type, title_label] )
        GenericPlot(Voltage(:,1), abs(Current(:,1)), labels, COLOR, [2,2,3],'semilogy');

        labels = {'Voltage (V)';'Two Probe Resistance (\Omega)'};
        % PlotElectrical(X, Y, [labels, colorIndex, axes_hndl, plot_type, title_label] )
        GenericPlot(Voltage(:,1), TwoProbeResistance, labels, COLOR, [2,2,2],'semilogy');

    case 'Traces' % Plot Current and Voltage traces
        % if time sequence is a series of integers
        if isequal(TimeSequence - floor(TimeSequence), 0*TimeSequence)
            x_label = 'Sequence #'; % Sweeping Measurement
        else
            x_label = 'Time (s)'; % Sampling Measurement
        end
        
        max_current = max(max(abs(Current)));
        max_voltage = max(max(abs(Voltage)));
        
        for smu = 1:4
            axes_handl = subplot(2,4,smu,'Parent',iv_panel_hndl);
            cla(axes_handl);
            LABELS = {x_label;'Current (A)'};
            PlotElectrical( TimeSequence, Current(:,smu), LABELS, COLOR, axes_handl , 'plot', ['SMU ',num2str(smu)] );
            ylim([-max_current, max_current]);
                        
            axes_handl = subplot(2,4,smu+4,'Parent',iv_panel_hndl);
            cla(axes_handl);
            LABELS = {x_label;'Voltage (V)'};            
            PlotElectrical( TimeSequence, Voltage(:,smu), LABELS , COLOR, axes_handl, 'plot', ['SMU ',num2str(smu)] );
            ylim([-max_voltage, max_voltage]);
        end

    %  case 'Transistor'  % !!! NEED TO DEFINE !!!             
    otherwise  % IV, differential resistance 2P

        labels = {'Voltage (V)';'Current (A)'};
        % PlotElectrical(X, Y, [labels, colorIndex, axes_hndl, plot_type, title_label] )
        GenericPlot(Voltage(:,1), Current(:,1), labels, COLOR, [1,2,1]);

        labels = {'Voltage (V)';'Two Probe Resistance (\Omega)'};
        % PlotElectrical(X, Y, [labels, colorIndex, axes_hndl, plot_type, title_label] )
        GenericPlot(Voltage(:,1), TwoProbeResistance, labels, COLOR, [1,2,2]);
end



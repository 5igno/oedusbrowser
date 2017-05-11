function PlotElectrical(X, Y, varargin)
% function PlotElectrical(X, Y, [labels, colorIndex, axes_hndl, plot_type, title_label] )

font_size = 10;

switch length(varargin)
    case 0 % No label, No Color, No subplot
        labels = {'Voltage (V)';'Current (A)'};
        COLOR = 1;
        plot_type = 'plot';
        axes_hndl = subplot(1,1,1);
    
    case 1 % Label, No Color, No subplot
        labels = varargin{1};
        COLOR = 1;
        plot_type = 'plot';
        axes_hndl = subplot(1,1,1);
    
    case 2 % Label and Color, No subplot
        labels = varargin{1};
        COLOR = varargin{2};
        plot_type = 'plot';
        axes_hndl = subplot(1,1,1) ;
    
    case 3 % Label and Color, Axes definition
        labels = varargin{1};
        COLOR = varargin{2};
        axes_hndl = varargin{3};
        plot_type = 'plot';
    
    case 4
        labels = varargin{1};
        COLOR = varargin{2};
        axes_hndl = varargin{3};
        plot_type = varargin{4};
    
    case 5
        labels = varargin{1};
        COLOR = varargin{2};
        axes_hndl = varargin{3};
        plot_type = varargin{4};
        title_label = varargin{5};
                
end

line_hndl = plot(axes_hndl,X,Y);

switch plot_type
    case 'semilogx'
        %Switch the y scale to log plot
        set(axes_hndl,'XScale','log');        
    case 'semilogy'
        set(axes_hndl,'YScale','log');        
    case 'loglog'
        set(axes_hndl,'XScale','log');        
        set(axes_hndl,'YScale','log');
end

axis(axes_hndl,'tight');
hold on;    
box on;
set(line_hndl, 'Color', COLOR);
set(line_hndl, 'LineWidth', 1);

xlabel( axes_hndl, labels{1} ,'FontSize', font_size );
ylabel( axes_hndl, labels{2} ,'FontSize', font_size );
set( axes_hndl,'FontSize',font_size);

if exist('title_label')
    h = title(axes_hndl, title_label);
    h.FontWeight = 'normal';
    h.FontSize = font_size ;
end

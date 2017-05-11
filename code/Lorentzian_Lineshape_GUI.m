function y = Lorentzian_Lineshape_GUI(x,Q,varargin)
% LORENTZIAN_LINESHAPE returns a set of Lorentian lineshapes with the variables
% spacified in P and Q. 
% The structure Q contains a set of variable names. The value of these 
% variables is stored in the vector P.
% The Lineshape returned will be different depending on the parameters
% given as an input. The order used to submit the variable names and values
% does not matter. The only thing you have to take care of is the
% corrispondence between variable names and their values.
% These are the variables which are handled by this function:
% 1) N_peaks : is a scalar, equal to the number of peaks to be fitted
% 2) Maximum_intensity : is a vector containing the intensities of each
%                        peak
% 3) Peak_potision: is a vectoror containing the abscissa of each peak
% 4) Line_broadening: is a vector containing the line widths of each peak
% 5) Baseline: is the constant background which can be subtracted from both
%              peaks
% The PL_Lineshape function will be different depending on which values 
% are specified in the structure.

maybesomething = varargin;
CreateLorentianVariablesGUI(Q,maybesomething);

y = 0*x;

% Sum over the contributions of different peaks
for k=1:N_peaks
    Lorentzian = Maximum_intensity(k).* (Line_broadening(k).^2)./(Line_broadening(k).^2+(x-Peak_position(k)).^2); %#ok<NODEF>
    y = y + Lorentzian;
end

% Add the contribution of the baseline
if exist('Slope','var')
    y = y + Intercept;
end

if exist('Intercept','var')
    y = y + Slope.*x;
end


function Q = CreateLorentianVariablesGUI(Q,maybesomething)
% The parameters defining the peaks (height, width and position) are
% stored in three dinstinct vectors.
% 
% As a reminder, this are the possible variable created by this function:
% 
% 1) N_peaks : is a scalar, equal to the number of peaks to be fitted
% 
% 2) Maximum_intensity : is a vector containing the intensities of each
%                        peak
% 
% 3) Peak_potision: is a vectoror containing the abscissa of each peak
% 
% 4) Line_broadening: is a vector containing the line widths of each peak
% 
% 5) Baseline: is the constant background which can be subtracted from both
% 
if isempty(maybesomething)
    % there's no P vector given: take the values from Q
    [~,l]=size(Q);

    for id_parameter=1:l
            varname = Q(id_parameter).label;
            varvalue = Q(id_parameter).value; 
            assignin('caller',varname,varvalue);
    end

else
    % there's P to be used to take varialbes... take it from varargin

    P=cell2mat(maybesomething);

    % Create the variables you need

    N_peaks=Q(1).value;

    [~,l]=size(Q);

    for id_parameter=1:l
        switch id_parameter
            case 1 % N_peaks: the number of Loretians is an not a varible to be changed
                varname = Q(id_parameter).label;
                varvalue = Q(id_parameter).value;  
            case {2,3,4} % This updates the Lorentians
                varname = Q(id_parameter).label;
                indexes = (id_parameter-1)+3*(0:1: N_peaks-1);
                varvalue = P(indexes);
                Q(id_parameter).value=varvalue; 
            case {5,6} % This updates the Background
                varname = Q(id_parameter).label;
                indexes = (id_parameter-1)+3*(N_peaks-1);
                varvalue = P(indexes);
        end
        assignin('caller',varname,varvalue);
    end      
end
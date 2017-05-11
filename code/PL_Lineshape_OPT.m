function y = PL_Lineshape_OPT(x,Q,varargin)
% PL_LINESHAPE returns a PL lineshape composed of several bulk-like (square
% root) Joint Density of States, with the variables spacified in P and Q. 
% The structure Q contains a set of variable names. The value of these 
% variables is stored in the vector P.
% The Lineshape returned will be different depending on the parameters
% given as an input. The order used to submit the variable names and values
% does not matter. The only thing you have to take care of is the
% corrispondence between variable names and their values.
% These are the variables which are handled by this function:
% 1) N_peaks : is a scalar, equal to the number of peaks to be fitted
% 2) Maximum_intensity : is a vector containing the intensities of each
%                        JDOS contribution
% 3) Peak_potision: is a vectoror containing the lowest energy of each JDOS
%                   contribution
% 4) Temperature: is the Temperature used for the Boltzmann-like
%                 population of every debnsity of states
% 4) Line_width: is a vector containing the line widths of each peak
% 5) Baseline: is the linear background subtracted from all peaks
% 
% The PL_Lineshape function will be different depending on which values 
% are specified in the structure.

maybesomething = varargin;
CreatePLVariablesGUI(Q,maybesomething);

if ~exist('Line_broadening','var')
    Line_broadening = 0;
end

y = PL_Lineshape (x,Energy_gap,Maximum_intensity,Line_broadening,Temperature);

% Add the contribution of the baseline
if exist('Slope','var')
    y = y + Slope.*x;
end

if exist('Intercept','var')
    y = y + Slope.*x;
end



function Q = CreatePLVariablesGUI(Q,maybesomething)
% The parameters defining the peaks (height, width and position) are
% stored in three dinstinct vectors.
% 
% As a reminder, this are the possible variable created by this function:
% 
% 1) N_peaks : is a scalar, equal to the number of peaks to be fitted
% 2) Maximum_intensity : is a vector containing the intensities of each
%                        JDOS contribution
% 3) Peak_potision: is a vectoror containing the lowest energy of each JDOS
%                   contribution
% 4) Temperature: is the Temperature used for the Boltzmann-like
%                 population of every debnsity of states
% 5) Line_width: is a vector containing the line widths of each peak
% 6) Baseline: is the linear background subtracted from all peaks
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
            case 1 % N_peaks: the number of JDOSs is an not a varible to be changed
                varname = Q(id_parameter).label;
                varvalue = Q(id_parameter).value;  
            case {2,3} % This updates the JDOS components
                varname = Q(id_parameter).label;
                indexes = (id_parameter-1)+2*(0:1: N_peaks-1);
                varvalue = P(indexes);
                Q(id_parameter).value=varvalue; 
            case {4,5,6} % This updates Background, Linewidth and Temperature
                varname = Q(id_parameter).label;
                indexes = (id_parameter-1)+2*(N_peaks-1);
                varvalue = P(indexes);
        end
        assignin('caller',varname,varvalue);
    end      
end
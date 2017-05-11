function y_type = GetYaxis(hObject)

switch get(hObject,'Value');
    case 1
        y_type = 'Linear';
    case 2 
        y_type = 'Logaritmic';
end

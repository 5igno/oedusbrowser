function handles = RoiChoiceMenuCallback(hObject,handles)

handles.data.roi.slct = get(hObject,'Value');

handles.data.roi.choice = get(handles.roi_choice_menu,'Value');


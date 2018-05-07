function varargout = esimilarity(varargin)
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @esimilarity_OpeningFcn, ...
                   'gui_OutputFcn',  @esimilarity_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);

if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

% --- Executes just before esimilarity is made visible.
function esimilarity_OpeningFcn(hObject, ~, handles, varargin)
% Choose default command line output for esimilarity
global lab1 lab2 copy_eval;
lab1 = [];
lab2 = [];

who = evalin('base','whos');
who = struct2cell(who);
who = who(1,:);
if ismember('copy_eval',who)
    copy_eval = evalin('base','copy_eval');
else
    master_coordinates = evalin('base','master_coordinates');
    copy_coordinates = evalin('base','copy_coordinates');
    copy_eval = -ones(size(master_coordinates,2), size(copy_coordinates,2));
end

handles.output = hObject;
set(handles.back,'Enable','off');
set(handles.next,'Enable','off');
set(handles.x1, 'Enable', 'off');
set(handles.y1, 'Enable', 'off');
set(handles.z1, 'Enable', 'off');
set(handles.r1, 'Enable', 'off');
set(handles.g1, 'Enable', 'off');
set(handles.b1, 'Enable', 'off');
set(handles.l1, 'Enable', 'off');
set(handles.a1, 'Enable', 'off');
set(handles.bb1, 'Enable', 'off');
set(handles.x2, 'Enable', 'off');
set(handles.y2, 'Enable', 'off');
set(handles.z2, 'Enable', 'off');
set(handles.r2, 'Enable', 'off');
set(handles.g2, 'Enable', 'off');
set(handles.b2, 'Enable', 'off');
set(handles.l2, 'Enable', 'off');
set(handles.a2, 'Enable', 'off');
set(handles.bb2, 'Enable', 'off');
set(handles.deltaE, 'Enable', 'off');
set(handles.patch_RGB,'xcolor', get(hObject,'Color'), 'ycolor', get(hObject,'Color'));

% Update handles structure
guidata(hObject, handles);


% --- Outputs from this function are returned to the command line.
function varargout = esimilarity_OutputFcn(hObject, ~, handles)
% Get default command line output from handles structure
varargout{1} = handles.output;


% --------------------------------------------------------------------
function FileMenu_Callback(hObject, eventdata, handles)
% hObject    handle to FileMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function OpenMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to OpenMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
file = uigetfile('*.fig');
if ~isequal(file, 0)
    open(file);
end

% --------------------------------------------------------------------
function PrintMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to PrintMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
printdlg(handles.GUI)

% --------------------------------------------------------------------
function CloseMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to CloseMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selection = questdlg(['Close ' get(handles.GUI,'Name') '?'],...
                     ['Close ' get(handles.GUI,'Name') '...'],...
                     'Yes','No','Yes');
if strcmp(selection,'No')
    return;
end

delete(handles.GUI)

function similarity_Callback(hObject, eventdata, handles)
if ~isnan(str2double(get(hObject,'String')))
    eval = str2double(get(hObject,'String'));
    if eval < 0 
        set(hObject,'String','0');
    end
    if eval > 3
        set(hObject,'String','3');
    end
    set(handles.evaluate,'Enable','on');
else
    set(hObject,'String','');
end

% --- Executes during object creation, after setting all properties.
function similarity_CreateFcn(hObject, eventdata, handles)
set(hObject,'String','');
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in ok.
function ok_Callback(hObject, eventdata, handles)
str2double(get(handles.similarity,'String'));


% --- Executes on button press in cancel.
function cancel_Callback(hObject, eventdata, handles)
set(handles.similarity,'String','');


% --- Executes on selection change in choose_master1.
function choose_master1_Callback(hObject, ~, handles)
global lab1 lab2;
items = get(hObject,'String');
master1_index = str2double(items{get(hObject,'Value')});
master_spectra = evalin('base','master_spectra');
axes(handles.master_spectrum);
plot_SPD(380:800, master_spectra(:,master1_index));
master_coordinates = evalin('base','master_coordinates');
set(handles.x1,'String', master_coordinates(1, master1_index));
set(handles.y1,'String', master_coordinates(2, master1_index));
set(handles.z1,'String', master_coordinates(3, master1_index));
set(handles.r1,'String', master_coordinates(4, master1_index));
set(handles.g1,'String', master_coordinates(5, master1_index));
set(handles.b1,'String', master_coordinates(6, master1_index));
set(handles.l1,'String', master_coordinates(7, master1_index));
set(handles.a1,'String', master_coordinates(8, master1_index));
set(handles.bb1,'String', master_coordinates(9, master1_index));
axes(handles.patch_RGB);
plot_lpatch(master_coordinates(4:6, master1_index));
lab1 = master_coordinates(7:9, master1_index);

global tmp_copy_spectra tmp_copy_coordinates copy_index copy_eval;
tmp_copy_spectra = [];
tmp_copy_coordinates = [];
copy_index = 1;
master_copied = evalin('base','master_copied');
if ismember(master1_index, master_copied)
    master1_index = find(master_copied == master1_index);
    copy_spectra = evalin('base','copy_spectra');
    tmp_copy_spectra = copy_spectra(:,:,master1_index);
    
    copy_coordinates = evalin('base','copy_coordinates');
    tmp_copy_coordinates = copy_coordinates(:,:,master1_index);
end

axes(handles.copy_spectrum);
plot_SPD(380:800, tmp_copy_spectra(:,copy_index));
set(handles.x2,'String', tmp_copy_coordinates(1, copy_index));
set(handles.y2,'String', tmp_copy_coordinates(2, copy_index));
set(handles.z2,'String', tmp_copy_coordinates(3, copy_index));
set(handles.r2,'String', tmp_copy_coordinates(4, copy_index));
set(handles.g2,'String', tmp_copy_coordinates(5, copy_index));
set(handles.b2,'String', tmp_copy_coordinates(6, copy_index));
set(handles.l2,'String', tmp_copy_coordinates(7, copy_index));
set(handles.a2,'String', tmp_copy_coordinates(8, copy_index));
set(handles.bb2,'String', tmp_copy_coordinates(9, copy_index));
axes(handles.patch_RGB);
plot_rpatch(tmp_copy_coordinates(4:6, copy_index));
lab2 = tmp_copy_coordinates(7:9, copy_index);
if size(lab1,1) ~= 0 && size(lab2,1) ~= 0 && get(handles.show_delta,'Value') == 1
    [~, ~, e00] = compute_deltaE(lab1, lab2);
    set(handles.deltaE,'String',num2str(e00));
end

set(handles.list,'String',strcat({'Copy '}, num2str(copy_index) ,{' of '}, num2str(size(tmp_copy_spectra,2))));
set(handles.next,'Enable','on');
items = get(hObject,'String');
master_index = str2double(items{get(hObject,'Value')});
if (copy_eval(master_index, copy_index) == 1)
    set(handles.equal,'Value',1);
else
    set(handles.equal,'Value',0);
end

if (copy_eval(master_index, copy_index) == 2)
    set(handles.similar,'Value',1);
else
    set(handles.similar,'Value',0);
end

if (copy_eval(master_index, copy_index) == 3)
    set(handles.different,'Value',1);
else
    set(handles.different,'Value',0);
end

% --- Executes during object creation, after setting all properties.
function choose_master1_CreateFcn(hObject, ~, handles)
master = [];
who = evalin('base','whos');
if ismember('master_copied',[who(:).name])
    master_copied = evalin('base','master_copied');
    if ~isempty(master_copied)
        master = master_copied;
    end
end

if ~isempty(master)
    set(hObject, 'Enable', 'on');
    set(hObject, 'String', {unique(master)});
    set(hObject, 'Value', 1);
else
    set(hObject, 'String', 'Choose master');
    set(hObject, 'Enable', 'off');
    set(hObject, 'Value', 1);
end

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function copy_spectrum_CreateFcn(hObject, eventdata, handles)
% hObject    handle to copy_spectrum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate copy_spectrum

function deltaE_Callback(hObject, eventdata, handles)
% hObject    handle to deltaE (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of deltaE as text
%        str2double(get(hObject,'String')) returns contents of deltaE as a double


% --- Executes during object creation, after setting all properties.
function deltaE_CreateFcn(hObject, eventdata, handles)
% hObject    handle to deltaE (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in show_similarity.
function show_similarity_Callback(hObject, eventdata, handles)
% hObject    handle to show_similarity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of show_similarity


% --- Executes on button press in show_delta.
function show_delta_Callback(hObject, eventdata, handles)
global lab1 lab2;
if get(hObject,'Value') == 1
    if size(lab1,1) ~= 0 && size(lab2,1) ~= 0 && get(handles.show_delta,'Value') == 1
        [~, ~, e00] = compute_deltaE(lab1, lab2);
        set(handles.deltaE,'String',num2str(e00));
    end
else
    set(handles.deltaE,'String','');
end



function x1_Callback(hObject, eventdata, handles)
% hObject    handle to x1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of x1 as text
%        str2double(get(hObject,'String')) returns contents of x1 as a double


% --- Executes during object creation, after setting all properties.
function x1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to x1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function y1_Callback(hObject, eventdata, handles)
% hObject    handle to y1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of y1 as text
%        str2double(get(hObject,'String')) returns contents of y1 as a double


% --- Executes during object creation, after setting all properties.
function y1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to y1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function z1_Callback(hObject, eventdata, handles)
% hObject    handle to z1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of z1 as text
%        str2double(get(hObject,'String')) returns contents of z1 as a double


% --- Executes during object creation, after setting all properties.
function z1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to z1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function r1_Callback(hObject, eventdata, handles)
% hObject    handle to r1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of r1 as text
%        str2double(get(hObject,'String')) returns contents of r1 as a double


% --- Executes during object creation, after setting all properties.
function r1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to r1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function g1_Callback(hObject, eventdata, handles)
% hObject    handle to g1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of g1 as text
%        str2double(get(hObject,'String')) returns contents of g1 as a double


% --- Executes during object creation, after setting all properties.
function g1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to g1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function b1_Callback(hObject, eventdata, handles)
% hObject    handle to b1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of b1 as text
%        str2double(get(hObject,'String')) returns contents of b1 as a double


% --- Executes during object creation, after setting all properties.
function b1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to b1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function l1_Callback(hObject, eventdata, handles)
% hObject    handle to l1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of l1 as text
%        str2double(get(hObject,'String')) returns contents of l1 as a double


% --- Executes during object creation, after setting all properties.
function l1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to l1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function a1_Callback(hObject, eventdata, handles)
% hObject    handle to a1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of a1 as text
%        str2double(get(hObject,'String')) returns contents of a1 as a double


% --- Executes during object creation, after setting all properties.
function a1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to a1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function bb1_Callback(hObject, eventdata, handles)
% hObject    handle to bb1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of bb1 as text
%        str2double(get(hObject,'String')) returns contents of bb1 as a double


% --- Executes during object creation, after setting all properties.
function bb1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bb1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function x2_Callback(hObject, eventdata, handles)
% hObject    handle to x2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of x2 as text
%        str2double(get(hObject,'String')) returns contents of x2 as a double


% --- Executes during object creation, after setting all properties.
function x2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to x2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function y2_Callback(hObject, eventdata, handles)
% hObject    handle to y2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of y2 as text
%        str2double(get(hObject,'String')) returns contents of y2 as a double


% --- Executes during object creation, after setting all properties.
function y2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to y2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function z2_Callback(hObject, eventdata, handles)
% hObject    handle to z2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of z2 as text
%        str2double(get(hObject,'String')) returns contents of z2 as a double


% --- Executes during object creation, after setting all properties.
function z2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to z2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function r2_Callback(hObject, eventdata, handles)
% hObject    handle to r2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of r2 as text
%        str2double(get(hObject,'String')) returns contents of r2 as a double


% --- Executes during object creation, after setting all properties.
function r2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to r2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function g2_Callback(hObject, eventdata, handles)
% hObject    handle to g2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of g2 as text
%        str2double(get(hObject,'String')) returns contents of g2 as a double


% --- Executes during object creation, after setting all properties.
function g2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to g2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function b2_Callback(hObject, eventdata, handles)
% hObject    handle to b2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of b2 as text
%        str2double(get(hObject,'String')) returns contents of b2 as a double


% --- Executes during object creation, after setting all properties.
function b2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to b2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function l2_Callback(hObject, eventdata, handles)
% hObject    handle to l2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of l2 as text
%        str2double(get(hObject,'String')) returns contents of l2 as a double


% --- Executes during object creation, after setting all properties.
function l2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to l2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function a2_Callback(hObject, eventdata, handles)
% hObject    handle to a2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of a2 as text
%        str2double(get(hObject,'String')) returns contents of a2 as a double


% --- Executes during object creation, after setting all properties.
function a2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to a2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function bb2_Callback(hObject, eventdata, handles)
% hObject    handle to bb2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of bb2 as text
%        str2double(get(hObject,'String')) returns contents of bb2 as a double


% --- Executes during object creation, after setting all properties.
function bb2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bb2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in compute_similarity.
function compute_similarity_Callback(hObject, eventdata, handles)
% hObject    handle to compute_similarity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in back.
function back_Callback(hObject, eventdata, handles)
global copy_index tmp_copy_coordinates tmp_copy_spectra lab2 lab1 copy_eval;

if get(handles.equal,'Value') == 1
    set(handles.equal,'Value',0);
elseif get(handles.similar,'Value') == 1
    set(handles.similar,'Value',0);
elseif get(handles.different,'Value') == 1
    set(handles.different,'Value',0);
end

if copy_index - 1 == 1
    set(hObject,'Enable','off');
end

if copy_index - 1 >= 1
    copy_index = copy_index - 1;
    set(handles.next,'Enable','on');
    axes(handles.copy_spectrum);
    plot_SPD(380:800, tmp_copy_spectra(:,copy_index));
    set(handles.x2,'String', tmp_copy_coordinates(1, copy_index));
    set(handles.y2,'String', tmp_copy_coordinates(2, copy_index));
    set(handles.z2,'String', tmp_copy_coordinates(3, copy_index));
    set(handles.r2,'String', tmp_copy_coordinates(4, copy_index));
    set(handles.g2,'String', tmp_copy_coordinates(5, copy_index));
    set(handles.b2,'String', tmp_copy_coordinates(6, copy_index));
    set(handles.l2,'String', tmp_copy_coordinates(7, copy_index));
    set(handles.a2,'String', tmp_copy_coordinates(8, copy_index));
    set(handles.bb2,'String', tmp_copy_coordinates(9, copy_index));
    axes(handles.patch_RGB);
    plot_rpatch(tmp_copy_coordinates(4:6, copy_index));
    lab2 = tmp_copy_coordinates(7:9, copy_index);
    if size(lab1,1) ~= 0 && size(lab2,1) ~= 0 && get(handles.show_delta,'Value') == 1
        [~, ~, e00] = compute_deltaE(lab1, lab2);
        set(handles.deltaE,'String',num2str(e00));
    end
    set(handles.list,'String',strcat({'Copy '}, num2str(copy_index) ,{' of '}, num2str(size(tmp_copy_spectra,2))));
    items = get(handles.choose_master1,'String');
    master_index = str2double(items{get(handles.choose_master1,'Value')});
    if (copy_eval(master_index, copy_index) == 1)
        set(handles.equal,'Value',1);
    else
        set(handles.equal,'Value',0);
    end

    if (copy_eval(master_index, copy_index) == 2)
        set(handles.similar,'Value',1);
    else
        set(handles.similar,'Value',0);
    end

    if (copy_eval(master_index, copy_index) == 3)
        set(handles.different,'Value',1);
    else
        set(handles.different,'Value',0);
    end
end


% --- Executes on button press in evaluate.
function evaluate_Callback(hObject, eventdata, handles)



% --- Executes on button press in next.
function next_Callback(hObject, eventdata, handles)
global copy_index copy_eval tmp_copy_coordinates tmp_copy_spectra lab2 lab1;
items = get(handles.choose_master1,'String');
master_index = str2double(items{get(handles.choose_master1,'Value')});
if get(handles.equal,'Value') == 1
    eval = 1;
    set(handles.equal,'Value',0);
elseif get(handles.similar,'Value') == 1
    eval = 2;
    set(handles.similar,'Value',0);
elseif get(handles.different,'Value') == 1
    eval = 3;
    set(handles.different,'Value',0);
else
    eval = -1;
end

copy_eval(master_index, copy_index) = eval;
assignin('base', 'copy_eval', copy_eval);

if copy_index + 1 > size(tmp_copy_spectra, 2)
    set(handles.choose_master1,'Value', get(handles.choose_master1,'Value') + 1);
    choose_master1_Callback(handles.choose_master1, [], handles);
else
    copy_index = copy_index + 1;
    set(handles.back,'Enable','on');
    axes(handles.copy_spectrum);
    plot_SPD(380:800, tmp_copy_spectra(:,copy_index));
    set(handles.x2,'String', tmp_copy_coordinates(1, copy_index));
    set(handles.y2,'String', tmp_copy_coordinates(2, copy_index));
    set(handles.z2,'String', tmp_copy_coordinates(3, copy_index));
    set(handles.r2,'String', tmp_copy_coordinates(4, copy_index));
    set(handles.g2,'String', tmp_copy_coordinates(5, copy_index));
    set(handles.b2,'String', tmp_copy_coordinates(6, copy_index));
    set(handles.l2,'String', tmp_copy_coordinates(7, copy_index));
    set(handles.a2,'String', tmp_copy_coordinates(8, copy_index));
    set(handles.bb2,'String', tmp_copy_coordinates(9, copy_index));
    axes(handles.patch_RGB);
    plot_rpatch(tmp_copy_coordinates(4:6, copy_index));
    lab2 = tmp_copy_coordinates(7:9, copy_index);
    if size(lab1,1) ~= 0 && size(lab2,1) ~= 0 && get(handles.show_delta,'Value') == 1
        [~, ~, e00] = compute_deltaE(lab1, lab2);
        set(handles.deltaE,'String',num2str(e00));
    end
    set(handles.list,'String',strcat({'Copy '}, num2str(copy_index) ,{' of '}, num2str(size(tmp_copy_spectra,2))));
    items = get(handles.choose_master1,'String');
    master_index = str2double(items{get(handles.choose_master1,'Value')});
    if (copy_eval(master_index, copy_index) == 1)
        set(handles.equal,'Value',1);
    else
        set(handles.equal,'Value',0);
    end

    if (copy_eval(master_index, copy_index) == 2)
        set(handles.similar,'Value',1);
    else
        set(handles.similar,'Value',0);
    end

    if (copy_eval(master_index, copy_index) == 3)
        set(handles.different,'Value',1);
    else
        set(handles.different,'Value',0);
    end
end


% --- Executes on button press in equal.
function equal_Callback(hObject, eventdata, handles)
if get(hObject,'Value') == 1
    set(handles.similar, 'Value', 0);
    set(handles.different, 'Value', 0);
end


% --- Executes on button press in similar.
function similar_Callback(hObject, eventdata, handles)
if get(hObject,'Value') == 1
    set(handles.equal, 'Value', 0);
    set(handles.different, 'Value', 0);
end

% --- Executes on button press in different.
function different_Callback(hObject, eventdata, handles)
if get(hObject,'Value') == 1
    set(handles.similar, 'Value', 0);
    set(handles.equal, 'Value', 0);
end

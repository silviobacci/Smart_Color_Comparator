function varargout = ccopy(varargin)
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ccopy_OpeningFcn, ...
                   'gui_OutputFcn',  @ccopy_OutputFcn, ...
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

% --- Executes just before ccopy is made visible.
function ccopy_OpeningFcn(hObject, ~, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ccopy (see VARARGIN)
global copy_spectra_GUI copy_rSPD_GUI copy_coordinates_GUI master_copied_GUI last_master_index last_copy_spectrum last_copy_coordinates last_copy_rSPD rSPD1 rSPD2 lab1 lab2;
rSPD1 = [];
rSPD2 = [];
lab1 = [];
lab2 = [];
last_master_index = []; 
last_copy_spectrum = []; 
last_copy_coordinates = []; 
last_copy_rSPD = [];
who = evalin('base','whos');
who = struct2cell(who);
who = who(1,:);
if ismember('master_copied_GUI',who)
    master_copied_GUI = evalin('base','master_copied_GUI');
else
    master_copied_GUI = [];
end

if ismember('copy_rSPD_GUI',who)
    copy_rSPD_GUI = evalin('base','copy_rSPD_GUI');
else
    copy_rSPD_GUI = [];
end

if ismember('copy_spectra_GUI',who)
    copy_spectra_GUI = evalin('base','copy_spectra_GUI');
else
    copy_spectra_GUI = [];
end

if ismember('copy_coordinates_GUI',who)
    copy_coordinates_GUI = evalin('base','copy_coordinates_GUI');
else
    copy_coordinates_GUI = [];
end

% Choose default command line output for ccopy
handles.output = hObject;
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
set(handles.similarity, 'Enable', 'off');
set(handles.choose_master1, 'Enable', 'on');
set(handles.patch_RGB,'xcolor', get(hObject,'Color'), 'ycolor', get(hObject,'Color'));

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ccopy wait for user response (see UIRESUME)
% uiwait(handles.ccopy);


% --- Outputs from this function are returned to the command line.
function varargout = ccopy_OutputFcn(hObject, ~, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

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

% --- Executes during object creation, after setting all properties.
function similarity_CreateFcn(hObject, eventdata, handles)
set(hObject,'String','');
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in cancel.
function cancel_Callback(hObject, eventdata, handles)
global lab2 rSPD2 last_master_index last_copy_spectrum last_copy_coordinates last_copy_rSPD;
cla(handles.copy_spectrum);
axes(handles.patch_RGB);
plot_rpatch([1 1 1]);
set(handles.similarity,'String', '');
lab2 = [];
rSPD2 = [];
last_master_index = []; 
last_copy_spectrum = []; 
last_copy_coordinates = []; 
last_copy_rSPD = [];
set(handles.deltaE,'String', '');
set(handles.x2,'String', '');
set(handles.y2,'String', '');
set(handles.z2,'String', '');
set(handles.r2,'String', '');
set(handles.g2,'String', '');
set(handles.b2,'String', '');
set(handles.l2,'String', '');
set(handles.a2,'String', '');
set(handles.bb2,'String', '');


% --- Executes on selection change in choose_master1.
function choose_master1_Callback(hObject, ~, handles)
global lab1 rSPD1 lab2 rSPD2;
items = get(hObject,'String');
master_index = str2double(items{get(hObject,'Value')});
master_spectra = evalin('base','master_spectra');
axes(handles.master_spectrum);
plot_SPD(380:800, master_spectra(:,master_index));
master_coordinates = evalin('base','master_coordinates');
set(handles.x1,'String', master_coordinates(1, master_index));
set(handles.y1,'String', master_coordinates(2, master_index));
set(handles.z1,'String', master_coordinates(3, master_index));
set(handles.r1,'String', master_coordinates(4, master_index));
set(handles.g1,'String', master_coordinates(5, master_index));
set(handles.b1,'String', master_coordinates(6, master_index));
set(handles.l1,'String', master_coordinates(7, master_index));
set(handles.a1,'String', master_coordinates(8, master_index));
set(handles.bb1,'String', master_coordinates(9, master_index));
axes(handles.patch_RGB);
plot_lpatch(master_coordinates(4:6, master_index));
lab1 = master_coordinates(7:9, master_index);
master_rSPD = evalin('base','master_rSPD');
rSPD1 = master_rSPD(:,master_index);
cla(handles.copy_spectrum);
axes(handles.patch_RGB);
plot_rpatch([1 1 1]);
set(handles.similarity,'String', '');
lab2 = [];
rSPD2 = [];
set(handles.deltaE,'String', '');
set(handles.x2,'String', '');
set(handles.y2,'String', '');
set(handles.z2,'String', '');
set(handles.r2,'String', '');
set(handles.g2,'String', '');
set(handles.b2,'String', '');
set(handles.l2,'String', '');
set(handles.a2,'String', '');
set(handles.bb2,'String', '');

% --- Executes during object creation, after setting all properties.
function choose_master1_CreateFcn(hObject, ~, handles)
master_spectra = evalin('base','master_spectra');
set(hObject, 'String', {1:size(master_spectra,2)});
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function change_wl_Callback(hObject, eventdata, handles)
% hObject    handle to change_wl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function change_wl_CreateFcn(hObject, eventdata, handles)
% hObject    handle to change_wl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function change_noise_Callback(hObject, eventdata, handles)
% hObject    handle to change_noise (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function change_noise_CreateFcn(hObject, eventdata, handles)
% hObject    handle to change_noise (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
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
% Hin


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


% --- Executes on slider movement.
function slide_initial_wl_Callback(hObject, eventdata, handles)
% hObject    handle to slide_initial_wl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global initial_wl;
initial_wl = floor(get(hObject,'Value'));
if get(handles.slider_final_wl,'Value') < initial_wl
    initial_wl = floor(get(handles.slider_final_wl,'Value'));
    set(hObject,'Value', initial_wl);
end
set(handles.initial_wl,'String', num2str(initial_wl));


% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slide_initial_wl_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slide_initial_wl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global initial_wl final_wl;
initial_wl = 380;
final_wl = 800;
set(hObject,'Min', initial_wl);
set(hObject,'Max', final_wl);
set(hObject,'Value', initial_wl);

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider_final_wl_Callback(hObject, ~, handles)
% hObject    handle to slider_final_wl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global final_wl;
final_wl = floor(get(hObject,'Value'));
if get(handles.slide_initial_wl,'Value') > final_wl
    final_wl = floor(get(handles.slide_initial_wl,'Value'));
    set(hObject,'Value', final_wl);
end
set(handles.final_wl,'String', num2str(final_wl));

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider_final_wl_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_final_wl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global initial_wl final_wl;
initial_wl = 380;
final_wl = 800;
set(hObject,'Min', initial_wl);
set(hObject,'Max', final_wl);
set(hObject,'Value', final_wl);

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function final_wl_Callback(hObject, eventdata, handles)
% hObject    handle to final_wl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global final_wl initial_wl;
if ~isnan(str2double(get(hObject,'String')))
    final_wl = floor(str2double(get(hObject,'String')));
end

if final_wl > 800
    final_wl = 800;
end

if final_wl < 380
    final_wl = 380;
end

if final_wl < initial_wl
    final_wl = initial_wl;
end

set(handles.slider_final_wl, 'Value', final_wl);
set(hObject, 'String', num2str(final_wl));
% Hints: get(hObject,'String') returns contents of final_wl as text
%        str2double(get(hObject,'String')) returns contents of final_wl as a double


% --- Executes during object creation, after setting all properties.
function final_wl_CreateFcn(hObject, eventdata, handles)
% hObject    handle to final_wl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global final_wl;
final_wl = 800;
set(hObject,'String', num2str(final_wl));
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function initial_wl_Callback(hObject, eventdata, handles)
% hObject    handle to initial_wl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global final_wl initial_wl;
if ~isnan(str2double(get(hObject,'String')))
    initial_wl = floor(str2double(get(hObject,'String')));
end

if initial_wl > 800
    initial_wl = 800;
end

if initial_wl < 380
    initial_wl = 380;
end

if initial_wl > final_wl
    initial_wl = final_wl;
end

set(hObject, 'String', num2str(initial_wl));
set(handles.slide_initial_wl, 'Value', initial_wl);
% Hints: get(hObject,'String') returns contents of initial_wl as text
%        str2double(get(hObject,'String')) returns contents of initial_wl as a double


% --- Executes during object creation, after setting all properties.
function initial_wl_CreateFcn(hObject, eventdata, handles)
% hObject    handle to initial_wl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global initial_wl;
initial_wl = 380;
set(hObject,'String', num2str(initial_wl));
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function intensity_Callback(hObject, eventdata, handles)
% hObject    handle to intensity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global intensity;
if ~isnan(str2double(get(hObject,'String')))
    intensity = floor(str2double(get(hObject,'String')));
end

if intensity > 60
    intensity = 60;
end

if intensity < 15
    intensity = 15;
end

set(hObject, 'String', num2str(intensity));
set(handles.slider_intensity, 'Value', intensity);
% Hints: get(hObject,'String') returns contents of intensity as text
%        str2double(get(hObject,'String')) returns contents of intensity as a double


% --- Executes during object creation, after setting all properties.
function intensity_CreateFcn(hObject, eventdata, handles)
% hObject    handle to intensity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global intensity;
intensity = 15;
set(hObject,'String', num2str(intensity));
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in apply.
function apply_Callback(hObject, eventdata, handles)
% hObject    handle to apply (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global last_master_index last_copy_spectrum last_copy_coordinates last_copy_rSPD;
global intensity initial_wl final_wl lab2 lab1 rSPD2;
items = get(handles.choose_master1,'String');
last_master_index = str2double(items{get(handles.choose_master1,'Value')});
master_spectra = evalin('base','master_spectra');
wl_noise = initial_wl:final_wl;
[last_copy_spectrum, last_copy_rSPD, last_copy_coordinates] = create_copy(master_spectra(:,last_master_index), intensity, wl_noise);
axes(handles.copy_spectrum);
plot_SPD(380:800, last_copy_spectrum);
set(handles.x2,'String', last_copy_coordinates(1));
set(handles.y2,'String', last_copy_coordinates(2));
set(handles.z2,'String', last_copy_coordinates(3));
set(handles.r2,'String', last_copy_coordinates(4));
set(handles.g2,'String', last_copy_coordinates(5));
set(handles.b2,'String', last_copy_coordinates(6));
set(handles.l2,'String', last_copy_coordinates(7));
set(handles.a2,'String', last_copy_coordinates(8));
set(handles.bb2,'String', last_copy_coordinates(9));
axes(handles.patch_RGB);
plot_rpatch(last_copy_coordinates(4:6));
lab2 = last_copy_coordinates(7:9);
rSPD2 = last_copy_rSPD;
if size(lab1,1) ~= 0 && size(lab2,1) ~= 0 && get(handles.show_delta,'Value') == 1
    [~, ~, e00] = compute_deltaE(lab1, lab2);
    set(handles.deltaE,'String',num2str(e00));
end
set(handles.similarity,'String', '');

% --- Executes on slider movement.
function slider_intensity_Callback(hObject, eventdata, handles)
% hObject    handle to slider_intensity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global intensity;
intensity = floor(get(hObject,'Value'));
set(handles.intensity,'String', num2str(intensity));
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider_intensity_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_intensity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global intensity;
intensity = 15;
set(hObject,'Min', intensity);
set(hObject,'Max', 60);
set(hObject,'Value', intensity);
% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes when user attempts to close GUI.
function GUI_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to GUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA

% Hint: delete(hObject) closes the figure
delete(hObject);

function compute_similarity_Callback(hObject, eventdata, handles)
global rSPD1 rSPD2;
if size(rSPD1,1) ~= 0 && size(rSPD2,1) ~= 0
    set(handles.similarity,'String', vec2ind(evaluate_similarity(rSPD1, rSPD2)));
end


% --- Executes on button press in save.
function save_Callback(hObject, eventdata, handles)
global last_master_index last_copy_spectrum last_copy_coordinates last_copy_rSPD;
global copy_rSPD_GUI copy_spectra_GUI copy_coordinates_GUI master_copied_GUI;
master_copied_GUI = [master_copied_GUI last_master_index];
copy_spectra_GUI = [copy_spectra_GUI last_copy_spectrum];
copy_coordinates_GUI = [copy_coordinates_GUI last_copy_coordinates];
copy_rSPD_GUI = [copy_rSPD_GUI last_copy_rSPD];
last_master_index = []; 
last_copy_spectrum = []; 
last_copy_coordinates = [];
last_copy_rSPD = [];
assignin('base', 'copy_spectra_GUI', copy_spectra_GUI);
assignin('base', 'copy_coordinates_GUI', copy_coordinates_GUI);
assignin('base', 'master_copied_GUI', master_copied_GUI);
assignin('base', 'copy_rSPD_GUI', copy_rSPD_GUI);


% --- Executes on button press in delete.
function delete_Callback(hObject, eventdata, handles)

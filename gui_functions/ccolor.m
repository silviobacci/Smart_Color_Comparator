function varargout = ccolor(varargin)
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ccolor_OpeningFcn, ...
                   'gui_OutputFcn',  @ccolor_OutputFcn, ...
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

% --- Executes just before ccolor is made visible.
function ccolor_OpeningFcn(hObject, ~, handles, varargin)
global rSPD1 rSPD2 lab1 lab2;
rSPD1 = [];
rSPD2 = [];
lab1 = [];
lab2 = [];
% Choose default command line output for ccolor
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
set(handles.patch_RGB,'xcolor', get(hObject,'Color'), 'ycolor', get(hObject,'Color'));

% Update handles structure
guidata(hObject, handles);


% --- Outputs from this function are returned to the command line.
function varargout = ccolor_OutputFcn(hObject, ~, handles)
% Get default command line output from handles structure
varargout{1} = handles.output;


% --------------------------------------------------------------------
function FileMenu_Callback(hObject, ~, handles)
% hObject    handle to FileMenu (see GCBO)
% ~  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function OpenMenuItem_Callback(hObject, ~, handles)
% hObject    handle to OpenMenuItem (see GCBO)
% ~  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
file = uigetfile('*.fig');
if ~isequal(file, 0)
    open(file);
end

% --------------------------------------------------------------------
function PrintMenuItem_Callback(hObject, ~, handles)
% hObject    handle to PrintMenuItem (see GCBO)
% ~  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
printdlg(handles.GUI)

% --------------------------------------------------------------------
function CloseMenuItem_Callback(hObject, ~, handles)
selection = questdlg(['Close ' get(handles.GUI,'Name') '?'],...
                     ['Close ' get(handles.GUI,'Name') '...'],...
                     'Yes','No','Yes');
if strcmp(selection,'No')
    return;
end

delete(handles.GUI)

function similarity_Callback(hObject, ~, handles)

% --- Executes during object creation, after setting all properties.
function similarity_CreateFcn(hObject, ~, handles)
set(hObject,'String','');
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in ok.
function ok_Callback(hObject, ~, handles)
str2double(get(handles.similarity,'String'));


% --- Executes on button press in cancel.
function cancel_Callback(hObject, ~, handles)
set(handles.similarity,'String','');


% --- Executes on selection change in choose_master1.
function choose_master1_Callback(hObject, ~, handles)
global master_copied_GUI lab1 lab2 rSPD1;
set(handles.choose_copy1,'Value', 1);
if get(handles.radiobutton1_master,'Value') == 1
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
    master_rSPD = evalin('base','master_rSPD');
    rSPD1 = master_rSPD(:,master1_index);
    if size(lab1,1) ~= 0 && size(lab2,1) ~= 0 && get(handles.show_delta,'Value') == 1
        [~, ~, e00] = compute_deltaE(lab1, lab2);
        set(handles.deltaE,'String',num2str(e00));
    end
    set(handles.similarity,'String', '');
end

if get(handles.radiobutton1_MATLAB,'Value') == 1
    who = evalin('base','whos');
    who = struct2cell(who);
    who = who(1,:);
    if ismember('copy_spectra',who)
        copy_spectra = evalin('base','copy_spectra');
        if ~isempty(copy_spectra)
            set(handles.choose_copy1,'Enable','on');
            set(handles.choose_copy1,'String',{1:size(copy_spectra,2)});
            set(handles.choose_copy1,'Value',1);
        end
        cla(handles.master_spectrum);
        axes(handles.patch_RGB);
        plot_lpatch([1 1 1]);
        set(handles.similarity,'String', '');
        lab1 = [];
        set(handles.deltaE,'String', '');
        set(handles.x1,'String', '');
        set(handles.y1,'String', '');
        set(handles.z1,'String', '');
        set(handles.r1,'String', '');
        set(handles.g1,'String', '');
        set(handles.b1,'String', '');
        set(handles.l1,'String', '');
        set(handles.a1,'String', '');
        set(handles.bb1,'String', '');
    end
end

if get(handles.radiobutton1_GUI,'Value') == 1
    if ~isempty(master_copied_GUI)
        set(handles.choose_copy1,'Enable','on');
        items = get(hObject,'String');
        master_index = str2double(items{get(hObject,'Value')});
        set(handles.choose_copy1,'String',{1:size(find(master_copied_GUI == master_index),2)});
        set(handles.choose_copy1,'Value',1);
    end
    cla(handles.master_spectrum);
    axes(handles.patch_RGB);
    plot_lpatch([1 1 1]);
    set(handles.similarity,'String', '');
    lab1 = [];
    set(handles.deltaE,'String', '');
    set(handles.x1,'String', '');
    set(handles.y1,'String', '');
    set(handles.z1,'String', '');
    set(handles.r1,'String', '');
    set(handles.g1,'String', '');
    set(handles.b1,'String', '');
    set(handles.l1,'String', '');
    set(handles.a1,'String', '');
    set(handles.bb1,'String', '');
end


% --- Executes during object creation, after setting all properties.
function choose_master1_CreateFcn(hObject, ~, handles)
set(hObject,'Enable', 'off');
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in choose_copy1.
function choose_copy1_Callback(hObject, ~, handles)
global copy_spectra_GUI copy_rSPD_GUI copy_coordinates_GUI master_copied_GUI lab1 lab2 rSPD1;
if get(handles.radiobutton1_MATLAB,'Value') == 1
    items = get(hObject,'String');
    copy1_index = str2double(items{get(hObject,'Value')});
    master1_index = get(handles.choose_master1,'Value');
    copy_spectra = evalin('base', 'copy_spectra');
    copy_coordinates = evalin('base', 'copy_coordinates');
    axes(handles.master_spectrum);
    plot_SPD(380:800, copy_spectra(:,copy1_index, master1_index));
    set(handles.x1,'String', copy_coordinates(1, copy1_index, master1_index));
    set(handles.y1,'String', copy_coordinates(2, copy1_index, master1_index));
    set(handles.z1,'String', copy_coordinates(3, copy1_index, master1_index));
    set(handles.r1,'String', copy_coordinates(4, copy1_index, master1_index));
    set(handles.g1,'String', copy_coordinates(5, copy1_index, master1_index));
    set(handles.b1,'String', copy_coordinates(6, copy1_index, master1_index));
    set(handles.l1,'String', copy_coordinates(7, copy1_index, master1_index));
    set(handles.a1,'String', copy_coordinates(8, copy1_index, master1_index));
    set(handles.bb1,'String', copy_coordinates(9, copy1_index, master1_index));
    axes(handles.patch_RGB);
    plot_lpatch(copy_coordinates(4:6, copy1_index, master1_index));
    lab1 = copy_coordinates(7:9, copy1_index, master1_index);
    copy_rSPD = evalin('base', 'copy_rSPD');
    rSPD1 = copy_rSPD(:,copy1_index, master1_index);
    if size(lab1,1) ~= 0 && size(lab2,1) ~= 0 && get(handles.show_delta,'Value') == 1
        [~, ~, e00] = compute_deltaE(lab1, lab2);
        set(handles.deltaE,'String',num2str(e00));
    end
    set(handles.similarity,'String', '');
end

if get(handles.radiobutton1_GUI,'Value') == 1
    items = get(hObject,'String');
    copy1_index = str2double(items{get(hObject,'Value')});
    items = get(handles.choose_master1,'String');
    master1_index = str2double(items{get(handles.choose_master1,'Value')});
    index = find(master_copied_GUI == master1_index);
    copy1_index = index(copy1_index);
    axes(handles.master_spectrum);
    plot_SPD(380:800, copy_spectra_GUI(:,copy1_index));
    set(handles.x1,'String', copy_coordinates_GUI(1, copy1_index));
    set(handles.y1,'String', copy_coordinates_GUI(2, copy1_index));
    set(handles.z1,'String', copy_coordinates_GUI(3, copy1_index));
    set(handles.r1,'String', copy_coordinates_GUI(4, copy1_index));
    set(handles.g1,'String', copy_coordinates_GUI(5, copy1_index));
    set(handles.b1,'String', copy_coordinates_GUI(6, copy1_index));
    set(handles.l1,'String', copy_coordinates_GUI(7, copy1_index));
    set(handles.a1,'String', copy_coordinates_GUI(8, copy1_index));
    set(handles.bb1,'String', copy_coordinates_GUI(9, copy1_index));
    axes(handles.patch_RGB);
    plot_lpatch(copy_coordinates_GUI(4:6, copy1_index));
    lab1 = copy_coordinates_GUI(7:9, copy1_index);
    copy_rSPD = evalin('base','copy_rSPD');
    rSPD1 = copy_rSPD(:,copy1_index, master1_index);
    if size(lab1,1) ~= 0 && size(lab2,1) ~= 0 && get(handles.show_delta,'Value') == 1
        [~, ~, e00] = compute_deltaE(lab1, lab2);
        set(handles.deltaE,'String',num2str(e00));
    end
    set(handles.similarity,'String', '');
end

% --- Executes during object creation, after setting all properties.
function choose_copy1_CreateFcn(hObject, ~, handles)
set(hObject,'Enable', 'off');
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function copy_spectrum_CreateFcn(hObject, ~, handles)

function deltaE_Callback(hObject, ~, handles)
% hObject    handle to deltaE (see GCBO)
% ~  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of deltaE as text
%        str2double(get(hObject,'String')) returns contents of deltaE as a double


% --- Executes during object creation, after setting all properties.
function deltaE_CreateFcn(hObject, ~, handles)
% hObject    handle to deltaE (see GCBO)
% ~  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in radiobutton1_master.
function radiobutton1_master_Callback(hObject, ~, handles)
global lab1;
if get(hObject,'Value') == 1
    set(handles.radiobutton1_MATLAB, 'Value', 0);
    set(handles.radiobutton1_GUI, 'Value', 0);
    who = evalin('base','whos');
    who = struct2cell(who);
    who = who(1,:);
    if ismember('master_spectra',who)
        master_spectra = evalin('base','master_spectra');
        if ~isempty(master_spectra)
            set(handles.choose_master1, 'Enable', 'on');
            set(handles.choose_master1, 'String', {1:size(master_spectra,2)});
            set(handles.choose_master1, 'Value', 1);
        end
    end
    set(handles.choose_copy1, 'String', 'Choose Copy');
    set(handles.choose_copy1, 'Enable', 'off');
    set(handles.choose_copy1, 'Value', 1);
    cla(handles.master_spectrum, 'reset');
    axes(handles.patch_RGB);
    plot_lpatch([1 1 1]);
    set(handles.similarity,'String', '');
    lab1 = [];
    set(handles.deltaE,'String', '');
    set(handles.x1,'String', '');
    set(handles.y1,'String', '');
    set(handles.z1,'String', '');
    set(handles.r1,'String', '');
    set(handles.g1,'String', '');
    set(handles.b1,'String', '');
    set(handles.l1,'String', '');
    set(handles.a1,'String', '');
    set(handles.bb1,'String', '');
else
    set(hObject,'Value', 1);
end


% --- Executes on button press in radiobutton1_MATLAB.
function radiobutton1_MATLAB_Callback(hObject, ~, handles)
global lab1;
if get(hObject,'Value') == 1
    set(handles.radiobutton1_master, 'Value', 0);
    set(handles.radiobutton1_GUI, 'Value', 0);
    who = evalin('base','whos');
    who = struct2cell(who);
    who = who(1,:);
    if ismember('master_copied',who)
        master_copied = evalin('base','master_copied');
        if ~isempty(master_copied)
            set(handles.choose_master1, 'Enable', 'on');
            set(handles.choose_master1, 'String', {master_copied});
            set(handles.choose_master1, 'Value', 1);
        else
            set(handles.choose_master1, 'String', 'Choose Master');
            set(handles.choose_master1, 'Enable', 'off');
            set(handles.choose_master1, 'Value', 1);
        end
    end
    set(handles.choose_copy1, 'String', 'Choose Copy');
    set(handles.choose_copy1, 'Enable', 'off');
    set(handles.choose_copy1, 'Value', 1);
    cla(handles.master_spectrum, 'reset');
    axes(handles.patch_RGB);
    plot_lpatch([1 1 1]);
    set(handles.similarity,'String', '');
    lab1 = [];
    set(handles.deltaE,'String', '');
    set(handles.x1,'String', '');
    set(handles.y1,'String', '');
    set(handles.z1,'String', '');
    set(handles.r1,'String', '');
    set(handles.g1,'String', '');
    set(handles.b1,'String', '');
    set(handles.l1,'String', '');
    set(handles.a1,'String', '');
    set(handles.bb1,'String', '');
else
    set(hObject,'Value', 1);
end


% --- Executes on button press in radiobutton1_GUI.
function radiobutton1_GUI_Callback(hObject, ~, handles)
global master_copied_GUI lab1;
if get(hObject,'Value') == 1
    set(handles.radiobutton1_master, 'Value', 0);
    set(handles.radiobutton1_MATLAB, 'Value', 0);
    if ~isempty(master_copied_GUI)
        set(handles.choose_master1, 'Enable', 'on');
        set(handles.choose_master1, 'String', {unique(master_copied_GUI)});
        set(handles.choose_master1, 'Value', 1);
    else
        set(handles.choose_master1, 'String', 'Choose Master');
        set(handles.choose_master1, 'Enable', 'off');
        set(handles.choose_master1, 'Value', 1);
    end
    set(handles.choose_copy1, 'String', 'Choose Copy');
    set(handles.choose_copy1, 'Enable', 'off');
    set(handles.choose_copy1, 'Value', 1);
    cla(handles.master_spectrum, 'reset');
    axes(handles.patch_RGB);
    plot_lpatch([1 1 1]);
    set(handles.similarity,'String', '');
    lab1 = [];
    set(handles.deltaE,'String', '');
    set(handles.x1,'String', '');
    set(handles.y1,'String', '');
    set(handles.z1,'String', '');
    set(handles.r1,'String', '');
    set(handles.g1,'String', '');
    set(handles.b1,'String', '');
    set(handles.l1,'String', '');
    set(handles.a1,'String', '');
    set(handles.bb1,'String', '');
else
    set(hObject,'Value', 1);
end


% --- Executes on selection change in choose_master2.
function choose_master2_Callback(hObject, ~, handles)
global master_copied_GUI lab2 rSPD2 lab1;
set(handles.choose_copy2,'Value', 1);

if get(handles.radiobutton2_master,'Value') == 1
    items = get(hObject,'String');
    master2_index = str2double(items{get(hObject,'Value')});
    master_spectra = evalin('base','master_spectra');
    axes(handles.copy_spectrum);
    plot_SPD(380:800, master_spectra(:,master2_index));
    master_coordinates = evalin('base','master_coordinates');
    set(handles.x2,'String', master_coordinates(1, master2_index));
    set(handles.y2,'String', master_coordinates(2, master2_index));
    set(handles.z2,'String', master_coordinates(3, master2_index));
    set(handles.r2,'String', master_coordinates(4, master2_index));
    set(handles.g2,'String', master_coordinates(5, master2_index));
    set(handles.b2,'String', master_coordinates(6, master2_index));
    set(handles.l2,'String', master_coordinates(7, master2_index));
    set(handles.a2,'String', master_coordinates(8, master2_index));
    set(handles.bb2,'String', master_coordinates(9, master2_index));
    axes(handles.patch_RGB);
    plot_rpatch(master_coordinates(4:6, master2_index));
    lab2 = master_coordinates(7:9, master2_index);
    master_rSPD = evalin('base','master_rSPD');
    rSPD2 = master_rSPD(:,master2_index);
    if size(lab1,1) ~= 0 && size(lab2,1) ~= 0 && get(handles.show_delta,'Value') == 1
        [~, ~, e00] = compute_deltaE(lab1, lab2);
        set(handles.deltaE,'String',num2str(e00));
    end
    set(handles.similarity,'String', '');
end

if get(handles.radiobutton2_MATLAB,'Value') == 1
    who = evalin('base','whos');
    who = struct2cell(who);
    who = who(1,:);
    if ismember('copy_spectra',who)
        copy_spectra = evalin('base','copy_spectra');
        if ~isempty(copy_spectra)
            set(handles.choose_copy2,'Enable','on');
            set(handles.choose_copy2,'String',{1:size(copy_spectra,2)});
        end
        cla(handles.copy_spectrum);
        axes(handles.patch_RGB);
        plot_rpatch([1 1 1]);
        lab2 = [];
        set(handles.similarity,'String', '');
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
    end
end

if get(handles.radiobutton2_GUI,'Value') == 1
    if ~isempty(master_copied_GUI)
        set(handles.choose_copy2,'Enable','on');
        items = get(hObject,'String');
        master_index = str2double(items{get(hObject,'Value')});
        set(handles.choose_copy2,'String',{1:size(find(master_copied_GUI == master_index),2)});
        set(handles.choose_copy2,'Value',1);
    end
    cla(handles.copy_spectrum);
    axes(handles.patch_RGB);
    plot_rpatch([1 1 1]);
    set(handles.similarity,'String', '');
    lab2 = [];
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
end


% --- Executes during object creation, after setting all properties.
function choose_master2_CreateFcn(hObject, ~, handles)
set(hObject,'Enable', 'off');
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in choose_copy2.
function choose_copy2_Callback(hObject, ~, handles)
global copy_spectra_GUI copy_coordinates_GUI master_copied_GUI copy_rSPD_GUI lab2 rSPD2 lab1;
if get(handles.radiobutton2_MATLAB,'Value') == 1
    items = get(hObject,'String');
    copy2_index = str2double(items{get(hObject,'Value')});
    master2_index = get(handles.choose_master2,'Value');
    copy_spectra = evalin('base', 'copy_spectra');
    copy_coordinates = evalin('base', 'copy_coordinates');
    axes(handles.copy_spectrum);
    plot_SPD(380:800, copy_spectra(:,copy2_index, master2_index));
    set(handles.x2,'String', copy_coordinates(1, copy2_index, master2_index));
    set(handles.y2,'String', copy_coordinates(2, copy2_index, master2_index));
    set(handles.z2,'String', copy_coordinates(3, copy2_index, master2_index));
    set(handles.r2,'String', copy_coordinates(4, copy2_index, master2_index));
    set(handles.g2,'String', copy_coordinates(5, copy2_index, master2_index));
    set(handles.b2,'String', copy_coordinates(6, copy2_index, master2_index));
    set(handles.l2,'String', copy_coordinates(7, copy2_index, master2_index));
    set(handles.a2,'String', copy_coordinates(8, copy2_index, master2_index));
    set(handles.bb2,'String', copy_coordinates(9, copy2_index, master2_index));
    axes(handles.patch_RGB);
    plot_rpatch(copy_coordinates(4:6, copy2_index, master2_index));
    lab2 = copy_coordinates(7:9, copy2_index, master2_index);
    copy_rSPD = evalin('base','copy_rSPD');
    rSPD2 = copy_rSPD(:,copy2_index, master2_index);
    if size(lab1,1) ~= 0 && size(lab2,1) ~= 0 && get(handles.show_delta,'Value') == 1
        [~, ~, e00] = compute_deltaE(lab1, lab2);
        set(handles.deltaE,'String',num2str(e00));
    end
    set(handles.similarity,'String', '');
end

if get(handles.radiobutton2_GUI,'Value') == 1
    items = get(hObject,'String');
    copy2_index = str2double(items{get(hObject,'Value')});
    items = get(handles.choose_master1,'String');
    master2_index = str2double(items{get(handles.choose_master2,'Value')});
    index = find(master_copied_GUI == master2_index);
    copy2_index = index(copy2_index);
    axes(handles.copy_spectrum);
    plot_SPD(380:800, copy_spectra_GUI(:,copy2_index, master2_index));
    set(handles.x2,'String', copy_coordinates_GUI(1, copy2_index, master2_index));
    set(handles.y2,'String', copy_coordinates_GUI(2, copy2_index, master2_index));
    set(handles.z2,'String', copy_coordinates_GUI(3, copy2_index, master2_index));
    set(handles.r2,'String', copy_coordinates_GUI(4, copy2_index, master2_index));
    set(handles.g2,'String', copy_coordinates_GUI(5, copy2_index, master2_index));
    set(handles.b2,'String', copy_coordinates_GUI(6, copy2_index, master2_index));
    set(handles.l2,'String', copy_coordinates_GUI(7, copy2_index, master2_index));
    set(handles.a2,'String', copy_coordinates_GUI(8, copy2_index, master2_index));
    set(handles.bb2,'String', copy_coordinates_GUI(9, copy2_index, master2_index));
    axes(handles.patch_RGB);
    plot_rpatch(copy_coordinates_GUI(4:6, copy2_index, master2_index));
    lab2 = copy_coordinates_GUI(7:9, copy2_index, master2_index);
    rSPD2 = copy_rSPD_GUI(:,copy2_index, master_index2);
    if size(lab1,1) ~= 0 && size(lab2,1) ~= 0 && get(handles.show_delta,'Value') == 1
        [~, ~, e00] = compute_deltaE(lab1, lab2);
        set(handles.deltaE,'String',num2str(e00));
    end
    set(handles.similarity,'String', '');
end


% --- Executes during object creation, after setting all properties.
function choose_copy2_CreateFcn(hObject, ~, handles)
set(hObject,'Enable', 'off');
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in radiobutton2_master.
function radiobutton2_master_Callback(hObject, ~, handles)
global lab2;
if get(hObject,'Value') == 1
    set(handles.radiobutton2_MATLAB, 'Value', 0);
    set(handles.radiobutton2_GUI, 'Value', 0);
    who = evalin('base','whos');
    who = struct2cell(who);
    who = who(1,:);
    if ismember('master_spectra',who)
        master_spectra = evalin('base','master_spectra');
        if ~isempty(master_spectra)
            set(handles.choose_master2, 'Enable', 'on');
            set(handles.choose_master2, 'String', {1:size(master_spectra,2)});
            set(handles.choose_master2, 'Value', 1);
        end
    end
    set(handles.choose_copy2, 'String', 'Choose Copy');
    set(handles.choose_copy2, 'Enable', 'off');
    set(handles.choose_copy2, 'Value', 1);
    cla(handles.copy_spectrum, 'reset');
    axes(handles.patch_RGB);
    plot_rpatch([1 1 1]);
    set(handles.similarity,'String', '');
    lab2 = [];
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
else
    set(hObject,'Value', 1);
end


% --- Executes on button press in radiobutton2_MATLAB.
function radiobutton2_MATLAB_Callback(hObject, ~, handles)
global lab2;
if get(hObject,'Value') == 1
    set(handles.radiobutton2_master, 'Value', 0);
    set(handles.radiobutton2_GUI, 'Value', 0);
    who = evalin('base','whos');
    who = struct2cell(who);
    who = who(1,:);
    if ismember('master_copied',who)
        master_copied = evalin('base','master_copied');
        if ~isempty(master_copied)
            set(handles.choose_master2, 'Enable', 'on');
            set(handles.choose_master2, 'String', {master_copied});
            set(handles.choose_master2, 'Value', 1);
        else
            set(handles.choose_master2, 'String', 'Choose Master');
            set(handles.choose_master2, 'Enable', 'off');
            set(handles.choose_master2, 'Value', 1);
        end
    end
    set(handles.choose_copy2, 'String', 'Choose Copy');
    set(handles.choose_copy2, 'Enable', 'off');
    set(handles.choose_copy2, 'Value', 1);
    cla(handles.copy_spectrum, 'reset');
    axes(handles.patch_RGB);
    plot_rpatch([1 1 1]);
    set(handles.similarity,'String', '');
    lab2 = [];
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
else
    set(hObject,'Value', 1);
end


% --- Executes on button press in radiobutton2_GUI.
function radiobutton2_GUI_Callback(hObject, ~, handles)
global master_copied_GUI lab2;
if get(hObject,'Value') == 1
    set(handles.radiobutton2_master, 'Value', 0);
    set(handles.radiobutton2_MATLAB, 'Value', 0);
    if ~isempty(master_copied_GUI)
        set(handles.choose_master2, 'Enable', 'on');
        set(handles.choose_master2, 'String', {unique(master_copied_GUI)});
        set(handles.choose_master2, 'Value', 1);
    else
        set(handles.choose_master2, 'String', 'Choose Master');
        set(handles.choose_master2, 'Enable', 'off');
        set(handles.choose_master2, 'Value', 1);
    end
    cla(handles.copy_spectrum, 'reset');
    set(handles.choose_copy2, 'String', 'Choose Copy');
    set(handles.choose_copy2, 'Enable', 'off');
    set(handles.choose_copy2, 'Value', 1);
    axes(handles.patch_RGB);
    plot_rpatch([1 1 1]);
    set(handles.similarity,'String', '');
    lab2 = [];
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
else
    set(hObject,'Value', 1);
end


% --- Executes on button press in show_similarity.
function show_similarity_Callback(hObject, ~, handles)
% hObject    handle to show_similarity (see GCBO)
% ~  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of show_similarity


% --- Executes on button press in show_delta.
function show_delta_Callback(hObject, ~, handles)
% hObject    handle to show_delta (see GCBO)
% ~  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global lab1 lab2;
if get(hObject,'Value') == 1
    if size(lab1,1) ~= 0 && size(lab2,1) ~= 0 && get(handles.show_delta,'Value') == 1
        [~, ~, e00] = compute_deltaE(lab1, lab2);
        set(handles.deltaE,'String',num2str(e00));
    end
else
    set(handles.deltaE,'String','');
end
% Hint: get(hObject,'Value') returns toggle state of show_delta



function x1_Callback(hObject, ~, handles)


% --- Executes during object creation, after setting all properties.
function x1_CreateFcn(hObject, ~, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit4_Callback(hObject, ~, handles)


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, ~, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function y1_Callback(hObject, ~, handles)

% --- Executes during object creation, after setting all properties.
function y1_CreateFcn(hObject, ~, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function z1_Callback(hObject, ~, handles)


% --- Executes during object creation, after setting all properties.
function z1_CreateFcn(hObject, ~, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function r1_Callback(hObject, ~, handles)

% --- Executes during object creation, after setting all properties.
function r1_CreateFcn(hObject, ~, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function g1_Callback(hObject, ~, handles)

% --- Executes during object creation, after setting all properties.
function g1_CreateFcn(hObject, ~, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function b1_Callback(hObject, ~, handles)


% --- Executes during object creation, after setting all properties.
function b1_CreateFcn(hObject, ~, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function l1_Callback(hObject, ~, handles)


% --- Executes during object creation, after setting all properties.
function l1_CreateFcn(hObject, ~, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function a1_Callback(hObject, ~, handles)


% --- Executes during object creation, after setting all properties.
function a1_CreateFcn(hObject, ~, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function bb1_Callback(hObject, ~, handles)


% --- Executes during object creation, after setting all properties.
function bb1_CreateFcn(hObject, ~, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function x2_Callback(hObject, ~, handles)


% --- Executes during object creation, after setting all properties.
function x2_CreateFcn(hObject, ~, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function y2_Callback(hObject, ~, handles)


% --- Executes during object creation, after setting all properties.
function y2_CreateFcn(hObject, ~, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function z2_Callback(hObject, ~, handles)
% hObject    handle to z2 (see GCBO)
% ~  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of z2 as text
%        str2double(get(hObject,'String')) returns contents of z2 as a double


% --- Executes during object creation, after setting all properties.
function z2_CreateFcn(hObject, ~, handles)
% hObject    handle to z2 (see GCBO)
% ~  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function r2_Callback(hObject, ~, handles)
% hObject    handle to r2 (see GCBO)
% ~  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of r2 as text
%        str2double(get(hObject,'String')) returns contents of r2 as a double


% --- Executes during object creation, after setting all properties.
function r2_CreateFcn(hObject, ~, handles)
% hObject    handle to r2 (see GCBO)
% ~  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function g2_Callback(hObject, ~, handles)
% hObject    handle to g2 (see GCBO)
% ~  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of g2 as text
%        str2double(get(hObject,'String')) returns contents of g2 as a double


% --- Executes during object creation, after setting all properties.
function g2_CreateFcn(hObject, ~, handles)
% hObject    handle to g2 (see GCBO)
% ~  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function b2_Callback(hObject, ~, handles)
% hObject    handle to b2 (see GCBO)
% ~  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of b2 as text
%        str2double(get(hObject,'String')) returns contents of b2 as a double


% --- Executes during object creation, after setting all properties.
function b2_CreateFcn(hObject, ~, handles)
% hObject    handle to b2 (see GCBO)
% ~  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function l2_Callback(hObject, ~, handles)
% hObject    handle to l2 (see GCBO)
% ~  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of l2 as text
%        str2double(get(hObject,'String')) returns contents of l2 as a double


% --- Executes during object creation, after setting all properties.
function l2_CreateFcn(hObject, ~, handles)
% hObject    handle to l2 (see GCBO)
% ~  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function a2_Callback(hObject, ~, handles)
% hObject    handle to a2 (see GCBO)
% ~  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of a2 as text
%        str2double(get(hObject,'String')) returns contents of a2 as a double


% --- Executes during object creation, after setting all properties.
function a2_CreateFcn(hObject, ~, handles)
% hObject    handle to a2 (see GCBO)
% ~  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function bb2_Callback(hObject, ~, handles)
% hObject    handle to bb2 (see GCBO)
% ~  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of bb2 as text
%        str2double(get(hObject,'String')) returns contents of bb2 as a double


% --- Executes during object creation, after setting all properties.
function bb2_CreateFcn(hObject, ~, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in compute_similarity.
function compute_similarity_Callback(hObject, ~, handles)
global rSPD1 rSPD2;
if size(rSPD1,1) ~= 0 && size(rSPD2,1) ~= 0
    set(handles.similarity,'String', vec2ind(evaluate_similarity(rSPD1, rSPD2)));
end

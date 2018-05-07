function varargout = start(varargin)
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @start_OpeningFcn, ...
                   'gui_OutputFcn',  @start_OutputFcn, ...
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


% --- Executes just before start is made visible.
function start_OpeningFcn(hObject, ~, handles, varargin)
who = evalin('base','whos');
who = struct2cell(who);
who = who(1,:);
if ~ismember('master_spectra',who)
    set(handles.create,'Enable', 'off');
    set(handles.compare,'Enable', 'off');
    set(handles.evaluate,'Enable', 'off');
end
addpath(genpath('./conversion_functions'));
addpath(genpath('./gui_functions'));
addpath(genpath('./nn_functions'));
addpath(genpath('./plot_functions'));
addpath(genpath('./utility_functions'));
addpath(genpath('./workspace'));
% Choose default command line output for start
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);


% --- Outputs from this function are returned to the command line.
function varargout = start_OutputFcn(~, ~, handles) 
% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in launch.
function launch_Callback(~, ~, handles)
evalin('base', 'main');
set(handles.create,'Enable', 'on');
set(handles.compare,'Enable', 'on');
set(handles.evaluate,'Enable', 'on');


% --- Executes on button press in create.
function create_Callback(~, ~, ~)
ccopy

function compare_Callback(~, ~, ~)
ccolor


% --- Executes on button press in evaluate.
function evaluate_Callback(~, ~, ~)
esimilarity


% --- Executes when figure1 is resized.
function figure1_SizeChangedFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function varargout = gui_ecg(varargin)
% GUI_ECG MATLAB code for gui_ecg.fig
%      GUI_ECG, by itself, creates a new GUI_ECG or raises the existing
%      singleton*.
%
%      H = GUI_ECG returns the handle to a new GUI_ECG or the handle to
%      the existing singleton*.
%
%      GUI_ECG('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_ECG.M with the given input arguments.
%
%      GUI_ECG('Property','Value',...) creates a new GUI_ECG or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_ecg_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_ecg_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui_ecg

% Last Modified by GUIDE v2.5 11-Apr-2017 14:53:51

% Begin initialization code - DO NOT EDIT

global dataClient;
dataClient = DataClient('localhost',55000,200,5,0.04); % Create client object
global t;
t = timer('StartDelay',1,'TimerFcn',@t_TimerFcn,'Period',0.05,'ExecutionMode','fixedRate'); %设置period作为周期

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_ecg_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_ecg_OutputFcn, ...
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



% --- Executes just before gui_ecg is made visible.
function gui_ecg_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui_ecg (see VARARGIN)

% Choose default command line output for gui_ecg
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui_ecg wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui_ecg_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global dataClient;
global t;
dataClient.Open;
pause(2);
handles.y=dataClient.GetRawData;%读数组
handles.z=dataClient.GetRwave;
line(1)=plot(handles.y); hold on
line(2)=scatter(handles.z,handles.y(handles.z)); hold off
set(line(2),'marker','o');
handles.line=line;
start(t);%start按钮 打开计时器
guidata(hObject, handles);

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
global dataClient;
global t;
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
dataClient.Close;
stop(t);
%stop按钮 stop(t); 停止计时器

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% 贴上你的connect对应的函数代码

% --- Executes during object creation, after setting all properties.
function text3_CreateFcn(hObject, eventdata, handles)
global dataClient;
% hObject    handle to text3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
handles.rate = dataClient.GetHR;
set(hObject,'string',handles.rate);%显示心率
guidata(hObject,handles);


function edit3_Callback(hObject, eventdata, handles)
global dataClient;
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double
name = get(hObject,'string');
dataClient.set_UserName(name);

% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




function t_TimerFcn(hobject,eventdata)
global dataClient;
handles.rate = dataClient.GetHR;
set(handles.text3,'string',handles.rate);%显示心率
handles.y=dataClient.GetRawData;%读数组
handles.z=dataClient.GetRwave;
set(handles.line(1),'YData',handles.y);
set(handles.line(2),'XData',handles.z,'YData',handles.y(handles.z))
drawnow;
%更新figure里的x数据
guidata(hObject, handles);


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
global dataClient;
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
dataClient.HRV;% 调出HRV分析的界面

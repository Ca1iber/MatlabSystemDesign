function varargout = GeminiAPI(varargin)
% GEMINIAPI MATLAB code for GeminiAPI.fig
%      GEMINIAPI, by itself, creates a new GEMINIAPI or raises the existing
%      singleton*.
%
%      H = GEMINIAPI returns the handle to a new GEMINIAPI or the handle to
%      the existing singleton*.
%
%      GEMINIAPI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GEMINIAPI.M with the given input arguments.
%
%      GEMINIAPI('Property','Value',...) creates a new GEMINIAPI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GeminiAPI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GeminiAPI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GeminiAPI

% Last Modified by GUIDE v2.5 26-Apr-2024 16:11:20

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GeminiAPI_OpeningFcn, ...
                   'gui_OutputFcn',  @GeminiAPI_OutputFcn, ...
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


% --- Executes just before GeminiAPI is made visible.
function GeminiAPI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GeminiAPI (see VARARGIN)

% Choose default command line output for GeminiAPI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GeminiAPI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GeminiAPI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
Question=handles.Question;
a=Question;
save('tempQuestion','a');
system('python Gemini_API_Test.py');
b=fileread('an.txt');
set(handles.text2,'String',b);



function edit2_Callback(hObject, eventdata, handles)
Question=get(hObject,'string');
handles.Question=Question;
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

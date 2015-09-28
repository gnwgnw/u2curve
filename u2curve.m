function varargout = u2curve(varargin)
% U2CURVE MATLAB code for u2curve.fig
%      U2CURVE, by itself, creates a new U2CURVE or raises the existing
%      singleton*.
%
%      H = U2CURVE returns the handle to a new U2CURVE or the handle to
%      the existing singleton*.
%
%      U2CURVE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in U2CURVE.M with the given input arguments.
%
%      U2CURVE('Property','Value',...) creates a new U2CURVE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before u2curve_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to u2curve_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help u2curve

% Last Modified by GUIDE v2.5 28-Sep-2015 11:17:48

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @u2curve_OpeningFcn, ...
                   'gui_OutputFcn',  @u2curve_OutputFcn, ...
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


% --- Executes just before u2curve is made visible.
function u2curve_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to u2curve (see VARARGIN)

const_u = 2;
amp_u = 0.2;

handles.t = 0:0.01:20;
handles.u = const_u * ( 1 + amp_u * sin(handles.t));
[handles.phi, handles.ro, handles.X, handles.Y, handles.G2] = u2G(handles.t, handles.u);

handles.u_stat(1:length(handles.t)) = const_u;
[handles.phi_stat, handles.ro_stat, handles.X_stat, handles.Y_stat, handles.G2_stat] = u2G(handles.t, handles.u_stat);

handles.S = [complex(0,0) complex(1,0);
             complex(1,0) complex(0,0)];

handles.G1 = restore_G1(handles.G2, handles.S);

%Plot data
axes(handles.axes_u);
hold on;
grid on;
plot(handles.t, handles.u_stat);
handles.plot_u = plot(handles.t, handles.u);
legend('u stationary', 'u');

axes(handles.axes_phi);
hold on;
grid on;
plot(handles.t, handles.phi_stat);
handles.plot_phi = plot(handles.t, handles.phi);
legend('phi stationary', 'phi');

axes(handles.axes_ro);
hold on;
grid on;
plot(handles.t, handles.ro_stat);
handles.plot_ro = plot(handles.t, handles.ro);
legend('ro stationary', 'ro');

axes(handles.axes_XY);
hold on;
grid on;
plot(handles.t, handles.X_stat, 'b');
plot(handles.t, handles.Y_stat, 'r');
handles.plot_X = plot(handles.t, handles.X, 'b', 'LineWidth', 1.5);
handles.plot_Y = plot(handles.t, handles.Y, 'r', 'LineWidth', 1.5);
legend('X stationary', 'Y stationary', 'X', 'Y');

axes(handles.axes_curve);
hold on;
axis equal;
grid on;
plot(handles.G2_stat);
handles.plot_G2 = plot(handles.G2);
handles.plot_G1 = plot(handles.G1);
legend('G2 stationary', 'G2', 'G1');

axes(handles.axes_G2_diff);
hold on;
axis equal;
grid on;
handles.plot_G2_diff = plot(handles.G2 - handles.G2_stat);
legend('G2 diff');

% Choose default command line output for u2curve
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes u2curve wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = u2curve_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


function slider_Callback(hObject, eventdata, handles)
tag_slider = get(hObject,'Tag');
tag_edit = strcat('edit_', tag_slider);

val = get(hObject, 'Value');
set(findobj('Tag', tag_edit), 'String', val);

tokens = regexp(tag_slider,'(\d{1})(\d{1})_([xy]{1})', 'tokens');
i = str2double(tokens{1}{1});
j = str2double(tokens{1}{2});
is_real = tokens{1}{3};

if is_real == 'x'
    is_real = true;
    handles.S(i,j) = re_change(handles.S(i,j), val);
else
    is_real = false;
    handles.S(i,j) = im_change(handles.S(i,j), val);
end

handles.G1 = restore_G1(handles.G2, handles.S);

set(handles.plot_G1, 'XData', real(handles.G1));
set(handles.plot_G1, 'YData', imag(handles.G1));

% Update handles structure
guidata(hObject, handles);


function edit_Callback(hObject, eventdata, handles)
% hObject    handle to edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit9 as text
%        str2double(get(hObject,'String')) returns contents of edit9 as a double

val = str2double(get(hObject,'String'));

tag_edit = get(hObject,'Tag');
tag_slider = regexp(tag_edit,'s\d{2}_[xy]', 'match');
tag_slider = tag_slider{1};

slider = findobj('Tag', tag_slider);
set(slider,'Value',val);

% Update handles structure
guidata(hObject, handles);
 
slider.Callback(slider, eventdata);

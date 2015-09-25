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

% Last Modified by GUIDE v2.5 25-Sep-2015 11:23:07

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

handles.t = 0:0.01:10;
handles.u = const_u + const_u * amp_u * sin(handles.t);
[handles.phi, handles.ro, handles.X, handles.Y, handles.G1] = u2G(handles.t, handles.u);

handles.u_stat(1:length(handles.t)) = const_u;
[handles.phi_stat, handles.ro_stat, handles.X_stat, handles.Y_stat, handles.G1_stat] = u2G(handles.t, handles.u_stat);

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
grid on;
plot(handles.G1_stat);
handles.plot_curve = plot(handles.G1);
legend('G1 stationary', 'G1');

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

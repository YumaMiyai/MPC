function initialize_CMPC
% system initialization function 

%%%%% Changes can be in
% Horizon, Ts, Tc, t_event, delta u, ARIMA, fmincon options

%%%%%%%%%%%%%%%%%%%%%%%% Global parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global Ts; global N; global actual_time; global horizon; 
global tc; global t_event;
global n; global m; global x_init;
global init_Control; global lb; global ub; global V1mL; global V2mL; 
global V1; global V2; global xl1; global xl2; global x1; global x2; 

global D1; global tubeID_1; global tubeID_2; global dt; global nx1; 
global nx2; global dx1; global dx2; global Ea1; global Ea2; global k01; 
global k02; global R; global Ac1; global Ac2;

global CA_molm3; global CB_molm3; global CD_molm3;

global MV;

%-------------------------------------------------------------------------
%% Constants
D1   = 0.005;               %diffusivity
tubeID_1 = 1.5875;          %1/8" O.D. tube - (1/16" or 1.5875mm I.D.)
tubeID_2 = 1.5875;          %1/8" O.D. tube - (1/16" or 1.5875mm I.D.)
Ac1  = pi*(tubeID_1/2/1000)^2;%cross-sectional area of tube (m^2)
Ac2  = pi*(tubeID_2/2/1000)^2;%cross-sectional area of tube (m^2)
V1mL = 6;                  %reactor 1 volume (mL)
V2mL = 5;                   %reactor 2 volume (mL)
V1   = V1mL/(10^6);         %reactor 1 volume (m^3)
V2   = V2mL/(10^6);         %reactor 2 volume (m^3)
xl1  = V1/Ac1;              %reacto 1 tubing length (m)
xl2  = V2/Ac2;              %reacto 2 tubing length (m)
dt   = 0.01;           %model calculation increment (s)
nx1  = 200;                 %reactor 1 broken down to 200 sections
nx2  = 200;                 %reactor 2 broken down to 200 sections
dx1  = xl1/(nx1-1);         %length of each section in reactor 1 (m)
dx2  = xl2/(nx2-1);         %length of each section in reactor 2 (m)
x1   = linspace(0,xl1,nx1); %tubing length over 200 sections
x2   = linspace(0,xl2,nx2); %tubing length over 200 sections
Ea1  = 57726;               %step 1 activation energy (J/mol)
Ea2  = 23681;               %step 2 activation energy (J/mol)              
k01  = 6892.9;             %reaction 1 pre-exponential constant (m3/mol.s)
k02  = 11.3;                %reaction 2 pre-exponential constant (m3/mol.s)                    
R    = 8.314;               %universal gas constant (j/mol.K)

% initial array settings for concnetrations (nx1 and nx2 sections)
A    = ones(1,nx1);
B    = ones(1,nx1);
C    = zeros(1,nx1);
C2   = ones(1,nx2);
D    = ones(1,nx2);
E    = zeros(1,nx2);

%--------------------------------------------------------------------------
%%
Ts=2;                %sampling time [s]
tc=10;                %Control interval [s]
actual_time=600;     %simulation span [s]
t_event=10;           %Event happens and Control is applied [s]
N=actual_time/Ts;    %final horizon
horizon=120;

n=1200;              %state size 
m=5;                 %input size

%% ------------------------------------------------------------------------

% Stock Solution Concentrations (M)
CA_M = 1;            % Fluoro
CB_M = 1.2;          % Acrylate
CD_M = 1.25;         % Cyclo

% Unit Conversion - Stock Solution Concentrations (mol/m^3)
CA_molm3  = CA_M*1000;   
CB_molm3  = CB_M*1000;     
CD_molm3  = CD_M*1000;      

% Flow rate (ml/min)
QA   = 2.5;          %2.5mL/min Fluoro
QB   = 2.5;          %2.5mL/min Acrylate
QC   = QA+QB;        %5mL/min step 1 
QD   = 2.5;          %2.5mL/min Cyclo
QE   = QC+QD;        %7.5mL/min step 2

% Unit Conversion - Flow rate (m^3/s)
F_QA  = QA/(10^6*60);
F_QB  = QB/(10^6*60);
F_QC  = QC/(10^6*60);
F_QD  = QD/(10^6*60);
F_QE  = QE/(10^6*60);

% Inlet concentration (mol/m^3)
F_CA  = CA_molm3*F_QA/F_QC;  %0m^3/s Fluoro
F_CB  = CB_molm3*F_QB/F_QC;  %0m^3/s Acrylate
F_CD  = CD_molm3*F_QD/F_QE;  %0m^3/s Cyclo

A(1) = F_CA;
B(1) = F_CB;
D(1) = F_CD;

% Reactor temperature (K)
T1   = 150;         %initial reaction 1 temperature (deg C)
T2   = 25;          %initial reaction 2 temperature (deg C)

% Initial State variables      
x_init = [A B C C2 D E]';  

%initial control inputs
init_Control=[F_QA F_QB F_QD T1 T2]'; 

% % MV upper and lower limits
% lb = [2.08e-8 2.08e-8 2.08e-8 25 25]'; 
% ub = [8.33e-8 8.33e-8 8.33e-8 160 25]';
%         % 1.25mL/min (lower boundary) to 5mL/min (higher boundary)

% Control Inputs
Fluoro = 1:0.25:5;
Acrylate = 1:0.25:5;
Cyclo = 1:0.25:5;
Temp1 = T1;
Temp2 = T2;

MV = ControlInputs(Fluoro,Acrylate,Cyclo)./(10^6*60);
MV(1:4913,4)=Temp1;
MV(1:4913,5)=Temp2;
end
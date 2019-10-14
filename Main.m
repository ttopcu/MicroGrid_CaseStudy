% This code is the main module for running the Entire Model
%% Obtain Simulation parameters
tic
FLdist = xlsread('FL_normalrandom.xlsx'); % random hourly observation generator in the following format
% HourID, Month, Day, Hour, Average GHI (calculated from above data),
% Average Windspeed, STD Dev GHI, STD Dev Windspeed
% observations are of size 8760*1
FLdist = FLdist(2:8761,:);%Discarding Row Names
% capture distributions for each day id
HourID = FLdist(:,1); % Set hour id vector
HourID_solar_ave = FLdist(:,5); % capture hourly solar GHI averages
HourID_solar_stddev = FLdist(:,7); % capture hourly solar STD devs
HourID_solar_stddev = HourID_solar_stddev/3;
HourID_wind_ave = FLdist(:,6); % capture hourly wind averages
HourID_wind_stddev = FLdist(:,8); % capture hourly wind STD devs
HourID_wind_stddev = HourID_wind_stddev/3;
Wind = zeros(length(HourID),1);% prelocate matrix size 
Sun = zeros(length(HourID),1);% prelocate matrix size 
%%  Enter Simulation Parameters
SimLifeYears = 25; % modify simulation years as you see fit. 25 for the Expert Systems Paper
%% Setting parameters and importing demand
Panel_Eff = 0.15; % a value between 10-20%
Charge_Eff = 0.95; % charge efficiency of Battery
Discharge_Eff = 0.92; % discharge efficiency of battery
Turbine_DegradationRate = 0.015; %annual performance degradation ratio of WindTurbines (1.5%/yr)
Panel_DegradationRate = 0.005; %annual performance degredation of Solar Panels cite#
MonteCarlo_Run = 1000; % specify number of monte carlo iterations.
%% Call other modules
DailyDist; %obtain daily schedule for fixing hourly consumption patterns
MG_DesignSpaceGenerator; %this creates the DMUs
N_DMUs = length(DMUs); %fix the number of DMUs based on design space
% DMU_Input = zeros(N_DMUs ,3); % preset DMU Input matrix size for computational speed [ lifetime cost , Land Area, energy bought from main grid]  
DMU_Output = zeros(N_DMUs ,3); % preset DMU Output matrix size for computational speed [Total Replaced Energy, hours spent off grid, $sold to main grid]
DMU_SelfSustain = zeros(N_DMUs,1); % initialize self sustainable hours for computational speed
%% Monte Carlo Simulator 
CCR_IO = zeros(MonteCarlo_Run,1); %initalize efficiency distribution matrix size for computation speed. Rows are 
DMU_TimeLog = zeros(N_DMUs*MonteCarlo_Run,7);
a=1;
bos = zeros(length(DMUs),1);
DMU_Input=horzcat(DMU_LifeCost_x1,DMU_LandArea_x2,bos,bos); %selecting the Input Variables for DEA
    for r=1:MonteCarlo_Run 
        Envo_Sim % simulates a random weather of 25 years long
        Community_Demand; %obtain previously simulated Community Demand for Population size 50k 
        Energy_Conversion % computes performance over 25 year period and generates input and output matrices 
        DMU_TimeLog(a:(r*N_DMUs),1:7) = horzcat(DMU_Input,DMU_Output); %  x1=Life cost in NPV, x2= Land Area, x3= Dollar energy purchased from main grid, 
        %y1= total energy production over life, y2= self sustainable hours
        %over life (out of all possible hours), y3= total worth of energy
        %sold to grid in US Dollars
        a=a+N_DMUs;
%  CCR_IO(r)=dea(DMU_Input,DMU_Output,'orient','io','rts','vrs');
    end
csvwrite('Deneme_250Iter.csv',DMU_TimeLog); % manually change file name based on analysis
toc



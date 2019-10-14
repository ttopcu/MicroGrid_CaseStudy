%% MG Design Space Generator 
% This module creates design alternatives within an abstract MG design space 
% that is composed of 3 design variables:
% Number of Wind Turbines ,Solar Panel Area (m^2), Battery Size (kWh)

% Step 1 establishing Boundaries for design variables

LB_Turbine = 1; % Lower Bound for WindTurbines, unit is quantity
UB_Turbine = 12; % Upper Bound for WindTurbines, unit is quantity
VaryTurbine = 1; % amount to vary the number of turbines
LB_SolarPanel = 1000; %Lower Bound for SolarPanelArea, unit is meter squared
UB_SolarPanel = 55000; %Upper Bound for SolarPanelArea, unit is meter squared
VaryPanel = 2000; % amount to vary the size of panels
LB_StorageCapacity = 10000; %Lower Bound for Storage, unit is kWh 
UB_StorageCapacity = 150000; %Upper Bound for Storage, unit is kWh 
VaryStorage = 10000; % amount to vary the size of storage

%% Step 2 - Varying within boundaries to generate design alternatives 
for i = LB_Turbine:UB_Turbine % Starting an array for possible number of turbines in a config
    PossibleTurbine(i,1) = i; % This matrix stores possible number of turbines in a config
end
PossibleTurbine(PossibleTurbine==0) = [];

for k = LB_SolarPanel:VaryPanel:UB_SolarPanel % % Starting an array for possible size of solar panels in a config
    PossibleSolarPanel(k,1) = k; % This creates an array, however, intermediate cells are zero (such as 1,2,etc.)
end
PossibleSolarPanel(PossibleSolarPanel==0) = []; % this line Removes zeros from the Possible Solar Panel Matrix

for i = LB_StorageCapacity:VaryStorage:UB_StorageCapacity % % Starting an array for possible size of storage capacity in a config
    PossibleStorage(i,1) = i; % This creates an array, however, intermediate cells are zero (such as 1,2,etc.)
end
PossibleStorage(PossibleStorage==0) = [];

%% Step 3 - Generate the Array of Alternative Configurations (DMUs)
DVs = { PossibleTurbine, PossibleSolarPanel, PossibleStorage }; % formulating the design space as a cell of vectors composed of design variable alternatives input data: cell array of vectors
n = numel(DVs); %// extract number of design variables
DMUs = cell(1,n); %// pre-define size of the array to generate comma-separated list
[DMUs{end:-1:1}] = ndgrid(DVs{end:-1:1}); % the reverse order in these two comma-separated lists is needed to produce the rows of the result matrix in
% lexicographical order 
DMUs = cat(n+1, DMUs{:}); %// concat the n n-dim arrays along dimension n+1
DMUs = reshape(DMUs,[],n); %// reshaped to obtain DMU specs. This is matrix includes all possible combinations given the limits
%// format of DMUs matrix = turbines, solarpanel area, storage space

%% Cost and Land Area Module
% This module computes the lifetime cost (including installation + land +
% operation and maintanance) and land area for performance calculation
DMU_LifeCost_x1 = zeros(length(DMUs),1);
Install_Cost = (2.3*1.5*10^6*DMUs(:,1)) + ((400/1.96)*DMUs(:,2))+ (250*DMUs(:,3)); %first term turbine cost, second panel cost, storage cost (250$/kwh)
OM_Cost =(0.03*Install_Cost)*((1-(1.07)^-25)/0.07); %PV of OM Costs
DMU_LandArea_x2 = (pi*6.5*40^2*DMUs(:,1))+ DMUs(:,2) + (1.075*DMUs(:,3)/210); %total land area
Land_Cost = DMU_LandArea_x2 * 7.4132; %multiplied by cost of land around Miami Homestead per m2
DMU_LifeCost_x1 = Install_Cost + OM_Cost + Land_Cost ;


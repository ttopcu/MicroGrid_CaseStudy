%% Energy Conversion Module 
% This module calculates the amount of energy produced by the DMU based on
% its characteristics and the weather profiles. Then it uses the demand and
% cost data to calculate how much energy is consumed, 
% This module is dependent on "MG_DesignSpaceGenerator.m", "Community_Demand.m", "DailyDist.m", and "Envo_Sim.m"

Sim_Duration = length(LifeWeather);
DMU_DollarBought = zeros(N_DMUs,1); 
DMU_EnergyBought = zeros(N_DMUs,1); 
DMU_DollarSold = zeros(N_DMUs,1); 
DMU_EnergySold = zeros(N_DMUs,1); 
DMU_SelfSustain = zeros(N_DMUs,1); 
for m=1:N_DMUs %this starts the loop for each DMU
    %% energy Production 
    N_Turbine = DMUs(m,1); % number of wind turbines
    A_Solar = DMUs(m,2); % solar panel area
    Storage_Size = DMUs(m,3); % storage size 
    Hourly_Wind_Power=zeros(Sim_Duration,1); % prealocate wind power matrix size of a single turbine for computation speed
    Hourly_Solar_Power =zeros(Sim_Duration,1); %prealocate solar power matrix size for computation speed
    % Nrel 1500 Large turbine ref power curve
    % Wind Energy Conversion Using NREL_1.5Kw Distributed Large Turbine
    % Reference Data and its curve fit
    %Logistic Function model
    %   -----------------------
    %   P = phi1/(1+exp((phi2-S)/phi3))
    %   where P -> Power and S -> Speed 

    %   phi 1 = 1510.491 
    %   phi 2 = 7.066426 
    %   phi 3 = 1.044499 
    %Metrics Weibull CDF Logistic Function
    % 1    RMSE  60.4434143        37.7675187
    % 2     MAE  21.2748854        24.3773857
    % 3    MAPE   3.9665873         9.3823989
    % 4      R2   0.9902229         0.9961828
    % 5     COR   0.9957271         0.9981723
    % Hourly_Power = 1510.491 /(1+exp((7.066426-LifeWeather(:,1)/1.044499)));
       
        for i=1:Sim_Duration % initiating the iteration for hourly wind power generation
%             Hourly_Wind_Power(i) = 1510.491/(1+exp((7.066426-LifeWeather(i,1)/1.044499))); % no
%             performancce degredation
            Hourly_Wind_Power(i) = (1510.491 /(1+exp((7.066426-LifeWeather(i,1)/1.044499))))*(1-i*(Turbine_DegradationRate/8760)); % This wind power matrix accounts for performance degradation of 1.5%/yr
        end
        
        Hourly_Wind_Power = Hourly_Wind_Power*N_Turbine; % Assuming Turbines don't interract
%        Test_Hourly_Wind_Power =  Test_Hourly_Wind_Power*N_Turbine;
        
        for i=1:Sim_Duration % initiating the iteration for hourly power generation
            %Hourly_Solar_Power(i) = A_Solar*LifeWeather(i,2)*Panel_Eff;
            %%assuming 2 axis tracking solar panel and no degredation
            Hourly_Solar_Power(i) = A_Solar*LifeWeather(i,2)*Panel_Eff*(1-i*(Panel_DegradationRate/8760));%assuming 2 axis tracking solar panel and including degredation
%            Hourly_Solar_Power(i) = A_Solar*LifeWeather(i,2)*Panel_Eff;            %assumin no loss
        end
   Hourly_DMU_Production = zeros(length(LifeWeather),1); % prelocating hourly DMU power matrix size
   Hourly_DMU_Production = Hourly_Wind_Power + Hourly_Solar_Power; %total power produced by the MG including performance degredation over time
%% energy balance - here we compare production to demand. We store the excess, sell the excess back to main grid and 
   Stored_Energy = zeros(Sim_Duration,1); % Initializing stored energy
   Energy_Purchased = zeros(Sim_Duration,1); % Initializing energy purchased from the grid
   Energy_Sold = zeros(Sim_Duration,1); % Initializing energy sold to the grid
   Dollar_Energy_Bought = zeros(Sim_Duration,1); % Initializing the cost of energy bought from to the grid
   Dollar_Energy_Sold = zeros(Sim_Duration,1); % Initializing the cost of energy bought from to the grid
   Self_Sustain_Hours = 0;
            for i=1:Sim_Duration %we will balance the energy for the lifeof the MG in this loop using production,consumption, and DMU characteristics
            % case1 - production exceeds demand yet we have empty storage space so
            % we store the excess
                if (Hourly_DMU_Production(i)>HourlyConsumption(i)) && (((Hourly_DMU_Production(i)-HourlyConsumption(i))*Charge_Eff)<=(Storage_Size-Stored_Energy(i)))
                Stored_Energy(i+1) = Stored_Energy(i)+ ((Hourly_DMU_Production(i)-HourlyConsumption(i))*Charge_Eff);
                Energy_Sold (i) = 0;
                Dollar_Energy_Sold(i) = Energy_Sold (i) * HourlyCost(i);%computes the monetary value of the energy sold based on hourly prize
                Energy_Purchased(i) = 0;
                Dollar_Energy_Bought(i) = Energy_Purchased(i) * HourlyCost(i);%;
                        Self_Sustain_Hours = Self_Sustain_Hours + 1;
            % case2 - production exceeds demand yet we don't have enough storage
            % space so we sell the excess energy
                elseif (Hourly_DMU_Production(i)>HourlyConsumption(i)) && (((Hourly_DMU_Production(i)-HourlyConsumption(i))*Charge_Eff)>(Storage_Size-Stored_Energy(i)))
                Stored_Energy(i+1) = Storage_Size;
                Energy_Sold (i) = (Hourly_DMU_Production(i)-HourlyConsumption(i)-((Storage_Size-Stored_Energy(i))/Charge_Eff));
                Dollar_Energy_Sold(i) = Energy_Sold (i) * HourlyCost(i);%computes the monetary value of the energy sold based on hourly prize
                Energy_Purchased(i) = 0;
                Dollar_Energy_Bought(i) = Energy_Purchased(i) * HourlyCost(i);%;
                Self_Sustain_Hours = Self_Sustain_Hours + 1;
            % case3 - demand exceeds production but we have enough energy in the storage so we use that instead of purchasing   
                elseif (HourlyConsumption(i)>Hourly_DMU_Production(i)) && ((Stored_Energy(i)*Discharge_Eff)>=((HourlyConsumption(i)-Hourly_DMU_Production(i))))   
                Stored_Energy(i+1) = ((Stored_Energy(i)*Discharge_Eff)-(HourlyConsumption(i)-Hourly_DMU_Production(i))); 
                Energy_Sold (i) = 0;
                Dollar_Energy_Sold(i) = Energy_Sold (i) * HourlyCost(i);%computes the monetary value of the energy sold based on hourly prize
                Energy_Purchased(i) = 0;
                Dollar_Energy_Bought(i) = Energy_Purchased(i) * HourlyCost(i);%;
                Self_Sustain_Hours = Self_Sustain_Hours + 1;
            % case4 - demand exceeds production and we don't have enough energy in
            % the storage so we purchase the exceed demand from the main grid.
                elseif ((HourlyConsumption(i)>Hourly_DMU_Production(i)) && (((HourlyConsumption(i)-Hourly_DMU_Production(i)))>(Stored_Energy(i)*Discharge_Eff)))   
                Energy_Purchased(i) = (HourlyConsumption(i)-Hourly_DMU_Production(i)-Stored_Energy(i)*Discharge_Eff);
                Stored_Energy(i+1)= 0;      
                Energy_Sold (i) = 0;
                Dollar_Energy_Sold(i) = Energy_Sold (i) * HourlyCost(i);%computes the monetary value of the energy sold based on hourly prize
                Dollar_Energy_Bought(i) = Energy_Purchased(i) * HourlyCost(i);%;
                end %this is the end of the loop for hourly power balance of the community            
            end %this is the end of the loop for the life time power balance of the community
% DMU_Input=horzcat(DMU_LifeCost_x1,DMU_LandArea_x2); %selecting the Input Variables for DEA
DMU_DollarBought(m,1) = sum(Dollar_Energy_Bought);
DMU_EnergyBought(m,1) = sum(Energy_Purchased);
DMU_DollarSold(m,1)= sum(Dollar_Energy_Sold);
DMU_EnergySold(m,1) = sum(Dollar_Energy_Sold);
DMU_SelfSustain(m,1) = Self_Sustain_Hours; %storing self sustainable hours
%DMU_Input(m,:)=horzcat(DMU_LifeCost_x1,DMU_LandArea_x2,sum(Dollar_Energy_Bought)); %selecting the Input Variables for DEA
DMU_Input(m,3)=(sum(Dollar_Energy_Bought)); 
DMU_Input(m,4)=(sum(Energy_Purchased));
DMU_Output(m,:) = horzcat(sum(Hourly_DMU_Production),Self_Sustain_Hours, sum(Dollar_Energy_Sold));%selecting the output variables
end
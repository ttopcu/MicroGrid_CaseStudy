DemandSim = xlsread('demandsim.csv'); %importing energy costs and consumption for 50k households for a 25 year lifetime; dataformat: year,month,cost/kwh,consumption of 50k households(kwh)
EnergyCost = DemandSim(:,3); %cents/kwh for that month
EnergyConsumption = DemandSim(:,[2 4]); %month and kwh for a month

%% Create Daily and hourly demand
% here we create a daily demand form the monthly consumption data and then
% divide it to hourly consumption. It is assumed that energy is consumed
% equally every day of the month, however, hourly changes in consumption
% patterns are captured based on data from:
% https://openei.org/datasets/dataset/commercial-and-residential-hourly-load-profiles-for-all-tmy3-locations-in-the-united-states
% This module is dependent on "Daily Dist.m","Envo_Sim.m", and
% "Demand.Sim.xlsx"
HourlyConsumption = zeros(length(LifeWeather),1); %prelocating matrix size for hourly system lifetime consumption
HourlyCost = zeros(length(LifeWeather),1); %
DailyConsumption = zeros(365*25,1);%prelocating matrix size for daily system lifetime consumption
DailyCost = zeros(365*25,1);
k=1; %inititalizing iterator for arranging number of days
s=1; %initializing iterrator for arranging hours

for i=1:length(EnergyConsumption)
HourlyEnergyConsumption=zeros(744,1);    
HourlyEnergyCost = zeros(744,1);    
    if  EnergyConsumption(i,1)== 1 % for the month of January
        days=31;
        p = 24*days;
        DailyEnergyConsumption =  EnergyConsumption(i,2)/days; 
        DailyEnergyCost = EnergyCost(i,1);
        for j=1:days %here we convert daily consumption to hourly consumption
            for l = 1:p
                if rem(l,24)==0
                HourlyEnergyConsumption(l)= DailyEnergyConsumption * Jan(24);
                HourlyEnergyCost(l) = DailyEnergyCost* Jan(24)*days;
                else
                HourlyEnergyConsumption(l)= DailyEnergyConsumption * Jan(rem(l,24)); 
                HourlyEnergyCost(l) = DailyEnergyCost * Jan(rem(l,24))*days; 
                end
            end  
        end
    end
    
    if  EnergyConsumption(i,1)== 2 % for the month of February
        days=28;
        p = 24*days;
        DailyEnergyConsumption =  EnergyConsumption(i,2)/days; 
        DailyEnergyCost = EnergyCost(i,1);
        for j=1:days %here we convert daily consumption to hourly consumption
            for l = 1:p
                if rem(l,24)==0
                HourlyEnergyConsumption(l)= DailyEnergyConsumption * Feb(24);
                HourlyEnergyCost(l) = DailyEnergyCost* Feb(24)*days;
                else
                HourlyEnergyConsumption(l)= DailyEnergyConsumption * Feb(rem(l,24));   
                HourlyEnergyCost(l) = DailyEnergyCost* Feb(rem(l,24))*days;   
                end
            end  
        end
    end
    
    if  EnergyConsumption(i,1)== 3 % for the month of March
        days=31;
        p = 24*days;
        DailyEnergyConsumption =  EnergyConsumption(i,2)/days; 
         DailyEnergyCost = EnergyCost(i,1);
        for j=1:days %here we convert daily consumption to hourly consumption
            for l = 1:p
                if rem(l,24)==0
                HourlyEnergyConsumption(l)= DailyEnergyConsumption * Mar(24);
                HourlyEnergyCost(l) = DailyEnergyCost * Mar(24)*days;
                else
                HourlyEnergyConsumption(l)= DailyEnergyConsumption * Mar(rem(l,24));    
                HourlyEnergyCost(l) = DailyEnergyCost * Mar(rem(l,24))*days;    
                end
            end  
        end
    end
    
    if  EnergyConsumption(i,1)== 4 % for the month of April
        days=30;
        p = 24*days;
        DailyEnergyConsumption =  EnergyConsumption(i,2)/days; 
         DailyEnergyCost = EnergyCost(i,1);
        for j=1:days %here we convert daily consumption to hourly consumption
            for l = 1:p
                if rem(l,24)==0
                HourlyEnergyConsumption(l)= DailyEnergyConsumption * Apr(24);
                HourlyEnergyCost(l) = DailyEnergyCost * Apr(24)*days;
                else
                HourlyEnergyConsumption(l)= DailyEnergyConsumption * Apr(rem(l,24));   
                HourlyEnergyCost(l) = DailyEnergyCost * Apr(rem(l,24))*days;   
                end
            end  
        end
    end
    
    if  EnergyConsumption(i,1)== 5 % for the month of May
        days=31;
        p = 24*days;
        DailyEnergyConsumption =  EnergyConsumption(i,2)/days; 
         DailyEnergyCost = EnergyCost(i,1);
        for j=1:days %here we convert daily consumption to hourly consumption
            for l = 1:p
                if rem(l,24)==0
                HourlyEnergyConsumption(l)= DailyEnergyConsumption * May(24);
                HourlyEnergyCost(l) = DailyEnergyCost * May(24)*days;
                else
                HourlyEnergyConsumption(l)= DailyEnergyConsumption * May(rem(l,24));    
                HourlyEnergyCost(l) = DailyEnergyCost * May(rem(l,24))*days;    
                end
            end  
        end
    end
    if  EnergyConsumption(i,1)== 6 % for the month of June
        days=30;
        p = 24*days;
        DailyEnergyConsumption =  EnergyConsumption(i,2)/days; 
        DailyEnergyCost = EnergyCost(i,1);
        for j=1:days %here we convert daily consumption to hourly consumption
            for l = 1:p
                if rem(l,24)==0
                HourlyEnergyConsumption(l)= DailyEnergyConsumption * Jun(24);
                HourlyEnergyCost(l) = DailyEnergyCost * Jun(24)*days;
                else
                HourlyEnergyConsumption(l)= DailyEnergyConsumption * Jun(rem(l,24));    
                HourlyEnergyCost(l) = DailyEnergyCost * Jun(rem(l,24))*days;    
                end
            end  
        end
    end
    
    if  EnergyConsumption(i,1)== 7 % for the month of July
        days=31;
        p = 24*days;
        DailyEnergyConsumption =  EnergyConsumption(i,2)/days; 
        DailyEnergyCost = EnergyCost(i,1);
        for j=1:days %here we convert daily consumption to hourly consumption
            for l = 1:p
                if rem(l,24)==0
                HourlyEnergyConsumption(l)= DailyEnergyConsumption * Jul(24);
                HourlyEnergyCost(l) = DailyEnergyCost * Jul(24)*days;
                else
                HourlyEnergyConsumption(l)= DailyEnergyConsumption * Jul(rem(l,24));
                HourlyEnergyCost(l) = DailyEnergyCost * Jul(rem(l,24))*days;
                end
            end  
        end
    end
    
    if  EnergyConsumption(i,1)== 8 % for the month of August
        days=31;
        p = 24*days;
        DailyEnergyConsumption =  EnergyConsumption(i,2)/days; 
        DailyEnergyCost = EnergyCost(i,1);
        for j=1:days %here we convert daily consumption to hourly consumption
            for l = 1:p
                if rem(l,24)==0
                HourlyEnergyConsumption(l)= DailyEnergyConsumption * Aug(24);
                HourlyEnergyCost(l) = DailyEnergyCost * Aug(24)*days;
                else
                HourlyEnergyConsumption(l)= DailyEnergyConsumption * Aug(rem(l,24));   
                HourlyEnergyCost(l) = DailyEnergyCost * Aug(rem(l,24))*days;
                end
            end  
        end
    end
    
    if  EnergyConsumption(i,1)== 9 % for the month of September
        days=30;
        p = 24*days;
        DailyEnergyConsumption =  EnergyConsumption(i,2)/days; 
        DailyEnergyCost = EnergyCost(i,1);
        for j=1:days %here we convert daily consumption to hourly consumption
            for l = 1:p
                if rem(l,24)==0
                HourlyEnergyConsumption(l)= DailyEnergyConsumption * Sep(24);
                HourlyEnergyCost(l) = DailyEnergyCost * Sep(24)*days;
                else
                HourlyEnergyConsumption(l)= DailyEnergyConsumption * Sep(rem(l,24));
                HourlyEnergyCost(l) = DailyEnergyCost * Sep(rem(l,24))*days;
                end
            end  
        end
    end
    if  EnergyConsumption(i,1)== 10 % for the month of October
        days=31;
        p = 24*days;
        DailyEnergyConsumption =  EnergyConsumption(i,2)/days; 
        DailyEnergyCost = EnergyCost(i,1);
        for j=1:days %here we convert daily consumption to hourly consumption
            for l = 1:p
                if rem(l,24)==0
                HourlyEnergyConsumption(l)= DailyEnergyConsumption * Oct(24);
                HourlyEnergyCost(l) = DailyEnergyCost * Oct(24)*days;
                else
                HourlyEnergyConsumption(l)= DailyEnergyConsumption * Oct(rem(l,24));    
                HourlyEnergyCost(l) = DailyEnergyCost * Oct(rem(l,24))*days;    
                end
            end  
        end
    end
    if  EnergyConsumption(i,1)== 11 % for the month of November
        days=30;
        p = 24*days;
        DailyEnergyConsumption =  EnergyConsumption(i,2)/days; 
        DailyEnergyCost = EnergyCost(i,1);
        for j=1:days %here we convert daily consumption to hourly consumption
            for l = 1:p
                if rem(l,24)==0
                HourlyEnergyConsumption(l)= DailyEnergyConsumption * Nov(24);
                HourlyEnergyCost(l) = DailyEnergyCost * Nov(24)*days;
                else
                HourlyEnergyConsumption(l)= DailyEnergyConsumption * Nov(rem(l,24));    
                HourlyEnergyCost(l) = DailyEnergyCost * Nov(rem(l,24))*days; 
                end
            end  
        end
    end
    if  EnergyConsumption(i,1)== 12 % for the month of December
        days=31;
        p = 24*days;
        DailyEnergyConsumption =  EnergyConsumption(i,2)/days; 
        DailyEnergyCost = EnergyCost(i,1);
        for j=1:days %here we convert daily consumption to hourly consumption
            for l = 1:p
                if rem(l,24)==0
                HourlyEnergyConsumption(l)= DailyEnergyConsumption * Dec(24);
                HourlyEnergyCost(l) = DailyEnergyCost * Dec(24)*days;
                else
                HourlyEnergyConsumption(l)= DailyEnergyConsumption * Dec(rem(l,24));
                HourlyEnergyCost(l) = DailyEnergyCost * Dec(rem(l,24))*days;
                end
            end  
        end
    end
    DailyConsumption(k:(k+days)) = DailyEnergyConsumption;
    DailyCost(k:(k+days)) = DailyEnergyCost;
    k=k+days;
    HourlyConsumption(s:(s+l-1)) = HourlyEnergyConsumption(HourlyEnergyConsumption~=0);
    HourlyCost(s:(s+l-1)) = HourlyEnergyCost(HourlyEnergyCost~=0);
    s = s+l; 
    
end
HourlyCost=HourlyCost/100; % converting to $/kWh from cents/kWh
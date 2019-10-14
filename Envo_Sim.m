%% This module constructs a weather simulation based on NREL Observations
% First Step - Import Observations around the desired area
% measurements are in the following format; Month, Day, Hour, GHI (W/m2),
% and Windspeed (m/s) 
% Observation sizes are 8760*1 (hourly for a year)
%% Random System Lifetime Generator for 25 years -- change as you see fit
RandomLifetimeID = zeros(219000,1); % size for 25 years in hours - format: first column id, second=wind, third=sun
LifeWeather = ones(1,2);
LifetimeWeather = zeros(262800,2); 
for i=1:219000
    RandomLifetimeID (i)=i;
end
for k =1:SimLifeYears %for a 25 year period, modify as you see fit
        for i=1:length(HourID) % creating this loop for every single hour during the year
        Wind(i)= abs(normrnd(HourID_wind_ave(i),HourID_wind_stddev(i))); % draw a wind value from normal dist
        Sun(i) = abs(normrnd(HourID_solar_ave(i),HourID_solar_stddev(i))); %draw a GHI value from normal dist
    %     if Sun(i)>1100
    %        Sun(i)=1100; 
    %     end
        end
    RandomYearWeather = horzcat(Wind,Sun);
    LifeWeather = [LifeWeather;RandomYearWeather]; %save random weathers for 25 year period
    k=k+1;
end
LifeWeather = LifeWeather(2:end,:); % 1 sample of random weather for a 25 year system lifespan, each row is an hour, 1st column is wind 2nd column sun GHI

%% Plots for paper 
%Hourly Wind and Solar Jan vs. July

% for i=1:24 %isolate the first day of Jan and capture it as a normal distribution
%     JanSolarHourlyDev(i,:)= [HourID_solar_ave(i),HourID_solar_stddev(i)];
%     JanWindHourlyDev(i,:) = [HourID_wind_ave(i),HourID_wind_stddev(i)];
% end
% 
% for i=4345:4368 %isolate the first day of Jul and capture it as a normal distribution
%     JulSolarHourlyDev(i-4344,:)= [HourID_solar_ave(i),HourID_solar_stddev(i)];
%     JulWindHourlyDev(i-4344,:) = [HourID_wind_ave(i),HourID_wind_stddev(i)];
% end
% 
% for k=1:24
%     for i=1:100 %create random instances for JanDay1
%         SolarJan(i,k) = normrnd(JanSolarHourlyDev(k,1),JanSolarHourlyDev(k,2));  
%         WspdJan(i,k) = normrnd(JanWindHourlyDev(k,1),JanWindHourlyDev(k,2));
%     end
% end
% 
% for k=1:24
%     for i=1:100 %create random years for JanDay1
%         SolarJul(i,k) = normrnd(JulSolarHourlyDev(k,1),JulSolarHourlyDev(k,2));  
%         WspdJul(i,k) = normrnd(JulWindHourlyDev(k,1),JulWindHourlyDev(k,2));
%     end
% end

% boxplot((SolarJul),'Notch','on','Colors','g','BoxStyle','filled');% box plot of Jul 1
% hold on; % keeping the plot area open
% plot(JanSolarHourlyDev(:,1),'c','LineStyle','- -','LineWidth',2);
% plot(JulSolarHourlyDev(:,1),'k','LineStyle','- -','LineWidth',2);
% boxplot((SolarJan),'Notch','on','Colors','b','BoxStyle','filled'); % box plot of Jan 1
% xlabel('Hour of the Day ','FontSize',16,'FontWeight','bold') % Labeling X axis
% ylabel('Global Horizantal Irradiance (GHI)  (W/m2)','FontSize',16,'FontWeight','bold') % Labeling Y axis
% set(gca,'fontsize',14) % Setting Axes tick mark size
% title('Hourly Simulated Solar Radiation (GHI) - January (Blue) vs. July (Green)','FontSize',18,'FontWeight','bold') % Add and format title
% legend('Average NREL GHI Measurement on January 1st','Average NREL GHI Measurement on July 1st') % adding legend to the plot
% ylim([0 1400]);
% xlim([5 21]);
% hold off
% 
% boxplot((WspdJul),'Notch','on','Colors','g','BoxStyle','filled');% box plot of Jul 1 - wind speed
% hold on; % keeping the plot area open
% plot(JanWindHourlyDev(:,1),'c','LineStyle','- -','LineWidth',1);
% plot(JulWindHourlyDev(:,1),'k','LineStyle','- -','LineWidth',1);
% boxplot((WspdJan),'Notch','on','Colors','b','BoxStyle','filled'); % box plot of Jan 1
% xlabel('Hour of the Day ','FontSize',20,'FontWeight','bold') % Labeling X axis
% ylabel('Wind Speed  (m/s)','FontSize',20,'FontWeight','bold') % Labeling Y axis
% set(gca,'fontsize',16) % Setting Axes tick mark size
% title('Hourly Simulated Wind Speed (m/s) - January (Blue) vs. July (Green)','FontSize',22,'FontWeight','bold') % Add and format title
% legend('Average NREL Wind Speed Measurement on January 1st','Average NREL Wind Speed Measurement on July 1st') % adding legend to the plot
% ylim([0 8]);
% hold off




%January Sample Plot - RandomYearSolarRadiation vs. Real
% sampleHourID = HourID(1:720);
% sampleSun = Sun(1:720);
% sampleHourID_solar_ave = HourID_solar_ave(1:720);
% plot(sampleHourID,sampleSun,'-.ok','MarkerFaceColor','y','LineWidth',1); % Simple plot of Randomly Simulated Solar Irradiance (GHI)(Hourly) vs. Hours in a year
% hold on; % keeping the plot area open
% plot(sampleHourID,sampleHourID_solar_ave ,'r','LineWidth',2); % Adding the Average sun to the simulated graph
% xlabel('Hour of the Month','FontSize',16,'FontWeight','bold') % Labeling X axis
% ylabel('Global Horizantal Irradiance (GHI)  (W/m2)','FontSize',16,'FontWeight','bold') % Labeling Y axis
% set(gca,'fontsize',14) % Setting Axes tick mark size
% title('Simulated Global Horizantal Irradiance vs. Actual Irradiance for the Month of January','FontSize',18,'FontWeight','bold') % Add and format title
% legend('Simulated GHI','Actual GHI') % adding legend to the plot
% hold off

%January Sample Plot - RandomYearWind vs. Real
% sampleWind = Wind(1:720);
% sampleHourID_wind_ave = HourID_wind_ave(1:720);
% plot(sampleHourID,sampleWind,'-.ok','MarkerFaceColor','b','LineWidth',1); % Simple plot of Randomly Simulated Wind (Hourly) vs. Hours in a year
% hold on; % keeping the plot area open
% plot(sampleHourID,sampleHourID_wind_ave,'r','LineWidth',2); % Adding the Average actual Wind to the simulated graph
% xlabel('Hour of the Month','FontSize',16,'FontWeight','bold') % Labeling X axis
% ylabel('Wind Speed (m/s)','FontSize',16,'FontWeight','bold') % Labeling Y axis
% set(gca,'fontsize',14) % Setting Axes tick mark size
% title('Simulated Wind Speed vs. Actual Windspeed for the Month of January','FontSize',18,'FontWeight','bold') % Add and format title
% legend('Simulated Wind Speed','Actual Wind Speed') % adding legend to the plot
% hold off


% 1 year sample wind plot - RandomYearWeather vs. Real
% plot(HourID,Wind,'-.ok','MarkerFaceColor','b','LineWidth',1); % Simple plot of Randomly Simulated Wind (Hourly) vs. Hours in a year
% hold on; % keeping the plot area open
% plot(HourID,HourID_wind_ave,'r','LineWidth',2); % Adding the Average actual Wind to the simulated graph
% xlabel('Hour of the Year','FontSize',16,'FontWeight','bold') % Labeling X axis
% ylabel('Wind Speed (m/s)','FontSize',16,'FontWeight','bold') % Labeling Y axis
% set(gca,'fontsize',14) % Setting Axes tick mark size
% title('Simulated Wind Speed vs. Actual Windspeed','FontSize',18,'FontWeight','bold') % Add and format title
% legend('Simulated Wind Speed','Actual Wind Speed') % adding legend to the plot
% hold off

% 1 year Sample Plot - RandomYearSolarRadiation vs. Real
% plot(HourID,Sun,'-.ok','MarkerFaceColor','y','LineWidth',1); % Simple plot of Randomly Simulated Solar Irradiance (GHI)(Hourly) vs. Hours in a year
% hold on; % keeping the plot area open
% plot(HourID,HourID_solar_ave,'r','LineWidth',2); % Adding the Average sun to the simulated graph
% xlabel('Hour of the Year','FontSize',16,'FontWeight','bold') % Labeling X axis
% ylabel('Global Horizantal Irradiance (GHI)  (W/m2)','FontSize',16,'FontWeight','bold') % Labeling Y axis
% set(gca,'fontsize',14) % Setting Axes tick mark size
% title('Simulated Global Horizantal Irradiance vs. Actual Irradiance','FontSize',18,'FontWeight','bold') % Add and format title
% legend('Simulated GHI','Actual GHI') % adding legend to the plot
% hold off

% monthly samples August vs. January 
% Month_ID = HourID(1:744);
% Sun_Jan = Sun(1:744);
% Wind_Jan = Wind(1:744);
% Sun_Aug = Sun(4345:5088);
% Wind_Aug = Wind(4345:5088);
% plot(Month_ID,Sun_Jan,'-.ok','MarkerFaceColor','b','LineWidth',1); % Simple plot of Randomly Simulated Solar Irradiance (GHI)(Hourly) vs. Hours in a year
% hold on;
% plot(Month_ID,Sun_Aug,'-.ok','MarkerFaceColor','r','LineWidth',1); % 
% xlabel('Hour of the Month','FontSize',16,'FontWeight','bold') % Labeling X axis
% ylabel('Global Horizantal Irradiance (GHI)  (W/m2)','FontSize',16,'FontWeight','bold') % Labeling Y axis
% legend('Month of January','Month of August') % adding legend to the plot
% hold off
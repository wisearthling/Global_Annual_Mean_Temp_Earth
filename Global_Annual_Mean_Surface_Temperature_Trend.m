clear all
% Reading data from the link
file = 'http://strega.ldeo.columbia.edu:81/CMIP5/.byScenario/.historical/.atmos/.mon/.tas/.CCSM4/.r1i1p1/dods';
lon = ncread(file,'lon');
lat = ncread(file,'lat');
tas = ncread(file,'tas');
ncdisp(file)
% tas has a size of 288-by-192-by-1872, that is longitude-by-latitude-by-month
% Now calculating annual mean and area mean
% tas is from Jan-1850 to Dec-2005, so 156 years, 12 months per year
% We reshape the size of tas so that it has 4 dimensions, which are longitude-by-latitude-by-12-by-year
tas = reshape(tas,[length(lon) length(lat) 12 156]);
% Averaging the data over 12 months
tas = squeeze(mean(tas,3));
% Calculating area average below
% Step 01: an average over all longitudinal points so that tas now has a size of latitude-by-year
tas = squeeze(mean(tas,1));
% Step 02: Calculating the weighted mean by calculating weighted mean by Cos(lat)
for year = 1:156
tas_mean(year) = sum(squeeze(tas(:,year)).*cosd(lat))/sum(cosd(lat));
% Step 03: converting the temperature from Kelvin to Celsius
tas_mean(year) = tas_mean(year) - 273;
end

% Finally, plotting the global annual mean surface temperature against time
x = 1:1:156;
y = tas_mean(x);
plot(1850:2005,y)
xlabel('Years');
ylabel('Temperature (in Celsius)');
title('Global Annual Mean Surface Air Temperature');
legend('Temp','location','northwest');
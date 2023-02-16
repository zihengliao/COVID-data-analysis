
% Name : Ziheng Liao
% Date Modified : 10/05/2022

clc, clear all, close all;

%% filtering out countries that don't have data across a whole year


covid = importdata('owid-covid-data_2020-21.csv');
covid_data = covid.data; %covid numeric data
country_data = string(covid.textdata); % the countries 
country_data = country_data(2:end,:);


covid_deaths = covid_data(:,3);
death_index = isnan(covid_deaths); % seeing for which places have NaN and giving the Nan a value of 1
covid_deaths(death_index) = 0; %converts all the NaN deaths into 0
covid_data(:,3) = covid_deaths;

covid_cases = covid_data(:,2);
cases_index = isnan(covid_cases); % seeing for which places have NaN and giving the Nan a value of 1
covid_cases(cases_index) = 0;
covid_data(:,2) = covid_cases;

country_with_396 = string([]); % countries that have 396 entries
country_no_396 = string([]); % countries without 396 entries
data_sorting = string([]); % sorting the data to see which list it should go
% country_dates = country_data(:,4);

% finding the country that does not have 396 days of data
for i = 1:length(covid_deaths)-1;
    if country_data(i,3) == country_data(i+1,3);
        data_sorting(1,end+1) = country_data(i,3); % for the name of the country 
%         data_sorting(2,end) = country_data(i,4); % for the dates of the country
    else
        if length(data_sorting) == 395
            country_with_396(end+1) = data_sorting(1,1);
            clear data_sorting;
            data_sorting = string([]);
        else
            country_no_396(end+1) = data_sorting(1,1);

            clear data_sorting;
            data_sorting = string([]);
        end

    end
    
end



start_dates = [];
end_dates = [];
date_common = '01/08/2020'; % all starting dates start at this time

% indexing for the dates of the country that do not have 396 days 
% aka countries in country_no_396
fprintf('The countries that didn''t track their data for a year: \n\n')
for i = 1:length(country_no_396)
    logic = country_no_396(i) == country_data(:,3); % obtaining the logical for the country that we want in the list of countries
    country_dates = country_data(logic, 4); % this correctly identifies the dates
    desired_country_date_start = country_dates(1);
    desired_country_date_end = country_dates(end);
    name_of_country = country_no_396(i);
    number_of_records = length(country_dates); %the number of 

    fprintf('%25s%15s%15s%10.f\n', name_of_country, desired_country_date_start, desired_country_date_end, number_of_records)
    
%     datetime_storage(end+1) = datetime(desired_country_date_start);
    start_dates(end+1) = double(days(datetime(desired_country_date_start,'InputFormat','dd/MM/yy') - datetime(date_common,'InputFormat','dd/MM/yy') + 1));
    end_dates(end+1) = double(days(datetime(desired_country_date_end,'InputFormat','dd/MM/yy') - datetime(date_common,'InputFormat','dd/MM/yy')+1));
    days_appended = start_dates(end):end_dates(end);
    covid_data(logic, 1) = days_appended;
end

index = country_data(:,3) == 'Palau';
palau_dates = covid_data(index,1);



%Print results
fprintf('The day of the Palau starts recording to end day is %.f - %.f\n\n\n', palau_dates(1), palau_dates(end))



%% graphing the trends for cases and deaths across continents

continents = unique(country_data(:,2));

% indexes the continent we want with the correct date
i_asia = country_data(:,2) == continents(2); 
i_africa = country_data(:,2) == continents(1); 
i_europe = country_data(:,2) == continents(3); 
i_oceania = country_data(:,2) == continents(5); 
i_northamerica = country_data(:,2) == continents(4); 
i_southamerica = country_data(:,2) == continents(6); 

% indexing for days, cases and deaths for each continent
asia = covid_data(i_asia,:);
africa = covid_data(i_africa,:);
europe = covid_data(i_europe,:);
oceania = covid_data(i_oceania,:);
northamerica = covid_data(i_northamerica,:);
southamerica = covid_data(i_southamerica,:);

country_cases = [];
country_deaths = [];

days = 1:396; 
for i = 1:396; 

    date_asia = asia(:,1) == i; % grabbing the cases
    date_africa = africa(:,1) == i;
    date_europe = europe(:,1) == i;
    date_oceania = oceania(:,1) == i;
    date_northamerica = northamerica(:,1) == i;
    date_southamerica = southamerica(:,1) == i;


    country_cases(1,end+1) = sum(asia(date_asia,2)); %summing up the cases on that day and appending it to a different matrix
    country_cases(2,end) = sum(africa(date_africa,2));
    country_cases(3,end) = sum(europe(date_europe,2));
    country_cases(4,end) = sum(oceania(date_oceania,2));
    country_cases(5,end) = sum(northamerica(date_northamerica,2));
    country_cases(6,end) = sum(southamerica(date_southamerica,2));

    country_deaths(1,end+1) = sum(asia(date_asia,3)); % summing up the deaths for asian countries on that day and appending it to a separate matrix
    country_deaths(2,end) = sum(africa(date_africa,3));
    country_deaths(3,end) = sum(europe(date_europe,3));
    country_deaths(4,end) = sum(oceania(date_oceania,3));
    country_deaths(5,end) = sum(northamerica(date_northamerica,3));
    country_deaths(6,end) = sum(southamerica(date_southamerica,3));

end   

case_asia = country_cases(1,:); % array for asian cases for each day. should be a 1x396 matrix
case_africa = country_cases(2,:);
case_europe = country_cases(3,:);
case_oceania = country_cases(4,:);
case_northamerica = country_cases(5,:);
case_southamerica = country_cases(6,:);

death_asia = country_deaths(1,:); %same thing done to deaths with cases
death_africa = country_deaths(2,:);
death_europe = country_deaths(3,:);
death_oceania = country_deaths(4,:);
death_northamerica = country_deaths(5,:);
death_southamerica = country_deaths(6,:);




% %Print results

figure(1)
subplot(1,2,1)

semilogy(days, case_asia)
hold on
semilogy(days, case_africa)
hold on
semilogy(days, case_europe)
hold on
semilogy(days, case_oceania)
hold on
semilogy(days, case_northamerica)
hold on
semilogy(days, case_southamerica)
legend('asia','africa','europe','oceania','north america', 'south america', location = 'southoutside')
title('total cases vs days')
xlabel('days')
ylabel('total cases')
grid on


subplot(1,2,2)

semilogy(days, death_asia)
hold on
semilogy(days, death_africa)
hold on
semilogy(days, death_europe)
hold on
semilogy(days, death_oceania)
hold on
semilogy(days, death_northamerica)
hold on
semilogy(days, death_southamerica)
legend('asia','africa','europe','oceania','north america', 'south america', location = 'southoutside')
title('total deaths vs days')
xlabel('days')
ylabel('total deaths')
grid on


%% displaying cases and deaths against population across continents

world_map = imread('world_map.bmp');
population_data = importdata('Population_data.xlsx');
population_num = population_data.data; % these numbers are in millions
population_countries = population_data.textdata(2:end,:); % the name of the countries


continent_and_cases = string([]); 
population = [];

for i = 1:length(population_countries)
    continent_index = country_data(:,3) == population_countries(i,2); %indexing for countries with the same name
    country_casess = covid_data(continent_index,2); % with the country index, grabbing the cases recorded by that country
    country_case = country_casess(end); % grabbing the last case for that country 
    % same thing done to deaths
    country_deathss = covid_data(continent_index,3);
    country_deaths = country_deathss(end);

    continentz = country_data(continent_index,2);
    continent = continentz(1); % identifies which continent it is

    % continent and cases will contain the following information
    % name of the continent, the cases and the deaths 
    continent_and_cases(i,1) = continent; 
    continent_and_cases(i,2) = country_case;
    continent_and_cases(i,3) = country_deaths;

    % finding the population of each country and appending it to a column
    % to identify how many people in the continent by summing up the column
    if continent == continents(1); %africa
        population(end+1,1) = population_num(i);

    elseif continent == continents(2); %asia
        population(end+1,2) = population_num(i);

    elseif continent == continents(3); %europe
        population(end+1,3) = population_num(i);

    elseif continent == continents(4); %north america
        population(end+1,4) = population_num(i);

    elseif continent == continents(5); %oceania
        population(end+1,5) = population_num(i);

    else continent == continents(6); % south america
        population(end+1,6) = population_num(i);
    end
end
% this is to workout which cases belong to which continent 
index_africa = continent_and_cases(:,1) == continents(1);
index_asia = continent_and_cases(:,1) == continents(2);
index_europe = continent_and_cases(:,1) == continents(3);
index_oceania = continent_and_cases(:,1) == continents(5);
index_northamerica = continent_and_cases(:,1) == continents(4);
index_southamerica = continent_and_cases(:,1) == continents(6);

% divided by 10^6 to get to cases in the millions
total_cases_africa = sum(double(continent_and_cases(index_africa,2)))/(10^6);
total_cases_asia = sum(double(continent_and_cases(index_asia,2)))/(10^6);
total_cases_europe = sum(double(continent_and_cases(index_europe,2)))/(10^6);
total_cases_oceania = sum(double(continent_and_cases(index_oceania,2)))/(10^6);
total_cases_northamerica = sum(double(continent_and_cases(index_northamerica,2)))/(10^6);
total_cases_southamerica = sum(double(continent_and_cases(index_southamerica,2)))/(10^6);


%deaths
total_deaths_africa = sum(double(continent_and_cases(index_africa,3)))/(10^6);
total_deaths_asia = sum(double(continent_and_cases(index_asia,3)))/(10^6);
total_deaths_europe = sum(double(continent_and_cases(index_europe,3)))/(10^6);
total_deaths_oceania = sum(double(continent_and_cases(index_oceania,3)))/(10^6);
total_deaths_northamerica = sum(double(continent_and_cases(index_northamerica,3)))/(10^6);
total_deaths_southamerica = sum(double(continent_and_cases(index_southamerica,3)))/(10^6);


% these numbers are in millions
population_africa = sum(population(:,1));
population_asia = sum(population(:,2));
population_europe = sum(population(:,3));
population_northamerica = sum(population(:,4));
population_oceania = sum(population(:,5));
population_southamerica = sum(population(:,6));

%indexing which part of the matrix belongs to which part of the continent 
index_africa_plot = world_map == 1;
index_asia_plot = world_map == 2;
index_europe_plot = world_map == 3;
index_southamerica_plot = world_map == 4;
index_northamerica_plot = world_map == 5;
index_oceania_plot = world_map == 6;

% the case/population fraction to determine whic continent has the highest
africa_ratio = total_cases_africa / population_africa;
asia_ratio = total_cases_asia / population_asia;
europe_ratio = total_cases_europe / population_europe;
northamerica_ratio = total_cases_northamerica / population_northamerica;
oceania_ratio = total_cases_oceania / population_oceania;
southamerica_ratio = total_cases_southamerica / population_southamerica;

ratio_africa_deaths = total_deaths_africa/population_africa;
ratio_asia_deaths = total_deaths_asia/population_asia;
ratio_europe_deaths = total_deaths_europe/population_europe;
ratio_northamerica_deaths = total_deaths_northamerica/population_northamerica;
ratio_oceania_deaths = total_deaths_oceania/population_oceania;
ratio_southamerica_deaths = total_deaths_southamerica/population_southamerica;



continent_names = ["South America", "Oceania", "North America", "Europe", "Asia", "Africa"];
all_country_ratio = [southamerica_ratio, oceania_ratio, northamerica_ratio, europe_ratio, asia_ratio, africa_ratio];
country_ratio_deaths = [ratio_southamerica_deaths, ratio_oceania_deaths, ratio_northamerica_deaths, ratio_europe_deaths, ratio_asia_deaths, ratio_africa_deaths];


pixel_max = max(all_country_ratio);
pixel_death_max = max(country_ratio_deaths);
pixels = string([]);

% determining which continent has the biggest cases per million so i know
% where to assign 255 to 
for i = 1:length(continent_names);
    if pixel_max == all_country_ratio(i);
        pixels(1, 1) = all_country_ratio(i);
        pixels(1, end+1) = 255;
        pixels(1, end+1) = continent_names(i);
        break
    end

end
%deaths
for i_death = 1:length(continent_names);
    if pixel_death_max == country_ratio_deaths(i);
        pixels(1, end+1) = country_ratio_deaths(i);
        pixels(1, end+1) = 255;
        pixels(1, end+1) = continent_names(i);
        break
    end
end
%deaths
for index_d = 1:length(continent_names);
    if index_d == i_death;
        continue
    else
        pixels(end+1,5) = string(country_ratio_deaths(index_d)/pixel_death_max*255); % determining what pixel colour to give it
        pixels(end,6) = continent_names(index_d); % continent name
        pixels(end, 4) = country_ratio_deaths(index_d); % the deaths to population ratio
    end
end

%cases
for index = 1:length(continent_names);
    if index == i;
        continue
    else
        pixels(index,2) = string(all_country_ratio(index)/pixel_max*255);
        pixels(index,3) = continent_names(index);
        pixels(index, 1) = all_country_ratio(index);
    end
end

% new world map is for the deaths map
new_world_map = world_map;

% appending cases to world_map so when i plot the map isnt completely black
for i = 1: length(pixels);
    if pixels(i,3) == "South America"
        world_map(index_southamerica_plot) = double(pixels(i,2));
    elseif pixels(i,3) == "Oceania"
        world_map(index_oceania_plot) = double(pixels(i,2));
    elseif pixels(i,3) == "North America"
        world_map(index_northamerica_plot) = double(pixels(i,2));
    elseif pixels(i,3) == "Europe"
        world_map(index_europe_plot) = double(pixels(i,2));
    elseif pixels(i,3) == "Asia"
        world_map(index_asia_plot) = double(pixels(i,2));
    else pixels(i,3) == "Africa";
        world_map(index_africa_plot) = double(pixels(i,2));
    end
end


for i = 1: length(pixels)
    if pixels(i,6) == "South America";
        new_world_map(index_southamerica_plot) = double(pixels(i,5));
    elseif pixels(i,6) == "Oceania";
        new_world_map(index_oceania_plot) = double(pixels(i,5));
    elseif pixels(i,6) == "North America";
        new_world_map(index_northamerica_plot) = double(pixels(i,5));
    elseif pixels(i,6) == "Europe";
        new_world_map(index_europe_plot) = double(pixels(i,5));
    elseif pixels(i,6) == "Asia";
        new_world_map(index_asia_plot) = double(pixels(i,5));
    else pixels(i,6) == "Africa";
        new_world_map(index_africa_plot) = double(pixels(i,5));
    end
end




%Print results
fprintf('The brightness of each continent(the higher the pixel number, the brighter the continent is):\n')
fprintf('       Continent(cases)            Pixel Number(cases)\n')
for elem = 1:length(pixels)
    fprintf('%20s %25.f\n',pixels(elem,3), double(pixels(elem,2)))
end

fprintf('       Continent(deaths)            Pixel Number(deaths)\n')
for elem = 1:length(pixels)
    fprintf('%20s %25.f\n',pixels(elem,6), double(pixels(elem,5)))
end



figure(2)

subplot(2,1,1)
imshow(world_map);
title('cases per million (lighter colour = higher cases per million)')

subplot(2,1,2)
imshow(new_world_map);
title('deaths per million (lighter colour = higher cases per million)')


function [ pow_out ] = calc_wind( wind_spd )
%calc_wind Calculates the power output of Enercon E-126 wind turbine
%   Data at http://www.enercon.de/p/downloads/ENERCON_PU_en.pdf

%Floors input so wind_spd will be an integer
wind_spd = floor(wind_spd);
%if-elseif-else statements to categorize power output
if(wind_spd <= 2)
    pow_out = 0;
elseif(wind_spd == 3)
    pow_out = 55;
elseif(wind_spd == 4)
    pow_out = 175;
elseif(wind_spd == 5)
    pow_out = 410;
elseif(wind_spd == 6)
    pow_out = 760;
elseif(wind_spd == 7)
    pow_out = 1250;
elseif(wind_spd == 8)
    pow_out = 1900;
elseif(wind_spd == 9)
    pow_out = 2700;
elseif(wind_spd == 10)
    pow_out = 3750;
elseif(wind_spd == 11)
    pow_out = 4850;
elseif(wind_spd == 12)
    pow_out = 5750;
elseif(wind_spd == 13)
    pow_out = 6500;
elseif(wind_spd == 14)
    pow_out = 7000;
elseif(wind_spd == 15)
    pow_out = 7350;
elseif(wind_spd == 16)
    pow_out = 7500;
else
    pow_out = 7580;
end

|=================================|
| Project 2 : Team 3.14 (Team Pi) |
|                                 |
|    Chung Yin Leung              |   
|    Erik Xu                      |
|	 Nathan Wong              |
|=================================|

===========================================================================
|-------------|
|Instructions:|
|-------------|

Part 1:

- Open MATLAB

- Run 'run_proj2.m'by typing in run_proj2 in the Command Line

- There will be the option to 'Load Database' to pick a database to use. The
default database is already weather.mat. But you may test the button by loading
weather.mat again.

- Once a database loads, the city list on the right will be updated to reflect
the database. Choose a city from the list.

- Use the slider on the top right to determine the percentage of area to allocate
to either solar energy or wind energy. Alternatively, you may manually input the
percentages. After you done so, remember to press the 'Set' button.

- Now at the bottom right of the GUI, select the month in which you want the
simulation to take place in. 

- Below the month selection, there will be data that displays the number of EVs
supported from the choices you made in city, month, and land area distribution. 

- When you are ready, click 'Initialize Simulation.' 

Note: If you exit the input GUI, the whole program will close.

Part 2: 

- A second GUI will show up. 

- The left graph shows the power needed by electric vehicles with respect to time.
The right graph shows the solar/wind farm size with respect to time

- There are controls that allow you to add more or take away electric vehicles and
Energy Consumers. These buttons are '+' and '-', respectively.

- You may also control the speed of the simulation in the panel with the 'Period'
text. The number next to it shows how frequently the GUI will simulate the next
hour. If the 'Period' is 1, the GUI will simulate the next hour every second.
The minimum value or fastest it would go is 0.125 seconds or 125 milliseconds.

- When you are ready press the 'Start' to begin the simulation. This button
changes into a 'Pause'/'Resume' button for the simulation. All of the controls
should work while the simulation is running so that you do no have to pause
the simulation to change the values.

-When you are satisfied with the simulation, press 'End' to close the GUI or
click the generic Windows' Close button on the top right corner.

-You will be able to start a new simulation from the input GUI with another
set of settings.

===========================================================================
|----------|
|File-list:|
|----------|
weather.mat - Database where values for wind and solar insulation are taken based 
    on the city and month

run_proj2.m - Simple script to launch GUI; Same as launching GUI through gui_input.m

gui_input.fig - Figure for the gui_input.m

gui_input.m - File that contains all the code for the input GUI to function

gui_output.fig - Figure for the gui_output.m

gui_output.m - File that contains all the code for the output GUI to function

EV.m - This is a class file for the EV object. It is an acronym for electric vehicles.

Energyconsumers.m - This is a class file for the Energyconsumer object. 

SolarPlant.m - A class that defines a SolarPlant object. It corresponds to a solar farm
    in real life or a collection of solar panels. It uses SunPower 425-watt solar panels.
    The solar panels' specifications are here:
     http://us.sunpowercorp.com/cs/Satellite?blobcol=urldata&blobheadername1=Content-Type
     &blobheadername2=Content-Disposition&blobheadervalue1=application%2Fpdf
     &blobheadervalue2=inline%3B+filename%3Dsp_425Ewh_en_ltr_ds_p_shortercable.pdf
     &blobkey=id&blobtable=MungoBlobs&blobwhere=1300276455310&ssbinary=true
    
WindPlant.m - A class that defines a WindPlant object. It corresponds to a wind farm
    in real life or a collection of wind turbines. It uses Enercon E-126 wind
    turbines.
    The wind turbines' specifications are here: 
        http://www.enercon.de/p/downloads/ENERCON_PU_en.pdf

calc_wind.m - It is a function used to calculate the power generated according
    to a given wind speed that is passed to this function. It is merely a sorter
    function to save space in other code.
    Data is from  http://www.enercon.de/p/downloads/ENERCON_PU_en.pdf

===========================================================================
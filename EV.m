classdef EV < handle
    properties 
        con; 
    end
    methods %these are the functions
        function obj = EV(arrayofconsumers) %constructor , make a single vechicle 
            if(nargin==1)
                obj.con = arrayofconsumers;
            else
                obj.con = Energyconsumers; 
            end
        end
        
        function move(obj) %arguement is an array of consumer objects 
            len = length(obj.con); %find how many consumers there are 
            j = randperm(len); %create a vector that is as long as the length, but randomize it without repitition
            for i = 1:len %loop through consumer objects
                num = obj.con(j(i)).checkFull(); %call the consumer function checkFull
                if num == 0; %if that consumer is empty then add one to it 
                    obj.con(j(i)).num_cars = obj.con(j(i)).num_cars + 1; 
                    return;
                end
            end
            
        end
    end
end

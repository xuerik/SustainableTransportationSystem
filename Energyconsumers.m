classdef Energyconsumers < handle
    %Energyconsumers Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        consumer_type; % Which energy consumer
        num_cars = 0; % Number of cars in the energy consumer location
        total_space; % The total EV spaces available at a energy consumer location
        evs_chrg = 0; % The number of EVs charging
    end
    
    properties(Constant)
        type = [1, 2, 3]; % 1 - Parking lot, 2 - Shopping Mall, 3 - Apartment
        ev_chrg = [300, 400, 150, 50, 25; 200, 600, 700, 600, 50; 40, 20, 120, 140, 180]; % Number of EVs charging at certain times of the day with respect to location(row) and time(column)

    end
    
    methods
        function obj = Energyconsumers(type)
            spaces = [500, 1000, 200]; % Total spaces of each energy consumer
            if(nargin == 1)
                obj.consumer_type = type;
                obj.total_space = spaces(type);
                
            else
            consumer = randi(3); % The number of spaces for the energy consumer 1) Parking Lot (500), 2) Shopping Mall (1000), 3) Apartment Building (200)
            obj.consumer_type = consumer;
            obj.total_space = spaces(consumer);
            end
        end

        
        function empty_space = checkFull(obj) % function called by EV to check if all the EV spaces are completely filled
            if(obj.num_cars == obj.total_space)
                empty_space = 1; % full
                
            else
                empty_space = 0; % not full
                
            end  
        end
        
        
        function obj = changeEV(obj, time) % function to change the total EV charging spaces depending on the time of the day
            for i = 1:length(obj)
            if(time >= 6 && time < 11)
                if(obj(i).consumer_type == 1)
                    obj(i).evs_chrg = obj(i).num_cars * obj(i).ev_chrg(1, 1);
                    
                elseif(obj(i).consumer_type == 2)
                    obj(i).evs_chrg = obj(i).num_cars * obj(i).ev_chrg(2, 1);
                    
                else
                    obj(i).evs_chrg = obj(i).num_cars * obj(i).ev_chrg(3, 1);
                end
                
            elseif(time >= 11 && time < 15)
                if(obj(i).consumer_type == 1)
                    obj(i).evs_chrg = obj(i).num_cars * obj(i).ev_chrg(1, 2);
                    
                elseif(obj(i).consumer_type == 2)
                    obj(i).evs_chrg = obj(i).num_cars * obj(i).ev_chrg(2, 2);
                    
                else
                    obj(i).evs_chrg = obj(i).num_cars * obj(i).ev_chrg(3, 2);
                end
                
            elseif(time >= 15 && time < 19)
                if(obj(i).consumer_type == 1)
                    obj(i).evs_chrg = obj(i).num_cars * obj(i).ev_chrg(1, 3);
                    
                elseif(obj(i).consumer_type == 2)
                    obj(i).evs_chrg = obj(i).num_cars * obj(i).ev_chrg(2, 3);
                    
                else
                    obj(i).evs_chrg = obj(i).num_cars * obj(i).ev_chrg(3, 3);
                end
                
            elseif(time >= 19 && time < 24)
                if(obj(i).consumer_type == 1)
                    obj(i).evs_chrg = obj(i).num_cars * obj(i).ev_chrg(1, 4);
                    
                elseif(obj(i).consumer_type == 2)
                    obj(i).evs_chrg = obj(i).num_cars * obj(i).ev_chrg(2, 4);
                    
                else
                    obj(i).evs_chrg = obj(i).num_cars * obj(i).ev_chrg(3, 4);
                end
                
            elseif(time >= 0 && time < 6)
                if(obj(i).consumer_type == 1)
                    obj(i).evs_chrg = obj(i).num_cars * obj(i).ev_chrg(1, 5);
                    
                elseif(obj(i).consumer_type == 2)
                    obj(i).evs_chrg = obj(i).num_cars * obj(i).ev_chrg(2, 5);
                    
                else
                    obj(i).evs_chrg = obj(i).num_cars * obj(i).ev_chrg(3, 5);
                end
            end
            end
        end

    end
end
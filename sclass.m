classdef sclass
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here

    properties
        x
    end

    methods
        function obj = sclass(x)
            %UNTITLED Construct an instance of this class
            %   Detailed explanation goes here
            obj.x = x;
        end

        function result = plus(obj, second_obj)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            result = sclass(obj.x + second_obj.x);
        end
    end
end
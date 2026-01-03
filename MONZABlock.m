classdef MONZABlock < matlab.System
    % untitled Add summary here
    %
    % NOTE: When renaming the class name untitled, the file name
    % and constructor name must be updated to use the class name.
    %
    % This template includes most, but not all, possible properties,
    % attributes, and methods that you can implement for a System object.

    % Public, tunable properties
    properties
        Ts double = 0.033
        disk_mass double = 0.1
        friction_coef double = 0
    end

    % Public, non-tunable properties
    properties (Nontunable)

    end

    % Discrete state properties
    properties (DiscreteState)
        disk_x
        disk_y
        disk_vx
        disk_vy
        disk_ax
        disk_ay
        disk_state %0 roll, 1 fall, 2 win, 3 lost
        current_piso
    end

    % Pre-computed constants or internal states
    properties (Access = private)

    end

    methods
        % Constructor
        function obj = MONZABlock(varargin)
            % Support name-value pair arguments when constructing object
            setProperties(obj,nargin,varargin{:})
        end

        function [xo,yo] = rotate(~,giro,x,y)
            xo=x*cos(giro)-y*sin(giro);
            yo=x*sin(giro)+y*cos(giro);
        end
    end

    methods (Access = protected)
        %% Common functions
        function setupImpl(obj)
            % Perform one-time calculations, such as computing constants
        end

        function [poseInercial, poseReferencial, velocidadRef] = stepImpl(obj,u,dificultad)
            % Implement algorithm. Calculate y as a function of input u and
            % internal or discrete states.
            g = 9.81;
            coder.extrinsic('gcs');
            coder.extrinsic('set_param');

            old_disk_x = obj.disk_x;
            old_disk_y = obj.disk_y;
            old_poseReferencial = obj.rotate(u, old_disk_x, old_disk_y);
            % Update disk dynamics
            switch obj.disk_state
            case 0 %rolling on parabola
                trackNormalAngle = obj.getTangentToParabola(u);
                a_tangent = g*(sin(trackNormalAngle)-cos(trackNormalAngle)*obj.friction_coef);
                obj.disk_ax = a_tangent * cos(trackNormalAngle);
                %For Angle>0<pi sin>=0; Angle<0>-pi sin<=0 -> Angle pos
                %means going left, angle neg means going right, thus the -
                obj.disk_ay = a_tangent * -sin(trackNormalAngle);
                obj.updateVelAndPose(old_disk_x, old_disk_y);
                % WIP: Change obj.disk_state if disk gets out of parabola
                % WIP: Change obj.disk_state if disk gets out of parabola
            case 1 %falling
                %projectile fall
                obj.disk_ax = 0;
                obj.disk_ay = obj.disk_mass * g;
                obj.updateVelAndPose(old_disk_x, old_disk_y);
                % WIP: Change obj.disk_state if disk falls into parabola
            case 2 %won
                %do nothing
                obj.disk_ax = 0;
                obj.disk_ay = 0;
                obj.disk_vx = 0;
                obj.disk_vy = 0;
                set_param(gcs, 'SimulationCommand', 'stop')
            case 3 %lost
                %do nothing
                obj.disk_ax = 0;
                obj.disk_ay = 0;
                obj.disk_vx = 0;
                obj.disk_vy = 0;
                set_param(gcs, 'SimulationCommand', 'stop')
            end

            poseInercial = [obj.disk_x, obj.disk_y];
            poseReferencial = obj.rotate(u, obj.disk_x, obj.disk_y);
            velocidadRef = old_poseReferencial-poseReferencial;
        end

        function resetImpl(obj)
            % Initialize / reset internal or discrete properties
            obj.disk_ax = 0;
            obj.disk_ay = 0;
            obj.disk_vx = 0;
            obj.disk_vy = 0;
            obj.current_piso = 1;
            obj.disk_state = 0;
            obj.disk_x = -0.1;
            obj.disk_y = 0.1092;
        end
        
        function updateVelAndPose(obj, old_disk_x, old_disk_y)
            obj.disk_vx = obj.disk_vx + obj.disk_ax * obj.Ts;
            obj.disk_vy = obj.disk_vy + obj.disk_ay * obj.Ts;
            obj.disk_x = old_disk_x + obj.disk_vx * obj.Ts + obj.disk_ax /2 * obj.Ts * obj.Ts; %x0 + vx*t +1/2*ax*t^2
            obj.disk_y = old_disk_y + obj.disk_vy * obj.Ts + obj.disk_ay /2 * obj.Ts * obj.Ts;
        end

        function theta = getTangentToParabola(obj,u)
            obj.current_piso;
            theta = u;
        end

        %% Backup/restore functions
        function s = saveObjectImpl(obj)
            % Set properties in structure s to values in object obj

            % Set public properties and states
            s = saveObjectImpl@matlab.System(obj);

            % Set private and protected properties
            %s.myproperty = obj.myproperty;
        end

        function loadObjectImpl(obj,s,wasLocked)
            % Set properties in object obj to values in structure s

            % Set private and protected properties
            % obj.myproperty = s.myproperty; 

            % Set public properties and states
            loadObjectImpl@matlab.System(obj,s,wasLocked);
        end

        %% Advanced functions
        function validateInputsImpl(obj,u)
            % Validate inputs to the step method at initialization
        end

        function validatePropertiesImpl(obj)
            % Validate related or interdependent property values
        end

        function ds = getDiscreteStateImpl(obj)
            % Return structure of properties with DiscreteState attribute
            ds = struct([]);
        end

        function processTunedPropertiesImpl(obj)
            % Perform actions when tunable properties change
            % between calls to the System object
        end

        function flag = isInputSizeMutableImpl(obj,index)
            % Return false if input size cannot change
            % between calls to the System object
            flag = false;
        end

        function flag = isInactivePropertyImpl(obj,prop)
            % Return false if property is visible based on object 
            % configuration, for the command line and System block dialog
            flag = false;
        end
    end
end

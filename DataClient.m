classdef DataClient<handle
    %DATACLIENT TCP/IP data client
    %   Detailed explanation goes here   
 
    properties
        TCPIP;
        serverPort;
        ipAddress;
        sampleRate;
        updateInterval;
        bufferSize;
        UserName;
    end
    
    methods
        function obj=DataClient(ipAddress, serverPort, sampleRate, bufferSize,updateInterval,username)
            obj.updateInterval=updateInterval;
            obj.serverPort = serverPort;
            obj.ipAddress = ipAddress;
            obj.sampleRate = sampleRate;
            obj.TCPIP = tcpip(obj.ipAddress, obj.serverPort,'NetworkRole','Client');
            obj.UserName=username;
            obj.bufferSize=bufferSize;
            if round(obj.sampleRate * obj.updateInterval) > 1
                updatePoints = round(obj.sampleRate * obj.updateInterval);
            else
                updatePoints = obj.sampleRate;
            end
            obj.TCPIP.BytesAvailableFcnCount = 4 * updatePoints;
            obj.TCPIP.BytesAvailableFcnMode = 'byte';
            obj.TCPIP.BytesAvailableFcn = {@GET_DATA, round(bufferSize*obj.sampleRate),obj.UserName};
            obj.TCPIP.InputBufferSize = obj.TCPIP.BytesAvailableFcnCount * 10;
            obj.TCPIP.ByteOrder = 'littleEndian';
        end
        
        function Open(obj)
            fopen(obj.TCPIP);
        end
        
        function Close(obj)
            fclose(obj.TCPIP);
        end
        
        function [signal]=GetRawData(obj)
            if length(obj.TCPIP.UserData)<=round(obj.bufferSize*obj.sampleRate)
                signal = obj.TCPIP.UserData;
            else
                signal = obj.TCPIP.UserData(1:round(obj.bufferSize*obj.sampleRate));
            end
        end
        
        function [R_wave]=GetRwave(obj)
            if length(obj.TCPIP.UserData)<=round(obj.bufferSize*obj.sampleRate)
                R_wave = [];
            else
                R_wave = obj.TCPIP.UserData(round(obj.bufferSize*obj.sampleRate)+1:end);
            end
        end
        
        function Heart_Rate=GetHR(obj)
            R_wave=GetRwave(obj);
            if isempty(R_wave);
                [~,R_wave,~]=pan_tompkin(GetRawData,obj.sampleRate,0);             
            end
            Heart_Rate=length(R_wave(:))/obj.bufferSize*60;
        end
        
        function HRV(obj)
            ecg=dlmread([obj.UserName,'.txt']);
            [~,r_i_raw,~]=pan_tompkin(ecg,obj.sampleRate,0);
            % Calculate Heart Rate
            t=sort(r_i_raw);
            t=(t-t(1))/fs;
            y=diff(t);
            t(end)=[];
            dlmwrite([obj.UserName,'.ibi'],[t(:),y(:)]);
            HRVAS
        end
    end
end

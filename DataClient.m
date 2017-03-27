classdef DataClient<handle
    %DATACLIENT TCP/IP data client
    %   Detailed explanation goes here   
 
    properties
        TCPIP;
        serverPort;
        ipAddress;
        sampleRate;
        updateInterval;
        fileName;
    end
    
    methods
        function obj=DataClient(UserName, ipAddress, serverPort, sampleRate, bufferSize,updateInterval)
            obj.fileName=UserName+'.txt';
            obj.updateInterval=updateInterval;
            obj.serverPort = serverPort;
            obj.ipAddress = ipAddress;
            obj.sampleRate = sampleRate;
            obj.TCPIP = tcpip(obj.ipAddress, obj.serverPort,'NetworkRole','Client');
            if round(obj.sampleRate * obj.updateInterval) > 1
                updatePoints = round(obj.sampleRate * obj.updateInterval);
            else
                updatePoints = obj.sampleRate;
            end
            obj.TCPIP.BytesAvailableFcnCount = 4 * updatePoints;
            obj.TCPIP.BytesAvailableFcnMode = 'byte';
            obj.TCPIP.BytesAvailableFcn = {@GET_DATA, bufferSize*obj.sampleRate,fileName};
            obj.TCPIP.InputBufferSize = obj.TCPIP.BytesAvailableFcnCount * 10;
            obj.TCPIP.ByteOrder = 'littleEndian';
        end
        
        function Open(obj)
            fopen(obj.TCPIP);
        end
        
        function Close(obj)
            fclose(obj.TCPIP);
        end
        
        function [data] = GetBufferData(obj)
            data = obj.TCPIP.UserData;
        end
    end
end

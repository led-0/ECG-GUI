close all; clear all; 
%% Create data client object
ipAddress = 'localhost'; % Data server IP address
serverPort = 55000; % Data server port%MCU will also send data to this port
sampleRate = 250; % Sampling rate
updateInterval = 0.04;
bufferSize = 2; % Data buffer size, in seconds
dataClient = DataClient('User1',ipAddress, serverPort, sampleRate, bufferSize,updateInterval); % Create client object
dataClient.Open;
data = dataClient.GetBufferData; % Get data from buffer
%% Process Data
%This part can show the data dynamically
%If needed, it can be changed to fit the GUI part
figure;
hPlot = plot(dataClient.GetBufferData');
%link dataClient.GetBufferData' to the figure 
dataSourceName = 'dataClient.GetBufferData';
set(hPlot, 'YDataSource', dataSourceName);
linkdata on;
telapsed = 0;
tic;
while true
    telapsed = telapsed + toc;
    if telapsed > updateInterval
        data = dataClient.GetBufferData;
        refreshdata(hPlot);
        telapsed = 0;
        tic;
    end
    pause(0.01);
end

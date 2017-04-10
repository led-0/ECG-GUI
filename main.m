close all; clear all; 
%% Basic procedure
% Create data client object
UserName = 'User_default';
ipAddress = 'localhost'; % Data server IP address
serverPort = 55000; % Data server port%MCU will also send data to this port
sampleRate = 250; % Sampling rate
updateInterval = 0.04;
bufferSize = 5; % Data buffer size, in seconds
%% 
%connect 这个按钮不用了
%start
dataClient = DataClient(ipAddress, serverPort, sampleRate, bufferSize,updateInterval,UserName); % Create client object
dataClient.Open;
%stop:
dataClient.Close;
%get ecg signal
dataClient.GetRawData;
%get R wave 这个数组记录所有R峰，下标与raw data 对应
dataClient.GetRwave;
%get Heart Rate
dataClient.GetHR;
%HRV analysis
dataClient.HRV;

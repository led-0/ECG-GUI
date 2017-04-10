function GET_DATA( obj, event, bufferSize ,UserName )
%GetChannelDataCallBack Summary of this function goes here
%   Detailed explanation goes here
data = fread(obj, obj.BytesAvailableFcnCount/4, 'float');
% 50Hz bandstop
b=[0.7294,0,2.1883,0,2.1883,0,0.7294];
a=[1,0,2.3741,0,1.9294,0,0.5321];
data=filtfilt(b,a,data(:));
%record all the data and save in file
dlmwrite(UserName+'.txt',data,'-append');
userDataLength = length(obj.UserData);
if userDataLength >=bufferSize
    signal=[obj.UserData(1:bufferSize);data];
    if length(signal)>bufferSize
        signal=signal((end-bufferSize+1):end);
    end
    %fs=200
    [~,r_i_raw,~]=pan_tompkin(signal,200,0);
    obj.UserData = [signal(:);r_i_raw(:)];
else
    obj.UserData = [obj.UserData; data];
end

end

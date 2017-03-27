function GET_DATA( obj, event, bufferSize, fileName)
%GetChannelDataCallBack Summary of this function goes here
%   Detailed explanation goes here
    data = fread(obj, obj.BytesAvailableFcnCount/4, 'int');
    %record all the data and save in file
    dlmwrite(fileName,data,'-append');
    obj.UserData = [obj.UserData;data];
    userDataLength = length(obj.UserData);
    if userDataLength > bufferSize
        obj.UserData = obj.UserData(:, (end-bufferSize+1):end);
    end
end

function GET_DATA( obj, event, bufferSize )
%GetChannelDataCallBack Summary of this function goes here
%   Detailed explanation goes here
    data = fread(obj, obj.BytesAvailableFcnCount/4, 'int');
    obj.UserData = [obj.UserData data];
    userDataLength = length(obj.UserData);
    if userDataLength > bufferSize
        obj.UserData = obj.UserData(:, (end-bufferSize+1):end);
    end
end
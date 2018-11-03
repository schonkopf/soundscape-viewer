function [filename, fileendtime]=getfile(file_time, list, recording_format, type, init)

if isempty(file_time)==1
    filename=[];
    fileendtime=[];
else
    if strcmpi('filename',type)==1
        method=1; 
    elseif strcmpi('time',type)==1
        method=2; 
    end

    if method==1
        file_time(2:end)=100+file_time(2:end);
        YY=num2str(file_time(1)); MM=num2str(file_time(2)); DD=num2str(file_time(3)); hh=num2str(file_time(4)); mm=num2str(file_time(5)); ss=num2str(file_time(6));
        filename=[init YY MM(2:3) DD(2:3) '_' hh(2:3) mm(2:3) ss(2:3) recording_format];
        fileendtime=[];
    elseif method==2
        for n=1:length(list)
            list_time(n)=list(n).datenum;
        end
        diff_data=list_time-datenum(file_time); diff_data(diff_data<0)=Inf;
        [~,filename]=min(abs(diff_data));
        fileendtime=list(filename).datenum;
        filename=list(filename).name;
    end
end
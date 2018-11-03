function [output, f, time_vec]=LTSA_combine(LTSA_folder, variable_flag, version, File)
file_load=1;

if nargin<2
    variable_flag=0;
end
if nargin<3
    version=1;
end
if nargin<4
    file_load=0;
end

if variable_flag==0
    PATH=cd;
    cd(LTSA_folder)
    if file_load==0
        file=dir(fullfile(cd, '*.mat'));
    else
        file(1).name=File;
    end
    
    % organize all the data
    time_stamp=[]; data_median=[]; data_mean=[];
    h=waitbar(0, 'Processing, please wait...');
    for n=1:size(file,1)
        temp=load(file(n).name);
        waitbar(n/size(file,1));
        if isfield(temp,'f')==1
            version=0;
        end
        if version==1
            temp=temp.Result; f=temp.f;
            time_start(n)=temp.LTS_median(1,1);
            time_stamp=[time_stamp; temp.LTS_median(:,1)];
            data_median=[data_median; temp.LTS_median]; data_mean=[data_mean; temp.LTS_mean];
        elseif version~=1
            f=temp.f;
            time_start(n)=temp.Result_median(1,1);
            time_stamp=[time_stamp; temp.Result_median(:,1)];
            data_median=[data_median; temp.Result_median]; data_mean=[data_mean; temp.Result_mean];
        end
    end
        
    % organize the data by timestamp
    LTSA_resolution=time_stamp(2)-time_stamp(1);
    time_vec=floor(min(time_stamp)):LTSA_resolution:ceil(max(time_stamp));
    output=nan(length(f),length(time_vec),2);

    for n=1:size(data_median,1)
        [c,i]=min(abs(time_vec-data_median(n,1)));
        output(:,i,1)=data_median(n,2:end)';
        output(:,i,2)=data_mean(n,2:end)';
    end
    output(:,:,3)=output(:,:,2)-output(:,:,1);
    close(h)
    cd(PATH);
    
elseif variable_flag==1
    data_median=LTSA_folder;
    time_stamp=data_median(:,1);
    f=[];
    
    % organize the data by timestamp
    LTSA_resolution=time_stamp(2)-time_stamp(1);
    time_vec=floor(min(time_stamp)):LTSA_resolution:ceil(max(time_stamp));
    output=nan(size(data_median,2)-1,length(time_vec));

    for n=1:size(data_median,1)
        [c,i]=min(abs(time_vec-data_median(n,1)));
        output(:,i,1)=data_median(n,2:end)';
    end
end


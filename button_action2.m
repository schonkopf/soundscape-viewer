
if input==1 % Referesh feature plot
    axes(c_axe2); cla(c_axe2,'reset');
    imagesc(1:length(soundscape_scene),f/1000,scene_feature); axis xy;
    xlabel('Event'); ylabel('Frequency (kHz)'); colorbar
    caxis([min(scene_feature(:))-(max(scene_feature(:))-min(scene_feature(:)))/50 max(scene_feature(:))]);
elseif input==2 % Play recording
    [x,y]=ginput(1);
    x_num=find(x_axis==floor(x));
    y_temp=y-y_axis;
    [~,y_num]=min(abs(y_temp));
    list_num=(x_num-1)*length(y_axis)+y_num; label_num=save_result(list_num,2);
    file_time=datevec(round((save_result(list_num,1))*24*3600)/24/3600);
    
    % Get filename and load recording
    if exist('list')==1
        [filename, fileendtime]=getfile(file_time, list, recording_format, 'time',init);
        if isempty(filename)==1
            matrix_duration=[];
        else
            cd(PATH)
            info = audioinfo(filename);
            if ceil(info.Duration)>LTSA_resolution*24*60*60
                begin_time=fileendtime-info.Duration/3600/24;
                matrix_duration=floor([(datenum(file_time)-begin_time)*24*60*60 (datenum(file_time)-begin_time+LTSA_resolution)*24*60*60].*info.SampleRate);
                if matrix_duration(end)>info.TotalSamples
                    matrix_duration(end)=info.TotalSamples;
                end
                if matrix_duration(1)<=0
                    matrix_duration(1)=1;
                elseif matrix_duration(1)>=info.TotalSamples
                    matrix_duration=[];
                end
                if isempty(matrix_duration)~=1
                    if matrix_duration(end)<=0
                        matrix_duration=[];
                    end
                end
            else
                matrix_duration=[1 info.TotalSamples];
            end 
        end
    else
        matrix_duration=[];
    end
        axes(c_axe2); cla(c_axe2,'reset');
        if label_num==0
            % Display scene and event features
            imagesc(1:length(soundscape_scene),f/1000,scene_feature); axis xy;
        else
            view_scene=nan(length(f),length(soundscape_scene));
            view_scene(:,label_num(1))=scene_feature(:,label_num(1));
            imagesc(1:length(soundscape_scene),f/1000,view_scene); axis xy;
        end
        xlabel('Event'); ylabel('Frequency (kHz)'); colorbar;
        caxis([min(scene_feature(:))-(max(scene_feature(:))-min(scene_feature(:)))/50 max(scene_feature(:))]);
        
    if isempty(matrix_duration)==1
        spec_disp=0;
        axes(c_axe4); cla(c_axe4,'reset');
        text(0.4,0.5,'No recording','FontSize',16)
    else
        spec_disp=1;
        [sound_data,fs]=audioread(filename, matrix_duration); player=audioplayer(sound_data,fs); play(player);
    end
    cd(PATH_o)
    
    if spec_disp==1
       [S,F,T,P]=spectrogram(sound_data(:,1),1024,256,1024,fs);
       axes(c_axe4); cla(c_axe4,'reset');
       P=10*log10(P);
       imagesc(T/60,F/1000,P); axis xy; caxis([prctile(P(:),1)-10 max(P(:))+5]);
       file_time(2:end)=100+file_time(2:end);
       YY=num2str(file_time(1)); MM=num2str(file_time(2)); DD=num2str(file_time(3)); hh=num2str(file_time(4)); mm=num2str(file_time(5)); ss=num2str(file_time(6));
       title([YY MM(2:3) DD(2:3) ' ' hh(2:3) mm(2:3) ss(2:3)]) ;xlabel('Time (min)'); ylabel('Frequency (kHz)');
       if strcmpi('.MP3',recording_format)==1
           ylim([0 16]);
       elseif strcmpi('.mp3',recording_format)==1
           ylim([0 16]);
       end
    end
            
elseif input==3 % Pause recording
       pause(player);

elseif input==4 % Resume player
       resume(player);
end

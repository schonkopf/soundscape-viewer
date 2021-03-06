

% Scene and event spectral features
for n=1:max(save_result(:,2))
    scene_feature(:,n)=soundscape_scene{n}(:,3);
end
    
% Preparing axis for visualization
time_vec=round(time_vec*24*60*6)/24/60/6;
LTSA_resolution=round((time_vec(2)-time_vec(1))*24*60*60)/24/60/60;
y_axis=unique(round((time_vec-floor(time_vec))*24*60*60)/3600); y_axis(y_axis>=24)=[]; 
N_rem=rem(size(save_result,1),length(y_axis));
x_axis=unique(floor(time_vec(1:end-N_rem)));
soundscape_context=reshape(save_result(1:end-N_rem,2),length(y_axis),[]);

% plot the soundscape scene and event
c_axe1=axes('position',[.15  .5  .5  .45]);
imagesc(x_axis+0.5, y_axis,soundscape_context(:,:,1)); ylim([0 24]);
xlabel('Date'); ylabel('Hour'); datetick('x','keepticks','keeplimits'); colormap(visualization_map);

c_axe2=axes('position',[.7  .5  .25  .45]);
imagesc(1:length(soundscape_scene),f/1000,scene_feature); axis xy;
xlabel('Event'); ylabel('Frequency (kHz)'); colorbar;
caxis([min(scene_feature(:))-(max(scene_feature(:))-min(scene_feature(:)))/50 max(scene_feature(:))]);

c_axe4=axes('position',[.15  .1  .8  .3]);
xlabel('Time (min)'); ylabel('Frequency (kHz)');
    
% access the wav file
PATH_o=cd;
[File,PATH] = uigetfile('*.*');
init_pos=strfind(PATH,'\');
init=PATH(init_pos(end-1)+1:init_pos(end)-1);
recording_format=File(end-3:end);
cd(PATH)
list=dir(cd); list=list(3:end);
cd(PATH_o)
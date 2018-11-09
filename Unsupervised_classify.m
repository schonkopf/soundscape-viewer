
% Panels
h2=figure('Position',[50 50 1200 600],'Menubar','none','Toolbar','figure');
% Menubar
m_load = uimenu(h2,'Label','Load', 'Callback','menu_style=3.1; button_action;');
m_save = uimenu(h2,'Label','Save', 'Callback','menu_style=4.3; button_action;');

% Buttons
c_button=uicontrol('Style','pushbutton','String','Refresh features','FontSize',8,'Position',[20 400 100 50],'BackgroundColor',[.8 .8 .8],'Callback','input=1; button_action2;');
c_button1=uicontrol('Style','pushbutton','String','Play recording','FontSize',8,'Position',[20 300 100 50],'BackgroundColor',[.8 .8 .8],'Callback','input=2; button_action2;');
c_button2=uicontrol('Style','pushbutton','String','Pause','FontSize',8,'Position',[20 200 100 50],'BackgroundColor',[.8 .8 .8],'Callback','input=3; button_action2;');
c_button3=uicontrol('Style','pushbutton','String','Resume','FontSize',8,'Position',[20 100 100 50],'BackgroundColor',[.8 .8 .8],'Callback','input=4; button_action2;');

save_result=[];

% Parameters
view=1; 

clear scene_feature;
if exist('analysis_data')==1
   time_vec=round(time_vec*24*60*60)/24/60/60;
   [save_result, soundscape_scene]=LTSA_context_analysis(analysis_data, time_vec, f, var_th);
else
   menu_style=3.1; button_action;
end


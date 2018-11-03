% Filtering input data
classification_th=str2num(get(h20_th, 'String'));
var_th=1-str2num(get(h20_var, 'String'))/100;
close(h20);

analysis_data=data;
analysis_data(analysis_data<classification_th)=classification_th; analysis_data=analysis_data-classification_th;

% Panels
h2=figure('Position',[50 50 1200 600],'Menubar','none','Toolbar','figure');
% Menubar
m_load = uimenu(h2,'Label','Load', 'Callback','menu_style=1.3; button_action;');
m_save = uimenu(h2,'Label','Save', 'Callback','menu_style=4.3; button_action;');

% Buttons
c_button=uicontrol('Style','pushbutton','String','Refresh features','FontSize',8,'Position',[20 400 100 50],'BackgroundColor',[.8 .8 .8],'Callback','input=1; button_action2;');
c_button1=uicontrol('Style','pushbutton','String','Play recording','FontSize',8,'Position',[20 300 100 50],'BackgroundColor',[.8 .8 .8],'Callback','input=2; button_action2;');
c_button2=uicontrol('Style','pushbutton','String','Pause','FontSize',8,'Position',[20 200 100 50],'BackgroundColor',[.8 .8 .8],'Callback','input=3; button_action2;');
c_button3=uicontrol('Style','pushbutton','String','Resume','FontSize',8,'Position',[20 100 100 50],'BackgroundColor',[.8 .8 .8],'Callback','input=4; button_action2;');

save_result=[];
clustering_interface;


clear; clc;
save_title=[]; save_title2=[];

% Panels
h1=figure('Position',[50 50 1200 600],'Menubar','none','Toolbar','figure');
axe1=axes('position',[.15  .15  .8  .8]);
% Menubar
m_load = uimenu(h1,'Label','Load');
m_analysis = uimenu(h1,'Label','Analysis');
m_save = uimenu(h1,'Label','Save');
% Sub-Menubar for analysis
m_load_file = uimenu(m_load,'Label','File', 'Callback','menu_style=1.1; button_action;');
m_load_folder = uimenu(m_load,'Label','Folder', 'Callback','menu_style=1.2; button_action;');
m_analysis_separation = uimenu(m_analysis,'Label', 'Unsupervised separation', 'Callback','menu_style=2.2; source_number;');     
m_analysis_supervised_SS = uimenu(m_analysis,'Label', 'Supervised separation', 'Callback','menu_style=2.3; button_action;');   
m_analysis_classification = uimenu(m_analysis,'Label', 'Clustering', 'Callback','menu_style=3; source_number;');
% Sub-Menubar for save
m_save_lts = uimenu(m_save,'Label', 'Save LTS', 'Callback','menu_style=4.1; button_action;');
m_save_model = uimenu(m_save,'Label', 'Save model', 'Callback','menu_style=4.2; button_action;');

% Button
h_button=uicontrol('Style','pushbutton','String','Change LTS','FontSize',8,'Position',[30 520 90 50],'BackgroundColor',[.8 .8 .8], 'Callback','menu_style=1.25; button_action;');
h_button1=uicontrol('Style','pushbutton','String','Zoom out','FontSize',8,'Position',[30 420 90 50],'BackgroundColor',[.8 .8 .8], 'Callback','menu_style=1.05; button_action;');
h_button2=uicontrol('Style','pushbutton','String','Renew date','FontSize',8,'Position',[30 320 90 50],'BackgroundColor',[.8 .8 .8], 'Callback','menu_style=0; button_action;');
h_button3=uicontrol('Style','pushbutton','String','Compare','FontSize',8,'Position',[30 220 90 50],'BackgroundColor',[.8 .8 .8], 'Callback','menu_style=2; button_action;');
h_button4=uicontrol('Style','pushbutton','String','Change SR','FontSize',8,'Position',[30 120 90 50],'BackgroundColor',[.8 .8 .8], 'Callback','menu_style=2.1; button_action;');


if menu_style==3
    h20=figure('Position',[50 200 350 150],'Menubar','none');
    hlabel2=uicontrol('Style','text','String','Enter the feature threshold','FontSize',10,'Position',[20 100 200 20]);
    h20_th=uicontrol('Style','edit','String',[],'FontSize',10,'Position',[230 100 60 30]);
    hlabel3=uicontrol('Style','text','String','Variation of clustering (%)','FontSize',10,'Position',[20 60 200 20]);
    h20_var=uicontrol('Style','edit','String',95,'FontSize',10,'Position',[230 60 60 30]);
    h20_enter=uicontrol('Style','pushbutton', 'String', 'Enter','Position',[230 20 60 30],'FontSize',10,'BackgroundColor',[.8 .8 .8],'Callback','button_action;');
else
    h20=figure('Position',[50 200 350 250],'Menubar','none');
    hlabel1=uicontrol('Style','text','String','Enter the PSD threshold','FontSize',10,'Position',[20 180 200 20]);
    h20_min_PSD=uicontrol('Style','edit','String',floor(min(data(:))),'FontSize',10,'Position',[230 180 60 30]);
    hlabel2=uicontrol('Style','text','String','Enter the number of sources','FontSize',10,'Position',[20 140 200 20]);
    h20_number=uicontrol('Style','edit','String',2,'FontSize',10,'Position',[230 140 60 30]);
    hlabel3=uicontrol('Style','text','String','Enter the number of frames','FontSize',10,'Position',[20 100 200 20]);
    h20_iter=uicontrol('Style','edit','String',1,'FontSize',10,'Position',[230 100 60 30]);
    hlabel4=uicontrol('Style','text','String','Sparseness for feature learning','FontSize',10,'Position',[20 60 200 20]);
    h20_sW=uicontrol('Style','edit','String',0.5,'FontSize',10,'Position',[230 60 60 30]);
    h20_enter=uicontrol('Style','pushbutton', 'String', 'Enter','Position',[230 20 60 30],'FontSize',10,'BackgroundColor',[.8 .8 .8],'Callback','menu_style=2.2; button_action;');
end
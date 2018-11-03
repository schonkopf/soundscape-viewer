visualization_map=colormap(jet(512));
visualization_map(1,:)=1;

if menu_style==0
    axes(axe1);
    datetick('x','keeplimits');
    caxis([floor(min(data(:)))-ceil(max(data(:)))/20 ceil(max(data(:)))]); colormap(visualization_map); colorbar;
elseif floor(menu_style)==1
    % Load data
    PATH_o=cd;
    if menu_style==1.1
        [File,LTSA_folder] = uigetfile('*.mat');
        [output.LTS, f, time_vec]=LTSA_combine(LTSA_folder, 0, 1, File);
        % Floor to the second digits
        output.LTS=floor(output.LTS*100)/100;
        data=output.LTS(:,:,1); 
        axes(axe1); cla(axe1,'reset');
        LTS_disp=3; clear temp
    elseif menu_style==1.2
        [LTSA_folder] = uigetdir;
        [output.LTS, f, time_vec]=LTSA_combine(LTSA_folder, 0, 1);
        % Floor to the second digits
        output.LTS=floor(output.LTS*100)/100;
        data=output.LTS(:,:,1);
        axes(axe1); cla(axe1,'reset');
        LTS_disp=3;
    elseif menu_style==1.3
        [Cluster_file,clustering_folder] = uigetfile('*.mat');
        cd(clustering_folder); temp=load(Cluster_file); cd(PATH_o);
        save_result=save_clustering.save_result;
        time_vec=save_clustering.time_vec;
        soundscape_scene=save_clustering.soundscape_scene;
        classification_th=save_clustering.classification_th;
        axes(c_axe4); cla(c_axe4,'reset');
        clustering_interface;
    end
    
    
    if menu_style>1.2
        axes(axe1); lts_boundary=[axe1.XLim; axe1.YLim];
    end
        
    title_text=[{'Median PSD'}, {'Mean PSD'}, {'Difference PSD'}];
    if menu_style>=1.1
        % Change view between median and mean PSD
        LTS_disp=rem(LTS_disp,3)+1; data=output.LTS(:,:,LTS_disp); 
    end
    axes(axe1); cla(axe1,'reset');
    imagesc(time_vec, f/1000, data); axis xy; title(title_text{LTS_disp}); save_title=title_text{LTS_disp};
    xlabel('Date'); ylabel('Frequency (kHz)'); caxis([floor(min(data(:)))-ceil(max(data(:)))/20 ceil(max(data(:)))]); colormap(visualization_map); colorbar;
    
    if menu_style>1.2
        xlim(lts_boundary(1,:)); ylim(lts_boundary(2,:));
    end
    datetick('x','keeplimits');
        
elseif floor(menu_style)==2
    if exist('output')==0
        PATHNAME_o=cd;
        [~,LTSA_folder] = uigetfile('*.mat');
        [output.LTS, f, time_vec]=LTSA_combine(LTSA_folder, 0, 1);
        % Floor to the second digits
        output.LTS=floor(output.LTS*100)/100;
        data=output.LTS(:,:,1);
    end
    
    if menu_style==2.2
        % Unsupervised separation by UNMF
        cd(PATH_o)
        PSD_threshold=str2num(get(h20_min_PSD, 'String'));
        k=str2num(get(h20_number, 'String'));
        time_frame=str2num(get(h20_iter, 'String'));
        sparseness_W=str2num(get(h20_sW, 'String'));
        close(h20);
        
        data_list=isnan(sum(data,1))~=1;
        data=data-PSD_threshold; data(data<0)=0;
        [data, W, W_cluster, H]=LTSA_PCNMF(data(:,data_list), k, time_frame, 'seminmf', sparseness_W);

        output.separation=repmat(output.LTS(:,:,1),1,1,k);
        for n=1:k
            output.separation(:,data_list,n)=data(:,:,n);
        end
        
        cd(PATH_o);
        title_separation=[{'Separated data'} {'Original data'}];
        UNMF_disp=1; comp_disp=2;
    elseif menu_style==2.3
        % Load previous model
        [model_file,model_folder] = uigetfile('*.mat');
        cd(model_folder); load(model_file); cd(PATH_o);
        
        % Supervised separation by UNMF
        cd(PATH_o)
        data_list=isnan(sum(data,1))~=1;
                
        W=save_pcnmf.W;
        W_cluster=save_pcnmf.W_cluster;
        k=save_pcnmf.k;
        time_frame=save_pcnmf.time_frame;
        PSD_threshold=save_pcnmf.PSD_threshold;
        sparseness_W=save_pcnmf.sparseness_W;
        
        data=data-PSD_threshold; data(data<0)=0;
        [data, W, W_cluster, H]=LTSA_PCNMF(data(:,data_list), k, time_frame, 'seminmf', sparseness_W, size(W,2), 200, W, [], W_cluster);
        
        output.separation=repmat(output.LTS(:,:,1),1,1,k);
        for n=1:k
            output.separation(:,data_list,n)=data(:,:,n);
        end
        
        cd(PATH_o);
        title_separation=[{'Separated data'} {'Original data'}];
        UNMF_disp=1; comp_disp=2;
    end
    
    % Plot data
    if menu_style==2.1 
        UNMF_disp=rem(UNMF_disp,k)+1;
        comp_disp=1;
    else
        comp_disp=rem(comp_disp,2)+1;
    end
    
    if comp_disp==2
        data=output.LTS(:,:,LTS_disp);
    elseif comp_disp==1
        data=output.separation(:,:,UNMF_disp); 
    end
    fig_boundary=axis(axe1);
    axes(axe1); cla(axe1,'reset');
    imagesc(time_vec, f/1000, data); axis xy; title(title_separation{comp_disp}); save_title2=[title_separation{comp_disp} '_Component_' num2str(comp_disp)];
    xlim(fig_boundary(1:2));
    xlabel('Date'); ylabel('Frequency (kHz)'); datetick('x','keepticks','keeplimits');
    caxis([floor(min(data(:)))-ceil(max(data(:)))/20 ceil(max(data(:)))]); colormap(visualization_map); colorbar;

elseif floor(menu_style)==3
    if exist('data')==0
        msgbox('Please load long-term spectrogram at first.')
    else
        Unsupervised_classify;
    end
    
elseif floor(menu_style)==4
    if menu_style==4.1
        save_output.time_vec=time_vec;
        save_output.f=f;
        save_output.data=data;
        save_output.input=save_title;
        save_output.display=save_title2;
        uisave('save_output');
    elseif menu_style==4.2
        save_pcnmf.W=W;
        save_pcnmf.W_cluster=W_cluster;
        save_pcnmf.k=k;
        save_pcnmf.time_frame=time_frame;
        save_pcnmf.PSD_threshold=PSD_threshold;
        save_pcnmf.sparseness_W=sparseness_W;
        uisave('save_pcnmf');
    elseif menu_style==4.3
        save_clustering.save_result=save_result;
        save_clustering.time_vec=time_vec;
        save_clustering.soundscape_scene=soundscape_scene;
        save_clustering.classification_th=classification_th;
        uisave('save_clustering');
        
        Recording_time=save_result(:,1)-693960;
        Cluster=save_result(:,2);
        T = table(Recording_time, Clustering);
        writetable(T,'soundscape_clustering.csv','Delimiter',',');
    end
end
    
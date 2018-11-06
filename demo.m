% loading the long-term spectrogram
%load('ML_S3_20140911-20141012_5min.mat');

% parameters
baseline_PSD=-130;
save_pcnmf.k=2;
save_pcnmf.time_frame=10;
save_pcnmf.clustering_method='seminmf';
save_pcnmf.sparseness_W=0.5;

% unsupervised separation
data=Result.LTS_mean(:,2:end)'-baseline_PSD; data(data<0)=0; % prevent any negative data
[BSS_output, save_pcnmf.W, save_pcnmf.W_cluster]=LTSA_PCNMF(data(:,1:700), save_pcnmf.k, save_pcnmf.time_frame, save_pcnmf.clustering_method, save_pcnmf.sparseness_W);
save('pcnmf_model.mat','save_pcnmf');

% supervised separation
[SS_output]=LTSA_PCNMF(data(:,701:1400), save_pcnmf.k, save_pcnmf.time_frame, save_pcnmf.clustering_method, save_pcnmf.sparseness_W, size(save_pcnmf.W,2), 200, save_pcnmf.W, [], save_pcnmf.W_cluster);

% visualize the results
figure(1); imagesc(Result.LTS_mean(:,2:end)'); axis xy; title('Original long-term spectral average');
figure(2); 
subplot(2,1,1); imagesc(BSS_output(:,:,1)); axis xy; title('Seperated source 1 by unsupervised learning');
subplot(2,1,2); imagesc(BSS_output(:,:,2)); axis xy; title('Seperated source 2 by unsupervised learning');
figure(3); 
subplot(2,1,1); imagesc(BSS_output(:,:,1)); axis xy; title('Seperated source 1 by supervised learning');
subplot(2,1,2); imagesc(BSS_output(:,:,2)); axis xy; title('Seperated source 2 by supervised learning');
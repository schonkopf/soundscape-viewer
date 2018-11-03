function [save_sampling_AF, class_index, N_class]=LTSA_k_means(save_sampling_AF, var_th)

eigan_value_th=0.9; % The threshold of variance accounted by selected principle components in PCA

mean_save_sampling_AF=mean(save_sampling_AF,2);
adjust_save_sampling_AF=save_sampling_AF-repmat(mean_save_sampling_AF,1,size(save_sampling_AF,2));
    
% PCA analysis for reducing variables
[pc,score,latent]=pca(adjust_save_sampling_AF);

% determine the PC factors used in further analysis
if min(cumsum(latent)./sum(latent))>eigan_value_th
    score=score(:,1);
else
    score=score(:,1:max(find(cumsum(latent)./sum(latent)<=eigan_value_th))+1);
end

h=waitbar(0, 'Processing, please wait...');
k=1;
while 1
    waitbar(k/100);
    [class_index,C,sumd,D]=kmeans(score,k,'emptyaction','singleton');
    intra_var(k)=sum(sumd)/(k);
    temp=intra_var./max(intra_var);
    save_class_index{k}=class_index;
    if temp(end)<=var_th
        break
    end
    k=k+1;
end
close(h);

intra_var=intra_var./max(intra_var);
k=min(find(intra_var<=var_th)); 
class_index=save_class_index{k};
N_class=hist(class_index,1:1:k);

[~,idx]=sort(N_class,'descend');
[~,idx]=sort(idx);
class_index=idx(class_index)';
N_class=hist(class_index,1:1:k);

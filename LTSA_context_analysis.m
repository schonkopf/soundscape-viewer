function [save_result, soundscape_scene]=LTSA_context_analysis(output, time_vec, f, var_th, F_range)

if nargin<5
    F_range=[0 inf];
end

% classifying different soundscape scenes (median) and events (mean-median)
list=find(f>=min(F_range) & f<=max(F_range));f=f(list);
data=output(list,:,:);
list1=find(isnan(output(1,:,1))==1);
[~,list2]=find(output(1,:,1)==-inf);
[~,list3]=find(output(1,:,1)==inf);
[~,list4]=find(sum(output(:,:,1),1)==0);
list=1:1:size(output,2);
list(unique([list1 list2 list3 list4]))=[];
class_index=zeros(1,size(output,2));

% Unsupervised classification of soundscape events
[~, temp]=LTSA_k_means(data(:,list)', var_th);
class_index(1,list)=temp;
save_result=[time_vec; class_index]';

% PSD feature extraction of each soundscape scene
for n=1:max(save_result(:,2))
    soundscape_scene{n,1}=prctile(data(:,save_result(:,2)==n,1),[5 25 50 75 95],2);
    scene_feature(:,n)=soundscape_scene{n}(:,3);
end
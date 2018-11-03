function [W, H, class_index, period_feature]=basis_exchange(W, H, k_range, segment_width, method)

% Use fft to analyze the encoding matrix to obtain features related to periodicity
for n=1:size(W,2)
    % periodicity
    aa=fft(H(n,:)-mean(H(n,:)))/size(H,2); aa=abs(aa(1:floor(length(aa)/2+1)));
    period_feature(:,n)=aa; diff_period(n,1)=max(aa(2:end))-median(aa);
end
period_feature=[period_feature(2:end,:)];

% automatically clustering the encoding matrix based on the periodicity
[class_index, ~, ~, ~]=nmfsc_clustering(matrix_standardization(period_feature),k_range, method);
class_index=reshape(class_index,1,[]);

% reorganize the basis label based on the periodicity
for n=1:max(class_index)
    mean_diff_period(n,1)=mean(diff_period(find(class_index==n)));
end
[~,i]=sort(mean_diff_period,'descend');
for n=1:max(class_index)
    class_index(class_index==i(n))=10000+n;
end
class_index=class_index-10000;

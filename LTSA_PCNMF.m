function [output, W, W_cluster, H]=LTSA_PCNMF(data, basis_exchange_clusters, segment_width, clustering_method, sparseness_W, basis_num, iter_num, W0, H0, W_cluster)
% This program aims to separate different sound sources with different levels of periodicity by using the PC-NMF.
% 
% Input parameters
% data: a non-negative spectrogram for source separation
% basis_exchange_clusters: number of source you want to separate, it can also be a range if the number of source is unknown
% segment_width: number of time frames you want to cascade the input spectrogram
% basis_num: number of basis in NMF
% iter_num: number of iterations in NMF
%
% output: spectrogram of each sound source separated by using PC-NMF
% W: basis matrix provided by NMF
% W_cluster: numerical label of each sound source for separating the basis matrix
% H: encoding matrix provided by NMF
%
% Written by Tzu-Hao Harry Lin (Academia Sinica, Taiwan), 2017/5/11
% Corresponding email: schonkopf@gmail.com

%% Parameters
if nargin<2
   basis_exchange_clusters=2; % number of clusters to unsupervised separate groups with different periodicity 
end
if nargin<3
    segment_width=1; % number of sequential vectors
end
if nargin<4
   clustering_method='seminmf';
end
if nargin<5
    sparseness_W=0.5;
end
if nargin<6
    basis_num=60; % number of basis for NMF
end
if nargin<7
	iter_num=200; % number of iterations for updating the basis and encoding matrix during NMF
end
if nargin<8
    W0=[];
end
if nargin<9
    H0=[];
end
if nargin<10
    W_cluster=[]; W_fix=0; H_fix=0;
end
if isempty(W_cluster)==0
    W_fix=1; H_fix=0;
end

%sparseness_W=[]; % sparsness parameter for updating the basis matrix during NMF (1 means very sparse, 0 means toward the gaussian distribution)
sparseness_H=[]; % sparsness parameter for updating the encoding matrix

%% Main Procedures
f_dim=size(data,1); 
data=sequential_matrix(data, segment_width);

[W,H] = nmfsc(data,basis_num,sparseness_W,sparseness_H,iter_num,0, W0, H0, W_fix, H_fix);

output=[]; clear V;
% Cluster different basis matrices with different periodicity by sparse NMF
if isempty(W_cluster)==1
    [W, H, W_cluster]=basis_exchange(W, H, basis_exchange_clusters, segment_width, clustering_method);
end

% Use traditional NMF enhancement procedure to reconstruct different sound sources
for m=1:max(W_cluster)
    output(:,:,m)=matrix_mean(data.*(W(:,W_cluster==m)*H(W_cluster==m,:)./(W*H)),segment_width,f_dim);
end



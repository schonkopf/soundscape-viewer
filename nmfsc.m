function [W,H] = nmfsc( V, rdim, sW, sH, iter_num, showflag, W0, H0, W_fix, H_fix)
% nmfsc - non-negative matrix factorization with sparseness constraints
% 
% SYNTAX:
% [W,H] = nmfsc( V, rdim, sW, sH, fname, showflag );
%
% INPUTS:
% V          - data matrix 
% rdim       - number of components (inner dimension of factorization)
% sW         - sparseness of W, in [0,1]. (give [] if no constraint)
% sH         - sparseness of H, in [0,1]. (give [] if no constraint)
% fname      - name of file to write results into
% showflag   - binary flag. if set then graphically show progress
%    
% Note: Sparseness is measured on the scale [0,1] where 0 means
% completely distributed and 1 means ultimate sparseness.
%    
% NOTE: There is NO CONVERGENCE CRITERION. The estimation never ends,
% but rather has to be terminated manually. See README file of code 
% package for details. 
%

h=waitbar(0, 'Processing, please wait...');
% Check that we have non-negative data
if min(V(:))<0, error('Negative values in data!'); end

% Data dimensions
vdim = size(V,1);
samples = size(V,2);
    
% Create initial matrices
if nargin<7
    W = abs(randn(vdim,rdim));
elseif nargin>=7
    if isempty(W0)==1
        W = abs(randn(vdim,rdim));
    else
        W=W0;
    end
end
if nargin<8
    H = abs(randn(rdim,samples));
    H = H./(sqrt(sum(H.^2,2))*ones(1,samples));
elseif nargin>=8
    if isempty(H0)==1
        H = abs(randn(rdim,samples));
        H = H./(sqrt(sum(H.^2,2))*ones(1,samples));
    else
        H=H0;
    end
end
if nargin<9
    W_fix=0;
end
if nargin<10
    H_fix=0;
end

% Make initial matrices have correct sparseness
if ~isempty(sW), 
    L1a = sqrt(vdim)-(sqrt(vdim)-1)*sW; 
    for i=1:rdim, W(:,i) = projfunc(W(:,i),L1a,1,1); end
end
if ~isempty(sH), 
    L1s = sqrt(samples)-(sqrt(samples)-1)*sH; 
    for i=1:rdim, H(i,:) = (projfunc(H(i,:)',L1s,1,1))'; end
end

% Initialize displays
if showflag,
   figure(1); clf; % this will show the energies and sparsenesses
   figure(2); clf; % this will show the objective function
   drawnow;
end

% Calculate initial objective
objhistory = 0.5*sum(sum((V-W*H).^2));

% Initial stepsizes
stepsizeW = 1;
stepsizeH = 1;

timestarted = clock;

% Start iteration
for iter=1:iter_num    
	waitbar(iter/iter_num);
    % Show stats
    if showflag & (rem(iter,5)==0),
	figure(1);
	subplot(3,1,1); bar(sqrt(sum(W.^2)).*sqrt(sum(H'.^2)));
	cursW = (sqrt(vdim)-(sum(abs(W))./sqrt(sum(W.^2))))/(sqrt(vdim)-1);
	subplot(3,1,2); bar(cursW);
	cursH = (sqrt(samples)-(sum(abs(H'))./sqrt(sum(H'.^2)))) ...
		/(sqrt(samples)-1);
	subplot(3,1,3); bar(cursH);
	if iter>1,
	    figure(2);
	    plot(objhistory(2:end));
    end
    % added for now
    figure(100); imstiled(reshape(W,15,15,43),[],'gray')
	drawnow;
    end
    
    % Update iteration count
    %iter = iter+1;    
    
    % Save old values
    Wold = W;
    Hold = H;
        
    % ----- Update H ---------------------------------------
    if H_fix==0
    if ~isempty(sH),
    
	% Gradient for H
	dH = W'*(W*H-V);
	begobj = objhistory(end);
        
	% Make sure we decrease the objective!
    count=1;
	while 1,
	    
	    % Take step in direction of negative gradient, and project
	    Hnew = H - stepsizeH*dH;
	    for i=1:rdim, Hnew(i,:) = (projfunc(Hnew(i,:)',L1s,1,1))'; end
	    % Calculate new objective
	    newobj = 0.5*sum(sum((V-W*Hnew).^2));
	    
	    % If the objective decreased, we can continue...
	    if newobj<=begobj,
		break;
        else
            count=count+1;
            if count>=10
                break;
            end
	    end
	    
	    % ...else decrease stepsize and try again
	    stepsizeH = stepsizeH/2;
	
	end
	
	% Slightly increase the stepsize
	stepsizeH = stepsizeH*1.2;
	H = Hnew;

    else
        % Update using standard NMF multiplicative update rule
        H = H.*(W'*V)./(W'*W*H + 1e-9);

        % Renormalize so rows of H have constant energy
        norms = sqrt(sum(H'.^2));
        H = H./(norms'*ones(1,samples));
        W = W.*(ones(vdim,1)*norms);
    end
    end
    
    % ----- Update W ---------------------------------------
    if W_fix==0
    if ~isempty(sW),    
    
	% Gradient for W
	dW = (W*H-V)*H';
	begobj = 0.5*sum(sum((V-W*H).^2));
	
	% Make sure we decrease the objective!
    count=1;
	while 1,
	    
	    % Take step in direction of negative gradient, and project
	    Wnew = W - stepsizeW*dW;
	    norms = sqrt(sum(Wnew.^2));
	    for i=1:rdim, 
		Wnew(:,i) = projfunc(Wnew(:,i),L1a*norms(i),(norms(i)^2),1); 
	    end
	
	    % Calculate new objective
	    newobj = 0.5*sum(sum((V-Wnew*H).^2));
	    
	    % If the objective decreased, we can continue...
	    if newobj<=begobj,
		break;
        else
            count=count+1;
            if count>=10
                break;
            end
	    end
	    
	    % ...else decrease stepsize and try again
	    stepsizeW = stepsizeW/2;
	
	end
	
	% Slightly increase the stepsize
	stepsizeW = stepsizeW*1.2;
	W = Wnew;

    else
	% Update using standard NMF multiplicative update rule	
	W = W.*(V*H')./(W*H*H' + 1e-9);	
    end
    end  
    % Calculate objective
    newobj = 0.5*sum(sum((V-W*H).^2));
     
end
close(h);
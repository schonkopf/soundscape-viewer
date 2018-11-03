function V=matrix_mean(V,segment_width,f_dim)
% Convert a cascading matrix back to original matrix
for run=1:abs(segment_width)
    temp(:,:,run)=V((run-1)*f_dim+1:run*f_dim,run:end-segment_width+run);
end
V=mean(temp,3);
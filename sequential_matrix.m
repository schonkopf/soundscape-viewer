function output=sequential_matrix(data, segment_width)
% Cascading the input spectrogram to consider contextual information across multuple consecutive time frames
% To convert the cascading spectrogram back to original spectrogram, please use matrix_mean.m
y=size(data,1);
x=size(data,2);
if segment_width>=1
    output=zeros(y*segment_width,x+segment_width-1);
    for n=1:segment_width
        output((n-1)*y+1:n*y,n:end-segment_width+n)=data;
    end
end


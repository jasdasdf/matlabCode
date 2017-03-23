%function out = WaveletRec(y,FrRanges,sr,w0,IsLogSc)
% reconstructs the signal in FrRanges (each row - range)
function out = WaveletRec(y,FrRanges,sr,w0,IsLogSc)

method = 2; 
nRanges = size(FrRanges,1);
out = [];
%totFr = 
%totFrRange = reshape(FrRanges,;

switch method
case 1
    out = y;
    
    for i=1:nRanges
        [wave,t,f,s,p] = Wavelet(y,FrRanges(i,:),sr,w0,IsLogSc);
        n=size(wave); 
        if (length(n)>2) 
            n=n(1,end); 
            x=real(wave)./repmat(sqrt(s'),n);
            x = sum(x,2);
            out = out - x;
        else
            x=real(wave)./repmat(sqrt(s)',n(1),1);
            x = sum(x,2);
            out = out - x; 
        end
        
    end
    
case 2
    wave =[]; s=[];
    for i=1:nRanges
        [tmpwave,t,f,tmps,p] = Wavelet(y,FrRanges(i,:),sr,w0,IsLogSc);
        wave = cat(2,wave,tmpwave);
        s = cat(1,s,tmps);
%        keyboard
    end
    %for i=1:nRanges
        n=size(wave); 
        if (length(n)>2) 
            n=n(1,end); 
            x=real(wave)./repmat(sqrt(s'),n);
            x = sum(x,2);
            out =  x;
        else
            x=real(wave)./repmat(sqrt(s)',n(1),1);
            x = sum(x,2);
            out = x; 
        end
        %end
end
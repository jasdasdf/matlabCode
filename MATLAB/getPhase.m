function [ccd, ed]=getPhase(FileBase, State, cch, ech, Res, Clu)

cd /gpfs01/sirota/data/bachdata/data/weiwei/m_sm/
if exist([FileBase, '_SP_', State, '.mat'])
    load([FileBase, '_SP_', State, '.mat'], 'SP','FreqB')
else
    disp(['you do not have SP for ', State])
end
nprd=length(SP);
mLFP=[];
n1=length(cch);
n2=length(ech);
nch=n1+n2;
ch=[cch(:);ech(:)];
for sjn=1:nprd
    load([FileBase, '_LFPsig_', State, num2str(sjn)])
    if sjn==1
        Freq=out.FreqBins;
        nfr=size(Freq,1);
        nvar=size(out.LFPsig,2);
        nch=nvar/nfr;       
    end
    nt=size(out.LFPsig,1);
    out.LFPsig=reshape(double(out.LFPsig),nt,nch,nfr);
    %% get spike time
    SP=out.Periods;
    tClu=[];
    tRes=[];
    addb=0;
    for k=1:size(SP,1)
        temp=find((Res<SP(k,2))&(Res>SP(k,1)));
        tClu=[tClu;Clu(temp)];
        tRes=[tRes;Res(temp)-SP(k,1)+1+addb];
        addb=addb+SP(k,2)-SP(k,1)+1;
    end
%     if isfcause
        ttake=tRes>80;
%     else
%         ttake=tRes<(size(out.LFPsig,1)-40);
%     end
    clfp=zeros(length(ttake),nCh,nfr,40);
    for k=1:40
        clfp(:,:,:,k)=out.LFPsig(tRes(ttake)+2*k-80,ch,:);%nt*nfr*nlag
    end
    mLFP=[mLFP;clfp];
    waitbar(sjn/length(SP))
    ccd=mLFP(:,1:n1,:,:);
    ed=mLFP(:,(n1+1):end,:,:);
end
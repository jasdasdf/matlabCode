
FileBase='ec013.961_974';%906_918';%906_918 393_418 868_893
cd(['/storage/antsiro/data/blab/kenji/', FileBase,'/'])
load([FileBase,'.par.mat'])
% cd /storage/antsiro/data/blab/kenji/ec014.120_130/
% load ec014.120_130.par.mat
Period=load([FileBase, '.sts.REM']);
sprintf('ec013.51	ec013.906_918	unit2 020051	EC2	EC3	EC4	EC5	DG	DG	DG	DG')
% ec013.48	ec013.853_866	unit4 020048	EC2	EC3	EC4	EC5	CA1	CA1	CA1	CA1
% this two might be interesting to see the EC3-CA1 connection 
% ec013.49	ec013.868_893	unit6 020049	EC2	EC3	EC4	EC5	CA1	CA1	CA1	CA1
shanknames={'EC2'	'EC3'	'EC4'	'EC5'	'DG'	'DG'	'DG'	'DG'};
HP=1:64;
lfp=LoadBinary([FileBase '.lfp'],HP,65,2,[],[],Period)';
oPeriod=Period;
Period=ReshapePeriod(Period);
nPeriod=Period;
Period=Period(diff(Period,1,2)>25000,:);
luP=size(Period,1);
%%
cthr=.999;
B=cell(luP,1);
sA=cell(luP,1);
jdfr=[35:10:90];
channels=1:16;%32[33:61, 63:64]
for k=1:luP
    [B{k}, cc]=SSpecJAJD(lfp(Period(k,1):Period(k,2),channels),1250,400,400,jdfr,100,cthr,0);
    sA{k}=pinv(B{k});% lambda/B{k}
    fprintf('%d-',k)
end
[gB, gc]=SSpecJAJD(lfp(:,channels),1250,400,400,jdfr,100,cthr,0);
gsA=pinv(gB);%lambda/gB
%%
FreqBins=[4 100;30 55;50 90; 80, 120;140 200];%[4 3
nfr=size(FreqBins,1);
channels=[33:61, 63,64];%1:16;
for kfr=1:nfr
    A=cell(luP,1);
    W=cell(luP,1);
    LFP=ButFilter(lfp,4,FreqBins(kfr,:)/625,'bandpass');
    for k=1:luP
        [~, A{k}, W{k}, m]=wKDICA(LFP(Period(k,1):Period(k,2),channels)',cthr,0,0,0);%.999
        fprintf('%d-',k)
    end
    [~, gA, gW, m]=wKDICA(LFP(Period(5,1):Period(10,2),channels)',cthr,0,0,0);%.999
[nm,lost,dists]=ClusterCompO(gA,A,.1);
S(kfr).hA=A;
S(kfr).hW=W;
S(kfr).hgA=gA;
S(kfr).hgW=gW;
S(kfr).hnm=nm;
end
%%
for kfr=1:nfr
    figure(kfr)
    lnm=size(S(kfr).gA,2);
    for k=1:lnm
        fd=sum(S(kfr).nm{k}.^2,1)>10^-8;
        nmD=sum(fd);
        
        if nmD>0
            dt=bsxfun(@times,bsxfun(@rdivide,S(kfr).nm{k}(:,fd),sqrt(sum(S(kfr).nm{k}(:,fd).^2,1))),sign(S(kfr).gA(:,k)'*S(kfr).nm{k}(:,fd)));
            ny(:,k)=mean(dt,2);%GaussionProcessRegression(repmat(nx,nmD,1),dt(:),.8,.00001,nxx(:));
            %                 thetav=sqrt(var(dt,2));
            %                 muny(:,k)=thetam*ny(:,k)*nmD./(thetam*nmD+thetav);
            if 1%;ifplot
                figure(25)
                subplot(4,lnm, k+lnm*(kfr-1))%length(r),lnm,k+(nr-1)*lnm
                clim=max(abs(ny(:,k)));
                imagesc(reshape(ny(:,k),8,[]),clim*[-1 1]);
%                 plot(dt,HP)
                %                 set(gca,'YTick',ylbs,'YTicklabel',names)
%                 hold on
%                 plot(ny(:,k),HP,'b','Linewidth',3)
%                 %                 plot(muny(:,k),HP,'g--','Linewidth',3)
%                 grid on
%                 axis([-.5 .5 HP(1) HP(end)])
                title(['comp.',num2str(k)])
                xlabel(num2str(sum(fd)))
                %    axis ij
%                 hold off
%                 n=n+1;
            end
        end
    end
    S(kfr).gbwnm=ny;
end


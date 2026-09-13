function [cmdirt,cmval]=get_cm(gdirt,idx,rho2000,nth_sl,ix,iy,cut)
%% set up
vgdirt=gdirt(idx,:);
uidx = setdiff(1:size(gdirt,1), idx);
udirt=gdirt(uidx,:);

irad=1;
ngae=length(idx);
ntgt=length(uidx);

erdirt=zeros(2*ngae,3);
erdirt(1:ngae,:)=vgdirt;
erdirt(ngae+1:end,:)=-vgdirt;

pxrho=zeros(2*irad+1,2*irad+1,2*ngae);
rst2000=squeeze(rho2000(:,:,nth_sl,idx));
pxrho(:,:,1:ngae)=squeeze(rst2000(ix-irad:ix+irad,iy-irad:iy+irad,:));
pxrho(:,:,ngae+1:end)=squeeze(rst2000(ix-irad:ix+irad,iy-irad:iy+irad,:));


%% make cm: We have no idea on the size to preallocate.

cmdirt=zeros(1,3);
cmval=[];
cmidx=1; 

% loop over unknown directions
nbd=4;  % 4 neighbors
for im=1:ntgt
    for ik=1:2*ngae
        dst(ik)=norm(udirt(im,:)-erdirt(ik,:));
    end
    [~,ind]=sort(dst);
   
    idst=zeros(nbd,1);
    for ii=1:nbd
        idst(ii)=ind(ii);
    end
    
    
    val=zeros(3,3,nbd);
    vec=zeros(nbd,3);
  

    for ii=1:nbd
        val(:,:,ii)=squeeze(pxrho(:,:,idst(ii)));
        vec(ii,:)=erdirt(idst(ii),:);
    end
    
    %loop over 4 trigangles
    for it=1:4
              
        ith=circshift([1:nbd]',it-1)';
        tri_val=val(:,:,ith(1:3));
        tri_vec=vec(ith(1:3),:);
        
        valcorr=zeros(3,1);
        tmp=corrcoef(squeeze(tri_val(:,:,1)),squeeze(tri_val(:,:,2)));
        valcorr(1)=(tmp(1,2));
        tmp=corrcoef(squeeze(tri_val(:,:,2)),squeeze(tri_val(:,:,3)));
        valcorr(2)=(tmp(1,2));
        tmp=corrcoef(squeeze(tri_val(:,:,3)),squeeze(tri_val(:,:,1)));
        valcorr(3)=(tmp(1,2));
        
        if sum(valcorr > cut)==3
           w1= valcorr(1)+valcorr(3);
           w2= valcorr(1)+valcorr(2);
           w3= valcorr(2)+valcorr(3);
           w=w1+w2+w3;
           
           cmdirt(cmidx,:)=(w1*tri_vec(1,:)+w2*tri_vec(2,:)+w3*tri_vec(3,:))./w;
           cmval(cmidx)=(w1*tri_val(2,2,1)+w2*tri_val(2,2,2)+w3*tri_val(2,2,3))./w;
           cmidx=cmidx+1;
        
        end
        
        
    end
    
    
    
end

cmdirt=cmdirt(1:cmidx-1,:);
cmval=cmval(1:cmidx-1)';
[cmdirt,cmidx]=unique(cmdirt,'rows');
cmval=cmval(cmidx);

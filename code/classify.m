function [ p_label, idx] = classify( ex, Model, knn )

  clu_centers=cell2mat(Model(:,7));%΢��Ⱥ����
  no_of_cls=length(cell2mat(Model(1,4)));%΢��Ⱥ��Ŀ
[idx, D]=knnsearch(clu_centers,ex,'NSMethod','exhaustive','k',knn);%����knn��΢��Ⱥ
        dist=zeros(no_of_cls,1);%��ʼ������
        for l=1:no_of_cls%��������΢��Ⱥ
            for j=1:knn
                ix=idx(j);
                LC=cell2mat(Model(ix,8));%���б�ǩl��΢��Ⱥ����
                R=cell2mat(Model(ix,5));%��΢��ȺMC���б�ǩl��ʵ������
                pr=cell2mat(Model(ix,4));%΢��Ⱥ����
                dist(l)=dist(l)+(R*pr(l)/sum(pr))/norm(ex-LC(l,:));%p_label����
                
            end
            
        end
        
       [v, p_label]=max(dist);
end


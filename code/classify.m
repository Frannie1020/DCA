function [ p_label, idx] = classify( ex, Model, knn )

  clu_centers=cell2mat(Model(:,7));%微集群中心
  no_of_cls=length(cell2mat(Model(1,4)));%微集群数目
[idx, D]=knnsearch(clu_centers,ex,'NSMethod','exhaustive','k',knn);%基于knn的微集群
        dist=zeros(no_of_cls,1);%初始化距离
        for l=1:no_of_cls%遍历所有微集群
            for j=1:knn
                ix=idx(j);
                LC=cell2mat(Model(ix,8));%带有标签l的微集群中心
                R=cell2mat(Model(ix,5));%在微集群MC中有标签l的实例概率
                pr=cell2mat(Model(ix,4));%微集群纯度
                dist(l)=dist(l)+(R*pr(l)/sum(pr))/norm(ex-LC(l,:));%p_label计算
                
            end
            
        end
        
       [v, p_label]=max(dist);
end


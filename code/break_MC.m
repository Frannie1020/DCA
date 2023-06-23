function [ Model ] = break_MC( Model, CurrentTime )%构造breack_MC函数，由模型矩阵和当前时间组成
neg_impr=cell2mat(Model(:,6));%将单元格转化为普通数组
cls_lbls=cell2mat(Model(1,14));%带标签的微集群模型
idx=find(neg_impr<0);%neg_impr小于0的向量为初始实例x
for i=1:size(idx,1)
    cls_lb=Model{idx(i),4};%带标签的微集群
    LS=Model{idx(i),10};%线性和模型
    SS=Model{idx(i),11};%平方和模型
     
    if sum(cls_lb>0)>1%微集群的特性
        for j=1:size(cls_lb,2)
            if cls_lb(j)>1
                n_idx=size(Model,1)+1;
                Model{n_idx,1}=LS(j,:);%存储线性和
                Model{n_idx,2}=SS(j,:);%存储平方和
                Model{n_idx,3}=[cls_lb(j) 0];%存储带标签的微集群
                temp_cls_lb=zeros(1,size(cls_lb,2));%当前带标签的微集群初始化
                temp_cls_lb(j)=cls_lb(j);%所有类的实例总数
                Model{n_idx,4}=temp_cls_lb;
                Model{n_idx,5}=0;%存储更新时间，初始化为0
                Model{n_idx,6}=1;%存储重要性，初始化为1
                Model{n_idx,7}=LS(j,:)/cls_lb(j);%存储微集群中心
                temp_cls_cen=zeros(size(cls_lb,2),size(LS,2));%当前微集群中心初始化+计算
                temp_cls_cen(j,:)=LS(j,:)/cls_lb(j);
                Model{n_idx,8}=temp_cls_cen;%存储微集群中心
                
                clu_r=sqrt(sum(SS(j,:)/cls_lb(j))-sum((LS(j,:)/cls_lb(j)).^2));%微集群半径计算+存储
                Model{n_idx,9}=clu_r;
                temp_cls_cen=zeros(size(cls_lb,2),size(LS,2));
                temp_cls_cen(j,:)=LS(j,:);
                Model{n_idx,10}=temp_cls_cen;
                temp_cls_cen=zeros(size(cls_lb,2),size(LS,2));
                temp_cls_cen(j,:)=SS(j,:);
                Model{n_idx,11}=temp_cls_cen;
                
                temp_r=zeros(1,size(cls_lb,2));%重要性
                r_v=Model{idx(i),12};
                temp_r(j)=r_v(j);
                Model{n_idx,12}=temp_r;
                Model{n_idx,13}=CurrentTime;%时间
                Model{n_idx,14}=cls_lbls;
                
                temp_p=num2cell(zeros(size(cls_lb,2),2));
                temp_p{j,1}=Model{idx(i),15}{j,1};
                temp_p{j,2}=Model{idx(i),15}{j,2};
                Model{n_idx,15}=temp_p;
                
            end
        end
    end
end
 Model(idx,:)=[];%清空现有微集群模型的数据
end


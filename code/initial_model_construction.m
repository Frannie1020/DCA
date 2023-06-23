function [Model]=initial_model_construction(data,num_cluster,train_class_labels)%初始模型建立函数

train_data=data(:,1:end-1);%训练集
train_data_labels=data(:,end);%标签
%[train_class_labels, ia, cid] = unique(train_data_labels,'stable');
num_replicates=1;
[membership, ctrs] = kmeans(train_data,num_cluster,'Replicates',num_replicates,'Distance','sqEuclidean','MaxIter',1000);%K均值聚类算法的分类
Model={};
for j=1:num_cluster
    clu_pt=find(membership==j);
    
    clu_data=train_data(clu_pt,:);
    clu_labels=train_data_labels(clu_pt,1);
    N_pt=size(clu_data,1);%当前微集群实例总数（条目）
    clu_center=ctrs(j,:);
    
    LS=sum(clu_data,1);
    SS=sum(clu_data.^2,1);
        clu_r=sqrt(sum(SS/N_pt)-sum((LS/N_pt).^2));%当前微集群半径的计算
    micro_clu{1,1}=LS; % 线性和
    micro_clu{1,2}=SS; % 平方和
    N_lb=N_pt;%sum(train_data_labels(clu_pt,2));
    N_ub=N_pt-N_lb;%未被标签的实例数目
    micro_clu{1,3}=[N_lb N_ub]; %已标记和未被标记的实例数目
    
    LD=[];
    LDC=[];
    RRR=[];
    DCL=[];
    tr_samples={};%训练样本
    perpt=30;
    for i=1:size(train_class_labels)
       
        aa=train_data_labels(clu_pt,1)==train_class_labels(i);%判断新的实例是否在模型边界中
        DCL(i)=train_class_labels(i);       
        LD(i)=sum(aa);
      
        rdp=find(aa==1);

        if LD(i)<=1%类在模型边界之内
           
            tr_samples{i,1}=0;
            tr_samples{i,2}=0;
        else%类在模型边界之外，声明为新的类并存储
            X_data=train_data(clu_pt(rdp),:);
            mu=mean(X_data);
            SIGMA=cov(X_data);
        tr_samples{i,1}=mu;
        tr_samples{i,2}=SIGMA;
        end
        
        LDC(i,:)=sum(train_data(clu_pt(aa),:),1);
        cls_LS(i,:)=sum(train_data(clu_pt(aa),:),1);
        cls_SS(i,:)=sum(train_data(clu_pt(aa),:).^2,1);
        
        if LD(i)==0
            RRR(i)=0;
            LDC(i,:)=0;
        else
            RRR(i)=sqrt(sum(cls_SS(i,:)/LD(i))-sum((cls_LS(i,:)/LD(i)).^2));%微集群半径
           
            LDC(i,:)=sum(train_data(clu_pt(aa),:),1)/LD(i);%微集群中心
        end
        
    end
    
    micro_clu{1,4}=LD;
    
    micro_clu{1,5}=0; % 时间
    
    micro_clu{1,6}=1; % 重要性
    micro_clu{1,7}=clu_center; 
    micro_clu{1,8}=LDC; % 每个类的中心
    micro_clu{1,9}=clu_r; % 半径
    micro_clu{1,10}=cls_LS; % 类线性和
    micro_clu{1,11}=cls_SS; % 类线性平方和
    micro_clu{1,12}=RRR; % 每个类点半径
    micro_clu{1,13}=1;
    micro_clu{1,14}=DCL;
    micro_clu{1,15}=tr_samples; %%实例代
    Model(j,:)=micro_clu;
   
end

 Model  = cal_reability( Model );
end
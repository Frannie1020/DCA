function [Model]=initial_model_construction(data,num_cluster,train_class_labels)%��ʼģ�ͽ�������

train_data=data(:,1:end-1);%ѵ����
train_data_labels=data(:,end);%��ǩ
%[train_class_labels, ia, cid] = unique(train_data_labels,'stable');
num_replicates=1;
[membership, ctrs] = kmeans(train_data,num_cluster,'Replicates',num_replicates,'Distance','sqEuclidean','MaxIter',1000);%K��ֵ�����㷨�ķ���
Model={};
for j=1:num_cluster
    clu_pt=find(membership==j);
    
    clu_data=train_data(clu_pt,:);
    clu_labels=train_data_labels(clu_pt,1);
    N_pt=size(clu_data,1);%��ǰ΢��Ⱥʵ����������Ŀ��
    clu_center=ctrs(j,:);
    
    LS=sum(clu_data,1);
    SS=sum(clu_data.^2,1);
        clu_r=sqrt(sum(SS/N_pt)-sum((LS/N_pt).^2));%��ǰ΢��Ⱥ�뾶�ļ���
    micro_clu{1,1}=LS; % ���Ժ�
    micro_clu{1,2}=SS; % ƽ����
    N_lb=N_pt;%sum(train_data_labels(clu_pt,2));
    N_ub=N_pt-N_lb;%δ����ǩ��ʵ����Ŀ
    micro_clu{1,3}=[N_lb N_ub]; %�ѱ�Ǻ�δ����ǵ�ʵ����Ŀ
    
    LD=[];
    LDC=[];
    RRR=[];
    DCL=[];
    tr_samples={};%ѵ������
    perpt=30;
    for i=1:size(train_class_labels)
       
        aa=train_data_labels(clu_pt,1)==train_class_labels(i);%�ж��µ�ʵ���Ƿ���ģ�ͱ߽���
        DCL(i)=train_class_labels(i);       
        LD(i)=sum(aa);
      
        rdp=find(aa==1);

        if LD(i)<=1%����ģ�ͱ߽�֮��
           
            tr_samples{i,1}=0;
            tr_samples{i,2}=0;
        else%����ģ�ͱ߽�֮�⣬����Ϊ�µ��ಢ�洢
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
            RRR(i)=sqrt(sum(cls_SS(i,:)/LD(i))-sum((cls_LS(i,:)/LD(i)).^2));%΢��Ⱥ�뾶
           
            LDC(i,:)=sum(train_data(clu_pt(aa),:),1)/LD(i);%΢��Ⱥ����
        end
        
    end
    
    micro_clu{1,4}=LD;
    
    micro_clu{1,5}=0; % ʱ��
    
    micro_clu{1,6}=1; % ��Ҫ��
    micro_clu{1,7}=clu_center; 
    micro_clu{1,8}=LDC; % ÿ���������
    micro_clu{1,9}=clu_r; % �뾶
    micro_clu{1,10}=cls_LS; % �����Ժ�
    micro_clu{1,11}=cls_SS; % ������ƽ����
    micro_clu{1,12}=RRR; % ÿ�����뾶
    micro_clu{1,13}=1;
    micro_clu{1,14}=DCL;
    micro_clu{1,15}=tr_samples; %%ʵ����
    Model(j,:)=micro_clu;
   
end

 Model  = cal_reability( Model );
end
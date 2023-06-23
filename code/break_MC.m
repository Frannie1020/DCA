function [ Model ] = break_MC( Model, CurrentTime )%����breack_MC��������ģ�;���͵�ǰʱ�����
neg_impr=cell2mat(Model(:,6));%����Ԫ��ת��Ϊ��ͨ����
cls_lbls=cell2mat(Model(1,14));%����ǩ��΢��Ⱥģ��
idx=find(neg_impr<0);%neg_imprС��0������Ϊ��ʼʵ��x
for i=1:size(idx,1)
    cls_lb=Model{idx(i),4};%����ǩ��΢��Ⱥ
    LS=Model{idx(i),10};%���Ժ�ģ��
    SS=Model{idx(i),11};%ƽ����ģ��
     
    if sum(cls_lb>0)>1%΢��Ⱥ������
        for j=1:size(cls_lb,2)
            if cls_lb(j)>1
                n_idx=size(Model,1)+1;
                Model{n_idx,1}=LS(j,:);%�洢���Ժ�
                Model{n_idx,2}=SS(j,:);%�洢ƽ����
                Model{n_idx,3}=[cls_lb(j) 0];%�洢����ǩ��΢��Ⱥ
                temp_cls_lb=zeros(1,size(cls_lb,2));%��ǰ����ǩ��΢��Ⱥ��ʼ��
                temp_cls_lb(j)=cls_lb(j);%�������ʵ������
                Model{n_idx,4}=temp_cls_lb;
                Model{n_idx,5}=0;%�洢����ʱ�䣬��ʼ��Ϊ0
                Model{n_idx,6}=1;%�洢��Ҫ�ԣ���ʼ��Ϊ1
                Model{n_idx,7}=LS(j,:)/cls_lb(j);%�洢΢��Ⱥ����
                temp_cls_cen=zeros(size(cls_lb,2),size(LS,2));%��ǰ΢��Ⱥ���ĳ�ʼ��+����
                temp_cls_cen(j,:)=LS(j,:)/cls_lb(j);
                Model{n_idx,8}=temp_cls_cen;%�洢΢��Ⱥ����
                
                clu_r=sqrt(sum(SS(j,:)/cls_lb(j))-sum((LS(j,:)/cls_lb(j)).^2));%΢��Ⱥ�뾶����+�洢
                Model{n_idx,9}=clu_r;
                temp_cls_cen=zeros(size(cls_lb,2),size(LS,2));
                temp_cls_cen(j,:)=LS(j,:);
                Model{n_idx,10}=temp_cls_cen;
                temp_cls_cen=zeros(size(cls_lb,2),size(LS,2));
                temp_cls_cen(j,:)=SS(j,:);
                Model{n_idx,11}=temp_cls_cen;
                
                temp_r=zeros(1,size(cls_lb,2));%��Ҫ��
                r_v=Model{idx(i),12};
                temp_r(j)=r_v(j);
                Model{n_idx,12}=temp_r;
                Model{n_idx,13}=CurrentTime;%ʱ��
                Model{n_idx,14}=cls_lbls;
                
                temp_p=num2cell(zeros(size(cls_lb,2),2));
                temp_p{j,1}=Model{idx(i),15}{j,1};
                temp_p{j,2}=Model{idx(i),15}{j,2};
                Model{n_idx,15}=temp_p;
                
            end
        end
    end
end
 Model(idx,:)=[];%�������΢��Ⱥģ�͵�����
end


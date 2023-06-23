function [ Model ] = cal_reability( Model )

    lb_data=cell2mat(Model(:,4));%��ǩ��������
    mx=max(lb_data,[],2);%����ǩ���ݵ����ֵ
    sm=sum(lb_data,2);%����ǩ��������
   purity=max(lb_data,[],2)./sum(lb_data,2);%΢��Ⱥ����
   Model(:,5)=num2cell(purity);
     H=0;
     PD=[];
     total_lb=sum(sum(lb_data));%���б���ǩ��ʵ����
     cls_lb=sum(lb_data,1);%ÿ��΢��Ⱥ�б���ǩ��ʵ����
     for i=1:size(lb_data,2)%������ȷ������
         H=H+(-cls_lb(i)/total_lb)*log(cls_lb(i)/total_lb);%ʵ������
         PD(i)=cls_lb(i)/total_lb;%������ʵ��ռ��
     end
         
     for i=1:size(lb_data,1)
         HC=0;
         vE=0;
         if sum(lb_data(i,:))==0
             Model{i,5}=0;
         else
         for j=1:size(lb_data,2)
             PC=lb_data(i,j)/sum(lb_data(i,:));%����ʵ��ռ��
             if PC~=0
               HC=HC+(-PC)*log(PC);%����ʵ������
                
             end
             vE=vE+(PC-PD(j))/PD(j);%��error
         end
             
             CR=(H-HC)/H;%������ʵ���������Ϊ����ı�
             
             CP=1/(1+exp(-vE));%sigmoid function
             R=CR*CP;%����ʵ���������Ϊ������ı�
             if isnan(R)
                 Model{i,5}=0;
             else
                 Model{i,5}=R;
             end
         end
         
         
     end
 
end


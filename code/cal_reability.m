function [ Model ] = cal_reability( Model )

    lb_data=cell2mat(Model(:,4));%标签化的数据
    mx=max(lb_data,[],2);%被标签数据的最大值
    sm=sum(lb_data,2);%被标签数据总数
   purity=max(lb_data,[],2)./sum(lb_data,2);%微集群纯度
   Model(:,5)=num2cell(purity);
     H=0;
     PD=[];
     total_lb=sum(sum(lb_data));%所有被标签的实例数
     cls_lb=sum(lb_data,1);%每个微集群中被标签的实例数
     for i=1:size(lb_data,2)%分类正确率评估
         H=H+(-cls_lb(i)/total_lb)*log(cls_lb(i)/total_lb);%实例总数
         PD(i)=cls_lb(i)/total_lb;%现有类实例占比
     end
         
     for i=1:size(lb_data,1)
         HC=0;
         vE=0;
         if sum(lb_data(i,:))==0
             Model{i,5}=0;
         else
         for j=1:size(lb_data,2)
             PC=lb_data(i,j)/sum(lb_data(i,:));%新类实例占比
             if PC~=0
               HC=HC+(-PC)*log(PC);%新类实例总数
                
             end
             vE=vE+(PC-PD(j))/PD(j);%总error
         end
             
             CR=(H-HC)/H;%现有类实例被误分类为新类的比
             
             CP=1/(1+exp(-vE));%sigmoid function
             R=CR*CP;%新类实例被误分类为现有类的比
             if isnan(R)
                 Model{i,5}=0;
             else
                 Model{i,5}=R;
             end
         end
         
         
     end
 
end


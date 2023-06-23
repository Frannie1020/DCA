load patients SelfAssessedHealthStatus Height Weight     
HealthStatus = categorical(SelfAssessedHealthStatus);    
summary(HealthStatus) 
scatter(Height,Weight,[],HealthStatus,'filled')
xlabel('Height')
ylabel('Weight')
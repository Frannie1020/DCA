load patients SelfAssessedHealthStatus Height Weight     
HealthStatus = categorical(SelfAssessedHealthStatus);    
summary(HealthStatus) 
X1 = Weight(HealthStatus=='Excellent');
Y1 = Height(HealthStatus=='Excellent');
X2 = Weight(HealthStatus=='Fair');
Y2 = Height(HealthStatus=='Fair');
X3 = Weight(HealthStatus=='Good');
Y3 = Height(HealthStatus=='Good');
X4 = Weight(HealthStatus=='Poor');
Y4 = Height(HealthStatus=='Poor');
figure
subplot(1,2,1);
h1 = scatter(X1,Y1,'o');
hold on
h2 = scatter(X2,Y2,'x');
title('Height vs. Weight')
xlabel('Weight (lbs)')
ylabel('Height (in)');
subplot(1,2,2);
h1 = scatter(X3,Y3,'o');
hold on
h2 = scatter(X4,Y4,'x');
title('Height vs. Weight')
xlabel('Weight (lbs)')
ylabel('Height (in)');
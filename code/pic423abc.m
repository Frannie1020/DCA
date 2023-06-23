x1=500:500:3000;
x2=1:2:11;
x3=0:25:150;
t1=[23.98,24.10,25.47,26.69,27.88,28.10]; 
t2=[24.10,24.33,25.22,26.31,27.10,27.45];
t3=[25.20,24.88,24.33,24.20,23.56,23.10,22.97];
subplot(1,3,1);
plot(x1,t1,'-*r'); %线性，颜色，标记
axis([500,3000,0,60])  %确定x轴与y轴框图大小
set(gca,'XTick',[500:250:3000]);
set(gca,'YTick',[0:10:60]);
title('(a)Blocksize vs error');
xlabel('S');
ylabel('error');
subplot(1,3,2);
plot(x2,t2,'-db');
axis([1,11,0,60]) 
set(gca,'XTick',[1:1:11]);
set(gca,'YTick',[0:10:60]);
title('(b)Number of nearest neighbors vs error');
xlabel('κ');
ylabel('error');
subplot(1,3,3);
plot(x3,t3,'-pg');
axis([0,150,0,60]) 
set(gca,'XTick',[0:25:150]);
set(gca,'YTick',[0:10:60]);
title('(c)Number of clusters vs error');
xlabel('K');
ylabel('error');
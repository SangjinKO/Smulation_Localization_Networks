close all
clear
runs=1;
pointct = 25;%1:10:1000;
senselen = 250;%1:2:250;
data=zeros(length(pointct),length(senselen),runs);
error=zeros(length(pointct),length(senselen),runs);
for i=1:length(pointct)
    for j=1:length(senselen)
        for k=1:runs
            [data(i,j,k), error(i,j,k)]=mobiletest(pointct(i),senselen(j));
        end
    end
end

result = mean(data,3);

function [percent,error] = mobiletest( points, senselen )
noisestd = 5;
sense=senselen;  %sense distance
k=points+3; %3 known points
p=zeros(k,2);
pa=zeros(k,2); %found points
dist=zeros(k);
distnoise=zeros(k);
known=zeros(k,1); %is the location known

%allocate the points
for i = 4:k
    for d=1:2 %2 dimensions
        p(i,d) = rand*250;
    end
end
%allocate static points
p(1,1)=0; p(1,2)=0; %0,0
p(2,1)=5; p(2,2)=0; %5,0
p(3,1)=0; p(3,2)=5; %0,5

for i=1:k
    for j=1:k
           %if i==j continue; end
           %distance between points
           dist(i,j)=sqrt(((p(i,1)-p(j,1)).^2 + (p(i,2)-p(j,2)).^2)); 
           distnoise(i,j)=dist(i,j)+normrnd(0,noisestd);
           %strengths(i,j) = (100)/(dist.^2);
    end
end

%1st step of denoising - average each direction, assumptions are made here
for i=1:k
    for j=1:k
        m=(distnoise(i,j) + distnoise(j,i)) /2;
        distnoise(i,j)=m;
        distnoise(j,i)=m;
    end
end

%static poitnts are known
known(1)=1; pa(1,1)=0; pa(1,2)=0; %0,0
known(2)=1; pa(2,1)=5; pa(2,2)=0; %5,0
known(3)=1; pa(3,1)=0; pa(3,2)=5; %0,5


change=1; %see if we found any points on that itteration
while change==1
    change=0;
    for i=4:k%for each node
        if known(i)==1%if we already know where we are, don't do extra work
            continue
        end
        first=1;
        
        ci=0;
        c=zeros(k);
        
        for j=1:k
            if(known(j)==1 && distnoise(i,j)<=sense)%see if we have 3 neighbors
                ci=ci+1;
                c(ci)=j;
                if(ci==3)
                    break;
                end
            end
        end
        if(ci==3)%we have 3 neighbors
            change=1;
            %between each set of points
            [ax,ay]=circcirc(pa(c(1),1),pa(c(1),2),distnoise(c(1),i),pa(c(2),1),pa(c(2),2),distnoise(c(2),i));
            [bx,by]=circcirc(pa(c(3),1),pa(c(3),2),distnoise(c(3),i),pa(c(2),1),pa(c(2),2),distnoise(c(2),i));
            %find one that is the same
            %find the one that is the closest to the actual
            s1=abs(ax(1)-bx(1))+abs(ay(1)-by(1));
            s2=abs(ax(2)-bx(2))+abs(ay(2)-by(2));
            s3=abs(ax(1)-bx(2))+abs(ay(1)-by(2));
            s4=abs(ax(2)-bx(1))+abs(ay(2)-by(1));
            %see if any are out of range
            if(ax(1)<-5)
                s1=inf;
                s3=inf;
            end
            if(ax(2)<-5)
                s2=inf;
                s4=inf;
            end
            if(ay(1)<-5)
                s1=inf;
                s3=inf;
            end
            if(ay(2)<-5)
                s2=inf;
                s4=inf;
            end
            
            %find the best option
            
            if(s1<s2 && s1<s3 && s1<s4)
                pa(i,1)=ax(1);
                pa(i,2)=ay(1);
            end
            if(s2<s1 && s2<s3 && s2<s4)
                pa(i,1)=ax(2);
                pa(i,2)=ay(2);
            end
            if(s3<s1 && s3<s2 && s3<s4)
                pa(i,1)=ax(1);
                pa(i,2)=ay(1);
            end
            if(s4<s1 && s4<s2 && s4<s3)
                pa(i,1)=ax(2);
                pa(i,2)=ay(2);
            end
            known(i)=1;
        end
    end
end
error = sum( sqrt(((pa(:,1)-p(:,1)).^2 + (pa(:,2)-p(:,2)).^2)))/length(pa);
scatter(p(:,1),p(:,2));
figure
scatter(pa(:,1),pa(:,2));
percent = (sum(known)-3) / (length(known)-3);
end
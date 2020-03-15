clear

% HOW TO TEST
% Changable variables : 'runs, knowns'
% In case 'pointct, senselen' are changed, you MUST reset figures1~5

% Variables
pointct = 1:50:1000; %Number of nodes
senselen = 1:5:250; %Range(=signal strength=sensing distance) of nodes
runs=100; %Number of trials
knowns=6; %Number of known nodes (3,6,9 or 12)

% Data sets
result_Data = {};% list of data sets
data1=zeros(length(pointct),length(senselen),runs); %1.Probability of localization
data2 = cell(length(pointct), length(senselen), runs); %2.locations of all nodes
data3 = cell(length(pointct), length(senselen), runs); %3.locations of known nodes

% Getting probability of localization of nodes given that
% 1)varying number of randomly distributed nodes
% 2)varing signal strength of nodes(each nodes has same signal strength)
for i=1:length(pointct)
    for j=1:length(senselen)
        parfor k=1:runs %Pararell execution
            fprintf('# of NODES: %d // RANGE: %d\n',i*50,j*10);
            result_Data = mobiletest(pointct(i),senselen(j),knowns);
            data1(i,j,k) = result_Data{1};%1.Probability of localization
            data2(i,j,k) = {result_Data{2}};%2.locations of all nodes
            data3(i,j,k) = {result_Data{3}};%3.locations of known nodes
            
        end
    end
end

% Averages of number of nodes, range of nodes (Subspaces)
result1 = mean(data1,3);

% figure1 : Probability of Localization (depends on the number of nodes)
figure(1);
hold on
plot(pointct,result1(:,10),'or');%range1=50
plot(pointct,result1(:,20),':');%range2=100
plot(pointct,result1(:,30),'-.');%range3=150
plot(pointct,result1(:,40),'--');%range4=200
plot(pointct,result1(:,50));%range5=250
legend('range1=50m','range2=100m','range3=150m','range4=200m','range5=250m');
title('Probability of Localization');
xlabel('Number of Nodes');
ylabel('Known/All Nodes');
hold off

% figure2 : Probability of Localization (depends on the range of nodes)
figure(2);
hold on
plot(senselen,result1(5,:),':');%Nodes = 250
plot(senselen,result1(10,:),'-.');%Nodes=500
plot(senselen,result1(15,:),'--');%Nodes=750
plot(senselen,result1(20,:));%Nodes=1000
legend('Nodes=250', 'Nodes=500', 'Nodes=750', 'Nodes=1000');
title('Probability of Localization');
xlabel('Range(Sensing Distance)');
ylabel('Known/All Nodes');
hold off

% figure3~5 : distribution of nodes (All & Known(Found) nodes)
% figure3 : CASE1 (Nodes : 400, Range: 50m(Bluetooth under severe Env.))
% figure4 : CASE2 (Nodes : 400, Range: 100m(Optimal Bluetooth))
% figure5 : CASE3 (Nodes : 400, Range: 200m(Optimal WiFi))
figure(3);
result2 = data2{8,10,1};%given ith(number), jth(range) and kth k(trial)
scatter(result2(:,1),result2(:,2));
hold on
result3 = data3{8,10,1};%given ith(number), jth(range) and kth k(trial)
scatter(result3(:,1),result3(:,2),'filled');
title('Distribution of Nodes (Bluetooth under severe Env.)');
hold off

figure(4);
result2 = data2{8,20,8};%given ith(number), jth(range) and kth k(trial)
scatter(result2(:,1),result2(:,2));
hold on
result3 = data3{8,20,8};%given ith(number), jth(range) and kth k(trial)
scatter(result3(:,1),result3(:,2),'filled');
title('Distribution of Nodes (Optimal Bluetooth)');
hold off

figure(5);
result2 = data2{8,30,1};%given ith(number), jth(range) and kth k(trial)
scatter(result2(:,1),result2(:,2));
hold on
result3 = data3{8,30,1};%given ith(number), jth(range) and kth k(trial)
scatter(result3(:,1),result3(:,2),'filled');
title('Distribution of Nodes (Optimal WiFi)');
hold off


% FUNCTION> Getting probability of localization of nodes
function result = mobiletest( points, senselen, knowns)
k_nodes = knowns; %Number of known nodes
n_nodes = knowns + 1;%Index of first unknown nodes
sense=senselen;  %Range(sensing distance) of nodes'
k=points+k_nodes; %Number of nodes including known knodes
p=zeros(k,2); %All nodes (i=x,j=y)
pa=zeros(k,2); %Known nodes (i=x,j=y)
dist=zeros(k); %Distances between two nodes ( Dist x,y )
known=zeros(k,1); %Known nodes (i=index of nodes, j='1' if known)

% Randomly allocate nodes in '2 simensions' within '250 * 250 size'
for i = n_nodes:k %except for known nodes
    for d=1:2 %2 dimensions
        p(i,d) = rand*1000; %within 1000*1000 size (1km * 1km square room)
    end
end

% Allocate known/static nodes 
% Assumption1: known/static nodes exist at the edges of square area
if k_nodes >= 3
    p(1,1)=0; p(1,2)=0; % x,y => 0,0
    p(2,1)=5; p(2,2)=0; % x,y => 5,0
    p(3,1)=0; p(3,2)=5; % x,y => 0,5    
end
if k_nodes >= 6
    p(4,1)=1000; p(4,2)=1000; % x,y => 1000,1000
    p(5,1)=995; p(5,2)=1000; % x,y => 995,1000
    p(6,1)=1000; p(6,2)=995; % x,y => 1000,995
end
if k_nodes >= 12
    p(7,1)=0; p(7,2)=1000; % x,y => 0,1000
    p(8,1)=5; p(8,2)=1000; % x,y => 5,1000
    p(9,1)=0; p(9,2)=995; % x,y => 0,995
    p(10,1)=1000; p(10,2)=0; % x,y => 1000,0
    p(11,1)=995; p(11,2)=0; % x,y => 995,0
    p(12,1)=1000; p(12,2)=5; % x,y => 1000,5
end

% Caculating distances between two nodes(node i and node j) 
for i=1:k
    for j=1:k
           % Distance between points by square root
           dist(i,j)=sqrt(((p(i,1)-p(j,1)).^2 + (p(i,2)-p(j,2)).^2)); 
    end
end

% Allocate known/static nodes and set them as known nodes
if k_nodes >= 3
    known(1)=1; pa(1,1)=0; pa(1,2)=0; % x,y => 0,0
    known(2)=1; pa(2,1)=5; pa(2,2)=0; % x,y => 5,0
    known(3)=1; pa(3,1)=0; pa(3,2)=5; % x,y => 0,5
end
if k_nodes >= 6
    known(4)=1; pa(4,1)=1000; pa(4,2)=1000; % x,y => 1000,1000
    known(5)=1; pa(5,1)=995; pa(5,2)=1000; % x,y => 995,1000
    known(6)=1; pa(6,1)=1000; pa(6,2)=995; % x,y => 1000,995
end
if k_nodes >= 12
    known(7)=1; pa(7,1)=0; pa(7,2)=1000; % x,y => 0,1000
    known(8)=1; pa(8,1)=5; pa(8,2)=1000; % x,y => 5,1000
    known(9)=1; pa(9,1)=0; pa(9,2)=995; % x,y => 0,995
    known(10)=1; pa(10,1)=1000; pa(10,2)=0; % x,y => 1000,0
    known(11)=1; pa(11,1)=995; pa(11,2)=0; % x,y => 995,0
    known(12)=1; pa(12,1)=1000; pa(12,2)=5; % x,y => 1000,5
end



change=1; %Check bit for interation(see if we found any nodes on each loop)
while change==1
    change=0;
    
    % Sense and localize nodes for each nodes (except known/fixed nodes)
    for i=n_nodes:k
        
        % If it is a already found node, don't do extra work
        if known(i)==1
            continue
        end
        
        ci=0; %Number of neighbor nodes (0, 1, 2, or 3)
        c=zeros(3); %Index of neighbor nodes
        for j=1:k
            
            % Sense a node within a range of a known(already found) node
            % (Assumption2: All nodes have same signal strength)
            if(known(j)==1 && dist(i,j)<=sense)%See if a node has 3 neighbors
                ci=ci+1;
                c(ci)=j;
                if(ci==3)
                    break;
                end
            end
            
        end
        
        % If a node has 3 neighbors, caculating its position based on RSSI
        if(ci==3)%We have 3 neighbors
            change=1;
            
            % Caculate relative position between each set of nodes
            % There are 2 points at which two circles intersect => total 4 points
            [ax,ay]=circcirc(pa(c(1),1),pa(c(1),2),dist(c(1),i),pa(c(2),1),pa(c(2),2),dist(c(2),i));
            [bx,by]=circcirc(pa(c(3),1),pa(c(3),2),dist(c(3),i),pa(c(2),1),pa(c(2),2),dist(c(2),i));
            
            % Find one that is the same to localize a node among 4 points
            % Marginal error : 5mm
            if(abs(ax(1)-bx(1))<.001 && abs(ay(1)-by(1))<.001)
                pa(i,1)=ax(1);
                pa(i,2)=ay(1);
            end
            if(abs(ax(2)-bx(2))<.001 && abs(ay(2)-by(2))<.001)
                pa(i,1)=ax(2);
                pa(i,2)=ay(2);
            end
            if(abs(ax(1)-bx(2))<.001 && abs(ay(1)-by(2))<.001)
                pa(i,1)=ax(1);
                pa(i,2)=ay(1);
            end
            if(abs(ax(2)-bx(1))<.001 && abs(ay(2)-by(1))<.001)
                pa(i,1)=ax(2);
                pa(i,2)=ay(2);
            end
            
            known(i)=1;
        end
    end
end

% Probability of localizing nodes (How many nodes can be found except 6 known knodes?)
percent = (sum(known)-k_nodes) / (length(known)-k_nodes);
all_nodes = p;
known_nodes = pa;
result = {percent,all_nodes,known_nodes};
end

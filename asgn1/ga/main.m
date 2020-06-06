clear;
clc;
tStart = tic; % �㷨��ʱ��
%%%%%%%%%%%%�Զ������%%%%%%%%%%%%%
load tspdata.mat
times=1;
cityNum=1000;
cities=tspdata;
cities = cities';
maxGEN = 10000;
popSize = 100; % �Ŵ��㷨��Ⱥ��С
crossoverProbabilty = 0.9; %�������
mutationProbabilty = 0.9; %�������
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
gbest = 1000;
% ������ɳ���λ��
%cities = rand(2,cityNum) * 100;%100����Զ����
% �����������ɵĳ��о���
distances = calculateDistance(cities);
% ������Ⱥ��ÿ���������һ��·��
pop = zeros(popSize, cityNum);
for i=1:popSize
    pop(i,:) = randperm(cityNum);
end
offspring = zeros(popSize,cityNum);
%����ÿ������С·�����ڻ�ͼ
minPathes = zeros(maxGEN,1);
% GA�㷨
for  gen=1:maxGEN
    % ������Ӧ�ȵ�ֵ����·���ܾ���
    [fval, sumDistance, minPath, maxPath] = fitness(distances, pop);
    % ���̶�ѡ��
    tournamentSize=4; %���ô�С
    for k=1:popSize
        % ѡ�񸸴����н���
        tourPopDistances=zeros( tournamentSize,1);
        for i=1:tournamentSize
            randomRow = randi(popSize);
            tourPopDistances(i,1) = sumDistance(randomRow,1);
        end
        % ѡ����õģ���������С��
        parent1  = min(tourPopDistances);
        [parent1X,parent1Y] = find(sumDistance==parent1,1, 'first');
        parent1Path = pop(parent1X(1,1),:);
        for i=1:tournamentSize
            randomRow = randi(popSize);
            tourPopDistances(i,1) = sumDistance(randomRow,1);
        end
        parent2  = min(tourPopDistances);
        [parent2X,parent2Y] = find(sumDistance==parent2,1, 'first');
        parent2Path = pop(parent2X(1,1),:);
        subPath = crossover(parent1Path, parent2Path, crossoverProbabilty);%����
        for i=1:times
            subPath = mutate(subPath, mutationProbabilty);%����
        end
        offspring(k,:) = subPath(1,:);
        minPathes(gen,1) = minPath;
    end
    fprintf('����:%d   ���·��:%.2fKM \n', gen,minPath);
    % ����
    Twopop=[pop;offspring];
    [fitnessvar1,sumDistances1,minPath1, maxPath1] = fitness( distances, Twopop );
    [val,ind]=sort(sumDistances1);
    nextpop=Twopop(ind(1:100),:);
    pop = nextpop;
% pop=offspring;
    % ������ǰ״̬�µ����·��
    if minPath < gbest
        gbest = minPath;
        paint(cities, pop, gbest, sumDistance,gen);
    end
    % figure
    plot(minPathes, 'MarkerFaceColor', 'red','LineWidth',1);
    title('��������ͼ��ÿһ�������·����');
    set(gca,'ytick',500:100:5000);
    ylabel('·������');
    xlabel('��������');
    grid on
end
tEnd = toc(tStart);
fprintf('ʱ��:%d ��  %f ��.\n', floor(tEnd/60), rem(tEnd,60));
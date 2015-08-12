%% Mini Matlab 5
% Kelvin Lin Spencer Chan Neema Aggarararagagrgagrgaggargrgagrwal
clc; clear all; close all;
%% svm
trainingdat = dlmread('./australian.csv',' ');

x = trainingdat(:,2:end);
y = trainingdat(:,1);
dataset = prtDataSetClass(x(1:345,:),y(1:345));
dataset2 = prtDataSetClass(x(346:690,:),y(346:690));

gamma = 0.01:0.01:1;
cost = 1:20;

iter = numel(gamma)*numel(cost);
score = zeros([numel(cost), numel(gamma)]);
h = waitbar(0);
% iterate over gammas and costs
for gi = 1:length(gamma)
    for ci = 1:length(cost)
        classSvm = prtClassLibSvm('gamma',gamma(gi),'cost',cost(ci));
        PreProcPca = prtPreProcPca;
        PreProcPca.nComponents = 12;
        class = prtPreProcZmuv + PreProcPca + classSvm + prtDecisionMap;
        class = class.train(dataset);
        classRun = run(class,dataset2);
        score(ci,gi) = prtScorePercentCorrect(classRun);
%         truth = dataset2.getTargets;
%         yOutKfolds = classSvm.kfolds(dataset2,2);
%         
%         [nVotes,guess] = max(yOutKfolds.getObservations,[],2);
%         
%         subplot(1,1,1);
%         prtScoreConfusionMatrix(guess,truth,dataset2.uniqueClasses,dataset2.getClassNames);
%         close;
%         score(gi,ci) = 1-sum(guess-truth)/numel(truth);
        h = waitbar(((gi-1)*length(cost) + (ci-1))/iter,h,[num2str(round(((gi-1)*length(cost) + (ci-1))/iter*100)) '%']);
    end
end
close(h);
disp('Done iterating')
% Find optimal values
max_score = max(max(score));
[max_ind_c max_ind_g] = find(score == max_score);
gamma_opt = gamma(max_ind_g);
cost_opt = cost(max_ind_c);

figure
[gp cp] = meshgrid(gamma,cost);
surf(gp,cp,score,'EdgeColor','none');
title('Score Map')
xlabel('\gamma');
ylabel('C');
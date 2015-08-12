% Kelvin Lin
% Makeene the Trees

% Kaggle
close all;clear all;clc;
trainingdat = csvread('training.csv',1);
testingdat = csvread('testing.csv',1);
ID = testingdat(:,1);
testingdat = prtDataSetClass([testingdat(:,2:11) bi2de(testingdat(:,12:55))]);

x = [trainingdat(:,2:11) bi2de(trainingdat(:,12:55))];
y = trainingdat(:,56);
dataset = prtDataSetClass(x,y);
% dataset2 = prtDataSetClass(x(2001:4000,:),y(2001:4000));

% classTree = prtClassTreeBaggingCap('nTrees',1000,'nFeatures',10);
% classTree = prtPreProcZeroMeanColumns + classTree + prtDecisionMap; % 72%


% classTree = prtClassKnn + prtDecisionMap;
% classTree = prtClassKnn + classTree;
% classBoost = prtClassAdaBoost;
% classBoost = prtPreProcZmuv + prtPreProcPca + classBoost;
% classTree = classTree + classBoost;
% classTree = classTree.train(dataset);
% data2out = run(classTree,dataset2);
% 
classTree = prtPreProcZeroMeanColumns + ;
% classTree.internalDecider = prtDecisionMap;
truth = dataset.getTargets; %the true class labels
proc = classTree.kfolds(dataset,5); %10-Fold cross-validation
% classTree = classTree.train(dataset);
% [nVotes,guess] = max(dataout.getObservations,[],2);
% prtScorePercentCorrect(classTree.run(dataset))

[nVotes,guess] = max(proc.getObservations,[],2);

subplot(1,1,1); 
prtScoreConfusionMatrix(guess,truth,dataset.uniqueClasses,dataset.getClassNames);


%%
clc;
% testingdat2 = testingdat;
% testingdat2 = run(proc,testingdat);
% classTree = classTree.train(dataset);
testingdat2 = run(classTree,testingdat);

[val,dataout] = max(testingdat2.data,[],2);
dataout = [ID,dataout];
csvwrite('output.csv',dataout);


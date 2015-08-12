clc;

test = csvread('testing.csv',1);
train = csvread('training.csv',1);

x = test(:,1:11);
y = test(:,55);
traindata = prtDataSetClass(x,y)

% train = prtDataGenUnimodal;
% test = prtDataGenUnimodal;

classifier = prtClassMap;
classifier = classifier.train(traindata);
classified = run(classifier, traindata);



 %    Test` = prtDataGenUnimodal;       % Create some test and
 %    TrainingDataSet = prtDataGenUnimodal;   % training data
 %    classifier = prtClassMap;               % Create a classifier
 %    classifier = classifier.train(TrainingDataSet);    % Train
 %    classified = run(classifier, TestDataSet);         % Test
 %
 %    subplot(2,1,1); classifier.plot;  % Plot results
 %    subplot(2,1,2); prtScoreRoc(classified,TestDataSet);
 %    set(get(gca,'Children'), 'LineWidth',3) 
 
truth = traindata.getTargets; %the true class labels
yOutKfolds = classifier.kfolds(traindata,10); %10-Fold cross-validation

%We need to parse the output of the KNN classifier to turn vote counts into
%class guesses - for each observation, our guess is the column with the
%most votes!
[nVotes,guess] = max(yOutKfolds.getObservations,[],2);

subplot(1,1,1); %don't plot in the last figure window.
prtScoreConfusionMatrix(guess,truth,traindata.uniqueClasses,traindata.getClassNames);
% title('Iris Classification Confusion Matrix');
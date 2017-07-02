function [training, trainingclass, validation, validationclass, test, testclass] = splitData(data, class)

% Split the dataset according to samples' class
datac0 = data(class == 0, :);
datac1 = data(class == 1, :);

% Divide class 0 in training, validation and test
% Shuffle
[nrows0, ~] = size(datac0);
shrows0 = randperm(nrows0);
datac0 = datac0(shrows0, :);
% Divide
nrowstra0 = fix(0.5 * nrows0);
nrowsval0 = fix(0.25 * nrows0);
training0 = datac0(1:nrowstra0, :);
validation0 = datac0((nrowstra0 + 1):(nrowstra0 + 1 + nrowsval0), :);
test0 = datac0((nrowstra0 + 1 + nrowsval0 + 1):end, :);

% Divide class 1 in training, validation and test
% Shuffle
[nrows1, ~] = size(datac1);
shrows1 = randperm(nrows1);
datac1 = datac1(shrows1, :);
% Divide
nrowstra1 = fix(0.5 * nrows1);
nrowsval1 = fix(0.25 * nrows1);
training1 = datac1(1:nrowstra1, :);
validation1 = datac1((nrowstra1 + 1):(nrowstra1 + 1 + nrowsval1), :);
test1 = datac1((nrowstra1 + 1 + nrowsval1 + 1):end, :);

% Since class 1 is unbalanced, lets replicate the training and validation
% sets to have the same size as class 0's training and validation sets
replications = fix(nrows0 / nrows1);
training1 = repmat(training1, replications, 1);
validation1 = repmat(validation1, replications, 1);

% Merge the training, validation and test sets
% Training
[nrowstra0, ~] = size(training0);
[nrowstra1, ~] = size(training1);
trainingclass = [zeros(nrowstra0, 1); ones(nrowstra1, 1)];
training = [training0; training1];
% Shuffle
[nrowstra, ~] = size(training);
shrowstra = randperm(nrowstra);
training = training(shrowstra, :);
trainingclass = trainingclass(shrowstra, :);

% Validation
[nrowsval0, ~] = size(validation0);
[nrowsval1, ~] = size(validation1);
validationclass = [zeros(nrowsval0, 1); ones(nrowsval1, 1)];
validation = [validation0; validation1];
% Shuffle
[nrowsval, ~] = size(validation);
shrowsval = randperm(nrowsval);
validation = validation(shrowsval, :);
validationclass = validationclass(shrowsval, :);

% Test
[nrowstes0, ~] = size(test0);
[nrowstes1, ~] = size(test1);
testclass = [zeros(nrowstes0, 1); ones(nrowstes1, 1)];
test = [test0; test1];
end
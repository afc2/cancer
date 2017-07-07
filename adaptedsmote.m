function [training, trainingclass, validation, validationclass, test, testclass] = adaptedsmote(data, class, k)

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

% Apply the adapted SMOTE algorithm to the training set and to the validation set
% of the unbalanced class
training1 = adaptedsmotealgorithm([training0; training1], [zeros(size(training0, 1), 1); ones(size(training1, 1), 1)], training1, k);
validation1 = adaptedsmotealgorithm([validation0; validation1], [zeros(size(validation0, 1), 1); ones(size(validation1, 1), 1)], validation1, k);

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

function newdata = adaptedsmotealgorithm(data, class, minoritydata, k)

% Preallocate for performance
newdata = zeros((k + 1) * size(minoritydata, 1), size(minoritydata, 2));

% Since the nearest neighbor is always the own sample, we search for its
% k+1 closest neighbors and discard the first one
IDX = knnsearch(data, minoritydata, 'k', (k + 1));
IDX = IDX(:, 2:end);

% Generate the synthetic samples
for i = 1:size(IDX, 1)
    newdata(((i - 1) * (k + 1)) + 1, :) = data(i, :);
    for j = 1:size(IDX, 2)
        if (class(IDX(i, j), 1) == 1) % Belongs to the minority class
            newdata(((i - 1) * (k + 1)) + j, :) = minoritydata(i, :) + (rand * (data(IDX(i, j), :) - minoritydata(i, :)));
        else % Belongs to the majority class
            newdata(((i - 1) * (k + 1)) + j, :) = minoritydata(i, :) + ((rand / 2) * (data(IDX(i, j), :) - minoritydata(i, :)));
        end
    end
end
end
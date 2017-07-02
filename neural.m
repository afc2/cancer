% Read the mammography dataset
data = csvread('mammography-consolidated.csv');

% Put the samples' class in another variable
class = data(:, end);
data = data(:, 1:(end - 1));

% Split the dataset
% Training: 50%
% Validation: 25%
% Test: 25%
[training, trainingclass, validation, validationclass, test, testclass] = splitData(data, class);

% Write to a csv file
csvwrite('mammography-consolidated-training.csv', [training, trainingclass])
csvwrite('mammography-consolidated-validation.csv', [validation, validationclass])
csvwrite('mammography-consolidated-test.csv', [test, testclass])
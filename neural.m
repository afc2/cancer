% Read the mammography dataset
data = csvread('mammography-consolidated.csv');

% Put the samples' class in another variable
class = data(:, end);
data = data(:, 1:(end - 1));

% Normalize data
% Values are between 0-1
data = normalizedata(data);
 
% Split the dataset
% Training: 50%
% Validation: 25%
% Test: 25%
%[training, trainingclass, validation, validationclass, test, testclass] = splitData(data, class);
%[training, trainingclass, validation, validationclass, test, testclass] = oversample(data, class);

[training, trainingclass, validation, validationclass, test, testclass] = undersample(data, class);

% Write to a csv file
csvwrite('mammography-consolidated-training-undersample.csv', [training, trainingclass])
csvwrite('mammography-consolidated-validation-undersample.csv', [validation, validationclass])
csvwrite('mammography-consolidated-test-undersample.csv', [test, testclass])
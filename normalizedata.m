function data = normalizedata(data)

% Perform 0-1 normalization

maxvalues = max(data);
minvalues = min(data);

data = (data - repmat(minvalues, size(data, 1), 1)) ./ repmat((maxvalues - minvalues), size(data, 1), 1);
end
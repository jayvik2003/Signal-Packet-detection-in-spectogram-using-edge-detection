% Sample test data
tses = [1, 4, 7, 10];  % Example timestamps
time_bins = zeros(1, 10);  % Initialize time_bins with zeros

% Original code logic
for i = 1:length(tses) - 1
    startIdx = tses(i);
    endIdx = tses(i + 1);
    if endIdx - startIdx > 1
        time_bins(startIdx + 1:endIdx - 1) = 1;
    end
end

% Display results
disp('tses:');
disp(tses);
disp('Resulting time_bins:');
disp(time_bins);

% Verify the output
expected_output = [0 1 1 0 1 1 0 1 1 0];
assert(isequal(time_bins, expected_output), 'Test failed: time_bins does not match expected output.');
disp('Test passed: time_bins matches expected output.');






% load('../DATASET1_1_TEST/mat_ax.mat','waveform_ax');
% waveform = waveform_ax();
% w = waveform';
% fs = 20e6;  
% t = (0:length(w)-1)/fs;
% W = [ fft(w) fft(w).*(cos(2*pi*(3e6./20e6).*t)) ]; 
% w1 = ifft(W);
% 
% nwin = 256; 
% overlap = ceil(nwin * 0.55); 
% win = gausswin(nwin); 
% 
% szeropad = [zeros(1, nwin), w1, zeros(1, nwin)]';
% [S, ~, ~] = stft(szeropad, fs, 'Window', win, 'OverlapLength', overlap);
% 
% figure;
% subplot(3,1,1)
% imagesc(abs(S))
% subplot(3,1,2)
% plot(abs(fft(w1)));
% subplot(3,1,3)
% plot(abs(fft(w)))
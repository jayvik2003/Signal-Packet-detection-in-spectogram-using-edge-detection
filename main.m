% Load waveform data
load('../DATASET1_1_TEST/mat_ax.mat', 'waveform_g','waveform_ax');
% waveform = waveform_ax()';
% waveform = [zeros(1,1000) waveform zeros(1,1000)];
waveform = fadedSignal_ray';
total_B = 40e6;  
signal_B = 20e6; 
fs = 20e6;  
nwin = 256;
waveform1 = resample(waveform, 2, 1);

% Transforming the ground truth 
[GT_S]=compute_stft(waveform1, fs, nwin);

% Define ranges for SNR and peaks
snr_range = 0:1:10;       % SNR range from 0 to 10 dB
peaks_range = 10:20:200;  % Peaks range from 10 to 110, in steps of 10

% Initialize matrix to store comparison results
comparison_matrix = zeros(length(snr_range), length(peaks_range));

% Loop over each target SNR and peak value
for i = 1:length(snr_range)
    for j = 1:length(peaks_range)
        % Set current SNR and peak parameters
        target_snr = snr_range(i);
        peaks = peaks_range(j);
        
        % Calculate adjusted SNR for AWGN
        new_SNR = target_snr - 10 * log10(total_B / signal_B);
        
        % Apply AWGN to waveform
        noisy_waveform = apply_AWGN(waveform1, new_SNR);

        % Compute STFT
        [noisy_S] = compute_stft(noisy_waveform, fs, nwin);

        % Perform edge detection and Hough Transform with current peaks value
        [projected_S, theta, rho, edges] = perform_edge_detection(noisy_S, peaks);

        % Bin and estimate
        [S_hat, time_bins, freq_bins, ...
            time_hist_S, freq_hist_S, ...
            time_hist_estimate_S, freq_hist_estimate_S] = bin_and_estimate(projected_S, noisy_S);

        % Calculate similarity using Correlation Coefficient (M5)
        corr_coeff = corr2(abs(GT_S), abs(S_hat));
        
        % Store Correlation Coefficient in the matrix
        comparison_matrix(i, j) = corr_coeff; % comaparison matrix between estimated S and ground truth S
    end
end

% Display the comparison matrix as a heatmap
figure;
pcolor(peaks_range, snr_range, abs(comparison_matrix));
colorbar;
xlabel('Number of Peaks');
ylabel('Target SNR (dB)');




% figure;
% 
% % Plot the original 2D matrix (STFT magnitude)
% subplot(2,2,1);
% imagesc(abs(S)); 
% title('Original 2D Matrix');
% colorbar;
% xlabel('Time ');
% ylabel('Frequency ');
% 
% % Plot the filtered 2D matrix
% subplot(2,2,2);
% imagesc(abs(estimate_S)); 
% title('estimated 2D Matrix');
% colorbar;
% xlabel('Time ');
% ylabel('Frequency ');
% 
% % Plot the Canny edges with Hough lines
% subplot(2,2,3);
% imshow(edges); 
% hold on;





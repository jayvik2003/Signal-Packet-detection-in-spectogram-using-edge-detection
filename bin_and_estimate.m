function [S_hat,time_bins,freq_bins,time_hist_S,freq_hist_S,time_hist_estimate_S,freq_hist_estimate_S] = bin_and_estimate(projected_S, S)
    time_bins = sum(projected_S, 1);
    freq_bins = sum(projected_S, 2);

    time_bins_norm = time_bins / max(time_bins);  
    freq_bins_norm = freq_bins / max(freq_bins); %STBT  

    threshold_time = 0;  %STBT
    threshold_freq = 0;  

    time_bins = time_bins_norm > threshold_time; %STBT
    freq_bins = freq_bins_norm > threshold_freq; 

    fses = find(freq_bins == 1);
    tses = find(time_bins == 1);

    for i = 1:length(tses) - 1
        startIdx = tses(i);
        endIdx = tses(i + 1);
        if endIdx - startIdx > 1
            time_bins(startIdx + 1:endIdx - 1) = 1;
        end
    end

    for i = 1:length(fses) - 1
        startIdx = fses(i);
        endIdx = fses(i + 1);
        if endIdx - startIdx > 1
            freq_bins(startIdx + 1:endIdx - 1) = 1;
        end
    end

    % Estimate S from the projections
    projected_S = freq_bins * time_bins;
    S_hat = projected_S .* S; % dot product to find estimated S

    time_hist_S = sum(abs(S), 1);        
    freq_hist_S = sum(abs(S), 2);         

    time_hist_estimate_S = sum(abs(S_hat), 1);  
    freq_hist_estimate_S = sum(abs(S_hat), 2);

    
% % Plot histograms along the time dimension
% figure;
% subplot(2, 1, 1);
% plot(time_hist_S);
% hold on;
% plot(time_hist_estimate_S);
% title('Time-Dimension Histogram Comparison');
% xlabel('Time Bins');
% ylabel('Magnitude Sum');
% legend('Original S', 'Estimated S');
% grid on;
% 
% % Plot histograms along the frequency dimension
% subplot(2, 1, 2);
% plot(freq_hist_S);
% hold on;
% plot(freq_hist_estimate_S);
% title('Frequency-Dimension Histogram Comparison');
% xlabel('Frequency Bins');
% ylabel('Magnitude Sum');
% legend('Original S', 'Estimated S');
% grid on;
% 
% figure;
% subplot(1, 2, 1);
% histogram(abs(S(:)), 50);
% title('Histogram of Original (S)');
% 
% subplot(1, 2, 2);
% histogram(abs(estimate_S(:)), 50);
% title('Histogram of (estimate\_S)');

end

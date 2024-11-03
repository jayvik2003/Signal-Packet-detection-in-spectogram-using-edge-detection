function [S] = compute_stft(waveform, fs, nwin) %STBT
    % Set STFT parameters
    overlap = ceil(nwin * 0.55); %STBT
    win = gausswin(nwin); %STBT

    szeropad = [zeros(1, nwin), waveform, zeros(1, nwin)]';
    [S, ~, ~] = stft(szeropad, fs, 'Window', win, 'OverlapLength', overlap);

end


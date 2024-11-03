function [projected_S,theta,rho,edges] = perform_edge_detection(S,num_peaks)
    % Step 1: Edge detection using Canny
    matrix = abs(S);
    filtered_matrix = wiener2(matrix, [3 3]); %STBT 

    edges = edge(filtered_matrix, 'canny', [0.35, 0.45]);  % STBT

    % Step 2: Hough Transform
    [H, theta, rho] = hough(edges);
    %num_peaks = 50;  
    peaks = houghpeaks(H, num_peaks, 'Threshold', ceil(0.3 * min(H(:)))); % STBT

    % Step 3: Extract lines using Hough Transform
    lines = houghlines(edges, theta, rho, peaks, 'FillGap', 5, 'MinLength', 7); % STBT
    
    % Step 4: Initialize Hough Lines Matrix
    projected_S = zeros(size(S));  

    % Step 5: Mark line positions
    for k = 1:length(lines)
        xy = [lines(k).point1; lines(k).point2];
        line_x = round(linspace(xy(1, 1), xy(2, 1), 1000)); 
        line_y = round(linspace(xy(1, 2), xy(2, 2), 1000));  

        line_x = max(min(line_x, size(S, 2)), 1); 
        line_y = max(min(line_y, size(S, 1)), 1); 

        % Mark the line points in the matrix
        for i = 1:length(line_x)
            projected_S(line_y(i), line_x(i)) = 1;
        end
    end

% figure;
% 
% % Plot the Canny edges with Hough lines
% subplot(2,1,1);
% imshow(edges); 
% hold on;
% 
% % Plot the lines on the edges
% for k = 1:length(lines)
%     xy = [lines(k).point1; lines(k).point2]; % Get line endpoints
%     plot(xy(:,1), xy(:,2), 'LineWidth', 2, 'Color', 'red'); % Plot lines
% end
% title('Edge Detection with Hough Lines');
% 
% % Plot the Hough transform with detected peaks
% subplot(2,1,2);
% imshow(imadjust(rescale(H)), 'XData', theta, 'YData', rho);
% title('Hough Transform with Peaks');
% xlabel('\theta (degrees)');
% ylabel('\rho (pixels)');
% axis on, axis normal;
% hold on;
% plot(theta(peaks(:, 2)), rho(peaks(:, 1)), 's', 'color', 'red');  % Mark peaks on HT
% hold off;


end

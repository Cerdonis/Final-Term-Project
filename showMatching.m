% Visualization of image matching
% This code is modification of original code by "Ilwoo Lyu"


function[m,m_inlier] = showMatching(I1,I2, X, Y, m)
    
    w1=length(I1);

    I=[I1, I2];
    figure; imshow(I);
    hold on;
    title('Match: Original')
    for cnt=1:length(X)
        plot(X(cnt, 1), X(cnt, 2), 'g*'); 
    end
    for cnt=1:length(Y)
        plot(Y(cnt, 1)+w1, Y(cnt, 2), 'g*'); 
    end
    
    if nargin == 5
        c = jet(length(m));
        for i = 1: length(m)
            plot([X(m(i,1),1),Y(m(i,2),1)+w1], [X(m(i,1),2), Y(m(i,2), 2)],'color',c(i,:),'LineWidth',1);
            text(X(m(i,1), 1), X(m(i,1), 2), num2str(m(i,1)),'color',c(i,:),'fontsize', 20);
            text(Y(m(i,2),1)+w1, Y(m(i,2), 2), num2str(m(i,2)),'color',c(i,:),'fontsize', 20);
        end
    end
    hold off;  
   
    
    [r, c] = size(m);
    m_inlier = zeros(r,c);
    m = [m zeros(r,2)];
    for i = 1:r
       m(i,3) = (Y(m(i,2), 2)-X(m(i,1), 2)) / (Y(m(i,2),1)+w1-X(m(i,1), 1));
       m(i,4) = norm([Y(m(i,2),1) Y(m(i,2), 2)] - [X(m(i,1), 1) X(m(i,1), 2)]);        
    end
    
    % Discard erroneous pairs
%     [a, TF_slope] = rmoutliers(m(:,3));
%     [a, TF_dist] = rmoutliers(m(:,4));
    [a, TF_slope] = rmoutliers(m(:,3), 'percentiles', [0 100]);
    [a, TF_dist] = rmoutliers(m(:,4), 'percentiles', [0 00]);
    
    cnt=1;
    for i = 1:r
      if TF_slope(i,1) == 0 && TF_dist(i,1) ==0
          m_inlier(cnt,:) = m(i,1:2);
          cnt = cnt+1;
      end
    end    
    m_inlier(cnt:end,:) = [];
    
    % Show inlier pairs
    figure; imshow(I);
    hold on;
    title('Match: Good pairs only')
    for cnt=1:length(X)
        plot(X(cnt, 1), X(cnt, 2), 'g*'); 
    end
    for cnt=1:length(Y)
        plot(Y(cnt, 1)+w1, Y(cnt, 2), 'g*'); 
    end
    
    if nargin == 5
        c = jet(length(m_inlier));
        for i = 1: length(m_inlier)
            plot([X(m_inlier(i,1),1),Y(m_inlier(i,2),1)+w1], [X(m_inlier(i,1),2), Y(m_inlier(i,2), 2)],'color',c(i,:),'LineWidth',1);
            text(X(m_inlier(i,1), 1), X(m_inlier(i,1), 2), num2str(m_inlier(i,1)),'color',c(i,:),'fontsize', 20);
            text(Y(m_inlier(i,2),1)+w1, Y(m_inlier(i,2), 2), num2str(m_inlier(i,2)),'color',c(i,:),'fontsize', 20);
        end
    end
    hold off;  
    
end

function showCorner(key_x, key_y)
    plot(key_x,key_y,'X','markersize',8,'color','red');
end
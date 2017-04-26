% Script to create bar plot for the best ARMAX orders
N = 10;
best = zeros(N,6);

for i = 1:3
    N = numel(gen(i).snaps);
    j = 1;
    while j<=N && ~isempty(gen(i).snaps(j).indicators)
        for k = 1:3  
            [~,I] = min(gen(i).snaps(j).indicators(:,3+k));
            best(gen(i).snaps(j).indicators(I,1),k) = best(gen(i).snaps(j).indicators(I,1),k) + 1;

            [~,I] = max(gen(i).snaps(j).indicators(:,6+k));
            best(gen(i).snaps(j).indicators(I,1),3+k) = best(gen(i).snaps(j).indicators(I,1),3+k) + 1;
        end
       % [~,I] = max(gen(i).snaps(j).indicators(:,7));
        %best(gen(i).snaps(j).indicators(I,1),4) = best(gen(i).snaps(j).indicators(I,1),4) + 1;
        %A=max(gen(i).snaps(j).indicators(:,7))- gen(i).snaps(j).indicators(:,7);
        %low = find(A<1);
        %iLow = low(1);
        %best(gen(i).snaps(j).indicators(iLow,1),5) = best(gen(i).snaps(j).indicators(iLow,1),5) + 1;
        %bet(gen(i).snaps(j).inidcators(:,8)
        j = j+1;
    end
end

figure
bar(best)
legend('AIC','BIC','FPE','NRMSE','VAF', 'VAF_{SIM}')
grid on
cleanfigure
matlab2tikz('ARXOrders_1200.tikz')
clf
figure('Color',[1, 1, 1])
%subplot(1,2,1)
hold on
plot(y, x,'bx','MarkerSize',20,'LineWidth',5)

text(y(1)-1.4,x(1)-0.5,'Max A, Max V', 'FontSize',14,'FontWeight','bold')
text(y(2)-1.4,x(2)-0.5,'Min A, Max V', 'FontSize',14,'FontWeight','bold')
text(y(3)-1.4,x(3)-0.5,'Min A, Min V', 'FontSize',14,'FontWeight','bold')
text(y(4)-1.4,x(4)-0.5,'Max A, Min V', 'FontSize',14,'FontWeight','bold')

title('MIREmotion Results', 'FontSize',20,'FontWeight','Bold')
set(gca,'linewidth',2)
xlabel('Valence', 'FontSize',15,'FontWeight','Bold')
ylabel('Activity', 'FontSize',15,'FontWeight','Bold')

plot([1 7], [4 4], 'k-','LineWidth',5); % plot the horizontal line
plot([4 4], [1 7], 'k-','LineWidth',5); % plot the horizontal line
hold off
set(gca,'FontSize',20)
box on
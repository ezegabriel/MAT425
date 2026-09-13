function [varargout] = plotSphNodes2(x,y,z, xm,ym,zm)

%PLOTSPHNODES Makes a simple plot of a given set of nodes on the surface of
%   the unit sphere.
%
%   plotSphNodes(X) plots the nodes contained in X on the surface of the
%   unit sphere.  Here X is assumed to be an N-by-3 array with each row
%   consisting of the (x,y,z) Cartesian coordinates for a node.
%
%   cax = plotSphNodes(X) returns a handle to Axes for the plot.
%
%   Example:
%       x = 2*rand(101,3)-1;
%       x = bsxfun(@rdivide,x,sqrt(sum(x.^2,2)));  % Project to the sphere.
%       plotSphNodes(x);
%

% Author: Grady Wright, 2014

% Make sure the nodes are on the unit sphere.
x = bsxfun(@rdivide,x,sqrt(sum(x.^2,2)));
y = bsxfun(@rdivide,y,sqrt(sum(y.^2,2)));

%
% Generate a unit sphere.
%
[xx,yy,zz] = sphere(101);
% Color of the sphere will be yellow:
clr = [255 255 102]/255;
% Plot the sphere
cax = newplot;
hold on;
surf(xx,yy,zz,1+0*xx,'EdgeColor','None','FaceColor',clr); axis equal
%alpha 0.4

%
% Add the nodes as pointcolor.
%

nx=size(x,1);
ny=size(y,1);
for i=1:nx
    
    plot3(x(i,1),x(i,2),x(i,3), 'ro','MarkerSize',4,'MarkerFaceColor','r');
    if size(xm,1)>0
    text(x(i,1),x(i,2),x(i,3), {xm(i)}, 'FontSize', 20, 'FontWeight','bold');
    end
    hold on
end

if size(y,1)>0
    ny=size(y,1);
    for j=1:ny
        plot3(y(j,1),y(j,2),y(j,3),'g*','MarkerSize',5,'MarkerFaceColor','g');
        if size(ym,1)>0
        a=0.05;
        text(y(j,1),y(j,2),y(j,3)+a, {ym(j)},'Color','red','FontSize', 10,'FontWeight','bold');
        end
        hold on
    end
end

if size(z,1)>0
    nz=size(z,1);
    for j=1:nz
        plot3(z(j,1),z(j,2),z(j,3),'bo','MarkerSize',4,'MarkerFaceColor','b');
        if size(zm,1)>0
        a=0;
        text(z(j,1),z(j,2),z(j,3)+a, {zm(j)},'Color','blue','FontSize', 10,'FontWeight','bold');
        end
        hold on        
    end
end


hold off

daspect([1 1 1]);
view(3);

if nargout == 1
    varargout = cax;
end

end




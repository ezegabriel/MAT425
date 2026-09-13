function plotVSD(S,V,F,b,S0,scale,Origin)

if S0    
    SV = repmat(S,[1 3]) .* V;
    figure
    patchsignal(SV,F,[0 0 0],scale)
    D = - (1/b) * log(S/S0);
    DV = repmat(D,[1 3]) .* V;
    xlabel('X'); zlabel('Z'); ylabel('Y');
    axis equal; grid on;
    camlight
    figure
    patchsignal(DV,F,[0 0 0],scale)
    xlabel('X'); zlabel('Z'); ylabel('Y');
    axis equal; grid on;
    camlight
else
    D = S;
    DV = repmat(D,[1 3]) .* V;
    % figure;
    % colordef black
    patchsignal(DV,F,Origin,scale)
    % xlabel('X'); zlabel('Z'); ylabel('Y');
    % material shiny;
    % material dull;
    axis equal;
    grid off;
end
return

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function patchsignal(V,F,Origin,scale)

OV = (scale * V) + repmat(Origin,[size(V,1) 1]);

a = V ./ ...
      (repmat(sqrt(dot(V,V,2)),1,3) + eps);
%   a = a(:,[1 3 2]);

patch('Vertices', OV, 'Faces', F, ...
      'FaceVertexCData', abs(a),...
      'FaceColor', 'interp',...
      'FaceLighting','phong',...
      'LineStyle','-',...
      'LineWidth',.05,...
      'EdgeColor',[.3 .3 .3],...
      'AmbientStrength',.4,...
      'FaceLighting','phong',...
      'SpecularColorReflectance',.2,...
      'DiffuseStrength',.5,...
      'BackFaceLighting', 'reverselit');

% patch('vertices', V, 'faces', F, ...
%       'facecolor', [0.7 0.8 1], 'edgecolor', [.2 .2 .6]);
return
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

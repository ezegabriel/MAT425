function plotQBI(ODF,aa,V,F)
% plotQBI(ODF); ODF on a sphere
% plotQBI(ODF, 1); normalized ODF = test_QBI
% plotQBI(ODF, 2); normalized ODF without chart
% plotQBI(ODF, 3); ODF without chart

if nargin<=2
    V = load('724_shell.txt');
    F = load('724_sphere_facets.txt');
end
Origen = [0 0 0.25];

if nargin>1 & aa==1
    
    ODF = ODF - min(ODF); % for non negative
    ODF = ODF/sum(ODF); 
    ODF=ODF/max(ODF);
    
elseif nargin>1 & aa==2
    
    ODF = ODF - min(ODF); % for non negative
    ODF = ODF/sum(ODF); 
    ODF=ODF/max(ODF);
    set(gcf, 'color', 'white'); %background color

    plotVSD(ODF,V,F,0,0,1,Origen);
    
    %remove triangulization
    shading interp;
    camlight headlight;
    axis off; 
    return;
elseif nargin>1 & aa==3
  
    set(gcf, 'color', 'white'); %background color

    plotVSD(ODF,V,F,0,0,1,Origen);
    
    %remove triangulization
    shading interp;
    camlight headlight;
    axis off; 
    return;
    
end

set(gcf, 'color', 'white'); %background color

    %angle chart, need scaling
    angle = 0:.01:2*pi;
    R = ones(1,length(angle));
    polarm(angle,R,'k'); 

    plotVSD(ODF,V,F,0,0,1,Origen);

    %remove triangulization
    shading interp;
    camlight headlight;


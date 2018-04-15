%
% Ricardo Martins
% CiBIT/ICNAS - University of Coimbra
% http://www.uc.pt/en/icnas
% ricardo.martins@uc.pt
%
% Sample code - creation of simple plaids (transparency)
%
%
%%
clear all
close all
sca
clc


%% Plaid Parameters
ambiguous=1;                           % 1- ambiguous;  0-unambiguous
circle_diameter=700;                   % [pixels]
line_spacing=160;                      % [pixels]
line_width=40;                         % [pixels]
line_color=180;                        % [8-bit grayscale, 0-black 255-white]
intercept_color_ambiguous=120;         % [8-bit grayscale, 0-black 255-white]
intercept_color_unambiguous=230;       % [8-bit grayscale, 0-black 255-white]
line_angle=75;                         % [degrees]  
speed=180;                             % [pixels per second] 
display_refresh=60;                    % [Hz] - display refresh rate 








%% Create circle mask
center_x=circle_diameter/2;
center_y=circle_diameter/2;
myFakeWindow01=zeros(circle_diameter,circle_diameter,'uint8');

for i=1:size(myFakeWindow01,1)
    for j=1:size(myFakeWindow01,1)
        if (i-center_y)^2 + (j-center_x)^2 <= (circle_diameter/2)^2
            myFakeWindow01(j,i)=255;                      
        end
    end
end
circle_mask=find(myFakeWindow01==0);


%%
nFramesLoop=floor(line_spacing*display_refresh/speed);
myFakeWindow02=zeros(circle_diameter*2,circle_diameter*2,'uint8');

startLine=1;
endLine=size(myFakeWindow02,1);
startArrayLineReal=startLine:line_spacing:endLine;

for i=1:nFramesLoop
    startArrayLine=floor(startArrayLineReal);
    myFakeWindow02=zeros(circle_diameter*2,circle_diameter*2,'uint8');
    
    for j=1:size(startArrayLine,2)
        myFakeWindow02(startArrayLine(j):min(startArrayLine(j)+line_width-1,endLine),1:size(myFakeWindow02,2))=255;
    end
    startLine=startArrayLineReal(1)+speed/display_refresh;
    startArrayLineReal=startLine:line_spacing:endLine;
    startArrayLineReal=[startLine:-line_spacing:1,startArrayLineReal(2:end)];
    
    myFakeWindow02_angleA=imrotate(myFakeWindow02,line_angle,'bicubic','crop');
    myFakeWindow02_angleA=double(myFakeWindow02_angleA);
    myFakeWindow02_angleB=imrotate(myFakeWindow02,-line_angle,'bicubic','crop');
    myFakeWindow02_angleB=double(myFakeWindow02_angleB);
    
    myFakeWindow02_merge=myFakeWindow02_angleA(circle_diameter/2:circle_diameter/2+circle_diameter-1,circle_diameter/2:circle_diameter/2+circle_diameter-1)+myFakeWindow02_angleB(circle_diameter/2:circle_diameter/2+circle_diameter-1,circle_diameter/2:circle_diameter/2+circle_diameter-1);
    
    line_mask=find(myFakeWindow02_merge>=205 & myFakeWindow02_merge<=310);
    intercept_mask=find(myFakeWindow02_merge>=311);
    
    
    myFakeWindow03=zeros(circle_diameter,circle_diameter,'uint8')+255;
    if ambiguous==1
        myFakeWindow03(line_mask)=line_color;
        myFakeWindow03(intercept_mask)=intercept_color_ambiguous;
        myFakeWindow03(circle_mask)=0;
        myFramesLoopArray_Amb(:,:,i)=myFakeWindow03;        
    elseif ambiguous==0
        myFakeWindow03(line_mask)=line_color;
        myFakeWindow03(intercept_mask)=intercept_color_unambiguous;
        myFakeWindow03(circle_mask)=0;
        myFramesLoopArray_Unamb(:,:,i)=myFakeWindow03;        
    end
    
end

if ambiguous==1
    save('./OfflineData/myFramesLoopArray_Amb.mat','myFramesLoopArray_Amb');
elseif ambiguous==0
    save('./OfflineData/myFramesLoopArray_Unamb.mat','myFramesLoopArray_Unamb');
end

% display sample frame
figure;
imshow(myFakeWindow03)






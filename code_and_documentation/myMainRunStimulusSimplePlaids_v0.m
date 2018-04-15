%
% Ricardo Martins
% CiBIT/ICNAS - University of Coimbra
% http://www.uc.pt/en/icnas
% ricardo.martins@uc.pt
%
% Sample code - creation of simple plaids (transparency)
%
%

clear all
close all
clc

%% standard stuff - psychophysics toolbox initialization
Screen('CloseAll');
HideCursor;
Screen('Preference', 'SkipSyncTests', 1); 
Priority(2);
screens = Screen('Screens');
screenNumber = max(screens);
[windowID rect] = Screen('OpenWindow', screenNumber, 0, []);
Screen('BlendFunction', windowID, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);





%% load data - Plaid Frames - textures - loop
ambiguous=1;  % 1- ambiguous;  0-unambiguous

if ambiguous==1
    load('./OfflineData/myFramesLoopArray_Amb.mat');
    nLoopFrames=size(myFramesLoopArray_Amb,3);
    for i=1:nLoopFrames
        myTextureLoopArray(i,1) = Screen('MakeTexture', windowID, myFramesLoopArray_Amb(:,:,i));
    end    
elseif ambiguous==0
    load('./OfflineData/myFramesLoopArray_Unamb.mat');
    nLoopFrames=size(myFramesLoopArray_Unamb,3);
    for i=1:nLoopFrames
        myTextureLoopArray(i,1) = Screen('MakeTexture', windowID, myFramesLoopArray_Unamb(:,:,i));
    end       
end





%% Run stimulus
Screen('FillRect', windowID, [0 0 0]); % black brackground 
myLoopFrameCounter=1;

% press a key to exit 
while ~KbCheck
    Screen('DrawTextures', windowID, myTextureLoopArray(myLoopFrameCounter,1) );
    Screen('Flip', windowID); 

    myLoopFrameCounter=myLoopFrameCounter+1;
    if myLoopFrameCounter>nLoopFrames
        myLoopFrameCounter=1;
    end    
end


sca;




%%
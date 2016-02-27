classdef goggleCropper<goggleBoxPlugin
    properties(Access=protected)
        hFig
        hPanelPosition
        hXPositionMin
        hYPositionMin
        hXPositionMax
        hYPositionMax
        
        hPanelResult
        hXSize
        hYSize
        hNPixels
        hReduction
        
        hChannels
        hSliceFrom
        hSliceTo
        
        fontName
        fontSize
        hSelectionRectangle
        
    end
    
    properties(Access=protected, Dependent)
        maxSliceNum
    end
    
    methods
    function obj=goggleCropper(caller, ~)
            obj=obj@goggleBoxPlugin(caller);
           
             %% Settings
            obj.fontName=gbSetting('font.name');
            obj.fontSize=gbSetting('font.size');
            try
                pos=gbSetting('cropper.figurePosition');
            catch
                ssz=get(0, 'ScreenSize');
                lb=[ssz(3)/3 ssz(4)/3];
                pos=round([lb 400 550]);
                gbSetting('cropper.figurePosition', pos)
            end
            %% Main UI
            obj.hFig=figure(...
                'Position', pos, ...
                'CloseRequestFcn', {@deleteRequest, obj}, ...
                'MenuBar', 'none', ...
                'NumberTitle', 'off', ...
                'Name', ['Cropper: ' obj.goggleViewer.Meta.experimentName], ...
                'Color', gbSetting('viewer.panelBkgdColor'));
            %% Crop Position Indicators
            obj.hPanelPosition=uipanel(...
                'Parent', obj.hFig, ...
                'Units', 'normalized', ...
                'Position', [0.05 0.7 0.55 0.25], ...
                'BackgroundColor', gbSetting('viewer.mainBkgdColor'), ...
                'ForegroundColor', gbSetting('viewer.textMainColor'), ...
                'FontSize', obj.fontSize+1, ...
                'Title', 'Crop Limits');
            
            uicontrol(...
                'Style', 'text', ...
                'HorizontalAlignment', 'right', ...
                'Parent', obj.hPanelPosition, ...
                'Units', 'normalized', ...
                'Position', [0.05 0.6 0.1 0.2], ...
                'BackgroundColor', gbSetting('viewer.mainBkgdColor'), ...
                'ForegroundColor', gbSetting('viewer.textMainColor'), ...
                'FontName', obj.fontName, ...
                'FontSize', obj.fontSize, ...
                'String', 'X:');
            uicontrol(...
                'Style', 'text', ...
                'HorizontalAlignment', 'right', ...
                'Parent', obj.hPanelPosition, ...
                'Units', 'normalized', ...
                'Position', [0.05 0.2 0.1 0.2], ...
                'BackgroundColor', gbSetting('viewer.mainBkgdColor'), ...
                'ForegroundColor', gbSetting('viewer.textMainColor'), ...
                'FontName', obj.fontName, ...
                'FontSize', obj.fontSize, ...
                'String', 'Y:');
            obj.hXPositionMin=uicontrol(...
                'Style', 'text', ...
                'HorizontalAlignment', 'center', ...
                'Parent', obj.hPanelPosition, ...
                'Units', 'normalized', ...
                'Position', [0.2 0.6 0.3 0.2], ...
                'BackgroundColor', gbSetting('viewer.mainBkgdColor'), ...
                'ForegroundColor', gbSetting('viewer.textMainColor'), ...
                'FontName', obj.fontName, ...
                'FontSize', obj.fontSize);
             obj.hYPositionMin=uicontrol(...
                'Style', 'text', ...
                'HorizontalAlignment', 'center', ...
                'Parent', obj.hPanelPosition, ...
                'Units', 'normalized', ...
                'Position', [0.2 0.2 0.3 0.2], ...
                'BackgroundColor', gbSetting('viewer.mainBkgdColor'), ...
                'ForegroundColor', gbSetting('viewer.textMainColor'), ...
                'FontName', obj.fontName, ...
                'FontSize', obj.fontSize);
             obj.hXPositionMax=uicontrol(...
                'Style', 'text', ...
                'HorizontalAlignment', 'center', ...
                'Parent', obj.hPanelPosition, ...
                'Units', 'normalized', ...
                'Position', [0.6 0.6 0.3 0.2], ...
                'BackgroundColor', gbSetting('viewer.mainBkgdColor'), ...
                'ForegroundColor', gbSetting('viewer.textMainColor'), ...
                'FontName', obj.fontName, ...
                'FontSize', obj.fontSize);
             obj.hYPositionMax=uicontrol(...
                'Style', 'text', ...
                'HorizontalAlignment', 'center', ...
                'Parent', obj.hPanelPosition, ...
                'Units', 'normalized', ...
                'Position', [0.6 0.2 0.3 0.2], ...
                'BackgroundColor', gbSetting('viewer.mainBkgdColor'), ...
                'ForegroundColor', gbSetting('viewer.textMainColor'), ...
                'FontName', obj.fontName, ...
                'FontSize', obj.fontSize);
                
             %% Crop Result Indicator
            obj.hPanelResult=uipanel(...
                'Parent', obj.hFig, ...
                'Units', 'normalized', ...
                'Position', [0.05 0.2 0.55 0.45], ...
                'BackgroundColor', gbSetting('viewer.mainBkgdColor'), ...
                'ForegroundColor', gbSetting('viewer.textMainColor'), ...
                'FontSize', obj.fontSize+1, ...
                'Title', 'Crop Result');
            uicontrol(...
                'Style', 'text', ...
                'HorizontalAlignment', 'right', ...
                'Parent', obj.hPanelResult, ...
                'Units', 'normalized', ...
                'Position', [0.1 0.75 0.2 0.15], ...
                'BackgroundColor', gbSetting('viewer.mainBkgdColor'), ...
                'ForegroundColor', gbSetting('viewer.textMainColor'), ...
                'FontName', obj.fontName, ...
                'FontSize', obj.fontSize, ...
                'String', 'X size:');
            uicontrol(...
                'Style', 'text', ...
                'HorizontalAlignment', 'right', ...
                'Parent', obj.hPanelResult, ...
                'Units', 'normalized', ...
                'Position', [0.1 0.6 0.2 0.15], ...
                'BackgroundColor', gbSetting('viewer.mainBkgdColor'), ...
                'ForegroundColor', gbSetting('viewer.textMainColor'), ...
                'FontName', obj.fontName, ...
                'FontSize', obj.fontSize, ...
                'String', 'Y size:');
             uicontrol(...
                'Style', 'text', ...
                'HorizontalAlignment', 'right', ...
                'Parent', obj.hPanelResult, ...
                'Units', 'normalized', ...
                'Position', [0.05 0.45 0.25 0.15], ...
                'BackgroundColor', gbSetting('viewer.mainBkgdColor'), ...
                'ForegroundColor', gbSetting('viewer.textMainColor'), ...
                'FontName', obj.fontName, ...
                'FontSize', obj.fontSize, ...
                'String', 'Image Size:');
            uicontrol(...
                'Style', 'text', ...
                'HorizontalAlignment', 'right', ...
                'Parent', obj.hPanelResult, ...
                'Units', 'normalized', ...
                'Position', [0.05 0.3 0.25 0.15], ...
                'BackgroundColor', gbSetting('viewer.mainBkgdColor'), ...
                'ForegroundColor', gbSetting('viewer.textMainColor'), ...
                'FontName', obj.fontName, ...
                'FontSize', obj.fontSize, ...
                'String', '% Initial:');
            
            obj.hXSize=uicontrol(...
                'Style', 'text', ...
                'HorizontalAlignment', 'left', ...
                'Parent', obj.hPanelResult, ...
                'Units', 'normalized', ...
                'Position', [0.35 0.75 0.6 0.15], ...
                'BackgroundColor', gbSetting('viewer.mainBkgdColor'), ...
                'ForegroundColor', gbSetting('viewer.textMainColor'), ...
                'FontName', obj.fontName, ...
                'FontSize', obj.fontSize);
            obj.hYSize=uicontrol(...
                'Style', 'text', ...
                'HorizontalAlignment', 'left', ...
                'Parent', obj.hPanelResult, ...
                'Units', 'normalized', ...
                'Position', [0.35 0.6 0.6 0.15], ...
                'BackgroundColor', gbSetting('viewer.mainBkgdColor'), ...
                'ForegroundColor', gbSetting('viewer.textMainColor'), ...
                'FontName', obj.fontName, ...
                'FontSize', obj.fontSize);
            obj.hNPixels=uicontrol(...
                'Style', 'text', ...
                'HorizontalAlignment', 'left', ...
                'Parent', obj.hPanelResult, ...
                'Units', 'normalized', ...
                'Position', [0.35 0.45 0.6 0.15], ...
                'BackgroundColor', gbSetting('viewer.mainBkgdColor'), ...
                'ForegroundColor', gbSetting('viewer.textMainColor'), ...
                'FontName', obj.fontName, ...
                'FontSize', obj.fontSize);

            obj.hReduction=uicontrol(...
                'Style', 'text', ...
                'HorizontalAlignment', 'left', ...
                'Parent', obj.hPanelResult, ...
                'Units', 'normalized', ...
                'Position', [0.35 0.3 0.6 0.15], ...
                'BackgroundColor', gbSetting('viewer.mainBkgdColor'), ...
                'ForegroundColor', gbSetting('viewer.textMainColor'), ...
                'FontName', obj.fontName, ...
                'FontSize', obj.fontSize);
            %% Selection Rectangle
            obj.hSelectionRectangle=imrect(obj.goggleViewer.hMainImgAx, getRectangleInitialPosition(obj));
            obj.updatePosition(getRectangleInitialPosition(obj))
            obj.hSelectionRectangle.Deletable=0;
            setRectangleConstraints(obj)
            
            %% Buttons
            uicontrol(...
                'Style', 'pushbutton', ...
                'HorizontalAlignment', 'center', ...
                'Parent', obj.hFig, ...
                'Units', 'normalized', ...
                'Position', [0.65 0.04 0.25 0.075], ...
                'BackgroundColor', gbSetting('viewer.mainBkgdColor'), ...
                'ForegroundColor', gbSetting('viewer.textMainColor'), ...
                'FontName', obj.fontName, ...
                'FontSize', obj.fontSize, ...
                'String', 'OK', ...
                'Callback', @(~,~) obj.doCrop);
            uicontrol(...
                'Style', 'pushbutton', ...
                'HorizontalAlignment', 'center', ...
                'Parent', obj.hFig, ...
                'Units', 'normalized', ...
                'Position', [0.35 0.04 0.25 0.075], ...
                'BackgroundColor', gbSetting('viewer.mainBkgdColor'), ...
                'ForegroundColor', gbSetting('viewer.textMainColor'), ...
                'FontName', obj.fontName, ...
                'FontSize', obj.fontSize, ...
                'String', 'Cancel', ...
                'Callback', @(~,~) close(obj.hFig));
            %% Which channels
            
            cropPanel=uipanel(...
                'Parent', obj.hFig, ...
                'Units', 'normalized', ...
                'Position', [0.65 0.7 0.3 0.25], ...
                'BackgroundColor', gbSetting('viewer.mainBkgdColor'), ...
                'ForegroundColor', gbSetting('viewer.textMainColor'), ...
                'FontSize', obj.fontSize+1, ...
                'Title', 'Channels');
            
            channels=fieldnames(obj.Meta.stitchedImagePaths);
            obj.hChannels=uicontrol(...
                'Parent', cropPanel, ...
                'Units', 'normalized', ...
                'Position', [0.05 0.05 0.9 0.9], ...
                'BackgroundColor', gbSetting('viewer.mainBkgdColor'), ...
                'ForegroundColor', gbSetting('viewer.textMainColor'), ...
                'FontName', obj.fontName, ...
                'FontSize', obj.fontSize, ...
                'Style', 'listbox', ...
                'Max', 10, 'Min', 2, ...
                'Value', 1:numel(channels),...
                'String',channels);
           %% Which slices
           hPanelSlices=uipanel(...
                'Parent', obj.hFig, ...
                'Units', 'normalized', ...
                'Position', [0.65 0.2 0.3 0.45], ...
                'BackgroundColor', gbSetting('viewer.mainBkgdColor'), ...
                'ForegroundColor', gbSetting('viewer.textMainColor'), ...
                'FontSize', obj.fontSize+1, ...
                'Title', 'Slices');
            uicontrol(...
                'Style', 'text', ...
                'HorizontalAlignment', 'center', ...
                'Parent', hPanelSlices, ...
                'Units', 'normalized', ...
                'Position', [0.1 0.75 0.7 0.1], ...
                'BackgroundColor', gbSetting('viewer.mainBkgdColor'), ...
                'ForegroundColor', gbSetting('viewer.textMainColor'), ...
                'FontName', obj.fontName, ...
                'FontSize', obj.fontSize, ...
                'String', 'From:');
            
            obj.hSliceFrom=uicontrol(...
                'Style', 'edit', ...
                'HorizontalAlignment', 'center', ...
                'Parent', hPanelSlices, ...
                'Units', 'normalized', ...
                'Position', [0.1 0.65 0.7 0.1], ...
                'BackgroundColor', gbSetting('viewer.mainBkgdColor'), ...
                'ForegroundColor', gbSetting('viewer.textMainColor'), ...
                'FontName', obj.fontName, ...
                'FontSize', obj.fontSize, ...
                'String', '1');
            
             uicontrol(...
                'Style', 'text', ...
                'HorizontalAlignment', 'center', ...
                'Parent', hPanelSlices, ...
                'Units', 'normalized', ...
                'Position', [0.1 0.4 0.7 0.1], ...
                'BackgroundColor', gbSetting('viewer.mainBkgdColor'), ...
                'ForegroundColor', gbSetting('viewer.textMainColor'), ...
                'FontName', obj.fontName, ...
                'FontSize', obj.fontSize, ...
                'String', 'To:');
                       
             obj.hSliceTo=uicontrol(...
                'Style', 'edit', ...
                'HorizontalAlignment', 'center', ...
                'Parent', hPanelSlices, ...
                'Units', 'normalized', ...
                'Position', [0.1 0.3 0.7 0.1], ...
                'BackgroundColor', gbSetting('viewer.mainBkgdColor'), ...
                'ForegroundColor', gbSetting('viewer.textMainColor'), ...
                'FontName', obj.fontName, ...
                'FontSize', obj.fontSize, ...
                'String', obj.maxSliceNum);
            
            
            
    end
    %% Getters
    function sn=get.maxSliceNum(obj)
        
         fnames=fieldnames(obj.Meta.stitchedImagePaths);
         sn=numel(obj.Meta.stitchedImagePaths.(fnames{1}));
         
    end
    %% Callbacks
    function updatePosition(obj, p,~)
        obj.hXPositionMin.String=sprintf('%u', round(p(1)));
        obj.hYPositionMin.String=sprintf('%u', round(p(2)));
        obj.hXPositionMax.String=sprintf('%u', round(p(1)+p(3)));
        obj.hYPositionMax.String=sprintf('%u', round(p(2)+p(4)));
        
        obj.hXSize.String=sprintf('%u (Original %u)', round(p(3)), round(obj.goggleViewer.mainDisplay.imageXLimOriginalCoords(end)));
        obj.hYSize.String=sprintf('%u (Original %u)', round(p(4)), round(obj.goggleViewer.mainDisplay.imageYLimOriginalCoords(end)));
        
        
        nPixels=round(p(3))*round(p(4));
        if nPixels<1e7
            pxStr=sprintf('%3.2f MPix', nPixels/1e6);
        elseif nPixels<1e8
            pxStr=sprintf('%3.1f MPix', nPixels/1e6);
        elseif nPixels<1e9
            pxStr=sprintf('%3.0f MPix', nPixels/1e6);
        elseif nPixels<1e10
            pxStr=sprintf('%3.2f GPix', nPixels/1e9);
        elseif nPixels<1e11
            pxStr=sprintf('%3.1f GPix', nPixels/1e9);
        else
            pxStr=sprintf('%3.0f GPix', nPixels/1e9);
        end
        
        pxStr=[pxStr ' (Original: '];
        
        nPixelsOrig=round(obj.goggleViewer.mainDisplay.imageXLimOriginalCoords(end))*round(obj.goggleViewer.mainDisplay.imageYLimOriginalCoords(end));
        if nPixelsOrig<1e7
            pxStr=[pxStr sprintf('%3.2f MPix', nPixelsOrig/1e6)];
        elseif nPixelsOrig<1e8
            pxStr=[pxStr sprintf('%3.1f MPix', nPixelsOrig/1e6)];
        elseif nPixelsOrig<1e9
            pxStr=[pxStr sprintf('%3.0f MPix', nPixelsOrig/1e6)];
        elseif nPixelsOrig<1e10
            pxStr=[pxStr sprintf('%3.2f GPix', nPixelsOrig/1e9)];
        elseif nPixelsOrig<1e11
            pxStr=[pxStr sprintf('%3.1f GPix', nPixelsOrig/1e9)];
        else
            pxStr=[pxStr sprintf('%3.0f GPix', nPixelsOrig/1e9)];
        end
        
        pxStr=[pxStr ')'];
        
        obj.hNPixels.String=pxStr;
       
        obj.hReduction.String=sprintf('%u%%', round(nPixels./nPixelsOrig*100));

    end
    function doCrop(obj)
        % Check valid slices
        sliceFrom=(str2double(obj.hSliceFrom.String));
        sliceTo=(str2double(obj.hSliceTo.String));
        if isnan(sliceFrom) || sliceFrom>obj.maxSliceNum ||...
                isnan(sliceTo) || sliceTo>obj.maxSliceNum ||...
                ~(sliceTo>sliceFrom)
            errordlg('Invalid slice selection')
            return
        end
        channelsToCrop=obj.hChannels.String(obj.hChannels.Value);
        questAns=questdlg(sprintf(['The following crop will be applied:\nChannels: \n' repmat(' %s\n', 1, numel(channelsToCrop)) 'Slices: %u-%u\n Is this OK?'], channelsToCrop{:}, sliceFrom, sliceTo'), 'Slice Cropper', 'Yes', 'No', 'No');
        
        if strcmp(questAns, 'Yes')
            cropSpec=[str2double(obj.hXPositionMin.String), str2double(obj.hYPositionMin.String), str2double(obj.hXPositionMax.String), str2double(obj.hYPositionMax.String)];
            executeCrop(obj.Meta, channelsToCrop, sliceFrom, sliceTo, cropSpec, obj);
        end
    end
    end
    
    methods(Static)
        function d=displayString()
            d='Crop Images...';
        end
    end
end

%% Callbacks

function deleteRequest(~, ~, obj)
    deleteRequest@goggleBoxPlugin(obj)
    delete(obj.hFig);
    delete(obj.hSelectionRectangle);
    delete(obj);
end

%% Functions
function initPos=getRectangleInitialPosition(obj)
    xl=obj.goggleViewer.hMainImgAx.XLim;
    yl=obj.goggleViewer.hMainImgAx.YLim;
    
    initPos=round([xl(1)+range(xl)/5 yl(1)+range(yl)/5 range(xl)*3/5 range(yl)*3/5]);
end


function setRectangleConstraints(obj)
    fcn=makeConstrainToRectFcn('imrect',obj.goggleViewer.mainDisplay.imageXLimOriginalCoords, obj.goggleViewer.mainDisplay.imageYLimOriginalCoords);
    setPositionConstraintFcn(obj.hSelectionRectangle,fcn);
    
    addNewPositionCallback(obj.hSelectionRectangle,@obj.updatePosition);
end

function executeCrop(Meta, channelsToCrop, sliceFrom, sliceTo, cropSpec, obj)
fNames=generateFileListToCrop(Meta, channelsToCrop, sliceFrom, sliceTo);
proceed=checkFilesAreUncropped(fNames);
if ~proceed
    errordlg('Some files have already been cropped. Aborting')
    return
else
    fprintf('%s\n', fNames{:})
    regionSpec=[cropSpec(1), cropSpec(2), cropSpec(3)-cropSpec(1)+1, cropSpec(4)-cropSpec(2)+1];
    s=SuperWaitBar(numel(fNames), 'Executing Crops');
    parfor ii=1:numel(fNames)
        s.progress; %#ok<PFBNS>
        I=openTiff(fNames{ii}, regionSpec, 1);
        
        tagStruct=duplicateTagStructure(fNames{ii});
        tagStruct.ImageLength=size(I, 1);
        tagStruct.ImageWidth=size(I, 2);
        tagStruct.RowsPerStrip=size(I, 1);
        
        tagStruct.XPosition=regionSpec(1)-1;
        tagStruct.YPosition=regionSpec(2)-1;
        
        t=Tiff(fNames{ii}, 'w');
        t.setTag(tagStruct);
        t.write(I);
        t.close;
    end
    s.delete;
    clear s
    close(obj.hFig)
end

end

function fileList=generateFileListToCrop(Meta, channelsToCrop, sliceFrom, sliceTo)
fileList={};
for ii=1:numel(channelsToCrop)
    fileList=[fileList, fullfile(Meta.baseDirectory, Meta.stitchedImagePaths.(channelsToCrop{ii})(sliceFrom:sliceTo))];  %#ok<AGROW>
end
parfor ii=1:numel(fileList)
    if ~exist(fileList{ii}, 'file')
        fileList{ii}='';
    end
end 
fileList(cellfun(@isempty, fileList))=[];
end

function allUncropped=checkFilesAreUncropped(fileList)
s=SuperWaitBar(numel(fileList), 'Checking file metadata');
allUncropped=1;
for ii=1:numel(fileList)
    s.progress;
    t=Tiff(fileList{ii}, 'r');
    try
    Xoffset = t.getTag('XPosition');
    catch
        Xoffset=0;
    end
    t.close();
    if ~Xoffset==0
        allUncropped=0;
        break
    end
end
s.delete;
clear s;
end


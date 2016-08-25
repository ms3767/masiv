classdef masivSystemMemoryUsageInfoPanel<handle
    properties(SetAccess=protected)
        parentFig
        position
        gzvm    
                
        mainPanel
        axMeter
        
        rectCacheMem
        rectMatMem
        rectUsedMem
        
        txtUsedOtherMem
        txtMatlabOtherMem
        txtCacheMem        
        txtFreeMem
        
        tmr
    end
    methods
        function obj=masivSystemMemoryUsageInfoPanel(parentFig, position, gzvm)
            obj.parentFig=parentFig;
            obj.position=position;
            obj.gzvm=gzvm;
            
            fSize=masivSetting('font.name');
            if fSize>1
                fSize=0.85;
            end

            obj.mainPanel=uipanel(...
                'Parent', parentFig, ...
                'Units', 'normalized', ...
                'Position', position, ...
                'BackgroundColor', masivSetting('viewer.panelBkgdColor'));
            
            %% Usage bar
            [~, totalMemKiB]=systemMemStats;
            obj.axMeter=axes(...
                'Parent', obj.mainPanel, ...
                'Position', [0.02 0.65 0.96 0.15], ...
                'Units', 'normalized', ...
                'Visible', 'on', ...
                'XTick', [], 'YTick', [], ...
                'Box', 'on', ...
                'XLim', [0 totalMemKiB/1024], 'YLim', [0 1], ...
                'HitTest', 'off', ...
                'SortMethod', 'childorder');
            rectangle(...
               'Parent', obj.axMeter, ...
               'Position', [0 0 obj.axMeter.XLim(2) 1], ...
               'EdgeColor', 'none', ...
               'FaceColor', hsv2rgb([0.6 0.6 0.8]));
           
            obj.rectUsedMem=rectangle(...
               'Parent', obj.axMeter, ...
               'EdgeColor', 'none', ...
               'FaceColor', hsv2rgb([0 0.6 0.8]));
            obj.rectMatMem=rectangle(...
               'Parent', obj.axMeter, ...
               'EdgeColor', 'none', ...
               'FaceColor', hsv2rgb([0.1 0.6 0.8]));           
            obj.rectCacheMem=rectangle(...
               'Parent', obj.axMeter, ...
               'EdgeColor', 'none', ...
               'FaceColor', hsv2rgb([0.3 0.6 0.8]));
           
           %% Title bar
           uicontrol(...
                'Parent', obj.mainPanel, ...
                'Style', 'text', ...
                'Units', 'normalized', ...
                'Position', [0.02 0.88 0.96 0.1], ...
                'FontUnits','normalized', ...
                'FontSize',fSize, ...
                'FontName', masivSetting('font.name'), ...
                'FontWeight', 'bold', ...
                'String', 'Overall Memory Status:', ...
                'HorizontalAlignment', 'center', ...
                'BackgroundColor', masivSetting('viewer.panelBkgdColor'), ...
                'ForegroundColor', masivSetting('viewer.textMainColor'), ...
                'HitTest', 'off');
           %% Inidividual Readouts
          uicontrol(...
                'Parent', obj.mainPanel, ...
                'Style', 'text', ...
                'Units', 'normalized', ...
                'Position', [0.02 0.47 0.6 0.1], ...
                'FontUnits','normalized', ...
                'FontSize',fSize, ...
                'FontName', masivSetting('font.name'), ...
                'String', 'Cached Images:', ...
                'HorizontalAlignment', 'right', ...
                'BackgroundColor', masivSetting('viewer.panelBkgdColor'), ...
                'ForegroundColor', hsv2rgb([0.3 0.6 0.8]), ...
                'HitTest', 'off');
            uicontrol(...
                'Parent', obj.mainPanel, ...
                'Style', 'text', ...
                'Units', 'normalized', ...
                'Position', [0.02 0.34 0.6 0.1], ...
                'FontUnits','normalized', ...
                'FontSize',fSize, ...
                'FontName', masivSetting('font.name'), ...
                'String', 'MATLAB:', ...
                'HorizontalAlignment', 'right', ...
                'BackgroundColor', masivSetting('viewer.panelBkgdColor'), ...
                'ForegroundColor', hsv2rgb([0.1 0.6 0.8]), ...
                'HitTest', 'off');
            uicontrol(...
                'Parent', obj.mainPanel, ...
                'Style', 'text', ...
                'Units', 'normalized', ...
                'Position', [0.02 0.21 0.6 0.1], ...
                'FontUnits','normalized', ...
                'FontSize',fSize, ...
                'FontName', masivSetting('font.name'), ...
                'String', 'Other Processes:', ...
                'HorizontalAlignment', 'right', ...
                'BackgroundColor', masivSetting('viewer.panelBkgdColor'), ...
                'ForegroundColor', hsv2rgb([0 0.6 0.8]), ...
                'HitTest', 'off');
            uicontrol(...
                'Parent', obj.mainPanel, ...
                'Style', 'text', ...
                'Units', 'normalized', ...
                'Position', [0.02 0.08 0.6 0.1], ...
                'FontUnits','normalized', ...
                'FontSize',fSize, ...
                'FontName', masivSetting('font.name'), ...
                'String', 'Free:', ...
                'HorizontalAlignment', 'right', ...
                'BackgroundColor', masivSetting('viewer.panelBkgdColor'), ...
                'ForegroundColor', hsv2rgb([0.6 0.6 0.8]), ...
                'HitTest', 'off');
            
            obj.txtCacheMem=uicontrol(...
                'Parent', obj.mainPanel, ...
                'Style', 'text', ...
                'Units', 'normalized', ...
                'Position', [0.60 0.47 0.3 0.1], ...
                'FontUnits','normalized', ...
                'FontSize',fSize, ...
                'FontName', masivSetting('font.name'), ...
                'HorizontalAlignment', 'right', ...
                'BackgroundColor', masivSetting('viewer.panelBkgdColor'), ...
                'ForegroundColor', hsv2rgb([0.3 0.6 0.8]), ...
                'HitTest', 'off');

            obj.txtMatlabOtherMem=uicontrol(...
                'Parent', obj.mainPanel, ...
                'Style', 'text', ...
                'Units', 'normalized', ...
                'Position', [0.60 0.34 0.3 0.1], ...
                'FontUnits','normalized', ...
                'FontSize',fSize, ...
                'FontName', masivSetting('font.name'), ...
                'HorizontalAlignment', 'right', ...
                'BackgroundColor', masivSetting('viewer.panelBkgdColor'), ...
                'ForegroundColor', hsv2rgb([0.1 0.6 0.8]), ...
                'HitTest', 'off');
            obj.txtUsedOtherMem=uicontrol(...
                'Parent', obj.mainPanel, ...
                'Style', 'text', ...
                'Units', 'normalized', ...
                'Position', [0.60 0.21 0.3 0.1], ...
                'FontUnits','normalized', ...
                'FontSize',fSize, ...
                'FontName', masivSetting('font.name'), ...
                'HorizontalAlignment', 'right', ...
                'BackgroundColor', masivSetting('viewer.panelBkgdColor'), ...
                'ForegroundColor', hsv2rgb([0 0.6 0.8]), ...
                'HitTest', 'off');
            obj.txtFreeMem=uicontrol(...
                'Parent', obj.mainPanel, ...
                'Style', 'text', ...
                'Units', 'normalized', ...
                'Position', [0.60 0.08 0.3 0.1], ...
                'FontUnits','normalized', ...
                'FontSize',fSize, ...
                'FontName', masivSetting('font.name'), ...
                'HorizontalAlignment', 'right', ...
                'BackgroundColor', masivSetting('viewer.panelBkgdColor'), ...
                'ForegroundColor', hsv2rgb([0.6 0.6 0.8]), ...
                'HitTest', 'off');

            %Set up a timer object to update the memory usage at a regular interval
            obj.tmr=timer('Name', 'Memory Info', ...
                         'ExecutionMode', 'fixedSpacing', ...
                          'Period', 2, ...
                          'TimerFcn', {@updateMemoryUsage, obj});
           
           start(obj.tmr)
           
        end
        function delete(obj)
            if ~isempty(obj.tmr)
                stop(obj.tmr)
            end
        end
    end
end

function updateMemoryUsage(~, ~, obj)

    [freeMemKiB, totalMemKiB]=systemMemStats;
    freeMemMiB=freeMemKiB/1024;
    totalMemMiB=totalMemKiB/1024;
    usedMemMiB=totalMemMiB-freeMemMiB;
    
    cacheMem=obj.gzvm.cacheMemoryUsed;
    otherMatMem=matlabMemUsageMiB-cacheMem; % these will be used more than once, so run query once and re-use variable
    try
        obj.rectUsedMem.Position=[0 0 usedMemMiB 1];
        obj.rectMatMem.Position=[0 0 otherMatMem 1];
        obj.rectCacheMem.Position=[0 0 cacheMem 1];
    catch
    end
    obj.txtFreeMem.String=sprintf('%uMiB', round(freeMemMiB));
    obj.txtUsedOtherMem.String=sprintf('%uMiB', round(usedMemMiB-otherMatMem));
    obj.txtMatlabOtherMem.String=sprintf('%uMiB', round(otherMatMem));
    obj.txtCacheMem.String=sprintf('%uMiB', round(cacheMem));
end












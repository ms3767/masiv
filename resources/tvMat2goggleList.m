function tvMat2goggleList(stitchedDir)
% Make goggleViewer files listing the stitched file locations from tvMat data
%
% function makeStictichedFileLists(stitchedDir)
%
%
% Purpose
% Make stitched image file lists from data stitched with tvMat to
% enable import into goggleViewer.
%
%
% Inputs
% stitchedDir - path to stitched data directory. 
%
% 
% Rob Campbell
%
% Notes: 
% Produces file with unix file seps on all platforms. Windows
% MATLAB seems OK about using these paths. Windows fileseps 
% mess up the fprintf.

if ispc
	fprintf('Fails on Windows machines. Not fixed yet\n')
end

if ~exist(stitchedDir,'dir')
	fprintf('Directory %s not found\n',stitchedDir)
	return
end


%Make file root name
baseName=directoryBaseName(getMosaicName);
baseName(end)=[]; %remove trailing '-'
stitchedFileListName=[baseName,'_','StitchedImagesPaths','_'];



%find the channels
chans = dir(stitchedDir);

for ii=1:length(chans)

	if regexp(chans(ii).name,'\d+')

        fprintf('Making channel %s file\n',chans(ii).name)
        tifDir=[stitchedDir,'/',chans(ii).name];
		tifs=dir([tifDir,'/','*.tif']);

		if isempty(tifs)
			fprintf('No tiffs in %s. Skipping\n',tifDir)
			continue
		end

		thisChan = str2num(chans(ii).name);
        
		fid=fopen(sprintf('%sCh%02d.txt',stitchedFileListName,thisChan),'w+');
		for thisTif = 1:length(tifs)         
                fprintf(fid,[tifDir,'/',tifs(thisTif).name,'\n']);
            
		end
		fclose(fid);

	end

end

% enter full path where the Imaris files are located
FOLDER = 'Z:\Ryan\Traces\To_convert\';
ims_files = dir([FOLDER '*.ims']);

did_not_pass = {};

for i=1:length(ims_files)
    ims_fn = ims_files(i).name;
    ims_dir = ims_files(i).folder;
    ims_full_fn = [ims_dir '\' ims_fn];
    disp(['Extracting filaments from ' ims_full_fn]);

    try
        extract_filaments_from_imaris(ims_full_fn);
    catch
        disp(['Did not succeed!']);
        did_not_pass{end+1} = ims_full_fn;
    end
   
end

% this will keep track of the Imaris files that were not converted
fid = fopen('failed_conversions.txt','wt');
for ii = 1:length(did_not_pass)
    fprintf(fid,'%s\n',did_not_pass{ii});
end
fclose(fid);

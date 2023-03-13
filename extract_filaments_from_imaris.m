

function [] = extract_filaments_from_imaris(ims_file)
    debug = 0;
    
    [filepath, ims_name, ext] = fileparts(ims_file);
    out_folder = fullfile('swc', ims_name);
    
    ir = ImarisReader(ims_file);
    NF = length(ir.Filaments);
    fprintf('There are %d filaments\n', NF);
    
    if exist(out_folder) == 0
        mkdir(out_folder)
    end

    % TODO: also extract physical voxel size
    %       as in https://github.com/PeterBeemiller/ImarisReader/blob/master/DatasetReader.m
    for i=1:NF
        fr = ir.Filaments(i);
        fr_name_ = regexprep(fr.Name,'[^a-zA-Z0-9]','');
        fprintf('Extracting Filament %03d/%03d "%s" into folder "%s"\n', i, NF, fr_name_, out_folder);
        
        if debug
            cmap = rand(fr.NumberOfFilaments+1, 3);
            figure;
        end
        
        for fidx=0:fr.NumberOfFilaments-1
            out_swc_fn = fullfile(out_folder, sprintf('Filament_%03d_%s_Trace_%04d.swc', i, strrep(fr_name_, ' ', '_'), fidx));
            fid = fopen(out_swc_fn, 'w');
            positons_lkp = fr.GetPositions(fidx);
            type_lkp = fr.GetTypes(fidx);
            
            % set root to have type '1' == soma
            type_lkp(1) = 1;
            radius_lkp = fr.GetRadii(fidx);

            if debug
                plot(positons_lkp(:, 1), positons_lkp(:, 2), '.', 'Color', cmap(fidx+1,:));
                hold on;
            end
            % sort according to index
            edges = fr.GetEdges(fidx);
            [~, order] = sort(edges(:,2));
            edges = edges(order,:);

            % index for lookup of pos and radii
            vertex_idx = [0;edges(:,2)]+1;

            % new, one-based, ids
            vertex_ids = double(1:length(vertex_idx));
            vertex_in_ids = double([-1; edges(:,1)+1]);

            % combine and export to file
            tree_rep = [vertex_ids', type_lkp(vertex_idx), positons_lkp(vertex_idx, :), radius_lkp(vertex_idx), vertex_in_ids];
            fprintf(fid, '%d %d %f %f %f %f %d\n', tree_rep');

            fclose(fid);
            
            current_script = mfilename('fullpath');
            [filepath, ~, ~] = fileparts(current_script);
            neuroland_conerter_exe = fullfile(filepath, 'NLMorphologyConverter.exe');
            if fidx == 0
                disp(['Neuroland seen in: ', neuroland_conerter_exe]);
            neuroland_args = ['"', out_swc_fn, '" --export "', out_swc_fn(1:end-4), '_nl_corrected.swc"', ' swc'];
            %neuroland_command = [neuroland_conerter_exe, ' ', neuroland_args];
            neuroland_command = ['NLMorphologyConverter', ' ', neuroland_args];
            disp(['  ...convert filament id ', num2str(fidx), ' with neuroland']);
            ec = system(neuroland_command);
            if ec > 0
                disp(' Neuroland conversion failed')
            end
        end
        
    end
end
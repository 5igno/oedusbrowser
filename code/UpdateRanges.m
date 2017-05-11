function ranges = UpdateRanges(ranges, ix, range_type)

if isempty(ranges)
    % if there was no range before, just add the range
    ranges = {range_type, ix, [], [], []};
else
    switch range_type
        case {'Raman','Photoluminescence','Rayleigh line'}
            % Run though the ranges
            [ N_ranges , ~ ] = size( ranges );
            for id_range = 1 : N_ranges
                %  and if there is already the same range in proximity
                if strcmp( ranges{id_range,1}, range_type ) && not( isempty( intersect( ix, ranges{ id_range, 2 } ) ) )
                    % identify the range index
                    id_overview = id_range;
                end
            end
            
        case 'Background'
            
            % Run though the ranges
            [ N_ranges , ~ ] = size( ranges );
            for id_range = 1 : N_ranges
                %  and if there is already the same range 
                if strcmp(ranges{id_range,1}, range_type)
                    % enlarge it
                    ix = union( ix, ranges{ id_range, 2 } );
                    % and identify the range index
                    id_overview = id_range;
                end
            end
    end
    
    if exist('id_overview','var')
        % and replace range
        ranges{ id_overview, 2 } = ix ;
        % and clean whatever there is of the fitting associated with it
        ranges{ id_overview, 3 } = [] ;
        ranges{ id_overview, 4 } = [] ;
        ranges{ id_overview, 5 } = [] ;
        
    else
        % otherwise add the range
        ranges = [ ranges ; {range_type, ix, [], [], []} ] ;
        
        
    end
end
        
        
        
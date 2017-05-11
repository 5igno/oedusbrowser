function [ new_ranges, roi_slct ] = DeleteROI( ranges, roi_slct )

[ N_ranges, ~ ] = size(ranges);

if N_ranges > 1
    new_ranges = cell(N_ranges-1,5);
    
    new_ix = 1;
    for id = 1:N_ranges
        if id ~= roi_slct
            new_ranges(new_ix, 1:5) = ranges(id, 1:5);
            new_ix = new_ix + 1;
        end
    end
    
    if roi_slct > N_ranges-1
        roi_slct = N_ranges-1;
    end
else
    new_ranges  = {};
    roi_slct = 1;
end
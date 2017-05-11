function answer = isinthe( astring, string_list )

answer = logical( strcmp(astring, string_list) * ones(length(string_list),1) );
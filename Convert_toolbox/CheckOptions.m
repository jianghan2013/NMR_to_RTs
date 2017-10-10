function opts = CheckOptions(opts,list)
% Checks if struct contains the fields in list, and sets the default value
% if it doesn't exist.
% {'field 1','string default value 1','field 2',numeric_default_value_2,... etc}
for i=1:2:length(list)
   if(~isfield(opts, list{i}))
    opts=setfield(opts,list{i},list{i+1});
    %fprintf('\nWarning: default value for %s is being used!\n',list{i});
   end
end

end

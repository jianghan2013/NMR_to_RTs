function opts = SetOptions(list)
% Generates a structure opts from the cell array list
% {'field 1','string value 1','field 2',numeric_value_2,... etc}
opts=[];
for i=1:2:length(list)
   opts=setfield(opts,list{i},list{i+1});
end

end


%%
bags=50;
load fisheriris

prefix='test'

 

% if lables are strings
strunique=unique(species);
for i=1:length(strunique)
I=strcmp(strunique{i},species);
speciesnum(I)=i;
end
classesunique=unique(speciesnum);
uniqueclasses=sort(classesunique);
species=speciesnum;
b = TreeBagger(bags,meas,species)

% if lables are numeric
% classesunique=unique(species);
% uniqueclasses=sort(classesunique);
% species=speciesnum;

extractDecTreeStruct(b,classesunique,1,bags,meas,species,prefix,uniqueclasses)
% 	

function []=DecTreeCwrite(Bags,branches,storeBranchLength,storeBranchLogic,storeBranchVal,storeBranchVecI,Class,filename,uniqueclasses)
% x is the vector to be classified
% branches is the total number of branches in the tree
% storeBranchLength is the length of each branch
% x(storeBranchVecI) tells us which item of x is to evaluted at each branch
% storeBranchVal stores the vale which x(storeBranchVecI) is to be tested
% against
% storeBranchLogic tells us wheather the logic test result is 0 or 1,1 is x(storeBranchVecI) < storeBranchVal
% 0 is x(storeBranchVecI) >= storeBranchVal

ID=fopen(filename,'w');

fprintf(ID,'Number of Classes\n%i \n',length(uniqueclasses));

fprintf(ID,'Number of Bags\n%i \n',Bags);

fprintf(ID,'Number of Branches\n%i \n',branches);
fprintf(ID,'Max branch length\n%i \n',max(storeBranchLength));


fprintf(ID,'Branch Lengths\n');

for i=1:length(storeBranchLength)
fprintf(ID,'%i ',storeBranchLength(i));
end
fprintf(ID,'\n');


fprintf(ID,'Branch Logic\n');
for i=1:length(storeBranchLogic(:,1))
    for j=1:length(storeBranchLogic(1,:))
    fprintf(ID,'%i ',storeBranchLogic(i,j));
    end
    fprintf(ID,'\n');

end

fprintf(ID,'Branch Values\n');
for i=1:length(storeBranchVal(:,1))
    for j=1:length(storeBranchVal(1,:))
    fprintf(ID,'%1.20f ',storeBranchVal(i,j));
    end
    fprintf(ID,'\n');

end


fprintf(ID,'Branch Input Vector Index\n');
for i=1:length(storeBranchVecI(:,1))
    for j=1:length(storeBranchVecI(1,:))
    fprintf(ID,'%i ',storeBranchVecI(i,j));
    end
    fprintf(ID,'\n');

end


fprintf(ID,'Class Labels\n');
for i=1:length(Class)
    if iscell(Class(i))==1
        tmp=Class{i};
        if isstr(tmp)==1;
        fprintf(ID,'%s ',tmp);
        elseif isnum(tmp)==1;
            fprintf(ID,'%i ',tmp);
        end

    elseif isnum(Class(i))==1
        tmp=Class(i);
        
            fprintf(ID,'%i ',tmp);
    end
    
end




fclose(ID);
% for bi=1:branches
%        result(bi)=1;
% 
%    for ni=1: storeBranchLength(bi)
%        test(bi,ni)=nan;
%        if storeBranchLogic(bi,ni)==1
%        if x(storeBranchVecI(bi,ni))<storeBranchVal(bi,ni)
%                 test(bi,ni)=1;
% 
%        end
%        end
%        
%         if storeBranchLogic(bi,ni)==0
%        if x(storeBranchVecI(bi,ni))>=storeBranchVal(bi,ni)
%            test(bi,ni)=1;
%        end
%        end
%        
%           result(bi)=result(bi)*test(bi,ni);
% 
%    end
%    
% end
% 
% class=Class(find(result==1));
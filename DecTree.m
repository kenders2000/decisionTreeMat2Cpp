function [class]=DecTree(x,branches,storeBranchLength,storeBranchLogic,storeBranchVal,storeBranchVecI,Class)
% x is the vector to be classified
% branches is the total number of branches in the tree
% storeBranchLength is the length of each branch
% x(storeBranchVecI) tells us which item of x is to evaluted at each branch
% storeBranchVal stores the vale which x(storeBranchVecI) is to be tested
% against
% storeBranchLogic tells us wheather the logic test result is 0 or 1,1 is x(storeBranchVecI) < storeBranchVal
% 0 is x(storeBranchVecI) >= storeBranchVal

for bi=1:branches
       result(bi)=1;

   for ni=1: storeBranchLength(bi)
       test(bi,ni)=nan;
       if storeBranchLogic(bi,ni)==1
       if x(storeBranchVecI(bi,ni))<storeBranchVal(bi,ni)
                test(bi,ni)=1;

       end
       end
       
        if storeBranchLogic(bi,ni)==0
       if x(storeBranchVecI(bi,ni))>=storeBranchVal(bi,ni)
           test(bi,ni)=1;
       end
       end
       
          result(bi)=result(bi)*test(bi,ni);

   end
   
end

class=Class(find(result==1));
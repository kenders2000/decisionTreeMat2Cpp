function []=extractDecTreeStruct(b,classesunique,treebag,bags,prefix)
% 	This function takes a treebagger class, or decision tree class, and outputs a text file with all
%	The information required to export the treebagger / classification functions
%   inputs
%	b : Treebagg class structure, or or classification tree structure
%	classesunique : list of unique class labels (numerical)
%	treebag : 0 for classification tree, 1 for treebagger
%	bags : number of bags
%	meas	: features - Test that classifier is working with this test
%	data
%	species	 : class labels (numeric)- Test that classifier is working with this test
%	data
%	prefix : filename prefix for text file output.
%	uniqueclasses : unique class in order (numeric)
%	Copyright (c) <2014> <Paul Kendrick>

%	Permission is hereby granted, free of charge, to any person obtaining a copy
%	of this software and associated documentation files (the "Software"), to deal
%	in the Software without restriction, including without limitation the rights
%	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
%	copies of the Software, and to permit persons to whom the Software is
%	furnished to do so, subject to the following conditions:

%	The above copyright notice and this permission notice shall be included in
%	all copies or substantial portions of the Software.

%	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
%	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
%	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
%	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
%	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
%	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
%	THE SOFTWARE.
%	Copyright (c) <2014> <Paul Kendrick>

% /*Permission is hereby granted, free of charge, to any person obtaining a copy
% of this software and associated documentation files (the "Software"), to deal
% in the Software without restriction, including without limitation the rights
% to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
% copies of the Software, and to permit persons to whom the Software is
% furnished to do so, subject to the following conditions:
% 
% The above copyright notice and this permission notice shall be included in
% all copies or substantial portions of the Software.
% 
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
% IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
% FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
% AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
% LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
% OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
% THE SOFTWARE.
% */

uniqueclasses=sort(classunique,'ascend');
% meas,species
clear class class_out
for bagi=1:bags
    if treebag==1
            [T] = evalc('view(b.Trees{bagi})');    
    else
        [T] = evalc('view(b)');    
    end

C=textscan(T,'%s','Delimiter','\n');
clear C1;
for i=3:length(C{1})-1
    
    C1{i-2}=C{1}{i};
end


i=1;
TreeMat=[];
clear TreeDecisions 
Cline=textscan(C1{i},'%s','Delimiter',' ');
Cline=Cline{1};
n=1;%str2num(Cline{7})
% first find every path through tree   
%%  Locate ends of branches
clear ends
for i=1:length(C1)
ends(i)=length(strfind(C1{i},'class'))>0;
end
branches=sum(ends); %branches


% log the node paths for each non-ned of branch path 

I=find(ends==0);
clear nodeVecI nodeVecI nodeLogicVal nodepaths

for i=1:length(I)
        Ctmp=textscan(C1{I(i)},'%s','Delimiter',' ');
    Ctmp=Ctmp{1};
nodepaths(I(i),1)=str2num(Ctmp{7});
nodepaths(I(i),2)=str2num(Ctmp{12});
nodeLogic{I(i),1}=(Ctmp{4});
nodeLogic{I(i),2}=(Ctmp{9});

tt=textscan(Ctmp{4},'%*c%*n%*c%n');
nodeLogicVal(I(i),1)=tt{1};


tt=textscan(Ctmp{4},'%*c%n%*c%*n');
nodeVecI(I(i),1)=(tt{1});


end
%%
clear storeBranchTmpVecI storeBranchTmpVal storeBranchTmpL storeBranchLength
I=find(ends==1);
for i=1:sum(ends)
    ClineEnd=textscan(C1{I(i)},'%s','Delimiter',' ');
    ClineEnd=ClineEnd{1};
    Class{i}=ClineEnd{end};
    node_next=str2num(ClineEnd{1});
    %now traceback to start recording logical decisions as we go
    BranchTmp=[];
    BranchTmpL=[];
    BranchTmpVecI=[];
    BranchTmpVal=[];
    foundStart=0;
    nodes=[];
    
    
    
    while foundStart==0
        
         n1=find(nodepaths==node_next);[n,J] = ind2sub(size(nodepaths),n1);
        
        
        nodes=[nodes n];
        BranchTmpL=[BranchTmpL J==1];
        BranchTmpVecI=[BranchTmpVecI nodeVecI(n)];
        BranchTmpVal=[BranchTmpVal nodeLogicVal(n)];
        if (n==1)
            foundStart=1;
        end

        ClineTmp=textscan(C1{n},'%s','Delimiter',' ');
        ClineTmp=ClineTmp{1};
        node_next=str2num(ClineTmp{1});
    end
    N=length(BranchTmpVecI);
    storeBranchTmpVecI(i,1:N)=fliplr(BranchTmpVecI);
    storeBranchTmpVal(i,1:N)=fliplr(BranchTmpVal);
    storeBranchTmpL(i,1:N)=fliplr(BranchTmpL);
    storeBranchLength(i)=length(BranchTmpVal);
    
end
storeBranchTmpVal(storeBranchTmpVecI==0)=nan;
storeBranchTmpL(storeBranchTmpVecI==0)=nan; % 1 is less than  ... 0 is greater or equal to
storeBranchTmpVecI(storeBranchTmpVecI==0)=nan;
%% % Decision tree code
filename=sprintf('%s_bag_%i.txt',prefix,bagi);

 DecTreeCwrite(bags,branches,storeBranchLength,storeBranchTmpL,storeBranchTmpVal,storeBranchTmpVecI,Class,filename,uniqueclasses);

for ii=1:length(meas)
x=meas(ii,:);
classout=0;
clear test
 cl=DecTree(x,branches,storeBranchLength,storeBranchTmpL,storeBranchTmpVal,storeBranchTmpVecI,Class);

class_out(bagi,ii)=classesunique(find(classesunique==str2num(cl{1})));
% find(strcmp(mat2str(classesunique),(cl{1})));

end

end
%%  test classifier

% clear count vote
% for datai=1:length(meas)
% for classi=1:length(classesunique)
%     count(datai,classi)=sum(classesunique(classi)==class_out(:,datai));
% end
% [ null Imax]=max(count(datai,:));
% [null Isorted]=sort(count(datai,:));
% 
% if sum(count(datai,Imax)==count(datai,Isorted))>1
% 
%     I=find(count(datai,Imax)==count(datai,:));
%     classesunique(  I(ceil(rand()*length(I)))  );
%     
%     
%      vote(datai)=min(classesunique(I));
% %       vote(datai)=    classesunique(  I(ceil(rand()*length(I)))  );
% else
%     vote(datai)=classesunique(Imax);
% end
%     
% end
% numericlabels=species;

% sum(vote==numericlabels)/length(numericlabels)
% 
%  trueVote=predict(b,meas);  trueVote=str2num(cell2mat(trueVote));             
%  sum(trueVote==numericlabels')/length(numericlabels)

function [def  undef]=select(node_pair)
%Select a IN, def is the returned IN, undef is the returned UIN;
un=[];%Undisputed Nodes
yun=[];%disputed Nodes
for i=1:size(node_pair,1)
    if length(find(node_pair(i,1)==node_pair(:,1)))==1
        if length(find(node_pair(i,2)==node_pair(:,2)))==1
            un=[un;node_pair(i,1:2)];
        end
    end
end
def=un;
if isempty(un)
    undef=node_pair(:,1:2);
else
    undef=setdiff(node_pair(:,1:2), un,'rows');
end
end
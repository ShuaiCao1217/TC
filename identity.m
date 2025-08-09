function [ def1 ] = identity(undef_user,lay1,lay2,lay_de,lay1_nei,lay2_nei,al_rec_list,jiekou)
%Further processing of UIN, considering the connection relationship between verified nodes, recalculate the similarity between non-clear nodes, def1 is the returned INP.
def=[];
tempresult=undef_user;
lay1_undef_def=lay1(lay1_nei(:,2),al_rec_list(:,2));
lay2_undef_def=lay2(lay2_nei(:,2),al_rec_list(:,3));
for i=1:size(undef_user,1)
    con_nei=find( lay1_undef_def(undef_user(i,1),:) & lay2_undef_def(undef_user(i,2),:) );%
    sub_net= jiekou(con_nei,con_nei) ;
    sub_node_edge=sum(sub_net,2);
    org_node_degree=lay_de(con_nei);
    tol=(1+sub_node_edge)./ org_node_degree;
    tol(isnan(tol))=0;
    tol(isinf(tol))=0;
    tempresult(i,3)=sum(tol);
    clear org_node_degree;
end
%The following is to select the node pair
temp1=[];
for i=1:size(tempresult,1)
    row=find(tempresult(:,1)==tempresult(i,1));
    re=sum(tempresult(row,3)>=tempresult(i,3));
    if re == 1
        temp1=[temp1;tempresult(i,1:2)];
    end
end
temp2=[];
for i=1:size(tempresult,1)
    col=find(tempresult(:,2)==tempresult(i,2));
    re=sum(tempresult(col,3)>=tempresult(i,3));
    if re == 1
        temp2=[temp2;tempresult(i,1:2)];
    end
end
if isempty(temp1)||isempty(temp2)
    def1=[];
else
    def1=intersect(temp1, temp2,'rows');%If a node pair satisfies both row maximum and column maximum, then it is a INP.
end
end
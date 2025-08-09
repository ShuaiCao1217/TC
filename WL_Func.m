function [UMP] = WL_Func(lay1_net,lay2_net,lay1_de,lay2_de,train_set)

already_recognition_list(:,1)=1:size(train_set,1);
already_recognition_list(:,2:3)=train_set;
nei_lay1=lay1_net(:,already_recognition_list(:,2));
nei_lay2=lay2_net(:,already_recognition_list(:,3));
nei_list_lay1=sum(nei_lay1,2);
nei_list_lay2=sum(nei_lay2,2);
nei_list_lay1=find(nei_list_lay1);
nei_list_lay2=find(nei_list_lay2);
nei_list_lay1=setdiff(nei_list_lay1,already_recognition_list(:,2));
nei_list_lay2=setdiff(nei_list_lay2,already_recognition_list(:,3));

already_recognition_neighbors_lay1(:,1)=1:length(find(nei_list_lay1));
already_recognition_neighbors_lay2(:,1)=1:length(find(nei_list_lay2));
already_recognition_neighbors_lay1(:,2)=nei_list_lay1;
already_recognition_neighbors_lay2(:,2)=nei_list_lay2;

lay1_temp=lay1_net(already_recognition_neighbors_lay1(:,2),already_recognition_list(:,2));
lay2_temp=lay2_net(already_recognition_list(:,3),already_recognition_neighbors_lay2(:,2));
lay1_2_con_de=sum(lay1_net(already_recognition_list(:,2),already_recognition_list(:,2)) & lay2_net(already_recognition_list(:,3),already_recognition_list(:,3)),2);

lay1_de_temp=lay1_de(already_recognition_list(:,2),2);
lay2_de_temp=lay2_de(already_recognition_list(:,3),2);
lay_de_temp1=lay1_de_temp+lay2_de_temp-lay1_2_con_de;

lay_de_temp=1./repmat(lay_de_temp1',[size(already_recognition_neighbors_lay1,1),1]);
lay_de_temp(isnan(lay_de_temp))=0;
lay_de_temp(isinf(lay_de_temp))=0;
lay_de_temp=lay_de_temp.*lay1_temp;
lay_k=lay_de_temp*lay2_temp;
lay1_lay2_score=lay_k;

this_result=[];
this_max_value=1;
while ~isempty(already_recognition_neighbors_lay1) && ~isempty(already_recognition_neighbors_lay2)
    
    [row col value]=find(lay1_lay2_score);
    score_list=[row col value];
    if isempty(score_list)
        break;
    end
    this_max_value=max(score_list(:,3));
    if isempty(this_max_value) || this_max_value == 0  
        break;
    end
    
    this_max_num=length( unique(score_list(:,3)) );
    max_num=0;
    
    contemp1=lay1_net(already_recognition_list(:,2),already_recognition_list(:,2));
    contemp2=lay2_net(already_recognition_list(:,3),already_recognition_list(:,3));
    contemp3=contemp1 | contemp2;
    
    while isempty(this_result) && (max_num<this_max_num*0.3)%When the similarity score is not in the top 30%, the possibility of it being the same person is too low, and the loop ends.
        max_num=max_num+1;
        [def  undef] = select(score_list(score_list(:,3)==this_max_value,1:2));
        %Start selecting from the node pair with the highest similarity level, def is the returned IN, and undef is the returned UIN;
        this_result=def;
        def1=[];
        if ~isempty(undef)%If there is an ambiguous node pair, run step 3 to calculate the similarity again
            [ def1 ] = identity(undef,lay1_net,lay2_net,lay_de_temp1,already_recognition_neighbors_lay1,already_recognition_neighbors_lay2,already_recognition_list,contemp3);
        end
        
        if ~isempty(def1)
            this_result=[this_result;def1];
        end
        score_list(score_list(:,3)==this_max_value,:)=[];
        this_max_value=max(score_list(:,3));
    end
    
    clear findmax_row findmax_col;
    
    if isempty(this_result)
        s2='Exit Condition 2'
        break;
    end
    clear row col value score_list;
    this_result(:,3)=already_recognition_neighbors_lay1(this_result(:,1),2);
    this_result(:,4)=already_recognition_neighbors_lay2(this_result(:,2),2);
    already_recognition_list=[already_recognition_list;this_result(:,2:4)];
    already_recognition_list(:,1)=1:size(already_recognition_list,1);
    
    this_result=[];
    nei_lay1=lay1_net(:,already_recognition_list(:,2));
    nei_lay2=lay2_net(:,already_recognition_list(:,3));
    nei_list_lay1=sum(nei_lay1,2);
    nei_list_lay2=sum(nei_lay2,2);
    nei_list_lay1=find(nei_list_lay1);
    nei_list_lay2=find(nei_list_lay2);
    nei_list_lay1=setdiff(nei_list_lay1,already_recognition_list(:,2));
    nei_list_lay2=setdiff(nei_list_lay2,already_recognition_list(:,3));
    
    clear already_recognition_neighbors_lay1;clear already_recognition_neighbors_lay2;
    already_recognition_neighbors_lay1(:,1)=1:length(find(nei_list_lay1));
    already_recognition_neighbors_lay2(:,1)=1:length(find(nei_list_lay2));
    already_recognition_neighbors_lay1(:,2)=nei_list_lay1;
    already_recognition_neighbors_lay2(:,2)=nei_list_lay2;    

lay1_temp=lay1_net(already_recognition_neighbors_lay1(:,2),already_recognition_list(:,2));
lay2_temp=lay2_net(already_recognition_list(:,3),already_recognition_neighbors_lay2(:,2));
lay1_2_con_de=sum(lay1_net(already_recognition_list(:,2),already_recognition_list(:,2)) & lay2_net(already_recognition_list(:,3),already_recognition_list(:,3)),2);
lay1_de_temp=lay1_de(already_recognition_list(:,2),2);
lay2_de_temp=lay2_de(already_recognition_list(:,3),2);
lay_de_temp1=lay1_de_temp+lay2_de_temp-lay1_2_con_de;

lay_de_temp=1./repmat(lay_de_temp1',[size(already_recognition_neighbors_lay1,1),1]);
lay_de_temp(isnan(lay_de_temp))=0;
lay_de_temp(isinf(lay_de_temp))=0;
lay_de_temp=lay_de_temp.*lay1_temp;
lay_k=lay_de_temp*lay2_temp;
lay1_lay2_score=lay_k;
end
UMP=already_recognition_list(size(train_set,1)+1:size(already_recognition_list,1),2:3);
end
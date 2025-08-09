dbstop if error
clear all;
net_num=20;
for inum=1:net_num
filename_lay1=['lay1_',num2str(inum),'.txt'];
filename_lay2=['lay2_',num2str(inum),'.txt'];
filename_lay1_2_rela=['rela_',num2str(inum),'.txt'];
filename_output=['re_DEEA_',num2str(inum),'.txt'];%The file name of the output result.
fid=fopen(filename_output,'w');
    lay1_linklist=textread(filename_lay1);
    lay2_linklist=textread(filename_lay2);  
    lay1_linklist=FormNet(lay1_linklist);
    lay2_linklist=FormNet(lay2_linklist);
    lay1_2_relation=textread(filename_lay1_2_rela);   
    
    known_rate=0.01:0.01:0.10;
    knownInterval=0.01;
    test_num=10;
    
    lay1_degree(:,1)=1:size(lay1_linklist,1);
    lay2_degree(:,1)=1:size(lay2_linklist,1);
    lay1_degree(:,2)=sum(lay1_linklist,2);
    lay2_degree(:,2)=sum(lay2_linklist,2);
    
    recall=zeros(length(known_rate),test_num);
    precision=zeros(length(known_rate),test_num);
    accuracy=zeros(length(known_rate),test_num);
    for experi_times=1:1:test_num    
        aaa=experi_times
        for this_rate=known_rate
            bbb=this_rate
            [train test] = divide_data(lay1_2_relation(:,1:2), this_rate); 
            [UMP]=WL_Func(lay1_linklist,lay2_linklist,lay1_degree,lay2_degree,train);%WL_Func is the specific process of the algorithm. 
            rightnum=0;
            therownum=int8(this_rate/knownInterval);
            lay1node=1:size(lay1_linklist,1);
            lay2node=1:size(lay2_linklist,1);
            lay1node=setdiff(lay1node,train(:,1));
            lay2node=setdiff(lay2node,train(:,2));
            lay1node_sur=setdiff(lay1node,UMP(:,1));
            lay2node_sur=setdiff(lay2node,UMP(:,2));
            lay1node_sur=setdiff(lay1node,lay1_2_relation(:,1));
            lay2node_sur=setdiff(lay2node,lay1_2_relation(:,2));
            for i=1:size(UMP)
                if(ismember(UMP(i,:),test,'rows')==1)
                    rightnum=rightnum+1;
                end
            end
            recall(therownum,experi_times)=rightnum/size(test,1);
            precision(therownum,experi_times)=rightnum/size(UMP,1);
            if isempty(UMP)||size(UMP,1)==0
                precision(therownum,experi_times)=0;
            end
            accuracy(therownum,experi_times)=(2*rightnum+length(lay1node_sur)+length(lay2node_sur))/(length(lay1node)+length(lay2node));
        end
    end
            
     result(:,1)=known_rate;
     result(:,2)=mean(recall,2);
     result(:,3)=mean(precision,2);
     result(:,4)=2*result(:,2).*result(:,3)./(result(:,2)+result(:,3));
     result(:,5)=mean(accuracy,2);
     for theknown_rate=known_rate
     therow=int8(theknown_rate/knownInterval);
     fprintf(fid,' %f %f %f %f %f\n',result(therow,1),result(therow,2),result(therow,3),result(therow,4),result(therow,5)); 
     end
clear recall;clear precision;clear result;clear accuracy;
fclose(fid);
end

function [nnews,ldic]=createwwnDiskSize(uniqueWords,text,textF,dictionaryMap,k)
mkdir IndicesTemp_TTA;
nnews = size(text,1) %number of news
ldic= double(dictionaryMap.Count);
%get 10% of dataset size 
s=floor(nnews*0.1);
c=s;
aux=s;
subIndNews=cell(1,c); 
valsNews=cell(1,c);
g=1;
size(uniqueWords)
for i=1:nnews
    nnews
    disp(i);
    uw=uniqueWords{i};
    subInd=cell(1,length(uw));
    vals=cell(1,length(uw));
    l=1;
    for j=1:length(uw)
        idxlist=find(strcmp(text{i},uw(j)));
        lidxlist=length(idxlist);
        co_oclist=cell(1,lidxlist);
        if lidxlist==1
            
            co_oclist{1,1} = findcooc(idxlist,text{i},textF(i),k);
        else
            for h=1:lidxlist
                
                co_oclist{1,h}=findcooc(idxlist(h),text{i},textF(i),k);
                
            end
        end
        co_oclist = horzcat(co_oclist{:});
        [uniqueCooc,~,idxCooc] = unique(co_oclist);
        fabs=accumarray(idxCooc,1);
        if ~isempty(uniqueCooc)
            idx=cell2mat(values(dictionaryMap,uniqueCooc));
            iduw = dictionaryMap(uw{j});
            indx=ones(1,length(idx))';
            subInd{l}=[(indx*iduw) idx' (i*indx)];
            vals{l} = fabs;
        end
        l=l+1;
        clear idx co_oclist uniqueCooc idxCooc fabs indx;
        %clear lidxlist;
    end
    subIndNews{1,g}=vertcat(subInd{:});
    valsNews{1,g}=vertcat(vals{:});
    clear subInd;
    clear vals;
    g=g+1;
    if i == aux
        subIndNews=vertcat(subIndNews{:});
        valsNews=vertcat(valsNews{:});
        file_name= strcat('./IndicesTemp_TTA/subIndNewsVals_', num2str(i),'.mat');
        save(file_name,'-v7.3','subIndNews','valsNews');
        clear subIndNews;
        clear valsNews;
        subIndNews=cell(1,c); 
        valsNews=cell(1,c);
        g=1;
        aux=aux+c;
    end
end
subIndNews=vertcat(subIndNews{:});
valsNews=vertcat(valsNews{:});
file_name= strcat('./IndicesTemp_TTA/subIndNewsVals_', num2str(nnews),'.mat');
save(file_name,'-v7.3','subIndNews','valsNews');
end


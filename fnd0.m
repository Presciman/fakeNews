function fnd(datasetFile,fn,R,nn,it,pl,window)

load(datasetFile);

[uniqueWords,dictionary,~,~,wordsNews] = createDictionary(news.textT);
news.textT=wordsNews;
for i=1:size(news,1)
    news.textF(i)=length(wordsNews{i});
end
%Use if the dictionatyMap has not been generated before
indices = 1:length(dictionary);
dictionaryMap = containers.Map(dictionary, indices);
%save('dictionaryMapList.mat','-v7.3','dictionaryMap');
disp('dictionaryMap finished');
tic
%set cell that contains news content, length, binary label.
textT=news.textT;
textF=news.textF;
label3=news.label3;
clear news; %remove dataset
%window=5;
%create co-occurrence indices
[nnews,ldic]=createwwnDiskSize(uniqueWords,textT,textF,dictionaryMap,window);
[wxwxn,wxwxnF,wxwxnL] = buildCoocTensor(nnews,ldic);
%save('co-occurrence_newds.mat','-v7.3','wxwxn','wxwxnF','wxwxnL');
disp('tensor done!')
%R=10;
%nn=10;
%pl=0.10;
%it=10;
%tensor decomposition
X=cp_als(wxwxn,R);
filename=strcat(fn,'_binary');
run_cp_FaBP_s(X.U{3},nn,it,pl,label3,filename);
clear X;
disp('binary done!');
X=cp_als(wxwxnF,R);
filename=strcat(fn,'_freq');
run_cp_FaBP_s(X.U{3},nn,it,pl,label3,filename);
clear X;
disp('freq done!');
X=cp_als(wxwxnL,R);
filename=strcat(fn,'_log');
run_cp_FaBP_s(X.U{3},nn,it,pl,label3,filename);
disp('log done!');
end

function fnd(fn,indxfile,R,nn,it,pl,window)
load('datasetNews.mat');
%filename='./equal.csv';
%filename='./uni.csv';
%fakeJoinnew=readtable(filename,'Delimiter',',');
%load('datasetNews.mat');
%fakeJoinnew=news;
%label3=fakeJoinnew.label3;
%XX=cell(1,100);
pl=[0.1];
for k=1:length(pl)
for h=1:1
%load(strcat ('./Matrices/newsTagsMatrix',num2str(h),'.mat'));
%fakeJoinnew=tagsHtmlDomain;
fakeJoinnew=news;
%Ystring=cellfun(@strsplit,cellstr(fakeJoinnew.textT),'UniformOutput',false);
[uniqueWords,dictionary,~,~,wordsNews] = createDictionary(fakeJoinnew.textT);%Ystring);
Ystring=wordsNews;
for i=1:size(fakeJoinnew,1)
  fakeJoinnew.textF(i)=length(wordsNews{i});
end
%Use if the dictionatyMap has not been generated before
indices = 1:length(dictionary);
dictionaryMap = containers.Map(dictionary, indices);
save('title_dictionary_1.mat','-v7.3','dictionaryMap');
disp('dictionaryMap finished');
tic
%set cell that contains news content, length, binary label.
textT=Ystring;
textF=fakeJoinnew.textF;
label3=fakeJoinnew.label3;
%clear news; %remove dataset
%window=5;
%reate co-occurrence indicesi
%size(uniqueWords)
[nnews,ldic]=createwwnDiskSize(uniqueWords,textT,textF,dictionaryMap,window);
[wxwxn,wxwxnF,wxwxnL] = buildCoocTensor_TTA(nnews,ldic);
%save(strcat('./TTA_TS3/TTA_',num2str(h),'.mat'),'-v7.3','wxwxn');
%load('./TTA_total.mat');
%load('co-occurrence_news.mat');
%load(strcat('/home/sabda005/themadone/source/CP_Matrix/wxwxn/wxwxn',num2str(h)));
disp('tensor done!')
%R=10;
%nn=10;
%tensor decomposition
%load ('Title.mat');

X=cp_als(wxwxn,R);
save('./TTA63k.mat','-v7.3','X','wxwxn');

%XX{h}=X;
%load('TTA_total.mat');
filename=strcat(fn,'_binary');
[avgl(h),prec_avgl(h),f1_avgl(h),rec_avgl(h)]= run_cp_FaBP_s2(X.u{3},nn,100,pl(k),label3);
%run_cp_FaBP_s(X.U{3},nn,it,pl,label3,filename,indxfile);
disp('binary done!');
%save(strcat('./TTA_TS/TTA_',num2str(pl(k)*100),'.mat'),'-v7.3','XX');
clear X;
clear XX;
  % avgl = mean(avgl);
   % prec_avgl = mean(prec_avgl);
   % f1_avgl = mean(f1_avgl);
   % rec_avgl = mean(rec_avgl);
    file_name= strcat('./TTA_TOTAL_nn10_it10_pl',num2str(pl(k)*100),'.mat');
    save(file_name,'-v7.3','avgl','prec_avgl','f1_avgl', 'rec_avgl');
%X=cp_als(wxwxnF,R);
%filename=strcat(fn,'_freq');
%run_cp_FaBP_s(X.U{3},nn,it,pl,label3,filename,indxfile);
%clear X;
%disp('freq done!');
%X=cp_als(wxwxnL,R);
%filename=strcat(fn,'_log');
%run_cp_FaBP_s(X.U{3},nn,it,pl,label3,filename,indxfile);
%disp('log done!');
end
end

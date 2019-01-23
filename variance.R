setwd('C:\\Users\\cloudhealth\\Desktop\\1123')
a=read.table("log_norm.txt",header=T,sep="\t",row.names=1) 
a
#Ԥ����2�������������ļ�������ͬ��ȫΪ0�������������ڴ洢p value�Ͳ��챶����log2FC��
Pvalue<-c(rep(0,nrow(a))) 
log2_FC<-c(rep(0,nrow(a))) 
# 2~4���Ǵ�����1,5~7���Ǵ�����2��
#��ʹ��ѭ����ÿһ�н���t����
#���ĳһ������ı�׼�����0�����޷�����t���飬������Щ��ʹ��NA���
#ÿһ�м���õ�p value��log2FC��������ԭ�ļ��ĺ����У�
#����log2FCʱ��ÿ���ֵ��0.001����Ϊ�˷�ֹ��ĸΪ0����bug��
for(i in 1:nrow(a)){
  if(sd(a[i,1:9])==0&&sd(a[i,10:18])==0){
    Pvalue[i] <-"NA"
    log2_FC[i]<-"NA"
  }else{
    y=var.test(as.numeric(a[i,1:9]),as.numeric(a[i,10:18]))
    Pvalue[i]<-y$p.value
    log2_FC[i]<-log2((mean(as.numeric(a[i,1:9]))+0.00001)/(mean(as.numeric(a[i,10:18]))+0.00001)) 
  }
}

##############################################
############�ֲ�����##########################
##############################################
for(i in 1:nrow(a)){
  if(sd(a[i,1:9])==0&&sd(a[i,10:18])==0){
    Pvalue[i] <-"NA"
    log2_FC[i]<-"NA"
  }else{
    b=matrix(c(as.numeric(a[i,1:9]),as.numeric(a[i,10:18])),ncol=2)
    x=mvnorm.etest(b,R=1000)
    Pvalue[i]<-x$p.value
    log2_FC[i]<-log2((mean(as.numeric(a[i,1:9]))+0.00001)/(mean(as.numeric(a[i,10:18]))+0.00001)) 
  }
}

# ��p value����FDRУ��
fdr=p.adjust(Pvalue, "BH") 
# ��ԭ�ļ��������log2FC��p value��FDR,��3�У�
out<-cbind(a[,0],log2_FC,Pvalue,fdr) 
genesymbol<-rownames(out)
out<-cbind(genesymbol,out)
write.table(out,file="energy-test.xls",quote=FALSE,sep="\t",row.names=FALSE)


setwd('C:\\Users\\cloudhealth\\Desktop\\1122')
a=read.table("log_norm.txt",header=T,sep="\t",row.names=1) 

#�����ض�Ԫ�������,����ǰ����裬һ���Ƕ�Ԫ��̬�ԣ�һ���Ƿ��Э�������ͬ����
type<-factor(c(rep('c',6),rep('m',6),rep('n',6)))
#Ԥ����2�������������ļ�������ͬ��ȫΪ0�������������ڴ洢p value�Ͳ��챶����log2FC��
Pvalue<-c(rep(0,nrow(a))) 
log2_FC<-c(rep(0,nrow(a))) 
# 2~4���Ǵ�����1,5~7���Ǵ�����2��
#��ʹ��ѭ����ÿһ�н��з������
#�������������0�Ļ��򣬲����飻
#ÿһ�м���õ�p value��log2FC��������ԭ�ļ��ĺ����У�
#����log2FCʱ��ÿ���ֵ��0.001����Ϊ�˷�ֹ��ĸΪ0����bug��
for(i in 1:nrow(a)){
  if(sum(a[i,1:6])==0&&sum(a[i,7:12])==0&&sum(a[i,13:18])==0){
    Pvalue[i] <-"NA"
    log2_FC[i]<-"NA"
  }else{
    y=aov(as.numeric(a[i,1:18])~type)
    Pvalue[i]<-summary(y)[[1]][,5][1]
    log2_FC[i]<-log2((mean(as.numeric(a[i,1:9]))+0.00001)/(mean(as.numeric(a[i,10:18]))+0.00001)) 
  }
}
# ��p value����FDRУ��
fdr=p.adjust(Pvalue, "BH") 
# ��ԭ�ļ��������log2FC��p value��FDR,��3�У�
out<-cbind(a[,0],log2_FC,Pvalue,fdr) 
genesymbol<-rownames(out)
out<-cbind(genesymbol,out)
write.table(out,file="aov.xls",quote=FALSE,sep="\t",row.names=FALSE)
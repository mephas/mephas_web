#`记录运行样例过程中需生成的函数。
#修改中的源代码时




defGeneNameList <- function(){
  # 生成基因注释包字典.gene.id
  k.geneid.list <- c("mgu74a","mgu74b","mgu74c","hcg110","mu11ksuba","mu11ksubb","mu19ksuba",
                     "mu19ksubb","mu19ksubc","hu6800","mgu74av2","mgu74bv2","mgu74cv2","rgu34a",
                     "rgu34b","rgu34c","rnu34","rtu34","hgu95av2","hgu95b","hgu95c","hgu95d",
                     "hgu95e","hgu133a","hgu133b","hu35ksuba","hu35ksubb","hu35ksubc","hu35ksubd",
                     "hgfocus","moe430a","mouse4302","rae230a","rae230b","hgu133plus2","hgu133a2",
                     "hgug4111a","hgug4110b","mouse430a2","u133x3p","rat2302","hgug4112a","h20kcod",
                     "adme16cod","hthgu133a","h10kcod","hgug4100a","illuminaHumanv1","illuminaHumanv2",
                     "hugene10sttranscriptcluster","illuminaHumanv3","hgu95av2",
                     "IlluminaHumanMethylation27k","illuminaHumanv4","hugene11sttranscriptcluster",
                     "HsAgilentDesign026652","IlluminaHumanMethylation450k","hgu219",
                     "GGHumanMethCancerPanelv1","hthgu133b","hthgu133a")
  name.id <- c("GPL32","GPL33","GPL34","GPL74","GPL75","GPL76","GPL77","GPL78","GPL79","GPL80",
               "GPL81","GPL82","GPL83","GPL85","GPL86","GPL87","GPL88","GPL89","GPL91","GPL92",
               "GPL93","GPL94","GPL95","GPL96","GPL97","GPL98","GPL99","GPL100","GPL101","GPL201",
               "GPL339","GPL340","GPL341","GPL342","GPL570","GPL571","GPL886","GPL887","GPL1261",
               "GPL1352","GPL1355","GPL1708","GPL2891","GPL2898","GPL3921","GPL4191","GPL5689",
               "GPL6097","GPL6102","GPL6244","GPL6947","GPL8300","GPL8490","GPL10558","GPL11532",
               "GPL13497","GPL13534","GPL13667","GPL15380","GPL15396","GPL17897")
  names(k.geneid.list) <- name.id
  
  return(k.geneid.list)
}

findIdPack <- function(gpl,v){#, gpl.platform=NULL,handin=NULL){
  # 查找gpl对应的注释包，并在没有的时候提示用户手动选择 自动选择时基于SYMBOL, 可修改基于entrez ID
  # @array:gpl:平台名称文件 字符串
  # @arrey:gpl.platform:之前下载的GPL文件
  # @array:type:选择ID的依据{"SYMBOL", "ENTREZID"} #删除
  # @array:handin:手选的基因列 c() #删除
  
  #v$platformdb:用于之后的代码生成
  gpl<-toupper(gpl)

  
  if (gpl %in% names(defGeneNameList())){
    # 存在注释包时
    ##ls("package:illuminaHumanv2.db") 查看注释包行名
    platform <- defGeneNameList()[[gpl]]
    platform.DB <- paste(platform,".db", sep="")
    if (platform.DB  %in% rownames(installed.packages()) == F){
      BiocManager::install(platform.DB, update = F, ask = F)
    }
    library(platform.DB, character.only = T)
    geneid <- toTable(get(paste(platform, "SYMBOL", sep=""))) # 输出探针-基因 list
    # names(geneid)[[1]]<-c("id") # 想要同意元素名称。但是之后引用也不是用元素名的，所以不改应该也可。
    
    v$platformdb<-c(1,platform)#[1]为存不存在注释包 [2]为注释包名
    return(geneid)
    
  }else{
    #不存在注释包1时 选择注释包2
    library(idmap2)
    aa<-as.matrix(gpl_list[2])#下载公用数据包
    
    if(gpl %in% aa){
      geneid <- get_soft_IDs(gpl) 
      v$platformdb<-c(2,"idmap2")
    }else{
      # 不存在注释包时 希望让客户选择注释id
      #geneid <- Table(gpl.platform)[, c("ID",handin)]
      base::print("wrong in annotation") # 需要进行进一步调整
      geneid <- NULL
      v$platformdb<-NULL
    }
    

    return(geneid)
  }
}

changeToGeneid <- function(expr,ids){
  # 将原有行向量（探针id）转换成基因id，并依照在所有样本中的平均表达值最大的原则，删除过多的探针
  #@array:expr:原有的表达矩阵
  #@array ids:指针-基因对应列表
  #return:转换为基因id的表达矩阵
  
  #处理ids列表
  ids <- na.omit(ids) #删除无对应基因的探针行
  
  ids_h<-grep('///',ids[,2])#删除对应多个基因的探针行（如果有）
  if(!is_empty(ids_h)){
    ids <- ids[-ids_h,] 
  }
  
  # 表达矩阵和ids探针对应，删除没有对应基因的探针行
  expr <- expr[rownames(expr) %in% ids[[1]], ] 
  # 将探针-基因 list和表达矩阵行 进行比对排序（使探针顺序一样 并删去无用行）
  ids <- ids[match(rownames(expr),ids[[1]]),]
  
  # 同一个基因对应多个指针的情况
  # 多个指针按列取平均值
  #expr<-avereps(expr,ID=ids[[2]])
  #expr<-as.data.frame(expr)
  
  
  #把平均值改成最大值
  tmp = by(expr,
           ids[[2]],
           function(x) rownames(x)[which.max(rowMeans(x))])
  probes = as.character(tmp)
  expr = expr[rownames(expr) %in% probes,] # 过滤有多个探针的基因
  rownames(expr)=ids[match(rownames(expr),ids[[1]]),2]
  
  return(expr)
}

log2Transform <- function(expr,v){
  # 判断表达矩阵data.expr是否需要进行log2计算
  #`array:expr 表达矩阵 data.expr
  #return:log2计算过的表达矩阵或者原表达矩阵
  #在进行测试运算的时候不需要log2计算 所以如果有需要计算的时候还得验证一下语法对不对
  #之后可以把print信息去掉，直接return expr 即可
  
  qx <- as.numeric(quantile(expr, c(0., 0.25, 0.5, 0.75, 0.99, 1.0), na.rm=T))
  LogC <- (qx[5] > 100) || (qx[6]-qx[1] > 50 && qx[2] > 0) ||
    (qx[2] > 0 && qx[2] < 1 && qx[4] > 1 && qx[4] < 2)
  
  if (LogC) {
    expr[which(expr <= 0)] <- NaN
    expr <- log2(expr)
    v$log2<-TRUE
    base::print("log2 transform finished")
  }else{
    v$log2<-FALSE
    base::print("log2 transform not needed")
  }
  return(expr)
}


defENTREZIDList <- function(){
  # 生成通道信息时的基因注释包字典
  k.entrezid.list <- c("org.Hs.eg.db", "org.Mm.eg.db", "org.Mmu.eg.db", 
                       "org.Pf.plasmo.db", "org.Pt.eg.db", "org.Rn.eg.db", 
                       "org.Sc.sgd.db", "org.Ss.eg.db", "org.Xl.eg.db", 
                       "org.Gg.eg.db",  "org.EcK12.eg.db", 
                       "org.Dr.eg.db", "org.Dm.eg.db", "org.Cf.eg.db", 
                       "org.Ce.eg.db", "org.Bt.eg.db", "org.At.tair.db", 
                       "org.Ag.eg.db")
  name.entrezid <- c("Homo sapiens","Mus musculus","Macaca mulatta",
                     "Plasmodium falciparum","Pan troglodytes","Rattus norvegicus",
                     "Saccharomyces cerevisiae","Sus scrofa","Xenopus laevis",
                     "Gallus gallus","Escherichia coli",
                     "Danio rerio","Drosophila melanogaster","Canis lupus familiaris",
                     "Caenorhabditis elegans","Bos taurus","Arabidopsis thaliana",
                     "Anopheles gambiae")
  name.keeg <-  c("hsa","mmu","mcc",
                  "pfa","ptr","rno",
                  "sce","ssc","xla",
                  "gga","eco",
                  "dre","dme","cfa",
                  "cel","bta","ath",
                  "aga")
  name.entrezid<-toupper(gsub(" ", "", name.entrezid)) #为了后续方便 去除空格并改成大写
  names(k.entrezid.list) <- name.entrezid
  k.entrezid.list <- cbind(k.entrezid.list,name.keeg)
  colnames(k.entrezid.list)<-c("GONAME","KEGGNAME")
  k.entrezid.list<-as.data.frame(k.entrezid.list)
  return(k.entrezid.list)
}

findEntreIdPack <- function(organism){
  #通过物种信息找对应的包的函数
  #全部改为大写且无间隔为了好匹配
  if(!is.null(organism)){
    organism<-toupper(gsub(" ", "", organism))
    
    if (organism %in% rownames(defENTREZIDList())){
      Entre_id <- as.character(defENTREZIDList()[organism,1])
      KEGG_id<-as.character(defENTREZIDList()[organism,2])
      
      naresult<-c(Entre_id,KEGG_id)
    
    }else{
      return(NULL)
    }
    return(naresult)
    
  }else{
    return(NULL)
  }
  
}




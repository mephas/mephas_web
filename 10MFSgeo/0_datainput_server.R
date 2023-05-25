#GSE37455 双平台例子
#GSE32575 测试例子2

source("example_function_new.R")

options(DT.options = list(pageLength = 10))


#测试输入是否能正常返回
output$test = renderUI({
  if(!is.null(input$diffrandomA)){
    HTML(v$group.rand)
  }else if(!is.null(input$diffrandomB)){
    HTML(input$diffrandomB)
  }else{
    return(NULL)
  }
  
})

#刷新页面
observeEvent(input$NUM_clear,{session$reload()})

#选择最上方注释的开关


#######生成即时变量v#######
#生成样本信息框 
## 下载相关数据 eventReactive 对S4对象好像不好用
v <- reactiveValues(data = NULL,platformdb=NULL,geoid=NULL,log2=FALSE) #初始存放数据集的list 需要后续修改
#v$SysInfo <- "Initializing"
genecode <- reactiveValues(report = NULL) #存放生成的可运行代码
ctrlcode<-reactiveValues(gse.code1=FALSE,gpl.code2=FALSE,
                         B1.code3=FALSE,B2.code4=FALSE,GOKE.code5=FALSE) #判断要不要更新代码



#######实际用于计算的函数#######
#用来下载GEO
#使用输入的数据
#v$choiceGpl获取GPL信息 v$dataSerise GSE文件
data.geodownload <- reactive({
  if (is.null(input$gse.id)) {
    return(NULL)}
  
  geoID <- input$gse.id
  
  progress <- shiny::Progress$new() #过程监视弹窗
  on.exit(progress$close())
  progress$set(message = "Step 1: ", value = 0)
  progress$inc(0.70, detail = "Downloading GEO data")

  gse<-NULL
  if (is.null(geoID)){
    return(NULL)
  }else{
    #尝试100次下载
    for (i in 1:2) {
      results = tryCatch({
        gse <-- getGEO(geoID,destdir = "./tmp",getGPL = FALSE) #这里会不会出问题？因为geoid本身有设定值 可能一上来就下载文件
      },
      error = function(e) {
      },
      finally = {
      })
      if (!is.null(gse)) {
        break
      }
    }
    #如果没能成功下载文件 则出现下载错误信息 并返回NULL
    if(is.null(gse)){
      cat(file = stderr(),
          "GEO download failed")
      showModal(
        modalDialog(
          title = "GEO download failed",
          "Please ensure that your GSE accession number is correct and that it has a series matrix file which is downloadable on GEO. If so, refresh the page and try again in a few minutes. (The GEO server is likely down)"
        )
      )
      return(NULL)
    }
   

   
  }
  #从注释文件里获取平台信息并存入v中
  a<-sapply(gse, annotation)
  names(a) <- a
  v$choiceGpl<-a #获取平台信息
  v$dataSerise <- gse 
  v$geoid<- geoID
  
  v$platformdb<-NULL#用于代码生成时下载包
  
})

#用来下载GPL/表达矩阵
#v$organism v$dataIndex v$dataP v$dataPchr v$dataPInfo v$namechr v$dataExpr
data.gpldownload <- reactive({
  if(is.null(input$gpl_id_choose)){#若GplID没有输入
    return(NULL)
  }
  
  


  gse <-v$dataSerise
  ind <- match(input$gpl_id_choose, sapply(gse, annotation))#索引
  dataP<-pData(gse[[ind]]) #生成(准)分组矩阵 未经处理
  
  
  #此处应该有调整dataP列数的功能函数
  dataExpr <- exprs(gse[[ind]])
  
  common = intersect(colnames(dataExpr), rownames(dataP)) # 两个矩阵名称取交集（确定样本相同）
  m1 = match(common, colnames(dataExpr)) # 提取表达矩阵对应的列（样本）
  m2 = match(common, rownames(dataP)) # 提取分组矩阵对应的行（样本）
  dataExpr = dataExpr[,m1] # 生成处理后的表达矩阵
  dataP = dataP[m2,] # 生成处理后的分组矩阵
  

  
  #确定样本的属性
  org_idx <- grep('organism', colnames(dataP))[1]#查找pdata里的organism列 grep给定字符串向量中搜索字符串
  v$organism <- dataP[,org_idx][1] #确定样本的属性 是人类
  cat(rownames(dataP), nrow(dataP), "\n")#提取dataP（分组矩阵data.p）的样本名 和 样本数
  
  #如果样本数小于等于1 则返回no
  if (nrow(dataP) <= 1) {
    stop("Not enough samples in dataset", call. = FALSE)
  }
  fvarLabels(gse[[ind]]) <- make.names(fvarLabels(gse[[ind]])) #将特征data.series[[data.index]]全都变成可以用的名字
  
  
  #从这里开始处理输入表格(数据输入流程图) 目的：返回用于输入的空表
  #表格1：用来返回dataP中的特征和每个特征的分类数（特征说明表格）
  #     (?这里的表格可能不对，需要用的是make.names(fvarLabels(data.series[[1]])) ?)
  #表格2：筛选想要显示出来的特征：样本名，特征。并有可填入分组信息的部分。
  
  #首先初始化两个表格
  dataPInfo<-data.frame()#生成表格1 dataP各特征信息的说明表 每一行是特征名，和每个特征有多少种分组
  dataPchr <-as.data.frame(matrix(NA,nrow=nrow(dataP)))#生成表格2 dataP各组特征 用于插入新分组 每一行是样本 和特征
  rownames(dataPchr) <- rownames(dataP)
  name.all<-c()#用来记录全部列名（之后用于dataPchr的筛选）
  idata2<-1 #用来记录dataPchr的列向量编号
  
  
  #进入dataP列循环i
  
  for (i in 1:ncol(dataP)) {#分组矩阵1-n列循环
    
    name <- paste(colnames(dataP[i]))#把i列列名粘贴进name变量
    
    if (name == "source_name_ch1") {#修正name中的source
      #如果是sourcenamech1那一列 则将这列列名换成source（name也跟着换成source）
      colnames(dataP)[i] <- "source"
      name <- "source"
    }
    
    isch1 <- grep(":ch", name)#列名里是否有:ch1（一般来说会和之前重复）
    if(length(isch1) != 0 ){
      helpname<-strsplit(name, ":")
      name <- helpname[[1]][1]#分割出冒号前特征名 转入name变量
      colnames(dataP)[i]<-name
      
    }
    
    col <- dataP[i] #把列内容粘贴进col变量
    
    
    #处理特殊列名 characteristics
    ischar <- grep("characteristics", name) #在name变量中搜索“cha~ 特征”匹配时输出元素下标，其实就是有cha~就输出1吧。
    
    #  dataP <- as.data.frame(dataP)
    col<-sapply(col, as.character)
    helpcol<-as.data.frame(col)
    col <- helpcol[,1]#这里必须得转换再取出 得把col转化成字符串 否则后面进行不了。
    
    if(length(ischar) != 0){#如果匹配到了有冒号的特征列
      #把列名变成特征中的冒号前内容
      helpcol<-strsplit(paste(col), ": ")
      name <- helpcol[[1]][1]#分割出冒号前特征名 转入name变量
      #把列内容变成特征中冒号后内容
      for (k in 1:length(helpcol)) {
        col[k] <- helpcol[[k]][2]
      }
      #name<-make.names(name)
    }#一定要转换DF 否则会遇到奇怪的文件头和文件尾"c(\"
    
    #以上处理完name和col
    
    
    
    #两个待生成的矩阵和向量
    #表1共通部分
    numGroups <- length(table(col))#用来确定col这一列有多少个不同元素（确定能不能用来做分类）
    freq_table <- as.data.frame(table(col))#table确定每一列不同的元素分别有多少个（计数）,exclude = NULL
 #   freq_table <- freq_table[order(-freq_table$Freq), c(1, 2)]#按照频度由高到低重新排序
  #  colnames(freq_table) <- c(name, "Freq")#重命名频度表的列名为原来的列名
    ####这里有问题！！！！↑ 0131
    
    
    for (j in 1:20) {#用于生成表1的第二列内容
      if (j > numGroups) {#如果组数少于20时 超过组数则提前跳出
        break
      }
      g<-paste(freq_table[j, 1],freq_table[j, 2],sep =": ")#生成“组名：频数”文字
      
      if(j == 1){
        helpg<-g
      }else if(j > 1 && j < min(numGroups,20)){
        
        helpg<-paste(helpg,g,sep=", ")
      }else if(j== numGroups){
        helpg<-paste(helpg,g,sep=", ")
        helpg<-paste(helpg,".",sep="")
      }else{
        a<- numGroups-20
        helpg<-paste(helpg,", ",g," ...(else ",a," omitted)",sep="")
      }
    }
    row1<-t(c(name,helpg))#表1的行向量
    
    
    if (i == 1) {#第一列的情况 需要初始化一下第一个列表
      #表1
      dataPInfo <- as.data.frame(row1)#初始化表1的行向量
    }else {#不是第一列的情况
      dataPInfo<-rbind(dataPInfo,row1)
    }
    
    
    #表2共通部分
    #如果该列满足条件 则放入表2（cbind）
    if((numGroups < length(col) && numGroups > 1 && !(name %in% name.all)) || name == "title"){
      dataPchr <- cbind(dataPchr, col)#在生成的dataPchr后面加新列
      colnames(dataPchr)[idata2+1] <- name #用列名name定义dataPchr对应列的名字
      name.all<-c(name.all,name)#存储列名
      idata2= idata2+1 #列编号+1
    }
    
  }#列i循环完了
  
  
  Group_Entry <-#生成需要手写的部分Group_Entry
    as.data.frame(matrix(
      data = "edit here",
      nrow = nrow(dataPchr),
      ncol = 1
    ))
  
  colnames(Group_Entry) <- "Group"  #定制手写部分列名
  dataPchr <- cbind(dataPchr, Group_Entry)#加到dataPchr后面
  
  
  Pair_Entry <-#生成需要手写的部分Group_Entry
    as.data.frame(matrix(
      data = "edit here",
      nrow = nrow(dataPchr),
      ncol = 1
    ))
  
  colnames(Pair_Entry) <- "Block"  #定制手写部分列名
  dataPchr <- cbind(dataPchr, Pair_Entry)#加到dataPchr后面
  
  
  
  dataPchr = dataPchr[,-1]#去掉第一列NA
  dataPchr <- as.data.frame(dataPchr)#将pdata转换成dataframe
  #length(dataPchr) ==0 则说明没有可用的分组信息
  
  
  
  #输入到v中
#  v$dataPlatform<-gpl
  v$dataIndex <- ind
  v$dataP <- dataP
  v$dataPchr <- dataPchr 
  v$edit_dataPchr <- dataPchr#后续用于编辑 添加
  v$dataPInfo <- dataPInfo
  v$namechr <- name.all
  v$dataExpr<-dataExpr
  
})


#下载表达矩阵/正交化/log2转换/因子转换###0105需要修正

data.update<-reactive({
  if (is.null(v$dataP) || is.null(v$dataSerise) || is.null(v$dataExpr) || is.null(input$gpl_id_choose)) {#如果之前下载失败了则返回NULL
    return(NULL)
  }
  
  progress <- shiny::Progress$new() #过程监视弹窗
  on.exit(progress$close())
  progress$set(message = "Step2: Processing ", value = 0)
  progress$inc(0.20, detail = "Id transform")
 
 
  dataExpr <-v$dataExpr
  #做id转换
  idss <- findIdPack(input$gpl_id_choose,v)
  if(!is.null(idss)){
    dataExpr<-changeToGeneid(dataExpr,idss)
  }else{
    print("wrong in idss")
  }
  
  progress$inc(0.20, detail = "Log transform and normalization")
  #做log2变换
  
  dataExpr <- log2Transform(dataExpr,v) 
  dataExpr<-as.data.frame(dataExpr)
  
  v$dataExpr<-dataExpr
  #做正交变换 
  
  dataExpr <- normalizeBetweenArrays(dataExpr)  
  
  progress$inc(0.30, detail = "PCA data calculating")
  #pca 处理
  dataex.tr<-t(dataExpr)##转换数据至行为sample,列为gene
  dataex.tr<-as.data.frame(dataex.tr)##注意数据要转换为数据框
  dataex.tr <- dataex.tr[,apply(dataex.tr, 2, var) != 0]
  
  if(ncol(dataex.tr)>=2000){
    dataex.tr.pca = as.matrix(dataex.tr[,order(colMeans(dataex.tr), decreasing =
                                             TRUE)[1:2000]])
  }else{
    dataex.tr.pca = as.matrix(dataex.tr[,order(colMeans(dataex.tr), decreasing =
                                             TRUE)[1:ncol(dataex.tr)]])
    
  }
  

  
  dataPCA <- prcomp(dataex.tr.pca, scale = TRUE)
  
  
  #将变量导入v中
  v$dataextr<-dataex.tr.pca#0206
  v$dataExprN <- dataExpr
  v$dataPCA <- dataPCA
  v$rowOrder<-rownames(v$dataExprN)[order(rownames(v$dataExprN))]
  
  

  
})#用于STEP3

#用来分析保存Limma结果
##1220用于将Step2中的分组结果反应到v中 并在dataLimma里调用
##使用了input$diffchoice
##生成了v$design v$diffchoice v$group.list v$contrast v$Block v$Treatment v$designcolname
data.LimmaPrepare <- reactive({
  if(is.null(input$diffchoice)){
    return(NULL)
  }
  v$diffchoice <- input$diffchoice#输入数据到v
  
  
  #取返回的factor参数
  if(!is.null(input$hot)){
    #v$dt <-data.frame(hot_to_r(input$hot)[,"group"], row.names = rownames(hot_to_r(input$hot)))
    
    #v$grouplist<-factor(hot_to_r(input$hot)[, "group"])
    grouplist <- hot_to_r(input$hot)
    grouplist <- as.data.frame(sapply(grouplist,make.names))#确保所有内容都可以输出
    

  }else{
    return(NULL)#0128 这里还是不对的
  }
  
  
  if(input$diffchoice=="choiceA"){#makename
    
    if(is.null(input$diffA_tab1)){#判断是否选择了difftab1
      return(NULL)
    }else if(length(input$diffA_tab1) >= 1){#这里对吗? 参考了kmeans
      grouplistA<-as.data.frame(grouplist[,input$diffA_tab1])
      grouplistA<-as.data.frame(sapply(grouplistA,as.character))
      
      TS<- sapply(as.data.frame(t(grouplistA)), function(x) paste(x,collapse  = "."))
      TS<-factor(TS)
      TScom<-combn(levels(TS),2)
      TScompa<-paste(TScom[1,],TScom[2,],sep = "-")
      
      v$group.list <- factor(TS,levels=unique(TS))
      v$contrast <-TScompa
      
      #v$group.list <- as.character(factor(grouplist[,input$diffA_tab1])) #因子化之后都变成数字了
      
      
      group.a<- v$group.list#factor(v$group.list,levels=unique(v$group.list))
      
      
      design.a <- model.matrix(~0+group.a)
      colnames(design.a)=levels(group.a)
      rownames(design.a)=colnames(v$dataExprN)
      
      v$design<- design.a
	  
	   v$selectfeature<-input$diffA_tab1
    }else{
      return(NULL)
    }
    
    #随机效应
    if((input$diffrandomA=="noneinrandom") || is.null(input$diffrandomA)){
      v$group.rand<-NULL
    }else{
      grouprand<-as.data.frame(grouplist[,input$diffrandomA])
      grouprand<-as.data.frame(sapply(grouprand,as.character))
      v$group.rand <- factor(as.data.frame(t(grouprand)))
	  v$select_rand_name <- input$diffrandomA
	}
    
    
  }
  
  
  
  if(input$diffchoice=="choiceB"){
    if(!is.null(input$diffB_tab1) && !is.null(input$diffB_tab2)){
      grouplistB1<-as.data.frame(grouplist[,input$diffB_tab1])
      grouplistB1<-as.data.frame(sapply(grouplistB1,as.character))
      grouplistB2<-as.data.frame(grouplist[,input$diffB_tab2])
      grouplistB2<-as.data.frame(sapply(grouplistB2,as.character))
      grouplistB<- cbind(grouplistB1,grouplistB2)
      
      
      BlockB <- factor(as.data.frame(t(grouplistB1)))
      Treatment <- factor(as.data.frame(t(grouplistB2)))
      
      design.b <- model.matrix(~0+Treatment+BlockB)
      colnames(design.b)[1:length(levels(Treatment))] <- levels(Treatment)
      rownames(design.b)=colnames(v$dataExprN)
      
      
      TSB<-combn(levels(Treatment),2)
      TScompB<-paste(TSB[1,],TSB[2,],sep = "-")
      v$contrastB <-TScompB #生成后面cotrast的公式 用于step4选择
      
      v$group.list <- factor(Treatment,levels=unique(Treatment)) #后续用于箱线图的分类 即Treament
      v$pair.list <- factor(BlockB,levels=unique(BlockB)) 
   #   v$designcolname <- colnames(design.b)[-1]
      v$designB <- design.b
    #  v$designcolname <- c(levels(BlockB),levels(Treatment))#这里生成了一个c(“a”,“b”)很奇怪
      
	  v$selectfeature<-input$diffB_tab2
      v$select_batch_name<-input$diffB_tab1  
    }else{
      return(NULL)
    }
    
    
    #随机效应
    if((input$diffrandomB=="noneinrandom") || is.null(input$diffrandomB)){
      v$group.rand<-NULL
    }else{
      grouprand<-as.data.frame(grouplist[,input$diffrandomB])
      grouprand<-as.data.frame(sapply(grouprand,as.character))
      v$group.rand <- factor(as.data.frame(t(grouprand)))
	  v$select_rand_name <- input$diffrandomB
    }
  }

  #聚类用 因为需要grouplist所以不能放在update里
  if(!is.null(v$group.list)){
    #test
#    dataExprhc <- as.matrix(v$dataExprN)
#    colnames(dataExprhc) <- paste(colnames(dataExprhc),v$group.list,sep='-')
#    dataExprhc2 = dataExprhc[apply(dataExprhc, 1, function(x)
#      var(x) > 0.005),] + 1
#    dataExprhc = as.matrix(dataExprhc2[order(rowMeans(dataExprhc2), decreasing =
#                                    TRUE)[1:2000], ])
    
    
    dataExprhc<-v$dataextr
    rownames(dataExprhc) <- paste(rownames(dataExprhc),v$group.list,sep='-')
    
    
    
    #testover
    

    
#    dataExprhc<-v$dataExprN
#    colnames(dataExprhc) <- paste(colnames(dataExprhc),v$group.list,sep='-')
       #  dataExprhc<-data.frame(scale(t(dataExprhc)))
       #  datahc<- hclust(dist(dataExprhc))
    
    datahc <- hclust(dist(dataExprhc))
    
    v$hc <- datahc
  }

})

##1220 用于step4之后
##使用了v$diffchoice
##生成了v$diff_result diff_result_org
data.Limma<-reactive({
  if(is.null(v$diffchoice)){
    return(NULL)
  }
  progress <- shiny::Progress$new() #过程监视弹窗
  on.exit(progress$close())
  progress$set(message = "Step 4: DGEA", value = 0.1)
  
  
  #
  if(v$diffchoice == "choiceA" && !is.null(input$Selecontrast) ){

    design.a1<-v$design
    ## 比较矩阵
    contrast.matrix.a1<-makeContrasts(contrasts=input$Selecontrast,levels = design.a1)
    #contrast.matrix.a1 
    ## 线性拟合
    
    if(is.null(v$group.rand)){#无随机效应
      fit.a1 <- lmFit(v$dataExprN, design.a1)
      
    }else{#有随机效应
	  progress$inc(0.60, detail = "Dealing with random effect.") 
      corfit.a <- duplicateCorrelation(v$dataExprN,design.a1,block=v$group.rand)
     # corfit$consensus
      fit.a1 <- lmFit(v$dataExprN,design.a1,block=v$group.rand,correlation=corfit.a$consensus)##重点
    }
    
       
    fit.a2 <- contrasts.fit(fit.a1, contrast.matrix.a1) 
    ## 贝叶斯检验
    fit.a2 <- eBayes(fit.a2)
    ## 提取差异结果，注意这里的coef是1
    all.diff.a1 <- topTable(fit.a2,adjust='fdr',coef=1,sort.by = "p",number=Inf) 
    all.diff.a1 <- na.omit(all.diff.a1) 
    #write.csv(all.diff,"limma_notrend.results.csv",quote = F)
   # head(all.diff.a1)
    v$diff_result_org <- all.diff.a1
    v$work1 <- "workA"
	v$select_contrast_name<-input$Selecontrast
}
  
  
  if(v$diffchoice == "choiceB" && !is.null(input$SelecontrastB) ){
    
    design.b<-v$designB
    
    #比较矩阵
    contrast.matrix.b <- makeContrasts(contrasts=input$SelecontrastB, levels=design.b)
    
    #线性拟合 贝叶斯
    
    if(is.null(v$group.rand)){#无随机效应
      fit.b1 <- lmFit(v$dataExprN, design.b)
      
    }else{#有随机效应
      progress$inc(0.60, detail = "Dealing with random effect.")
      
      
      corfit.b <- duplicateCorrelation(v$dataExprN,design.b,block=v$group.rand)
      # corfit$consensus
      fit.b1 <- lmFit(v$dataExprN,design.b,block=v$group.rand,correlation=corfit.b$consensus)##重点
    }
    
    
    fitB <- contrasts.fit(fit.b1, contrast.matrix.b) 
    fitB <- eBayes(fitB)

    ##提取差异结果
    all.diff.B=topTable(fitB,adjust='fdr',coef=1,sort.by = "p",number=Inf) 
    all.diff.B <- na.omit(all.diff.B) 
    
    #head(all.diff.B)
    v$diff_result_org <- all.diff.B
    v$work1 <- "workB"
	v$select_contrast_name<-input$SelecontrastB
  }
  

  v$diff_result <- v$diff_result_org #应对反向对应
  if(input$updownreverse && !is.null(input$updownreverse)){
    v$diff_result$logFC <- -(v$diff_result$logFC)
    v$diff_result$t <- -(v$diff_result$t)
  }
  




  
})



##0126 用于生成了差异分析之后 通路分析数据
##使用了v$diff_result
##生成了v$pathENTREZID v$orgapack v$go v$kegg v$gotab v$keggtab
data.pathway<-reactive({
  if(is.null(v$diffSig) || is.null(v$organism)){
    return(NULL)
  }
  
  progress <- shiny::Progress$new() #过程监视弹窗
  on.exit(progress$close())
  progress$set(message = "Step 5: Enrichment analysis ", value = 0)
  progress$inc(0.10, detail = "getting gene ID.")  
  
  
  all.diff <- v$diffSig
  orga<-findEntreIdPack(v$organism)
  orga.go <- orga[1]
  orga.kegg <- orga[2]
  #获得基因列表
  #gene <- rownames(all.diff)
  geneup <- rownames(all.diff[grep("UP",all.diff$change),])
  genedown <- rownames(all.diff[grep("DOWN",all.diff$change),])
  
  
  #基因名称转换，返回的是数据框
  
  if(!is.null(orga)){
    geneup <- bitr(geneup, fromType="SYMBOL", toType="ENTREZID", OrgDb=orga.go)
    genedown <- bitr(genedown, fromType="SYMBOL", toType="ENTREZID", OrgDb=orga.go)
    
	progress$inc(0.20, detail = "doing GO analysis.(upregulation)")
    #GO
    go_up <- enrichGO(geneup$ENTREZID, OrgDb = orga.go, ont="all")
    
    progress$inc(0.20, detail = "doing GO analysis.(downregulation)")
	go_down <- enrichGO(genedown$ENTREZID, OrgDb = orga.go, ont="all")
    
    Gt_up<-as.data.frame(summary(go_up))#为了生成table 
    colnames(Gt_up)<-gsub(" ", "", colnames(Gt_up))
    Gt_up <- Gt_up[,!colnames(Gt_up) %in% c("geneID")]

    ordgo <- order(Gt_up["pvalue"])
    Gt_up<-Gt_up[ordgo,]
	
    Gt_down<-as.data.frame(summary(go_down))#为了生成table 
    colnames(Gt_down)<-gsub(" ", "", colnames(Gt_down))
    Gt_down <- Gt_down[,!colnames(Gt_down) %in% c("geneID")]
    
    ordgo <- order(Gt_down["pvalue"])
    Gt_down<-Gt_down[ordgo,]
	
    #KEGG 
	progress$inc(0.20, detail = "doing KEGG analysis.(upregulation)")
    KEGG_up <- enrichKEGG(geneup$ENTREZID,
                         organism     = orga.kegg,
                         pvalueCutoff = 0.05)
	progress$inc(0.20, detail = "doing KEGG analysis.(downregulation)")
    KEGG_down <- enrichKEGG(genedown$ENTREZID,
                          organism     = orga.kegg,
                          pvalueCutoff = 0.05)
 

    
    Et_up<-as.data.frame(summary(KEGG_up)) #为了生成table 
    colnames(Et_up)<-gsub(" ", "", colnames(Et_up))
    Et_up <- Et_up[,!colnames(Et_up) %in% c("geneID")]
#    Et <- as.data.frame(Et)
    Et_down<-as.data.frame(summary(KEGG_down)) #为了生成table 
    colnames(Et_down)<-gsub(" ", "", colnames(Et_down))
    Et_down <- Et_down[,!colnames(Et_down) %in% c("geneID")]
    
	ordgo <- order(Et_up["pvalue"])
    Et_up<-Et_up[ordgo,]

    ordgo <- order(Et_down["pvalue"])
    Et_down<-Et_down[ordgo,]
    
    v$pathENTREZID_up <- geneup$ENTREZID
    v$pathENTREZID_down <- genedown$ENTREZID
    v$orgapack<- orga.go
    v$keggpack<-orga.kegg
    
    v$go_up<-go_up#上调基因go
    v$gotab_up<-Gt_up
    
    v$go_down<-go_down#下调基因go
    v$gotab_down<-Gt_down
    
    
    v$kegg_up<-KEGG_up
    v$keggtab_up<-Et_up
    
    v$kegg_down<-KEGG_down
    v$keggtab_down<-Et_down
    
  }else{
    v$orgapack<- NULL
    v$keggpack<-NULL
    return(NULL)
  }
  
  
})

#之后如果有需要可以把他们合到一起（但感觉没什么必要）


#######流程控制部分#######
#按下GSE按钮之后会发生的事情:GPL面板出现/选择gpl后后续STEP2面板出现
#GSE按钮在ui中
observeEvent(input$gsegoButton,{
  #1、下载geo数据
  data.geodownload()
  
  
  #2、生成输入侧UI（GPL Step2）
  ##生成GPL列表
  output$gpl.id <- renderUI({
      selectInput( ##type(list) length
        'gpl_id_choose',
        h5('选择平台信息（GPL）'),
        selected = v$choiceGpl[1],
        choices = c(v$choiceGpl),
        multiple = FALSE,
        selectize = FALSE
      )
   
  })
  ctrlcode$gse.code1 <- TRUE
  genecode$report<- NULL
  
})


#选择了GPL之后会发生的事情：生成Page1和P2  
observeEvent(input$gpl_id_choose,{
  if(nchar(input$gpl_id_choose) <= 1){
    return(NULL)
  }
  data.gpldownload()#1 下载gpl
  data.update()#Step2 预处理
  
  output$dataPInfo<- DT::renderDataTable(v$dataPInfo)#2 生成data描述
  
  #用于在输入数据之后update数据并将第二页箱线图加载出来 怎么跳转
#  output$update.button.p1<-renderUI({ 
#    if( (!is.null(input$gplgoButton)) && (input$gplgoButton != 0) ){
#      actionButton("updataButton","Update data")
#    }
#  })
  
  #3 生成可填写表格
  output$hot <- renderRHandsontable({
    show(v$edit_dataPchr)
    cat("HERE")
    rhandsontable(
      v$edit_dataPchr,
      rowHeaders=rownames(v$edit_dataPchr),
      useTypes = F,
      readOnly = TRUE,
      columnSorting = TRUE,
      rowHeaderWidth = 100
    ) %>%
      hot_col(col = c("Group"), readOnly = FALSE) %>%
      hot_col(col = c("Block"), readOnly = FALSE) %>%
      hot_context_menu(allowRowEdit = FALSE, allowColEdit = FALSE)
    
  })
  
  
  ##4：生成Step2、3的UI
  output$text_step2 <- renderUI({
    HTML("
 <h4><b>Step2. Pre-Process Data</b></h4>
 <p><b>The data has been pre-processed automatically:</b></p>
<ul> 
<li>log2-transformation
<li>Normalization
<li>Transpose between Prob ID and Gene SYMBOL
</ul>
<p><b>Results：</b> See Output 1（Data Descriptives）</p>
")
    })


  
  
  #Step3分组信息
  output$text_step3 <- renderUI({
    HTML("
 <h4><b>Step3. Group</b></h4>
 <h>Please choose methods，and define the groups。MephasGEO will check the quality of data and reasonability of group</h>
 <h><b>Results：</b>See Output 3（Check Data）</h>
")

  })
  
  #可隐藏部分的勾选框
  output$text_step3_control<-renderUI({
    checkboxInput("text_step3_control", "Click to see details",
                  value=FALSE)
  })
  #可隐藏部分的文字
  output$text_step3_choosetext <- renderUI({
    box(id = "step3text", width = '800px',#title = "Tree Output", 
        HTML("<h5><b>1. How to choose methods</b></h5>
<ul> 
<li><b>Between-group comparison：Compare 2 groups or pairs. </b>E.g.,：The purpose of GSE16020 analysis is to compare the difference in gene expression between the control group and the experimental group (autosomal dominant monocytopenia group). We can select the comparison between groups in the following difference comparison methods, and select disease state in the comparison basis, and select none in the random effect.
<li><b>Within-group comparison：Remove batch effect by paring samples. </b>On the basis of the comparison between the control group and the experimental group, other batch factors affect the experimental results, such as the differences between subjects. The batch element in GSE16020 is the rna isolation method. We can fill in the batch elements in the grouping basis for comparison within the group. And fill in the original disease state of the sample column to be compared in the comparison basis, and select none in the random effect.
<li><b>Random-effect：Deal with the variablity in repeat measures. </b>When it is necessary to compare the differences within and between the experimental subjects, we can regard the experimental subjects as random effects.
</ul> 
<h5><b>2. How to choose group feature</b></h5>
<b>According to the objective of analysis</b>
<ul>
<li>Refer to the grouping descriptive in Output 2-a. This  gives the statistical information of the original grouping characteristics of the chip.
<li>Check the output of Table 2-b，The table shows the features that can be selected. Please select the grouping feature that best meets the purpose according to the purpose of analysis（group list）
<li>If the existing grouping information cannot meet your needs, you can fill in the information in the Group and Block of Table 2-b, and select them in the subsequent operations.
</ul> ")#要隐藏的内容
    )
  })
  
  observeEvent(input$text_step3_control, {
    if(input$text_step3_control){
      shinyjs::show(id = "step3text")
    }else{
      shinyjs::hide(id = "step3text")
    }
  })

  
  output$diffchoice<- renderUI({
    selectInput("diffchoice", "Differential Analysis Methods", 
                choices=c("Between-group"="choiceA","Within-group"="choiceB"),
                selected=c("choiceA"), multiple=FALSE)
  })
  
  
#  output$page2example <- renderUI({#三种差异比较的说明文字
#    h5(tags$b("此处应该是说明文字")) 
#    
#  })
  
  
  #选择了差异比较方式之后的事情：怎样出现面板
  observeEvent(input$diffchoice,{
    #为了避免面板互相打架 所以先清除面板
   # v$delatechoice<-c()
    
    if(input$diffchoice!="choiceA"){
      output$diffA_tab1 <- renderUI({})
      output$diffrandomA<- renderUI({})
    }
    
    if(input$diffchoice!="choiceB"){
      output$diffB_tab1 <- renderUI({})
      output$diffB_tab2 <- renderUI({})
      output$diffrandomB<- renderUI({})
    }
    
    
    
    
    if(input$diffchoice=="choiceA"){
      output$diffA_tab1 <- renderUI({
        selectInput("diffA_tab1","Comparison Evidence",choices = colnames(v$dataPchr)[-1],
                    selected = NULL, multiple = TRUE)
      })
      
      
      #随机效应面板A
      output$diffrandomA<- renderUI({
        selectInput("diffrandomA", "Random-effects", choices = c("No"="noneinrandom",colnames(v$dataPchr)[- c(1,which(colnames(v$dataPchr) %in% input$diffA_tab1))]),
                    multiple=FALSE)#selected=list("No"), 
      })
      
    }else if(input$diffchoice=="choiceB"){
      output$diffB_tab1 <- renderUI({
        selectInput("diffB_tab1","Group (block)",choices = colnames(v$dataPchr)[-1],
                    selected = NULL, multiple = FALSE)
      })
      
      output$diffB_tab2 <- renderUI({
        selectInput("diffB_tab2","Comparison (Treatment)",choices = colnames(v$dataPchr)[- c(1,which(colnames(v$dataPchr) %in% input$diffB_tab1))],#这里还需要去掉1
                    selected = NULL, multiple = FALSE)
      })
     # v$delatechoice<-c(input$diffB_tab1,input$diffB_tab2)
      
      #随机效应面板B
      output$diffrandomB<- renderUI({
        selectInput("diffrandomB", "Random-effects", choices = c("No"="noneinrandom",
                    colnames(v$dataPchr)[- c(1,which(colnames(v$dataPchr) %in% input$diffB_tab1),which(colnames(v$dataPchr) %in% input$diffB_tab2))]),
                    multiple=FALSE)#selected=list("无"), 
      })
      
      
    }else{
      return(NULL)
    }
    

  })#三种方法比较结束
  
  #5 生成分析按钮
  output$uploadB1 <- renderUI({
    actionButton("uploadB1","Data Analysis")
  })
  
  
  #2、主要部分 数据描述
  
  output$text_Output1a <- renderUI({
    HTML("
 <h4><b>Output 1-a Expression matrix after data processing</b></h4>
")
  })
  
  output$showexpr <- DT::renderDataTable(
    v$dataExprN
  )
  output$downloadExpr <- downloadHandler(
    filename = function() {
      paste(v$geoid,"_Exprgene.txt", sep="")
    },
    content = function(file) {
      write.table(v$dataExprN, file,quote=FALSE,sep='\t')
    }
  )
  output$text_Output1b <- renderUI({
    HTML("
 <h4><b>Output 1-b Statistical graph of expression values of all samples</b></h4>
 <h5>before normalization</h5>
")
  })


  output$dataBoxBefore <- renderPlot({# 用来生成未正则化Boxplot
    par()
    boxplot(v$dataExpr,outline=FALSE, notch=T, las=2)
  })

  output$text_Output1b_2 <- renderUI({
    HTML("
 <h5>After normalization</h5>
 ")
  })
  
  output$dataBox <- renderPlot({# 用来生成Boxplot
    cat("")
	par()
    boxplot(v$dataExprN,outline=FALSE, notch=T, las=2)
  })
  

  if(v$log2){
    output$text_Output1all <- renderUI({
      HTML(
        "
 <h5><b>Explanation</b></h5>
 <ul>
 <li>Data is log2 transformed
 <li>Data is normalizaed 
 <li>The pointer of the chip has been converted to the corresponding gene name. (The blank pointer has been deleted, and the expression level of the same gene has been merged)
 <li>Notice: When the data center line of each sample cannot be approximated on a straight line, the results of the difference analysis may have large errors.
 </ul>

")
    })
  }else{
    output$text_Output1all <- renderUI({
      HTML(
        "
 <h5><b>Explantion</b></h5>
 <ul>
 <li>No need to do log2-transformation
 <li>Data is normalizaed 
 <li>The pointer of the chip has been converted to the corresponding gene name. (The blank pointer has been deleted, and the expression level of the same gene has been merged)
 <li>Notice: When the data center line of each sample cannot be approximated on a straight line, the results of the difference analysis may have large errors.
 </ul>

")
    })
  }
  
  output$text_Output2a <- renderUI({
    HTML("
 <h4><b>Output2-a Feature Descriptive Table</b></h4>
")
  })
  output$text_Output2aall <- renderUI({
    HTML("
 <h5><b>说明</b></h5>
 <p>This table counts the sample feature information that comes with the chip, and gives the number of samples in each feature that fall into the corresponding group.</p>
")
  })

  output$text_Output2b <- renderUI({
    HTML("
 <h4><b>Output2-b Feature Input Table</b></h4>
")
  })
  output$text_Output2ball <- renderUI({
    HTML("
 <h5><b>Explantion</b></h5>
 <p>This table gives the characteristics of classification significance.</p>
 <ul>
 <li>You can select existing features, or fill in the grouping method you want in the last two columns of the table.
 <li>To facilitate your management of custom features, we recommended to fill in the features used for grouping in the Group column and fill in the features used for pairing or batch identification in the Block column.
 </ul>
         ")
  })
  
  genecode$report<- NULL
  if(!is.null(input$gse.id)&&!is.null(input$gpl_id_choose)&&!is.null(v$organism)){
    ctrlcode$gse.code1 <- TRUE
    ctrlcode$gpl.code2<-TRUE
  }else{
    add.code(paste0("wrong in Gpl"))
  }
  
  v$havePart1 <- TRUE
  
})#GPL/Step2的信息输入结束（还没有处理）


#按下UP1按钮之后会发生的事情:STEP4面板出现
#也就是上传分组信息后 expr数据预处理过程
observeEvent(input$uploadB1,{
  #data处理
  
  data.LimmaPrepare()#对应step3差异比较
  
  #1、UI部分（左侧）
#  output$page3word <- renderUI({
#    h4(tags$b("Step 3. 预处理")) 
#  })
  

  
  ##出现step4面板
  output$text_step4 <- renderUI({#s4说明文字
    HTML("
 <h4><b>Step 4. Differential Analysis</b></h4>
 <p><b>After confirming that the data and grouping are correct, please select the two groups you want to compare. </b></p>
<ul> 
<li>Only when the format is the control group-the experimental group, the correct up- and down-regulated genes can be obtained.
<li>If the automatically generated two sets of comparisons are inconsistent with the order you expect, please check the factor conversion box, which will reverse the comparison order.
</ul>
<p><b>Results </b>See Ouptut 4 Diffetential Analysis</p>
")
  })
  
  
  ###
  #此处应该有一个选择框 用来选谁和谁比较
  if(v$diffchoice == "choiceA"){
    output$SelecontrastB <- renderUI({})
    
    output$Selecontrast <- renderUI({
      selectInput("Selecontrast","Choose Comparisons",
                  choices = v$contrast,
                  multiple = FALSE,
                  selectize = FALSE)
    })
  }
  if(v$diffchoice == "choiceB"){
    output$Selecontrast <- renderUI({})
    
    output$SelecontrastB <- renderUI({
      selectInput("SelecontrastB","Choose Comparisons",
                  choices = v$contrastB,
                  multiple = FALSE,
                  selectize = FALSE)
    })
    
  }
  output$updownreverse <- renderUI({
    checkboxInput("updownreverse","Factor Transformation",value=FALSE)#如果有挑上的话代表对照非对照反了 logFC和t取负
  })
  
  
  output$uploadB2 <- renderUI({
    actionButton("uploadB2","Start Differential Analysis")
  })
  
    ##part4ui结束

  
  
  
  #part4
  output$HC_cluster <- renderPlot({# 用来生成聚类
    if(!is.null(v$hc)){
	 par(mar=c(5,5,5,50))
     fviz_dend(v$hc,k =length(levels(v$group.list)),
                #cex = 0.5, 
                #          k_colors = c("#E41A1C", "#377EB8", "#4DAF4A", "#984EA3",
                #            "#FF7F00", "#FFFF33", "#A65628", "#F781BF", "#999999"),
                color_labels_by_k = TRUE, 
                repel = TRUE,
                horiz = TRUE,
                rect = TRUE,
				cex=0.5)
    }
  })
  
  output$dataPCA2 <- renderPlot({# 用来生成PCA2
    par()
    fviz_pca_ind(v$dataPCA,
                 col.ind = v$group.list, # 颜色对应group信息（这里不对。应该调整顺序
                 #palette = c("#00AFBB",  "#FC4E07"),
                 addEllipses = TRUE, # Concentration ellipses
                 ellipse.type = "confidence",
                 legend.title = "Group",## Legend名称
                 repel = TRUE
    )
  })
  
  output$text_Output3a <- renderUI({
    HTML("
 <h4><b>Output3-a Cluster Analysis</b></h4>
 
")
  })
  output$text_Output3aall <- renderUI({
    HTML("
 <h5><b>Explanation</b></h5>
<ul>
 <li>The graph is a hierarchical clustering graph generated by selecting the 2000 genes with the largest average expression in the expression file (if less than 2000 genes are used, all genes are used).
<li>If the samples are not separated according to your groupings in the cluster diagram, it means that the data may be affected by other factors (batch effects, etc.), and the accuracy of subsequent analysis may be reduced.
</ul>
         ")
  })
  
  output$text_Output3b <- renderUI({
    HTML("
 <h4><b>Output3-b PCA</b></h4>
")
  })
  output$text_Output3ball <- renderUI({
    HTML("
 <h5><b>Explanation</b></h5>
<ul>
 <li>This figure selects the 2000 genes with the largest average expression in the expression file (when less than 2000 genes are used, all genes are used), the principal component analysis is performed, and the previous two independent descriptive variables are used to visualize the sample.
<li>If the scatter plot generated in this step is not well separated by grouping, it means that the data may be affected by other factors (batch effect, etc.), and the accuracy of subsequent analysis may be reduced.
</ul>
         ")
  })
  
  
  
  
  
  genecode$report<- NULL
  ctrlcode$gse.code1 <- TRUE
  ctrlcode$gpl.code2<-TRUE
  ctrlcode$B1.code3<-TRUE
  
  v$havePart2 <- TRUE
  
})


#按下数据上传按钮2之后会发生的事情:差异分析
#数据上传按钮生成于按钮1事件
#也就是事实上的数据分析过程:差异分析、图表生成etc
observeEvent(input$uploadB2,{
  data.Limma()
  
  observeEvent(input$pvalue,{
    ##出现step5面板
    output$text_step5 <- renderUI({#s5说明文字
      HTML("
 <h4><b>Step5. Pathway Analysis</b></h4>
 <p><b>After the Differential Analysis is completed, you can perform GO analysis and KEGG analysis on the channel analysis page.</b></p>
<p><b>Results：</b>See Output 5 Differential Analysis</p>
")
    })
    
    output$text_Output4a <- renderUI({
      HTML("
 <h4><b>Output4-a Limma Analysis</b></h4>
")
    })
    
    output$text_Output4aall <- renderUI({
      HTML("
 <h5><b>Explanation</b></h5>
 <p>The table gives a list of differentially expressed genes analyzed by LIMMA software.</p>
  <p> </p>
<ul>
 <li>logFC: Shows the size of gene difference, the greater the absolute value, the greater the gene difference, the threshold default is 1.
<li>adj.P.Value：Shows the significance of the difference of the selected gene, the default is 0.05. You can customize the P value to change the confidence interval for screening differential genes. When you do not enter a p-value or enter a non-numeric p-value, the table will return the results of the difference analysis of all genes generated by LIMMA.
</ul>
         ")
    })
    
    output$text_Output4b <- renderUI({
      HTML("
 <h4><b>Output4-b Scatter Plot and Boxplot</b></h4>
")
    })
    
    output$text_Output4ball <- renderUI({
      HTML("
 <h5><b>Explantion</b></h5>
 <p>You can view the expression of the gene in different groups of samples by selecting the gene name.</p>

                   ")
    })
    
    output$text_Output4c <- renderUI({
      HTML("
 <h4><b>Output4-c Volcano plot</b></h4>
")
    })
    output$text_Output4call <- renderUI({
      HTML("
 <h5><b>Explanation</b></h5>
 <p>The volcano map is used to test whether the differential gene expression obtained is significantly different.</p>
 <p> </p>
  <ul>
 <li>Each point in the figure represents a gene.
<li>Red dots are genes that are significantly up-regulated. The green dots are genes whose expression is significantly down-regulated. Black dots are genes with no significant differences.
<li>It can be considered that the absolute value of logFC value is less than 1, adj.P.Value is less than the adj.P.Value selected by the user, there is no significant difference in gene points.
 </ul>
         ")
    })
    
    output$text_Output4d <- renderUI({
      HTML("
 <h4><b>Output4-d Heatmap</b></h4>
")
    })
    
    output$text_Output4dall <- renderUI({
      HTML("
 <h5><b>Expanation</b></h5>
<p>The heat map is used to show the expression levels of the top 50 differentially expressed genes in different samples. </p>
  <p> </p>
   <ul>
  <li>The abscissa is the sample name, and the ordinate is the selected differential gene.
<li>Red dots are genes that are significantly up-regulated. The green dots are genes whose expression is significantly down-regulated. Black dots are genes with no significant differences.
<li>Red represents the high expression value of the differential gene in the grouped samples, and blue represents the low expression value of the differential gene in the grouped samples.
  </ul>
         ")
    })
    
    
    
    if (is.null(input$pvalue)) {#可变p值 NA为输入了文字或为空值
      v$pvalue <- 0
    }else{
      if(is.na(as.numeric(input$pvalue))){
        v$pvalue <- 0
      }else{
        v$pvalue<-as.numeric(input$pvalue)
      }
    }
    

    
    if(v$pvalue==0){
     # v$diff_result$change <- ifelse(v$diff_result$adj.P.Val < 0.05 & abs(v$diff_result$logFC) > 1,
    #                                 ifelse(v$diff_result$logFC > 1,'UP','DOWN'),
    #                                 'NOT')
    #这里是之前留下来的diffsig
      v$diffSig <- v$diff_result[-grep("NOT",v$diff_result$change),]
      v$diffUp <- v$diff_result[grep("UP",v$diff_result$change),]
      v$diffDown <- v$diff_result[grep("DOWN",v$diff_result$change),]
      
      v$diffshow<-v$diff_result

    }else{
      v$diff_result$change <- ifelse(v$diff_result$adj.P.Val < v$pvalue & abs(v$diff_result$logFC) > 1,
                                     ifelse(v$diff_result$logFC > 1,'UP','DOWN'),
                                     'NOT')
      
      
      v$diffSig <- v$diff_result[-grep("NOT",v$diff_result$change),]
      v$diffUp <- v$diff_result[grep("UP",v$diff_result$change),]
      v$diffDown <- v$diff_result[grep("DOWN",v$diff_result$change),]
      
      v$diffshow<-v$diffSig 

      v$pvalueold <- v$pvalue #把之前的pvalue存了下来 当p=0的时候可以用      
    }

  
    
  })
  
  observeEvent(v$diffSig,{
    
    output$downloadData <- downloadHandler(
      filename = function() {
        paste(v$geoid,"_Diffgene.txt", sep="")
      },
      content = function(file) {
        write.table(v$diffshow, file,quote=FALSE,sep='\t')
      }
    )
  })

  
  output$testLimma <- DT::renderDataTable({#用来测试LimmaPrepare的返回值
    #HTML(v$group.list)
    v$diffshow
    #v$diff_result
    #head(v$diffSig)
  })
  
  output$Limmaresulttext<- renderUI({
    if(!is.null(v$diffSig) && v$pvalue!=0){
      p(paste0("P value",v$pvalue,"，Include Differential Genes",nrow(v$diffSig),
                  "The number of Up-regulated genes",nrow(v$diffUp),"The number of Down-regulate genes",nrow(v$diffDown),"."))
#      HTML(paste0("您选择的P值为",v$pvalue,"，包含差异基因",nrow(v$diffSig),
#                  "个。"))
    }else{
      p(paste0("You select all data. p is",v$pvalueold),"。")
    }

    
  })
  
  
  
  #绘制基因配对点图   
  output$geneselect <- renderUI({
    if(!is.null(v$dataExprN)){
      #从基因列表中选择基因 
      selectInput( ##type(list) length
        'geneselect',
        h5('Scatter plot gene selection'),
        selected = v$rowOrder[1],
        choices = v$rowOrder,
        multiple = FALSE,
        selectize = FALSE
      )
    }
  })
  observeEvent(input$geneselect,{
    output$genebotPlot <- renderPlot({
	  progress <- shiny::Progress$new() #过程监视弹窗
      on.exit(progress$close())
      progress$set(message = "STEP4: ", value = 0)
      progress$inc(0.50, detail = "Dot plot of genes")


      if(!is.null(v$pair.list) && v$diffchoice == "choiceB"){
        
        data_plot <- as.data.frame(t(v$dataExprN))
        data_plot <- data.frame(pairinfo=v$pair.list,
                                group=v$group.list,
                                data_plot,stringsAsFactors = F)
        library(ggplot2)
        ggplot(data_plot, aes(group,data_plot[,input$geneselect],fill=group)) +
          geom_boxplot(alpha = 0.5) +
          geom_point(size=2, alpha=0.5) +
          geom_line(aes(group=pairinfo), colour="black", linetype="11") +
          xlab("") +
          ylab(paste("Expression of ",input$geneselect))+
          theme_classic()+
          theme(legend.position = "none")
        
        
        
        
      }else{
        data_plot <- as.data.frame(t(v$dataExprN))
        data_plot <- data.frame(group=v$group.list,
                                data_plot,stringsAsFactors = F)
        
        library(ggplot2)
        ggplot(data_plot, aes(group,data_plot[,input$geneselect] ,fill=group)) +
          geom_boxplot(alpha = 0.5) +
          geom_jitter(aes(colour=group), size=2, alpha=0.7)+
          xlab("") +
          ylab(paste("Expression of ",input$geneselect))+
          theme_classic()+
          theme(legend.position = "none")
        
        
      }
    


    })
    genecode$report<- NULL
    ctrlcode$gse.code1 <- TRUE
    ctrlcode$gpl.code2<-TRUE
    ctrlcode$B1.code3<-TRUE
    ctrlcode$B2.code4<-TRUE
  })

  #开始绘图
  observeEvent(v$diffSig,{
    #火山图
    output$volPlot <- renderPlot({
      progress <- shiny::Progress$new() #过程监视弹窗
      on.exit(progress$close())
      progress$set(message = "STEP4: ", value = 0)
      progress$inc(0.50, detail = "volcano plot")
     
	  xMax=max(-log10(v$diff_result$adj.P.Val)) 
	  v$xMax<-xMax
      yMax=max(abs(v$diff_result$logFC))
	  v$yMax<-yMax
      par()
      ggplot(data= v$diff_result, aes(x = -log10(adj.P.Val), y = logFC, color = change)) +
        geom_point(alpha=0.8, size = 1) +
        theme_bw(base_size = 15) +
        theme(plot.title=element_text(hjust=0.5),   #  标题居中
              panel.grid.minor = element_blank(),
              panel.grid.major = element_blank()) + # 网格线设置为空白
        geom_hline(yintercept= 0 ,linetype= 2 ) +
        scale_color_manual(name = "", 
                           values = c("red", "green", "black"),
                           limits = c("UP", "DOWN", "NOT")) +
        xlim(0,xMax) + 
        ylim(-yMax,yMax) +
        labs(title = 'Volcano', x = '-Log10(adj.P.Val)', y = 'LogFC')
    })
    
    
    interactiveHeatmap <- reactive({
      {
        up_25<-v$diff_result %>% as_tibble() %>% 
          mutate(genename=rownames(v$diff_result)) %>% 
          dplyr::arrange(desc(logFC)) %>% 
          .$genename %>% .[1:25] ## 管道符中的提取
        
        down_25<-v$diff_result %>% as_tibble() %>% 
          mutate(genename=rownames(v$diff_result)) %>% 
          dplyr::arrange(logFC) %>% 
          .$genename %>% .[1:25] ## 管道符中的提取
        index<-c(up_25,down_25)
        index_matrix<-t(scale(t(v$dataExprN[index,])))##归一化
        index_matrix[index_matrix>1]=1
        index_matrix[index_matrix<-1]=-1
        anno=data.frame(group=v$group.list)
        rownames(anno)=colnames(index_matrix)
        
        v$index_matrix<-index_matrix
        v$anno<-anno
      }
      

      
      
      
#      p <- heatmaply(v$index_matrix) #%>% ##这里有问题：anno没有显示
      #plotly::layout(margin = list(l = 130, b = 40))


      #    pheatmap(
      #             show_colnames =F,
      #             show_rownames = F,
      #             cluster_cols = T, 
      #             annotation_col=v$anno)
       })
      
      #函数外的热图代码
      
      interactiveHeatmap()
	  
	  output$heatout <- renderPlot({#plotly::renderPlotly({
        #dev.off()
        progress <- shiny::Progress$new() #过程监视弹窗
        on.exit(progress$close())
        progress$set(message = "STEP4: ", value = 0)
        progress$inc(0.50, detail = "Heat map")

		par()
        pheatmap(v$index_matrix,
                 show_colnames =F,
                 show_rownames = F,
                 cluster_cols = T, 
                 annotation_col=v$anno)
      })
   
    
      v$havePart3 <- TRUE
    



    

    
    #通路分析隔离区
    observeEvent(input$GopathButton,{
      #通路分析
      data.pathway()
      output$text_Output5a <- renderUI({
        HTML("
 <h4><b>Output5-a GO Analysis</b></h4>
")
      })
      
      output$text_Output5b <- renderUI({
        HTML("
 <h4><b>Output5-b KEGG Analysis</b></h4>
")
      })
      
      
      output$text_GOup <- renderUI({
        HTML("
 <h5><b>Up-regulated genes: </b></h5>
")
      })
      
      
      output$text_GOdown <- renderUI({
        HTML("
 <h5><b>Down-regulated genes:</b></h5>
")
      })
      output$text_KEGGup <- renderUI({
        HTML("
 <h5><b>Up-regulated genes:</b></h5>
")
      })
      output$text_KEGGdown <- renderUI({
        HTML("
 <h5><b>Down-regulated genes:</b></h5>
")
      })
      
      
      if(!is.null(data.pathway())){
        #GO
        
        output$GoTable_up <-DT::renderDataTable({
          v$gotab_up
        })
        
        output$GoTable_down <-DT::renderDataTable({
          v$gotab_down
        })
        output$GOplot_up<-renderPlot({
          ## GO分析
          barplot(v$go_up, split="ONTOLOGY") +facet_grid(ONTOLOGY~., scale="free")
        })
        
        output$GOplot_down<-renderPlot({
          ## GO分析
          barplot(v$go_down, split="ONTOLOGY") +facet_grid(ONTOLOGY~., scale="free")
        })
        #KEGG
        output$KEGGTable_up <-DT::renderDataTable({
          v$keggtab_up
        })
        
        output$KEGGplot_up<-renderPlot({
          
          barplot(v$kegg_up)
          
        })
        
        output$KEGGTable_down <-DT::renderDataTable({
          v$keggtab_down
        })
        
        output$KEGGplot_down<-renderPlot({
          
          barplot(v$kegg_down)
          
        })
        

      }
      
      genecode$report<- NULL
      ctrlcode$gse.code1 <- TRUE
      ctrlcode$gpl.code2<-TRUE
      ctrlcode$B1.code3<-TRUE
      ctrlcode$B2.code4<-TRUE
      ctrlcode$GOKE.code5<-TRUE

    
      v$havePart4 <- TRUE
  
    })
    
    
    
    #通路分析下载
#    output$downlodGO <- downloadHandler(
#      filename = function() {
#        paste("result_GO","tar", sep=".")
#      },
#      content = function(file) {
#        tar(file, "file/path/")
#      },
#      contentType = "application/zip"
#    )

  })
  

  
  genecode$report<- NULL
  ctrlcode$gse.code1 <- TRUE
  ctrlcode$gpl.code2<-TRUE
  ctrlcode$B1.code3<-TRUE
  ctrlcode$B2.code4<-TRUE

  
})



#######生成可运行代码#######
## add R code to ace editor 加入代码
add.code <-function(line) {  
  if (is.null(genecode$report)) {
    genecode$report = line
  } else {
    genecode$report = paste(isolate(genecode$report), line, sep = "\n")
  }
}



#
observeEvent(genecode$report, {
  updateAceEditor(session, "rmd", genecode$report, 
                  mode = "markdown",wordWrap= TRUE, theme = "chrome")

  output$gecode <- downloadHandler(
    filename = function() {
      paste(v$geoid,"_code.r", sep="")
    },
    content = function(file) {
      writeLines(genecode$report, file,sep='\n')
    }
  )
})

#代码保存和生成的部分
observe({#####初始
  if (!ctrlcode$gse.code1) return(NULL) #控制为F时，不要运行该部分
  
  GSE = input$gse.id
  if (GSE == "") {
    return(NULL)
    #GSE = strsplit(names(GEO.test),"-")[[1]][1]
  }
  
  initialCode = NULL
  initialCode <- paste0(
    "## Load required packages 
library(GEOquery)
library(ggplot2)
library(limma)
    
## 下载GEO原始数据
GSE = \"",GSE,"\"
data.series = getGEO(GSE,destdir =\".\",getGPL = FALSE)# GEO芯片数据 
    "
)
  
  add.code(initialCode)
  #add.code(GSE)

  ctrlcode$gse.code1 <- FALSE 
})


observe({####第二部分 gpl
  if (!ctrlcode$gpl.code2) return(NULL) #控制为F时，不要运行该部分
  
  pluscode <- paste0("GPL = \"",input$gpl_id_choose,"\" # 选择的平台
data.index = match(GPL, sapply(data.series, annotation)) 
data.p = pData(data.series[[data.index]]) 
data.expr = exprs(data.series[[data.index]]) 

common = intersect(colnames(data.expr), rownames(data.p)) 
m1 = match(common, colnames(data.expr)) 
m2 = match(common, rownames(data.p)) 
data.expr = data.expr[,m1] # 表达矩阵
data.p = data.p[m2,] # 分组矩阵

orgnism = \"",v$organism,"\"

fvarLabels(data.series[[data.index]]) = make.names(fvarLabels(data.series[[data.index]]))
")
    
  add.code(pluscode)
  
  Gpl<-toupper(input$gpl_id_choose)
  
  
  if(is.null(v$platformdb)){
    add.code("wrong in platform")
  }else if(v$platformdb[1]==1){
    pluscode <- paste0("# id转换
BiocManager::install(\"",v$platformdb[2],".db\", update = F, ask = F)
library(\"",v$platformdb[2],".db\", character.only = T)
geneid = toTable(get(paste(\"",v$platformdb[2],"\", \"SYMBOL\", sep=\"\")))")
    
    add.code(pluscode)
    
  }else if(v$platformdb[1]==2){
    pluscode <- paste0("# id转换
library(idmap2)
geneid = get_soft_IDs(\"",Gpl,"\")")
    
    add.code(pluscode)
  }else{
    add.code("wrong in platform 3")
  }
  


  pluscode <- paste0("
geneid = na.omit(geneid) # 删除无对应基因的探针行
  
ids_h=grep('///',geneid[,2])# 删除对应多个基因的探针行（如果有）
if(!is_empty(ids_h)){
  geneid = geneid[-ids_h,] 
}
  
data.expr = data.expr[rownames(data.expr) %in% geneid[[1]], ] 

geneid = geneid[match(rownames(data.expr),geneid[[1]]),]
data.expr=as.data.frame(avereps(data.expr,ID=geneid[[2]]))


# log2变换判断
qx = as.numeric(quantile(data.expr, c(0., 0.25, 0.5, 0.75, 0.99, 1.0), na.rm=T))
LogC = (qx[5] > 100) || (qx[6]-qx[1] > 50 && qx[2] > 0) ||
    (qx[2] > 0 && qx[2] < 1 && qx[4] > 1 && qx[4] < 2)
  
if (LogC) {
  data.expr[which(data.expr <= 0)] = NaN
  data.expr = log2(data.expr)
}
data.expr = as.data.frame(data.expr) 

# 正交变换
data.expr = normalizeBetweenArrays(data.expr)

# 绘制箱线图
head(data.expr)
par()
boxplot(data.expr,outline=FALSE, notch=T, las=2)
")
  
  add.code(pluscode)
  ctrlcode$gpl.code2 <- FALSE
})


observe({## 聚类和分类信息
  if (!ctrlcode$B1.code3) return(NULL) #控制为F时，不要运行该部分
  
  if(is.null(v$group.list)) return(NULL)
  GG <- as.data.frame(sapply(as.data.frame(v$group.list),as.character))
  pluscode <- paste0("# 获取分组信息
Group = as.factor(",GG,")")
  add.code(pluscode)

  
  if(input$diffchoice=="choiceB"){
    if(is.null(v$pair.list)) return(NULL)
    BB <- as.data.frame(sapply(as.data.frame(v$pair.list),as.character))
    pluscode <- paste0("Block = as.factor(",BB,")")
    add.code(pluscode)
  }
  
  if(!is.null(v$group.rand)){
    RR <- as.data.frame(sapply(as.data.frame(v$group.rand),as.character))
    pluscode <- paste0("Rand = as.factor(",RR,")")
    add.code(pluscode)
  }
  
  
  if(v$diffchoice == "choiceA"){
    pluscode <- paste0("# 组间差异设计矩阵
design = model.matrix(~0+Group)")
    add.code(pluscode)
  }
  
  if(v$diffchoice == "choiceB"){
    pluscode <- paste0("# 组内差异设计矩阵
design = model.matrix(~0+Group+Block)")
    add.code(pluscode)
  }
  
  pluscode<-paste0("colnames(design)[1:length(levels(Group))] = levels(Group)
rownames(design) = colnames(data.expr)

# PCA图生成
library(factoextra)

dataex.tr=as.data.frame(t(data.expr))
dataex.tr = dataex.tr[,apply(dataex.tr, 2, var) != 0]
if(ncol(dataex.tr)>=2000){
  dataex.tr.pca = as.matrix(dataex.tr[,order(colMeans(dataex.tr), decreasing =
                                               TRUE)[1:2000]])
}else{
  dataex.tr.pca = as.matrix(dataex.tr[,order(colMeans(dataex.tr), decreasing =
                                               TRUE)[1:ncol(dataex.tr)]])
  
}
dataPCA = prcomp(dataex.tr.pca, scale = TRUE)

par()
fviz_pca_ind(dataPCA,
             col.ind = Group, 
             addEllipses = TRUE, # Concentration ellipses
             ellipse.type = \"confidence\",
             legend.title = \"Group\",
             repel = TRUE
)

# hclust聚类

rownames(dataex.tr.pca) = paste(rownames(dataex.tr.pca),Group,sep='-')
datahc = hclust(dist(dataex.tr.pca))

par()
fviz_dend(datahc,k =length(levels(Group)),
          color_labels_by_k = TRUE, 
          repel = TRUE,
          horiz = TRUE,
          rect = TRUE,
          cex=0.5)
")
  
  add.code(pluscode)
  
  
  
  ctrlcode$B1.code3 <- FALSE
})


observe({####第四部分 Limma和基因和热图和火山图
  if (!ctrlcode$B2.code4) return(NULL) #控制为F时，不要运行该部分
  if(v$diffchoice == "choiceA" && !is.null(input$Selecontrast) ){
    Contr<-input$Selecontrast }
  
  if(v$diffchoice == "choiceB" && !is.null(input$SelecontrastB) ){
    Contr<-input$SelecontrastB }
  
  if(input$updownreverse && !is.null(input$updownreverse)){
    hlContr<- strsplit(Contr,"-")
    Contr<-paste(hlContr[[1]][2],hlContr[[1]][1],sep="-")
  }

  pluscode<-paste0("## Limma差异分析

contrast.matrix = makeContrasts(contrasts=\"",Contr,"\",levels = design)
")
  
  add.code(pluscode)
  
  if(!is.null(v$group.rand)){
    pluscode<-paste0("corfit = duplicateCorrelation(data.expr,design,block = Rand) # 随机效应
fit.1 = lmFit(data.expr,design,block=Rand,correlation=corfit$consensus)
")
  }else{
    pluscode<-paste0("fit.1 = lmFit(data.expr, design) ")
  }
  add.code(pluscode)
  
  pluscode<-paste0("fit.2 = contrasts.fit(fit.1, contrast.matrix) 
fit.2 = eBayes(fit.2)# 贝叶斯检验
# 差异结果
all.diff = topTable(fit.2,adjust='fdr',coef=1,sort.by = \"p\",number=Inf) 
all.diff = na.omit(all.diff) ")
  add.code(pluscode)

  pluscode<-paste0("  
all.diff$change = ifelse(all.diff$adj.P.Val < ",v$pvalueold," & abs(all.diff$logFC) > 1,
                                 ifelse(all.diff$logFC > 1,'UP','DOWN'),
                                 'NOT')
")  
  add.code(pluscode)
  
  # 基因图
  if(!is.null(input$geneselect)){
    if(!is.null(v$pair.list) && v$diffchoice == "choiceB"){
      pluscode<-paste0("# 基因配对点图
    data.plot = data.frame(pairinfo=Block,
                        group=Group,
                        dataex.tr,stringsAsFactors = F)
ggplot(data.plot, aes(group,data.plot[,\"",input$geneselect,"\"],fill=group)) +
  geom_boxplot() +
  geom_point(size=2, alpha=0.5) +
  geom_line(aes(group=pairinfo), colour=\"black\", linetype=\"11\") +
  xlab(\"\") +
  ylab(paste(\"Expression of \",\"",input$geneselect,"\"))+
  theme_classic()+
  theme(legend.position = \"none\")")
    }else{
      pluscode<-paste0("# 基因配对点图
data.plot = data.frame(group=Group,
                        dataex.tr,stringsAsFactors = F)

ggplot(data.plot, aes(group,data.plot[,\"",input$geneselect,"\"] ,fill=group)) +
  geom_boxplot(alpha = 0.5) +
  geom_jitter(aes(colour=group), size=2, alpha=0.7)+
  xlab(\"\") +
  ylab(paste(\"Expression of \",\"",input$geneselect,"\"))+
  theme_classic()+
  theme(legend.position = \"none\")")
      
    }
    add.code(pluscode)
    
    

  }
  
  
  pluscode<-paste0("# 火山图
xMax = max(-log10(all.diff$adj.P.Val))   
yMax = max(abs(all.diff$logFC))
library(ggplot2)

par()
ggplot(data= all.diff, aes(x = -log10(adj.P.Val), y = logFC, color = change)) +
  geom_point(alpha=0.8, size = 1) +
  theme_bw(base_size = 15) +
  theme(plot.title=element_text(hjust=0.5),
        panel.grid.minor = element_blank(),
        panel.grid.major = element_blank()) +
  geom_hline(yintercept= 0 ,linetype= 2 ) +
  scale_color_manual(name = \"\", 
                     values = c(\"red\", \"green\", \"black\"),
                     limits = c(\"UP\", \"DOWN\", \"NOT\")) +
  xlim(0,xMax) + 
  ylim(-yMax,yMax) +
  labs(title = 'Volcano', x = '-Log10(adj.P.Val)', y = 'LogFC')")
  
  add.code(pluscode)
  
  
  
  pluscode<-paste0("# 热图
library(tidyverse)
library(pheatmap)

up_25 = all.diff %>% as_tibble() %>% 
  mutate(genename=rownames(all.diff)) %>% 
  dplyr::arrange(desc(logFC)) %>% 
  .$genename %>% .[1:25] ## 
  
down_25 = all.diff %>% as_tibble() %>% 
  mutate(genename=rownames(all.diff)) %>% 
  dplyr::arrange(logFC) %>% 
  .$genename %>% .[1:25] ## 
index = c(up_25,down_25)  
index_matrix = t(scale(t(data.expr[index,])))## 
index_matrix[index_matrix>1]=1
index_matrix[index_matrix = 1]=-1
anno=data.frame(group=Group)
rownames(anno)=colnames(index_matrix)

par()
pheatmap(index_matrix,
           show_colnames =F,
           show_rownames = F,
           cluster_cols = T, 
           annotation_col=anno)")
  
  add.code(pluscode)
  

  
  
  
  ctrlcode$B2.code4 <- FALSE
})


observe({#GO KEGG 代码区
  if (!ctrlcode$GOKE.code5) return(NULL) #控制为F时，不要运行该部分
  
  if(!is.null(v$orgapack)){
   
    pluscode<-paste0("
## 富集分析
library(clusterProfiler)
all.diff =all.diff[-grep(\"NOT\",all.diff$change),]
geneup = rownames(all.diff[grep(\"UP\",all.diff$change),])
genedown = rownames(all.diff[grep(\"DOWN\",all.diff$change),])


geneup = bitr(geneup, fromType=\"SYMBOL\", toType=\"ENTREZID\", OrgDb=\"",v$orgapack,"\")
genedown = bitr(genedown, fromType=\"SYMBOL\", toType=\"ENTREZID\", OrgDb=\"",v$orgapack,"\")

ENTREZ.ID.UP = geneup$ENTREZID
ENTREZ.ID.DOWN = genedown$ENTREZID ")
    
    add.code(pluscode)
    
    
    
  }else{
    pluscode<-paste0("# 没有种族信息或没有对应注释包 无法进行通道分析")
    add.code(pluscode)
    ctrlcode$GOKE.code5 <- FALSE
    return(NULL)
  }
  
  
  pluscode<-paste0("## GO分析
go.up = enrichGO(ENTREZ.ID.UP, OrgDb = \"",v$orgapack,"\", ont=\"all\")
go.down = enrichGO(ENTREZ.ID.DOWN, OrgDb = \"",v$orgapack,"\", ont=\"all\")

# 上调基因
Gt.up = as.data.frame(summary(go.up)) # table 
colnames(Gt.up) = gsub(\" \", \"\", colnames(Gt.up))
Gt.up = Gt.up[,!colnames(Gt.up) %in% c(\"geneID\")]
ordgou = order(Gt.up[\"pvalue\"])
Gt.up = Gt.up[ordgou,]

head(Gt.up)
barplot(go.up, split=\"ONTOLOGY\") +facet_grid(ONTOLOGY~., scale=\"free\")

# 下调基因
Gt.down = as.data.frame(summary(go.down)) # table 
colnames(Gt.down) = gsub(\" \", \"\", colnames(Gt.down))
Gt.down = Gt.down[,!colnames(Gt.down) %in% c(\"geneID\")]
ordgod = order(Gt.down[\"pvalue\"])
Gt.down = Gt.down[ordgod,]

head(Gt.down)
barplot(go.down, split=\"ONTOLOGY\") +facet_grid(ONTOLOGY~., scale=\"free\")



## KEGG分析

# 上调基因
KEGG.up = enrichKEGG(ENTREZ.ID.UP,
                   organism     = \"",v$keggpack,"\",
                   pvalueCutoff = 0.05)
                   
Et.up = as.data.frame(summary(KEGG.up)) #table 
colnames(Et.up) = gsub(\" \", \"\", colnames(Et.up))
Et.up = Et.up[,!colnames(Et.up) %in% c(\"geneID\")]
ordgouk = order(Et.up[\"pvalue\"])
Et.up = Et.up[ordgouk,]

head(Et.up)
barplot(KEGG.up)

# 下调基因             
KEGG.down = enrichKEGG(ENTREZ.ID.DOWN,
                   organism     = \"",v$keggpack,"\",
                   pvalueCutoff = 0.05)
Et.down = as.data.frame(summary(KEGG.down)) #table 
colnames(Et.down) = gsub(\" \", \"\", colnames(Et.down))
Et.down = Et.down[,!colnames(Et.down) %in% c(\"geneID\")]
ordgodk = order(Et.down[\"pvalue\"])
Et.down = Et.down[ordgodk,]

head(Et.down)
barplot(KEGG.down)                  
")
  
  add.code(pluscode)
  
  ctrlcode$GOKE.code5 <- FALSE
})

#######生成report#######
#下载markdown report

output$downloadreport <- downloadHandler(
  # For PDF output, change this to "report.pdf"
  
  filename = "report.html",
  
  content = function(file) {
    
    tempReport <- file.path(tempdir(), "MephasGEO.Rmd")
    file.copy("MephasGEO.Rmd", tempReport, overwrite = TRUE)
    params <- list(v = v)
    
    progress <- shiny::Progress$new() #过程监视弹窗
    on.exit(progress$close())
    progress$set(message = "Result", value = 0)
    progress$inc(0.70, detail = "generating Rmarkdown file")
	
    rmarkdown::render(tempReport, output_file = file,
                      params = params,
                      envir = new.env(parent = globalenv())
    )
  }
)

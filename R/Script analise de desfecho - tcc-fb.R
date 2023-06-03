
# Análise de Clusters K-means + Análise de Correspondência Múltipla

# Curso: MBA DSA (USP ESALQ)

# Prof. Wilson Tarantin Jr.

# Fonte dos dados: https://www.kaggle.com/datasets/kaushiksuresh147/customer-segmentation

# Instalação e carregamento dos pacotes utilizados
pacotes <- c("plotly", 
             "tidyverse", 
             "ggrepel",
             "knitr", "kableExtra", 
             "sjPlot", 
             "FactoMineR", 
             "amap", 
             "ade4",
             "cluster",
             "factoextra")

if(sum(as.numeric(!pacotes %in% installed.packages())) != 0){
  instalador <- pacotes[!pacotes %in% installed.packages()]
  for(i in 1:length(instalador)) {
    install.packages(instalador, dependencies = T)
    break()}
  sapply(pacotes, require, character = T) 
} else {
  sapply(pacotes, require, character = T) 
}

# Importando a base de dados
#setwd("/Users/fbarbosa/git/repositoriodatasharingfapesp/R")
#load("/Users/fbarbosa/git/repositoriodatasharingfapesp/R/data-tcc-fb-desfechos.csv")

desfechos <- read.csv("/Users/fbarbosa/git/repositoriodatasharingfapesp/R/data-tcc-fb-desfechos.csv", header=TRUE)
head(desfechos)

# removendo valores NA (se existirem)
desfechos <- drop_na(desfechos)

# Algumas variáveis são qualitativas e outras são quantitativas
## Vamos separar o banco de dados em 2 partes (somente quali e quanti)
desfechos_quali <- desfechos[,c(2,4)]
desfechos_quanti <- desfechos[,c(5,7,8,9,10,11,12,13,14,15,16,17,18,19,20)]

# A função para a criação da ACM pede que sejam utilizados "fatores"
desfechos_quali_factors <- as.data.frame(unclass(desfechos_quali), stringsAsFactors=TRUE)

# Estatísticas descritivas dos dados
summary(desfechos_quanti)
summary(desfechos_quali_factors)

# Iniciando a Análise de Cluster nas variáveis quantitativas

# Aplicando a padronização por ZScore
desfecho_pad <- as.data.frame(scale(desfechos_quanti))

round(mean(desfecho_pad$idade), 3)
round(mean(desfecho_pad$qtd_desfechos_obito), 3)

round(sd(desfecho_pad$idade), 3)
round(sd(desfecho_pad$qtd_desfechos_obito), 3)

fviz_nbclust(desfecho_pad, kmeans, method = "wss", k.max = 15)


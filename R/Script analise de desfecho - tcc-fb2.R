
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

#desfechos <- read.csv("/Users/fbarbosa/git/repositoriodatasharingfapesp/R/data-tcc-fb-desfechos.csv", header=TRUE)
desfechos <- read.csv("/Users/Flavio Barbosa/git/repositoriodatasharingfapesp/R/data-tcc-fb-desfechos.csv", header=TRUE)
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

#fviz_nbclust(desfecho_pad, kmeans, method = "wss", k.max = 30)

# Elaboração da clusterização não hieráquica k-means
cluster_kmeans <- kmeans(desfecho_pad,
                         centers = 15)

# Criando variável categórica para indicação do cluster no banco de dados
desfecho_pad$cluster_K <- factor(cluster_kmeans$cluster)
desfechos$cluster_K <- factor(cluster_kmeans$cluster)

# Análise de variância de um fator (ANOVA). Interpretação do output:

## Mean Sq do cluster_K: indica a variabilidade entre grupos
## Mean Sq dos Residuals: indica a variabilidade dentro dos grupos
## F value: estatística de teste (Sum Sq do cluster_K / Sum Sq dos Residuals)
## Pr(>F): p-valor da estatística 
## p-valor < 0.05: pelo menos um cluster apresenta média estatisticamente diferente dos demais

## A variável mais discriminante dos grupos contém maior estatística F (e significativa)

# ANOVA da variável 'Age'
summary(anova_idade <- aov(formula = idade ~ cluster_K,
                         data = desfecho_pad))

# ANOVA da variável 'Family_Size'
summary(anova_qtd_desfechos_obito <- aov(formula = qtd_desfechos_obito ~ cluster_K,
                                 data = desfecho_pad))


# Estatísticas descritivas para as variáveis originais 

## 'idade'
group_by(desfechos, cluster_K) %>%
  summarise(
    mean = mean(idade, na.rm = TRUE),
    sd = sd(idade, na.rm = TRUE),
    min = min(idade, na.rm = TRUE),
    max = max(idade, na.rm = TRUE),
    obs = n())

## 'qtd_desfechos_obito'
group_by(desfechos, cluster_K) %>%
  summarise(
    mean = mean(qtd_desfechos_obito, na.rm = TRUE),
    sd = sd(qtd_desfechos_obito, na.rm = TRUE),
    min = min(qtd_desfechos_obito, na.rm = TRUE),
    max = max(qtd_desfechos_obito, na.rm = TRUE),
    obs = n())

## 'ic_sexo'
group_by(desfechos, cluster_K) %>%
  count(ic_sexo) %>%
  mutate(prop = prop.table(n))

## 'localizacao'
group_by(desfechos, cluster_K) %>%
  count(localizacao) %>%
  mutate(prop = prop.table(n))


# Iniciando a Análise de Correspondência Múltipla nas variáveis qualitativas

# Adicionando variável qualitativa que indica o cluster
desfechos_quali_factors$cluster_K <- factor(cluster_kmeans$cluster)

# Estatísticas descritivas
summary(desfechos_quali_factors)

# Tabelas de contingência
sjt.xtab(var.row = desfechos_quali_factors$localizacao,
         var.col = desfechos_quali_factors$ic_sexo,
         show.exp = TRUE,
         show.row.prc = TRUE,
         show.col.prc = TRUE, 
         encoding = "UTF-8")

sjt.xtab(var.row = desfechos_quali_factors$localizacao,
         var.col = desfechos_quali_factors$cluster_K,
         show.exp = TRUE,
         show.row.prc = TRUE,
         show.col.prc = TRUE, 
         encoding = "UTF-8")

sjt.xtab(var.row = desfechos_quali_factors$ic_sexo,
         var.col = desfechos_quali_factors$cluster_K,
         show.exp = TRUE,
         show.row.prc = TRUE,
         show.col.prc = TRUE, 
         encoding = "UTF-8")

# Vamos gerar a ACM (para 3 eixos)
ACM <- dudi.acm(desfechos_quali_factors, scannf = FALSE, nf = 3)


# Analisando as variâncias de cada dimensão
perc_variancia <- (ACM$eig / sum(ACM$eig)) * 100
perc_variancia

# Quantidade de categorias por variável
quant_categorias <- apply(desfechos_quali_factors,
                          MARGIN =  2,
                          FUN = function(x) nlevels(as.factor(x)))

# Consolidando as coordenadas-padrão obtidas por meio da matriz binária
df_ACM <- data.frame(ACM$c1, Variável = rep(names(quant_categorias),
                                            quant_categorias))

# Plotando o mapa perceptual
df_ACM %>%
  rownames_to_column() %>%
  rename(Categoria = 1) %>%
  ggplot(aes(x = CS1, y = CS2, label = Categoria, color = Variável)) +
  geom_point() +
  geom_label_repel() +
  geom_vline(aes(xintercept = 0), linetype = "longdash", color = "grey48") +
  geom_hline(aes(yintercept = 0), linetype = "longdash", color = "grey48") +
  labs(x = paste("Dimensão 1:", paste0(round(perc_variancia[1], 2), "%")),
       y = paste("Dimensão 2:", paste0(round(perc_variancia[2], 2), "%"))) +
  theme_bw()

# Mapa perceptual em 3D (3 primeiras dimensões)
ACM_3D <- plot_ly()

# Adicionando as coordenadas
ACM_3D <- add_trace(p = ACM_3D,
                    x = df_ACM$CS1,
                    y = df_ACM$CS2,
                    z = df_ACM$CS3,
                    mode = "text",
                    text = rownames(df_ACM),
                    textfont = list(color = "blue"),
                    marker = list(color = "red"),
                    showlegend = FALSE)

ACM_3D

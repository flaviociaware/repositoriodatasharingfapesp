
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
             "reshape2",
             "PerformanceAnalytics",
             "psych",
             "Hmisc",
             "readxl",
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

# Estatísticas descritivas
summary(desfechos)

# Algumas variáveis são qualitativas e outras são quantitativas
## Vamos separar o banco de dados em 2 partes (somente quali e quanti)
desfechos_quali <- desfechos[,c(2,4)]
desfechos_quanti <- desfechos[,c(5,7,8,9,10,11,12,13,14,15,16,17,18,20)]

# A função para a criação da ACM pede que sejam utilizados "fatores"
desfechos_quali <- as.data.frame(unclass(desfechos_quali), stringsAsFactors=TRUE)

# Estatísticas descritivas dos dados
summary(desfechos_quanti)
summary(desfechos_quali)


# Coeficientes de correlação de Pearson para cada par de variáveis
rho <- rcorr(as.matrix(desfechos_quanti), type="pearson")

correl <- rho$r # Matriz de correlações
sig_correl <- round(rho$P, 4) # Matriz com p-valor dos coeficientes

# Elaboração de um mapa de calor das correlações de Pearson entre as variáveis
ggplotly(
  desfechos_quanti %>%
    cor() %>%
    melt() %>%
    rename(Correlação = value) %>%
    ggplot() +
    geom_tile(aes(x = Var1, y = Var2, fill = Correlação)) +
    geom_text(aes(x = Var1, y = Var2, label = format(Correlação, digits = 1)),
              size = 5) +
    scale_fill_viridis_b() +
    labs(x = NULL, y = NULL) +
    theme_bw())

# Visualização das distribuições das variáveis, scatters, valores das correlações
# DEMORADO
# chart.Correlation(desfechos_quanti[,], histogram = TRUE, pch = "+")


# Teste de esfericidade de Bartlett
cortest.bartlett(desfechos_quanti)

# Elaboração da análise fatorial por componentes principais
fatorial <- principal(desfechos_quanti[,],
                      nfactors = length(desfechos_quanti[,]),
                      rotate = "none",
                      scores = TRUE)
fatorial

# Eigenvalues (autovalores)
eigenvalues <- round(fatorial$values, 5)
eigenvalues

# Soma dos eigenvalues = 9 (quantidade de variáveis na análise)
# Também representa a quantidade máxima de possíveis fatores na análise
round(sum(eigenvalues), 2)

variancia_compartilhada <- as.data.frame(fatorial$Vaccounted) %>% 
  slice(1:3)

rownames(variancia_compartilhada) <- c("Autovalores",
                                       "Prop. da Variância",
                                       "Prop. da Variância Acumulada")

# Variância compartilhada pelas variáveis originais para a formação de cada fator
round(variancia_compartilhada, 3) %>%
  kable() %>%
  kable_styling(bootstrap_options = "striped", 
                full_width = FALSE, 
                font_size = 20)





# Cálculo dos scores fatoriais
scores_fatoriais <- as.data.frame(fatorial$weights)

# Visualização dos scores fatoriais
round(scores_fatoriais, 3) %>%
  kable() %>%
  kable_styling(bootstrap_options = "striped", 
                full_width = FALSE, 
                font_size = 20)

# Cálculo dos fatores propriamente ditos
fatores <- as.data.frame(fatorial$scores)

View(fatores)


# Coeficientes de correlação de Pearson para cada par de fatores (ortogonais)
rho <- rcorr(as.matrix(fatores), type="pearson")
round(rho$r, 4)

# Cálculo das cargas fatoriais
cargas_fatoriais <- as.data.frame(unclass(fatorial$loadings))

# Visualização das cargas fatoriais
round(cargas_fatoriais, 3) %>%
  kable() %>%
  kable_styling(bootstrap_options = "striped", 
                full_width = FALSE, 
                font_size = 20)

# Cálculo das comunalidades
comunalidades <- as.data.frame(unclass(fatorial$communality)) %>%
  rename(comunalidades = 1)

# Visualização das comunalidades (aqui são iguais a 1 para todas as variáveis)
# Foram extraídos 9 fatores neste primeiro momento
round(comunalidades, 3) %>%
  kable() %>%
  kable_styling(bootstrap_options = "striped",
                full_width = FALSE,
                font_size = 20)


### Elaboração da Análise Fatorial por Componentes Principais ###
### Fatores extraídos a partir de autovalores maiores que 1 ###

# Definição da quantidade de fatores com eigenvalues maiores que 1
k <- sum(eigenvalues > 1)
print(k)


# Elaboração da análise fatorial por componentes principais sem rotação
# Com quantidade 'k' de fatores com eigenvalues maiores que 1
fatorial2 <- principal(desfechos_quanti[,],
                       nfactors = k,
                       rotate = "none",
                       scores = TRUE)


fatorial2

# Cálculo das comunalidades com apenas os 'k' ('k' = 3) primeiros fatores
comunalidades2 <- as.data.frame(unclass(fatorial2$communality)) %>%
  rename(comunalidades = 1)


# Visualização das comunalidades com apenas os 'k' ('k' = 3) primeiros fatores
round(comunalidades2, 3) %>%
  kable() %>%
  kable_styling(bootstrap_options = "striped",
                full_width = FALSE,
                font_size = 20)

# Loading plot com as cargas dos dois primeiros fatores
cargas_fatoriais[, 1:2] %>% 
  data.frame() %>%
  rownames_to_column("variáveis") %>%
  ggplot(aes(x = PC1, y = PC2, label = variáveis)) +
  geom_point(color = "darkorchid",
             size = 3) +
  geom_text_repel() +
  geom_vline(aes(xintercept = 0), linetype = "dashed", color = "orange") +
  geom_hline(aes(yintercept = 0), linetype = "dashed", color = "orange") +
  expand_limits(x= c(-1.25, 0.25), y=c(-0.25, 1)) +
  theme_bw()

# Adicionando os fatores extraídos no banco de dados original
desfechos_quanti <- bind_cols(desfechos_quanti,
                    "fator_1" = fatores$PC1, 
                    "fator_2" = fatores$PC2,
                    "fator_3" = fatores$PC3)


summary(desfechos_quanti[,15:17])


sd(desfechos_quanti[,15])
sd(desfechos_quanti[,16])
sd(desfechos_quanti[,17])

## ATENÇÃO: os clusters serão formados a partir dos 3 fatores
## Não aplicaremos o Z-Score, pois os fatores já são padronizados

# Matriz de dissimilaridades
matriz_D <- desfechos_quanti[,15:17] %>% 
  dist(method = "euclidean")


# Elaboração da clusterização hierárquica
# DEMORA
cluster_hier <- agnes(x = matriz_D, method = "complete")

# Definição do esquema hierárquico de aglomeração

# As distâncias para as combinações em cada estágio
coeficientes <- sort(cluster_hier$height, decreasing = FALSE) 
coeficientes

# Tabela com o esquema de aglomeração. Interpretação do output:

## As linhas são os estágios de aglomeração
## Nas colunas Cluster1 e Cluster2, observa-se como ocorreu a junção
## Quando for número negativo, indica observação isolada
## Quando for número positivo, indica cluster formado anteriormente (estágio)
## Coeficientes: as distâncias para as combinações em cada estágio

esquema <- as.data.frame(cbind(cluster_hier$merge, coeficientes))
names(esquema) <- c("Cluster1", "Cluster2", "Coeficientes")
esquema

# Construção do dendrograma
dev.off()
fviz_dend(x = cluster_hier, show_labels = FALSE)

# Dendrograma com visualização dos clusters (definição de 10 clusters)
fviz_dend(x = cluster_hier,
          h = 3.0,
          show_labels = FALSE,
          color_labels_by_k = F,
          rect = F,
          rect_fill = F,
          ggtheme = theme_bw())


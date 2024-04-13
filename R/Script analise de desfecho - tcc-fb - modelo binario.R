

##################################################################################
#                  INSTALAÇÃO E CARREGAMENTO DE PACOTES NECESSÁRIOS             #
##################################################################################
#Pacotes utilizados
#install.packages("equatiomatic")

pacotes <- c("plotly","tidyverse","ggrepel","fastDummies","knitr", "kableExtra",
             "splines","reshape2","PerformanceAnalytics","correlation","see",
             "ggraph","psych","nortest","rgl","car","ggside","tidyquant","olsrr",
             "jtools","ggstance","magick","cowplot","emojifont","beepr","Rcpp", "equatiomatic", "palmerpenguins", "ggplot2", "latex2exp")

# https://www.rdocumentation.org/packages/equatiomatic/versions/0.3.1
# desenvolvedores: 
#remotes::install_github("datalorax/equatiomatic", force = TRUE)
# 
#

options(rgl.debug = TRUE)

if(sum(as.numeric(!pacotes %in% installed.packages())) != 0){
  instalador <- pacotes[!pacotes %in% installed.packages()]
  for(i in 1:length(instalador)) {
    install.packages(instalador, dependencies = T)
    break()}
  sapply(pacotes, require, character = T) 
} else {
  sapply(pacotes, require, character = T) 
}


#knitr::opts_chunk$set(echo = TRUE)

##################################################################################
# Importando a base de dados
##################################################################################
#setwd("/Users/fbarbosa/git/repositoriodatasharingfapesp/R")
Estudo <- read.csv("/Users/fbarbosa/git/repositoriodatasharingfapesp/R/data-tcc-fb-desfechos-quali-binario.csv", header=TRUE)
#estudo <- read.csv("/Users/Flavio Barbosa/git/repositoriodatasharingfapesp/R/data-tcc-fb-desfechos.csv", header=TRUE)
head(Estudo)

# removendo valores NA (se existirem)
Estudo <- drop_na(Estudo)

#Visualizando a base de dados
#Estudo %>%
#  kable() %>%
#  kable_styling(bootstrap_options = "striped", 
#                full_width = F, 
#                font_size = 12)


# Algumas variáveis são qualitativas e outras são quantitativas
## Vamos separar o banco de dados em 2 partes (somente quali e quanti)
#Estudo_quali <- Estudo[,c(1,2,3,4,6,7,8,9,10,11,12,13,14,15,16,17,18)]
#Estudo_quanti <- Estudo[,c(5,19,20,21,22,23,24,25,26,27,28,29,30)]

# A função para a criação da ACM pede que sejam utilizados "fatores"
#Estudo_quali <- as.data.frame(unclass(Estudo_quali), stringsAsFactors=TRUE)

# Estatísticas descritivas dos dados
#summary(Estudo_quanti)
#summary(Estudo_quali)

Estudo_mix <- Estudo[,c(2,3,4,6,7,8,9,10,11,12,13,14,15,16)]

Estudo_mix$genero <- factor(Estudo_mix$genero)

glimpse(Estudo_mix)

summary(Estudo_mix)



#Tabela de frequências absolutas da variável 'atrasado'
table(Estudo_mix$obito)

#Estudo_mix_obitos <- filter(Estudo_mix, obito==1)


################################################################################
#     GRÁFICO DE CORRELAÇÕES                                                   #
################################################################################
Estudo_simples <- Estudo[,c(3, 4,6,7,8,9,10,11,12,13,14,15,16)]
chart.Correlation( Estudo_simples, histogram = TRUE, pch = "+")

##############################################################################
#           ESTIMAÇÃO DE UM MODELO LOGÍSTICO BINÁRIO                         #
##############################################################################
modelo_estudo <- glm(formula = obito ~ idade + genero + inalterado + melhorado + curado + internacao + pa + desistencia + transfer + neonatal + alta_adm + ambulatorio + ass_domiciliar, 
                      data = Estudo_mix, 
                      family = "binomial")

#Parâmetros do modelo_atrasos
summary(modelo_estudo)

#Stepwise
modelo_estudo_stepped <- step(modelo_estudo, k = (qchisq(p=0.05,df=1,lower.tail=F)) )
summary(modelo_estudo_stepped)


#Visualização do modelo no ambiente Viewer
#função 'extract_eq' do pacote 'equatiomatic'
#
# 
#pacotes <- c("equatiomatic") 
#
#

extract_eq(modelo_estudo_stepped, use_coefs = T,
           wrap = T, show_distribution = T) %>%
  kable() %>%
  kable_styling(bootstrap_options = "striped",
                full_width = F,
                font_size = 25)


################################################################################
#                          PROCEDIMENTO N-1 DUMMIES     - TESTE COM DUMMIE     #
################################################################################
#Dummizando a variável regiao. O código abaixo, automaticamente, fará: a) o
#estabelecimento de dummies que representarão cada uma das regiões da base de 
#dados; b)removerá a variável dummizada original; c) estabelecerá como categoria 
#de referência a dummy mais frequente.
Estudo_dummies <- dummy_columns(.data = Estudo,
                                   select_columns = "ic_sexo",
                                   remove_selected_columns = T,
                                   remove_most_frequent_dummy = T)


modelo_estudo_dummy <- glm(formula = obito ~ idade + ic_sexo_M + desfecho + inalterado + melhorado + curado + internacao + pa + desistencia + transfer + neonatal + alta_adm + ambulatorio + ass_domiciliar, 
                     data = Estudo_dummies, 
                     family = "binomial")

#Parâmetros do modelo_atrasos
summary(modelo_estudo_dummy)

#MESMO RESULTADO, SEXO NÃO É ESTATISTICAMENTE SIGNIFICATIVO


# Extração dos intervalos de confiança ao nível de siginificância de 5%
confint(modelo_atrasos, level = 0.95)

#Extração do valor de Log-Likelihood (LL)
logLik(modelo_atrasos)



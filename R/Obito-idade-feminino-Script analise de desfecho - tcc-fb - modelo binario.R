

##################################################################################
#                  INSTALAÇÃO E CARREGAMENTO DE PACOTES NECESSÁRIOS             #
##################################################################################
#Pacotes utilizados
#install.packages("equatiomatic")

pacotes <- c("plotly","tidyverse","ggrepel","fastDummies","knitr", "kableExtra",
             "splines","reshape2","PerformanceAnalytics","correlation","see",
             "ggraph","psych","nortest","rgl","car","ggside","tidyquant","olsrr",
             "jtools","ggstance","magick","cowplot","emojifont","beepr","Rcpp", "equatiomatic",
             "palmerpenguins", "ggplot2", "latex2exp","pROC","ROCR","nnet","stargazer","lmtest","globals","caret")

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
Estudo <- read.csv("/Users/fbarbosa/git/repositoriodatasharingfapesp/R/obito-ida-gen-f-data-tcc-fb-desfecho-quali-binario.csv", header=TRUE)
#estudo <- read.csv("/Users/Flavio Barbosa/git/repositoriodatasharingfapesp/R/data-tcc-fb-desfechos.csv", header=TRUE)
head(Estudo)

# removendo valores NA (se existirem)
Estudo <- drop_na(Estudo)


glimpse(Estudo)

Estudo_mix <- Estudo[,c(2,3,5)]

glimpse(Estudo_mix)

summary(Estudo_mix)

head(Estudo_mix)


#Tabela de frequências absolutas da variável 'atrasado'
table(Estudo_mix$obito)

#Estudo_mix_obitos <- filter(Estudo_mix, obito==1)


################################################################################
#     GRÁFICO DE CORRELAÇÕES                                                   #
################################################################################
#Estudo_simples <- Estudo[,c(3, 4,6,7,8,9,10,11,12,13,14,15,16)]
#chart.Correlation( Estudo_simples, histogram = TRUE, pch = "+")

Estudo_simples <- Estudo_mix
chart.Correlation( Estudo_simples, histogram = TRUE, pch = "+")
cor(Estudo_simples)


##############################################################################
#           ESTIMAÇÃO DE UM MODELO LOGÍSTICO BINÁRIO                         #
##############################################################################
modelo_estudo <- glm(formula = obito ~ idade + feminino, 
                      data = Estudo, 
                      family = "binomial")

#Parâmetros do modelo do estudo
summary(modelo_estudo)

#Outro modo de apresentar os outputs do modelo do estudo
#summ(modelo_estudo, confint = T, digits = 3, ci.width = .95)
export_summs(modelo_estudo, scale = F, digits = 6)


#Stepwise
modelo_estudo_stepped <- step(modelo_estudo, k = (qchisq(p=0.05,df=1,lower.tail=F)) )
summary(modelo_estudo_stepped)

export_summs(modelo_estudo_stepped, scale = F, digits = 6)


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

#Valor do LL do modelo stepped
logLik(modelo_estudo_stepped)


#Fazendo predições para o modelo_estudo_stepped Exemplo: qual a probabilidade média
#de um paciente de 89 anos vir a óbito?
#
# - obs: existe um paciente de 89 anos que veio a obito nos dados.
#
predict(object = modelo_estudo_stepped, 
        data.frame(idade = 89), 
        type = "response")

predict(object = modelo_estudo_stepped, 
        data.frame(idade = 90), 
        type = "response")


# Adicionando os valores previstos de probabilidade na base de dados
Estudo$phat <- modelo_estudo_stepped$fitted.values

#Visualizando a base de dados com a variável 'phat'
Estudo %>%
  kable() %>%
  kable_styling(bootstrap_options = "striped", 
                full_width = F, 
                font_size = 22)



# Ajuste logístico determinístico entre a variável dependente e a variável 'idade'
#Sigmóide
# ggplotly(
#   Estudo %>% 
#     ggplot() +
#     geom_point(aes(x = idade, y = obito), color = "orange", linewidth = 2) +
#     geom_smooth(aes(x = idade, y = phat), 
#                 method = "glm", formula = y ~ x, 
#                 method.args = list(family = "binomial"), 
#                 se = FALSE,
#                 color = "darkorchid", linewidth = 2) +
#     labs(x = "Idade",
#          y = "Óbitos") +
#     theme_bw()
# )

# Ajuste logístico probabilístico entre a variável dependente e a variável 'IDADE'
#Sigmóide
ggplotly(
  Estudo %>% 
    ggplot() +
    geom_point(aes(x = idade, y = phat), color = "orange", linewidth = 2) +
    geom_smooth(aes(x = idade, y = phat), 
                method = "glm", formula = y ~ x, 
                method.args = list(family = "binomial"), 
                se = FALSE,
                color = "darkorchid", linewidth = 1) +
    labs(x = "Idade",
         y = "Probabilidade do evento Óbito") +
    theme_bw()
)

#Matriz de confusão


confusionMatrix(
  table(predict(modelo_estudo_stepped, type = "response")>=1.083127e-02, 
        Estudo$obito == TRUE)[2:1, 2:1]
)

#Visualizando os principais indicadores desta matriz de confusão
data.frame(Sensitividade = confusionMatrix(table(predict(modelo_estudo_stepped,
                                                         type = "response") >= 1.083127e-02,
                                                 Estudo$obito == TRUE)[2:1, 2:1])[["byClass"]][["Sensitivity"]],
           Especificidade = confusionMatrix(table(predict(modelo_estudo_stepped,
                                                          type = "response") >= 1.083127e-02,
                                                  Estudo$obito == TRUE)[2:1, 2:1])[["byClass"]][["Specificity"]],
           Acurácia = confusionMatrix(table(predict(modelo_estudo_stepped,
                                                    type = "response") >= 1.083127e-02,
                                            Estudo$obito == TRUE)[2:1, 2:1])[["overall"]][["Accuracy"]]) %>%
  kable() %>%
  kable_styling(bootstrap_options = "striped", position = "center",
                full_width = F, 
                font_size = 27)


#função prediction do pacote ROCR
predicoes_estudo <- prediction(predictions = modelo_estudo_stepped$fitted.values, 
                               labels = Estudo$obito) 

#a função prediction, do pacote ROCR, cria um objeto com os dados necessários
#para a futura plotagem da curva ROC.

#função performance do pacote ROCR
dados_curva_roc_estudo <- performance(predicoes_estudo, measure = "sens") 
#A função peformance(), do pacote ROCR, extraiu do objeto 'predicoes' os 
#dados de sensitividade, de sensibilidade e de especificidade para a plotagem.

#Porém, desejamos os dados da sensitividade, então devemos fazer o seguinte 
#ajuste:
sensitividade_estudo <- dados_curva_roc_estudo@y.values[[1]] 
#extraindo dados da sensitividade do modelo

especificidade_estudo <- performance(predicoes_estudo, measure = "spec") 
#extraindo os dados da especificidade, mas também há que se fazer um ajuste para a 
#plotagem:
especificidade_estudo <- especificidade_estudo@y.values[[1]]

cutoffs_estudo <- dados_curva_roc_estudo@x.values[[1]] 
cutoffs_estudo
#extraindo os cutoffs do objeto 'sensitividade'.

#Até o momento, foram extraídos 3 vetores: 'sensitividade', 'especificidade' 
#e 'cutoffs'. Poder-se-ia plotar normalmente a partir daqui com a linguagem 
#base do R, mas demos preferência à ferramenta ggplot2. Assim, criamos um data 
#frame que contém os vetores mencionados.

dados_plotagem_estudo <- cbind.data.frame(cutoffs_estudo, especificidade_estudo, sensitividade_estudo)

#Visualizando o novo dataframe dados_plotagem
dados_plotagem_estudo %>%
  kable() %>%
  kable_styling(bootstrap_options = "striped", 
                full_width = F, 
                font_size = 22)

#Plotando especificidade vs sensitivdade:
ggplotly(dados_plotagem_estudo %>%
           ggplot(aes(x = cutoffs_estudo, y = especificidade_estudo)) +
           geom_line(aes(color = "Especificidade"),
                     size = 1) +
           geom_point(color = "#95D840FF",
                      size = 1.9) +
           geom_line(aes(x = cutoffs_estudo, y = sensitividade_estudo, color = "Sensitividade"),
                     size = 1) +
           geom_point(aes(x = cutoffs_estudo, y = sensitividade_estudo),
                      color = "#440154FF",
                      size = 1.9) +
           labs(x = "Cutoff",
                y = "Sensitividade/Especificidade") +
           scale_color_manual("Legenda:",
                              values = c("#95D840FF", "#440154FF")) +
           theme_bw())



# CONSTRUÇÃO DA CURVA ROC
ROC_Estudo <- roc(response = Estudo$obito, 
                  predictor = modelo_estudo_stepped$fitted.values)

#Plotagem da curva ROC propriamente dita
ggplot() +
  geom_segment(aes(x = 0, xend = 1, y = 0, yend = 1),
               color = "grey40", size = 0.2) +
  geom_line(aes(x = 1 - especificidade_estudo, y = sensitividade_estudo),
            color = "darkorchid", size = 2) +
  labs(x = "1 - Especificidade",
       y = "Sensitividade",
       title = paste("Área abaixo da curva:",
                     round(ROC_Estudo$auc, 4),
                     "|",
                     "Coeficiente de Gini:",
                     round((ROC_Estudo$auc[1] - 0.5) / 0.5, 4))) +
  theme(panel.background = element_rect(NA),
        panel.border = element_rect(color = "black", fill = NA),
        legend.text = element_text(size = 10),
        legend.title = element_text(size = 10)
  )

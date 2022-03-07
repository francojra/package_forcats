
# Pacote Forcats - Tidyverse ---------------------------------------------------------------------------------------------------------------
# Autoria do script: Jeanne Franco ---------------------------------------------------------------------------------------------------------
# Data: 06/03/2022 -------------------------------------------------------------------------------------------------------------------------
# Fonte: Curso R ---------------------------------------------------------------------------------------------------------------------------

# Conceito do pacote forcats ---------------------------------------------------------------------------------------------------------------

## Algumas vezes o R base pode ler uma coluna de strings como um fator e esses fatores não podem ser
## manipulados da mesma forma que os vetores de strings são manipulados. Portanto, o pacote forcats
## foi desenvolvido por Hadley Wickham para solucionar esse problema.

## O pacote forcats (For Categorial Variables) implementa algumas ferramentas. As principais funções
## do forcats servem para alterar a ordem e modificar os níveis de um fator.

# Baixar pacotes necessários ---------------------------------------------------------------------------------------------------------------

library(forcats)
library(ggplot2)
library(dplyr)

# O que são fatores ------------------------------------------------------------------------------------------------------------------------

## fatores são uma classe de objetos no R criada para representar as variáveis categóricas numericamente.
## Eles são necessários pois muitas vezes precisamos representar variáveis categóricas como números.
## Quando estamos fazendo um gráfico, por exemplo, só podemos mapear variáveis numéricas em seus eixos,
## pois o plano cartesiano é formado por duas retas de números reais.
## O que fazemos então quando plotamos uma variável categórica? Nós a transformamos em fatores.

## Mas como a manipulação de fatores é diferente da manipulação de números e strings (graças aos famosos levels),
## tarefas que parecem simples, como ordenar as barras de um gráfico de barras, acabam se tornando grandes 
## desafios quando não sabemos lidar com essa classe de valores.

## Nos exemplos a seguir, vamos utilizar a base starwars (do pacote {dplyr}) para aprendermos a fazer as 
## principais operações com fatores utilizando o pacote {forcats}.
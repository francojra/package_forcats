
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

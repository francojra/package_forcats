
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

# Modificando níveis de um fator -----------------------------------------------------------------------------------------------------------

## Vamos trabalhar primeiro com a coluna sex, que diz qual é o sexo de cada personagem.

starwars %>% 
  pull(sex) %>% 
  unique()

## Vamos criar um objeto com os 16 primeiros valores da coluna sex já transformados em fator.

fator_sex <- starwars %>% 
  pull(sex) %>% 
  as.factor() %>% 
  head(16)
fator_sex

## Veja que se transformarmos a coluna em fator, esses serão os levels da variável, 
## não importa se o sub-conjunto que estivermos observando possua ou não todas as categorias.

## Para mudar os níveis de um fator, podemos utilizar a função lvls_revalue(). Veja que, ao 
## mudarmos os níveis de um fator, o label de cada valor também muda. Os novos valores precisam 
## ser passados conforme a ordem dos níveis antigos.

lvls_revalue(
  fator_sex, 
  new_levels = c("Fêmea", "Hermafrodita", "Macho", "Nenhum")
)

## Essa função é uma boa alternativa para mudar o nome das categorias de uma variável antes de 
## construir um gráfico.

starwars %>% 
  filter(!is.na(sex)) %>% 
  count(sex) %>% 
  mutate(
    sex = lvls_revalue(sex, c("Fêmea", "Hermafrodita", "Macho", "Nenhum"))
  ) %>% 
  ggplot() +
  geom_col(aes(x = sex, y = n)) 

## Como as colunas no gráfico respeitam a ordem dos níveis do fator, não importa a ordem que as 
## linhas aparecem na tabela, o gráfico sempre será gerado com as colunas na mesma ordem. Assim, 
## se quiséssemos alterar a ordem das barras do gráfico anterior, precisamos mudar a ordem dos 
## níveis do fator sex.

# Mudando a ordem dos níveis de um fator ---------------------------------------------------------------------------------------------------

## Para mudar a ordem dos níveis de um fator, podemos utilizar a função lvls_reorder(). 
## Basta passarmos qual a nova ordem dos fatores, com relação à ordem anterior. No exemplo 
## abaixo definimos que, na nova ordem,

## - a primeira posição terá o nível que estava na terceira posição na ordem antiga;
## - a segunda posição terá o nível que estava na primeira posição na ordem antiga;
## - a terceira posição terá o nível que estava na quarta posição na ordem antiga;
## - a quarta posição terá o nível que estava na segunda posição na ordem antiga.

lvls_reorder(fator_sex, c(3, 1, 4, 2))

## Assim, poderíamos usar essa nova ordem para ordenar as colunas do nosso gráfico.

starwars %>% 
  filter(!is.na(sex)) %>% 
  count(sex) %>% 
  mutate(
    sex = lvls_revalue(sex, c("Fêmea", "Hermafrodita", "Macho", "Nenhum")),
    sex = lvls_reorder(sex, c(3, 1, 4, 2))
  ) %>% 
  ggplot() +
  geom_col(aes(x = sex, y = n)) 

## O que queremos é que os níveis da coluna sex sejam ordenados segundo os valores da 
## coluna n, isto é, quem tiver o maior valor de n deve ser o primeiro nível, o segundo 
## maior valor de n seja o segundo nível e assim por diante.

## Podemos melhorar esse código utilizando a função fct_reorder(). Com ela, em vez de 
## definirmos na mão a ordem dos níveis do fator, podemos ordená-lo segundo valores de 
## uma segunda variável.

starwars %>% 
  filter(!is.na(sex)) %>% 
  count(sex) %>% 
  mutate(
    sex = lvls_revalue(sex, c("Fêmea", "Hermafrodita", "Macho", "Nenhum")),
    sex = fct_reorder(sex, n)
  ) %>% 
  ggplot() +
  geom_col(aes(x = sex, y = n)) 

## É quase o que queríamos! O problema é que os níveis estão sendo ordenados de forma 
## crescente e gostaríamos de ordenar na ordem decrescente. Para isso, basta utilizarmos 
## o parâmetro .desc.

starwars %>% 
  filter(!is.na(sex)) %>% 
  count(sex) %>% 
  mutate(
    sex = lvls_revalue(sex, c("Fêmea", "Hermafrodita", "Macho", "Nenhum")),
    sex = fct_reorder(sex, n, .desc = TRUE)
  ) %>% 
  ggplot() +
  geom_col(aes(x = sex, y = n)) 

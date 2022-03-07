
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

## Se em vez de construirmos um gráfico de barras da frequência da variável sex, construíssemos 
## boxplots da altura para cada sexo diferente, teríamos o gráfico a seguir.

starwars %>% 
  filter(!is.na(sex)) %>% 
  ggplot() +
  geom_boxplot(aes(x = sex, y = height))

## Se quiséssemos ordenar cada boxplot (pela mediana, por exemplo), continuamos podendo usar 
## a função fct_reorder(). Veja que ela possui o argumento .fun, que indica qual função será 
## utilizada na variável secundária para determinar a ordem dos níveis.

## No exemplo abaixo, utilizamos .fun = median, o que significa que, para cada nível da variável 
## sex, vamos calcular a mediana da variável height e ordenaremos os níveis de sex conforme a 
## ordem dessas medianas.

## Se quiséssemos ordenar de forma decrescente, bastaria utilizar o argumento .desc = TRUE.

starwars %>% 
  filter(!is.na(sex)) %>% 
  mutate(
    sex = lvls_revalue(sex, c("Fêmea", "Hermafrodita", "Macho", "Nenhum")),
    sex = fct_reorder(sex, height, .fun = median, na.rm = TRUE)
  ) %>% 
ggplot() +
  geom_boxplot(aes(x = sex, y = height))

## Também poderíamos ordenar pelo máximo, utilizando .fun = max. Neste argumento, podemos 
## usar qualquer função sumarizadora: min(), mean(), median(), max(), sd(), var() etc.

starwars %>% 
  filter(!is.na(sex)) %>% 
  mutate(
    sex = lvls_revalue(sex, c("Fêmea", "Hermafrodita", "Macho", "Nenhum")),
    sex = fct_reorder(sex, height, .fun = max, na.rm = TRUE)
  ) %>% 
ggplot() +
  geom_boxplot(aes(x = sex, y = height))

# Colapsando níveis de um fator ------------------------------------------------------------------------------------------------------------

## Imagine que quermos fazer um gráfico de barras com a frequência de personagens por espécie.

starwars %>% 
  ggplot(aes(x = species)) +
  geom_bar()

## O gráfico resultante é horrível, pois temos muitas espécies diferentes. Uma solução 
## seria agrupar as espécies menos frequentes, criando uma nova categoria (outras, por exemplo).

## Para isso, podemos usar a função fct_lump(). Vamos fazer isso primeiro com o vetor de espécies.

fator_especies <- as.factor(starwars$species)
fator_especies

## Temos 37 espécies diferentes na base. Podemos deixar apenas as 3 mais frequentes da seguinte 
## forma:

fct_lump(fator_especies, n = 3)

## O fator resultante possui 4 níveis: Droid, Gungan, Human e Other. Os 3 primeiros níveis 
## são os mais frequentes, enquanto o nível Other foi atribuído a todos os outros 34 níveis 
## que existiam anteiormente.

## Poderíamos definir o nome do nível Others usando o argumento other_level.

fct_lump(fator_especies, n = 3, other_level = "Outras espécies")

## Também podemos transformar em Outras os níveis cuja frequência relativa é menor que um 
## determinado limite, por exemplo, 2%. No exemplo abaixo, apenas espécies que representam 
## mais de 2% dos personagem na base são mantidas. As demais foram transformadas em Outras.


library(tidyverse)
library(openxlsx)  # Para carregar arquivos xlsx

# Instale a biblioteca readxl se ainda não estiver instalada
# install.packages("readxl")

# Carregando a biblioteca
library(readxl)

# Definindo o diretório onde os arquivos XLSX estão localizados
diretorio <- "G:/Meu Drive/Projetos/Uso de cobertura de solo/CHUVA CONFIRMAÇÃO"
#diretorio <- "G:/Meu Drive/Projetos/Uso de cobertura de solo/chuva_teste"


# Listar todos os arquivos na pasta com extensão XLSX
arquivos_xlsx <- list.files(diretorio, pattern = "\\.xlsx$", full.names = TRUE)

# Lista para armazenar os dados temporários das tabelas
dados_temporarios <- list()

# Loop para ler os dados de cada arquivo XLSX e adicionar ao data frame completo
for (arquivo in arquivos_xlsx) {
  print(paste("Lendo arquivo:", arquivo))
  
  # Ler todas as tabelas do arquivo XLSX
  tabelas <- readxl::excel_sheets(arquivo)
  
  for (tabela in tabelas) {
    print(paste("Lendo tabela:", tabela))
    
    # Ler os dados da primeira linha da tabela
    primeira_linha <- readxl::read_xlsx(arquivo, sheet = tabela)
    
    # Pegar os nomes das colunas a partir da primeira linha
    data_coluna <- as.character(primeira_linha[1,1])
    data_coluna <- rep(data_coluna, times = 4)
    data_identifica <- as.data.frame(data_coluna)
    
    # Ler os dados da tabela, começando da terceira linha
    dados_tabela <- readxl::read_xlsx(arquivo, sheet = tabela, skip = 2)
    
    # Unir periodo com dados
    dados_merge <- cbind(data_identifica, dados_tabela)
    
    
    # Adicionar os dados da tabela ao data frame completo
    dados_temporarios <- bind_rows(dados_temporarios, dados_merge)
  }
}


# Criar o data frame completo a partir dos dados temporários
dados_completos_df <- as.data.frame(dados_temporarios)

View(dados_completos_df)

dados_completos_df$data_coluna <- gsub("Mês: ", "", dados_completos_df$data_coluna)

separado <- strsplit(dados_completos_df$data_coluna, "/")

# Extrair os valores de mês e ano
mes <- sapply(separado, function(x) x[1])
ano <- sapply(separado, function(x) x[2])

dados_completos_df$mes <- mes
dados_completos_df$ano <- ano

library(writexl)

nome_do_arquivo <- "dados_completos_chuva.xlsx"

write_xlsx(dados_completos_df, nome_do_arquivo)

# Reorganizar os dados usando o tidyverse
'dados_transformados <- dados %>%
  pivot_wider(
    names_from = MESES,
    values_from = c("AGRESTE PARAIBANO", "BORBOREMA", "MATA PARAIBANA", "SERTÃO PARAIBANO")
  )

# Visualizar os dados transformados
View(dados_transformados)


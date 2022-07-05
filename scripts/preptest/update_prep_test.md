# Script para atualizar dados de um simulado

## Pré requisitos
Ter um arquivo csv no S3 localizado em mesalva-uploads:uploads/csv/scripts/
O arquivo deve estar no formato da planilha que ensino utiliza para controle:
https://docs.google.com/spreadsheets/d/1uzD9-GyAM7JzQhTOMeUZMX_wcD7U8bCTl8ajL2JXYJ4/edit#gid=0
Neste caso de exemplo baixei a aba "Simulado 1" no formato csv
Para próximas vezes que rodar o script deve-se garantir que o csv esteja no mesmo formato, com pelo menos as seguintes colunas dando match:

- Coluna 3 = Número da questão na prova original
- Coluna 4 = Letra da alternativa correta
- Coluna 5 = Matéria a qual a questão faz parte
- Coluna 7 = Competência, no formato "C{numero} - Descrição..."
- Coluna 8 = Habilidade, no formato "H{numero} - Descrição..."
- Coluna 9 = Nome do capítulo do Me Salva! a qual a questão faz parte
- Coluna 10 = Url ou permalink de para onde encaminhar o estudante caso ele erre a questão


## Exemplo de uso
MeSalva::PrepTest::PrepTestUpdater.new.update_from_csv('simulados_2022-Simulado_1')

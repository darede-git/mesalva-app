# Cadastro de estudantes CPS 2021

Utilizamos uma planilha com todos os alunos do centro paula souza que aceitaram
os termos de uso, essa planilha gera um array em json com todos os dados para o script.

Para cadastrar os usuários basta rodar sequencialmente os scripts
- 01-cps_mailer.rb
- 02-cadastro_alunos_cps.rb
- 03-cps-users-direto.rb ou 03-cps-users-s3.rb


## 03-cps-users-direto.rb ou 03-cps-users-s3.rb

No caso de muitos usuários (milhares) vale a pena hospedar um arquivo online (nosso S3 de preferencia)
e mandar o script ler desse json. Quando for menos alunos pode-se simplesmente
pegar a lista da planilha e rodar o script 03-cps-users-direto.rb

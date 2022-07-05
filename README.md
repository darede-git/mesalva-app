<p align="center"><img src="https://cdn.awsli.com.br/705/705335/logo/4441f498ac.png" alt="Me Salva!" width="150" height="150"></p>
<h1 align="center"><strong>Backend API</strong></h1>
<p align="center">Projeto de back-end para as REST API das aplicações do Me Salva!</p>

------

[![Apiary Documentation](https://img.shields.io/badge/Apiary-Documented-blue.svg)](https://mesalva.docs.apiary.io/#)
[![Code Climate](https://codeclimate.com/repos/57a36d478be19112df007570/badges/c7914b3a7a9f720166f0/gpa.svg)](https://codeclimate.com/repos/57a36d478be19112df007570/feed)
[![Issue Count](https://codeclimate.com/repos/57a36d478be19112df007570/badges/c7914b3a7a9f720166f0/issue_count.svg)](https://codeclimate.com/repos/57a36d478be19112df007570/feed)
[![Test Coverage](https://codeclimate.com/repos/57a36d478be19112df007570/badges/c7914b3a7a9f720166f0/coverage.svg)](https://codeclimate.com/repos/57a36d478be19112df007570/coverage)

------

## Tabela de Conteúdos
   * [Sobre](#sobre)
   * [Instalação](#instalação)
      * [Dependências](#dependências)
        * [RVM](#rvm)
        * [Ruby](#ruby)
        * [NodeJS](#nodejs)
        * [Rails](#rails)
        * [Redis](#redis)
        * [PostgreSQL](#postgresql)
        * [ImageMagick](#imagemagick)      
        * [NPM 6.4.1](#npm)
      * [Ferramentas](#ferramentas)
        * [Apache Benchmarking Tool 2.4](#apache-benchmarking-tool)
        * [Docker](#docker)
        * [Docker Compose](#docker-compose)
      * [Instalação do Projeto](#instalação-do-projeto)
        * [Download do Projeto](#download-do-projeto)
        * [Configuração de Banco de Dados Local](#configuração-de-banco-de-dados-local)
   * [Utilização do Projeto](#utilização-do-projeto)
      * [Execução do Projeto](#execução-do-projeto)
        * [Painel Admin](#painel-admin)
        * [Servidor do Redis](#servidor-redis)
        * [Servidor Sidekiq](#servidor-sidekiq)
        * [Servidor Clockwork](#servidor-clockwork)
      * [Trabalhando com o Projeto](#trabalhando-com-o-projeto)
        * [Consumo da API](#consumo-da-api)
        * [Deploy](#deploy)
        * [Ferramentas Docker](#ferramentas-docker)
        * [Testes](#testes)
        * [Qualidade de Código](#qualidade-de-código)
        * [Testes](#testes)
        * [Depuração](#depuracao)
        * [Rusky](#rusky)
        * [Rubocop Daemon](#rubocop-daemon)       
        * [Benchmark](#benchmark)
        * [Style Guides e Docs](#style-guides-e-docs)
        * [Requisições Abusivas](#requisições-abusivas)
        * [Atualização do Token Facebook](#atualização-do-token-facebook)
        * [Code Coverage em Produção](#code-coverage-em-produção)
   * [Wikis](#wikis)
      * [Engenharia](#engenharia)

<br>

## Sobre

Projeto de back-end para as REST API das aplicações do Me Salva!

<br>

## Instalação

Explicação detalhada de todo o processo de instalação do projeto e de todas as suas dependências. Conforme está mostrado neste documento, as dependências são essenciais para o funcionamento e o desenvolvimento no projeto. É recomendado que seja seguido com exatidão todo o processo listado, pois evitará que eventuais problemas ocorram durante a instalação das dependências e do projeto.

### Dependências

Abaixo está sendo explicado todo o processo de instalação das dependências para o funcionamento e desenvolvimento no projeto.

#### RVM

O RVM é uma ferramente de linha de comando que permite instalar, gerenciar e trabalhar com multiplos ambientes Ruby, desde interpretadores até as Gems. 
Para esse projeto, ele necessário estar instalado para permitir a instalação do Ruby e para definição da versão desejada do Ruby.
A documentação oficial pode ser acessada [aqui](https://rvm.io/).

1. **Instalação do software-properties-common**
    - O software-properties-common é um pré-requisito para o PPA. Instalar caso não possua:
      ```
      sudo apt-get install software-properties-common
      ```

2. **Adição do PPA**
    - Adicionar o repositório do PPA:
      ```
      sudo apt-add-repository -y ppa:rael-gc/rvm
      ```

3. **Atualização do gerenciador de pacotes**
    - Atualizar o gerenciador de pacotes:
      ```
      sudo apt-get update
      ```

4. **Instalação do RVM**
    - Realizar a instalação do RVM:
      ```
      sudo apt-get install rvm
      ```

5. **Adição do usuário no grupo do RVM**
    - Adicionar o usuário ao grupo do RVM, substituindo o "<NOME_DE_USUARIO>" pelo nome do seu usuário:
      ```
      sudo usermod -a -G rvm <NOME_DE_USUARIO>
      ```

6. **Ativação de Login Shell**
    - Ativar opção "Run command as a login shell" no terminal:
      1. No terminal, acessar opção "Edit" -> "Profile Preferences" → "Command"
      2. Ativar a opção 'Run command as a login shell'
      3. Reiniciar o terminal

7. **Reiniciar o computador**
Devido às muitas mudanças realizadas é necessário reiniciar o computador para o RVM passar a funcionar.

8. **Habilitação de Gemsets**
    - Habilitar as Gemsets locais:
      ```
      rvm user gemsets
      ```

#### Ruby
Linguagem open-source que é utilizada para o desenvolvimento deste projeto. Será necessário instalar o Ruby na versão 2.5.1. A documentação oficial pode ser acessada [aqui](http://ruby-doc.org).

1. **Instalação do Ruby**
    - A instalação do Ruby será realizada através do RVM, previamente instalado:
      ```
      rvm install <VERSAO_DO_RUBY>
      ```

2. **Definição da versão do Ruby**
    - Definir a versão do Ruby a ser utilizada:
      ```
      rvm use <VERSAO_DO_RUBY>
      ```

#### NodeJS
O NodeJS é um ambiente de execução JavaScript para o lado servidor. Ele é uma dependência para instalação e utilização do Rails. Será necessário instalar o NodeJS na versão 10.11.0. A documentação oficial pode ser acessada [aqui](https://nodejs.org/en/).

1. **Instalação do NodeJS**
    - Realizar a instalação do NodeJS:
      ```
      sudo apt install nodejs
      ```

#### Rails

Framework multiplataforma com coleção de bibliotecas na linguagem Ruby. Será necessário instalar o Rails na versão 5.2.1. A documentação oficial pode ser acessada [aqui](http://rubyonrails.org).

1. **Instalação do Rails**
    - A instalação do Rails será realizada através da gem rails, precisando do RubyGem, previamente instalado:
      ```
      gem install rails -v <VERSAO_DO_RAILS>
      ```

#### Redis

O Redis funciona provendo armazenamento de estruturas de dados em memória, utilizado como um banco de dados em memória distribuído no formato chave-valor. Será necessário instalar o Redis na versão 4.0.11. A documentação oficial pode ser acessada [aqui](http://redis.io).

1. **Download do Redis**
    - A instalação do Redis será realizada baixando o arquivo compactado e extraindo, para então realizar a instalação. Baixar o arquivo compactado, descompactá-lo e acessar a pasta criada:
      ```
      wget http://download.redis.io/redis-stable.tar.gz
      tar xvzf redis-stable.tar.gz
      cd redis-stable
      ```

2. **Instalação do Redis**
    - Realizar a instalação do Redis:
      ```
      make
      make test
      sudo make install
      ```

#### PostgreSQL

O PostgreSQL é um gerenciador de banco de dados relacional open-source. Será necessário instalar o PostgreSQL na versão 10.5. A documentação oficial pode ser acessada [aqui](https://www.postgresql.org).

1. **Instalação do PostgreSQL**
    - Realizar a instalação do PG:
      ```
      sudo apt-get install postgresql
      ```

2. **Instalação do libpq-dev**
    - Essa é uma dependência da Gem pg e precisa ser instalada:
      ```
      sudo apt-get install libpq-dev
      ```

3. **Configuração do Usuário "postgres"**
    - É necessário editar o arquivo pg_hba.conf:
      ```
      sudo nano /etc/postgresql/<VERSAO_DO_PG>/main/pg_hba.conf
      ```
    - Localizar a linha:
      ```
      local        all postgres peer
      ```
    - Substituir a palavra "peer" por "trust":
      ```
      local        all postgres trust
      ```
    - Salvar a alteração no arquivo pg_hba.conf.
    - Reiniciar o PostreSQL:
      ```
      sudo service postgresql restart
      ```
    - Conectar no PostgreSQL utilizando o usuário "postgres", sem utilizar senha:
      ```
      psql -U postgres
      ```
    - Agora dentro do terminal do PostgreSQL, executar o comando SQL para configurar uma senha para o usuário "postgres":
      ```
      ALTER USER postgres WITH ENCRYPTED PASSWORD 'NOVA_SENHA';
      ```
    - Sair do terminal do PostgreSQL:
      ```
      exit
      ```

4. **Configuração de Super Usuário**
    - É necessário editar novamente o arquivo pg_hba.conf:
      ```
      sudo nano /etc/postgresql/<VERSAO_DO_PG>/main/pg_hba.conf
      ```
    - Localizar a linha previamente alterada:
      ```
      local        all postgres trust
      ```
    - Substituir a palavra "trust" por "md5":
      ```
      local        all postgres md5
      ```
    - Salvar a alteração no arquivo pg_hba.conf.
    - Reiniciar o PostreSQL:
      ```
      sudo service postgresql restart
      ```
    - Conectar no PostgreSQL utilizando o usuário "postgres", agora com a senha que foi configurada previamente:
      ```
      psql -U postgres -W
      ```
    - Agora dentro do terminal do PostgreSQL novamente, executar o comando SQL para criar um novo usuário no banco de dados:
      ```
      CREATE USER SEU_USUARIO WITH ENCRYPTED PASSWORD 'SUA_SENHA';
      ```
    - Importante: O nome do usuário deve ser colocado sem aspas e a senha com aspas simples.
    - Ainda dentro do terminal do PostgreSQL, executar o comando SQL para conceder ao usuário criado, privilégios de super usuário:
      ```
      ALTER USER SEU_USUARIO WITH SUPERUSER;
      ```

#### ImageMagick

O ImageMagick é uma suite de aplicações de uso livre, utilizada para edição não interativa de imagens. Será necessário instalar o ImageMagick na versão 7.0.3-9 e o ImageMagick Buildpack. A documentação oficial pode ser acessada [aqui](https://www.imagemagick.org/script/binary-releases.php) e [aqui](https://github.com/mesalva/heroku-buildpack-imagemagick).

1. **Atualização do Gerenciador de Pacotes**
    - Atualizar o gerenciador de pacotes:
        ```
        sudo apt-get update
        ```

2. **Instalação de Dependências**
    - Instalar as dependências necessárias:
        ```
        sudo apt-get install libjpeg-dev libjpeg-turbo8-dev libjpeg8-dev
        ```

3. **Download do Arquivo para Instalação**
    - Baixar o arquivo compactado para instalação:
        ```
        wget https://www.imagemagick.org/download/ImageMagick.tar.gz
        ```        
    - Descompactar o arquivo:
        ```
        tar xvzf ImageMagick.tar.gz
        ```
    - Acessar a pasta descompactada:
        ```
        cd ImageMagick-<VERSAO_BAIXADA>
        ```

4. **Instalação do ImageMagick**
    - Configurar a compilação do ImageMagick:
        ```
        ./configure
        ```
    - Compilar o ImageMagick:
        ```
        make
        ```
    - Instalar o ImageMagick:
        ```
        sudo make install 
        ```
    - Configurar o Dynamic Linker:
        ```
        sudo ldconfig /usr/local/lib
        ```

5. **Instalação do ImageMagick BuildPack**
    - Este buildpack adiciona bináros da suite ImageMagick em projetos do heroku. No Me Salva! o utilizamos nas aplicações de QA e Prod. O repositório e documentação oficial podem ser acessados [aqui](https://github.com/mesalva/imagemagick-buildpack). Para adicionar um buildpack específico a um novo projeto, basta executar o seguinte comando:
        ```
        heroku buildpacks:add --index 1 https://github.com/mesalva/imagemagick-buildpack
        ```

#### NPM 
O NPM é um gerenciador de pacotes utilizado para a linguagem JavaScript. É uma dependência específica, portanto, será necessário instalar o NPM na versão 6.4.1 em casos específicos onde ele for necessário. A documentação oficial pode ser acessada [aqui](https://www.npmjs.com/).

1. **Instalação do NPM**
    - Realizar a instalação do NPM:
        ```
        sudo apt install npm
        ```

### Ferramentas:

#### Apache Benchmarking Tool

O Apache Benchmarking Tool é a ferramenta para medição de tempos de resposta usada na API. É recomendado a instalação  do Apache Benchmarking Tool na versão 2.4 caso seja necessário. A documentação oficial pode ser acessada [aqui](https://httpd.apache.org/docs/2.4/programs/ab.html).

O procedimento de instalação carece de detalhamento nesta documentação.

#### Docker

Docker é um conjunto de produtos de plataforma como serviço que usam virtualização de nível de sistema operacional para entregar software em pacotes chamados contêineres. Os contêineres são isolados uns dos outros e agrupam seus próprios softwares, bibliotecas e arquivos de configuração. A documentação oficial pode ser acessada [aqui](http://get.docker.com).

O procedimento de instalação carece de detalhamento nesta documentação.

#### Docker Compose

O Docker Compose é uma ferramenta para definição e utilização de aplicações multi-container Docker. A documentação oficial pode ser acessada [aqui](https://docs.docker.com/compose/install/).

O procedimento de instalação carece de detalhamento nesta documentação.

### Instalação do Projeto

#### Download do Projeto
Realizar o download do projeto localmente.
```
git clone git@github.com:mesalva/backend-api.git
```

#### Configuração de Banco de Dados Local

É interessante ter um banco de dados local, para facilitar o desenvolvimento do projeto e para evitar de interferir no trabalho de outros desenvolvedores. Para isso, o projeto será configurado para se conectar em um banco de dados PostgreSQL local.

##### 1. Criação dos Arquivos de Configuração Local

Existem dois arquivo que são utilizados para a configuração do banco de dados no projeto, sendo eles: `.env` e `config/database.yml`.

O arquivo `config/database.yml` contém as definições para conexão do projeto com o banco de dados. Nele podem ser definidas as informações para conexão com os bancos de dados, como locais, desenvolvimento, teste ou produção, por exemplo.

O arquivo `.env` contém as variáveis de configuração usadas na aplicação. Isso nos permite definir variáveis pessoais para serviços localmente sem interferir no trabalho de outros desenvolvedores ou no deploy da aplicação.

Os arquivos `.env` e `config/database.yml` são ignorados nas configurações do repositório, no arquivo `.gitignore`, portanto nunca serão sobrescrito pelos arquivos locais.

- É necessário criar os arquivos `config/database.yml` e `.env`. Copiar os arquivos de exemplo para uso local a partir dos exemplos existentes no projeto:
  ```
  cp config/database.yml.sample config/database.yml
  cp .env.sample .env
  ```
##### 2. Variável ENV WEB_APP_TOKEN

A variável `WEB_APP_TOKEN` do arquivo `.env` deve estar presente com o valor mockado `webapp-token`. Os testes de integração vão falhar caso não exista essa assinatura.

##### 3. Criação do Banco de Dados Local

- Realizar a criação do banco de dados local:
  ```
  bundle exec rake db:create
  ```

##### 4. Importação do Banco de Dados de Produção para o Local
Caso necessite, pode ser realizada a importação dos dados do banco de dados de produção para o banco de dados local criado previamente.

- Importação simples dos dados:
  ```
  bundle exec rake db:production:lite
  ```
- Importação completa dos dados:
  ```
  bundle exec rake db:production:full
  ```

##### 5. Migração do Banco de Dados Local

- Realizar a migração do banco de dados local:
  ```
  bundle exec rake db:migrate
  ```

<br>

## Utilização do Projeto

### Execução do Projeto

Para executar o projeto, é necessário iniciar os seguintes serviços, em background ou em diferentes terminais:

```
bundle exec rails s
bundle exec redis-server
bundle exec sidekiq -q default
bundle exec clockwork clock.rb
```

Abaixo está detalhado o que são e para que servem os serviços iniciados acima.

#### Painel Admin

Painel de administração do projeto. 

- O painel é acessado em `localhost:3000/panel`.

- Credenciais para acesso:
  ```
  LOGIN: admin@mesalva.com
  SENHA: uV{[%[be?A7<ErJb
  ```

#### Servidor Redis

O Redis é utilizado pelo Sidekiq para fila de processamento, então é necessário que o serviço do Redis seja iniciado antes do serviço do Sidekiq.


#### Servidor Sidekiq

Sidekiq é um worker. Ele pode ser desabilitado para fins de debug, definindo a variável `WER_CONCURRENCY` do arquivo `.env` para `0`.

- O painel é acessado em `localhost:3000/admin/sidekiq`.

- Credenciais para acesso:
  ```
  LOGIN: admin@mesalva.com
  SENHA: 2WuXc7yRifoJCnJiVNueRw
  ```

#### Servidor Clockwork

Carece de informações para detalhamento do Clockwork nesta documentação.

### Trabalhando com o Projeto

#### Consumo da API

Usamos HMAC para assinatura das request, o que dificulta a execução direta de aplicações de consumo via bash, como `curl`. Para dirimir esse problema, está disponível o script ruby `curl`, que assina a requisição a ser consumida com as mesmas regras usadas na API.

Uso:

```
→ ruby bin/curl [parametros separados por espaço]
curl -X GET -H 'Origin: http://mesalva.org' -H 'Content-Type: application/json' -H 'DATE: Fri, 11 Nov 2016 18:11:58 GMT' -H 'Authorization: APIAuth WEB:X1E0yk3sPQ9sWBo54lkcolOdbus=' http://apiv2.mesalva.com/education_segments
{"data":[{"id":"2","type":"nodes","attributes":{"slug":"enem-e-vestibulares","name":"Enem e Vestibulares","image":{"url":null}}},{"id":"3","type":"nodes","attributes":{"slug":"ensino-medio","name":"Ensino Médio","image":{"url":null}}},{"id":"4","type":"nodes","attributes":{"slug":"concursos","name":"Concursos","image":{"url":null}}},{"id":"5","type":"nodes","attributes":{"slug":"ciencias-da-saude","name":"Ciências da Saúde","image":{"url":null}}},{"id":"6","type":"nodes","attributes":{"slug":"engenharia","name":"Engenharia","image":{"url":null}}},{"id":"7","type":"nodes","attributes":{"slug":"negocios","name":"Negócios","image":{"url":null}}}]}
```

O script apresentará o comando e o executará, mostrando o resultado no console.

Parâmetros:

```
Ordem Nome           Default
1     method         GET
2     path           /education_segments
3     data           ''
4     uid            ''
5     access-token   ''
6     allowed        GET - Usado somente em requisições OPTIONS
```

Formato de data:

```
'{ "package_id": 1, "checkout_method": "bank_slip", "broker": "iugu", "installments": 1, "email": "email@teste.com", "cpf": "029.000.156-55", "nationality": "Brasileiro", "address_attributes": { "street": "Rua Padre Chagas", "street_number": 79, "street_detail": "302", "neighborhood": "Moinhos de Vento", "city": "Porto Alegre", "zip_code": "91920-000", "state": "RS", "country": "Brasil", "area_code": "11", "phone_number": "123123123"}}'
```

#### Deploy

Instale o client do heroku:
`sudo apt-get install -y heroku-toolbelt` no linux ou `brew install heroku-toolbelt`
no mac. Em seguida instale o pacote de uso `gem install heroku`.

Adicione as origens necessárias ao git para os processos de deploy:

```
git remote add mesalva-api https://git.heroku.com/mesalva-api.git
git remote add mesalva-backend-api-qa  https://git.heroku.com/mesalva-backend-api-qa.git
git remote add mesalva-backend-develop  https://git.heroku.com/mesalva-backend-develop.git
```

Ao rodar a listagem de urls do git, o resultado deve ser:

```
mesalva-api     https://git.heroku.com/mesalva-api.git (fetch)
mesalva-api     https://git.heroku.com/mesalva-api.git (push)
mesalva-backend-api-qa  https://git.heroku.com/mesalva-backend-api-qa.git (fetch)
mesalva-backend-api-qa  https://git.heroku.com/mesalva-backend-api-qa.git (push)
mesalva-backend-develop	https://git.heroku.com/mesalva-backend-develop.git (fetch)
mesalva-backend-develop	https://git.heroku.com/mesalva-backend-develop.git (push)
origin  git@github.com:mesalva/backend-api.git (fetch)
origin  git@github.com:mesalva/backend-api.git (push)
```

Rode o comando `heroku login` para começar a usar.

O ambiente de _staging_ será utilizado para testes de novas funcionalidades e sua
integração com o consumers da API (front, iOS e Android).

Use a rake task `bundle exec rake deploy:staging` no branch atual para mandar
seu trabalho para o ambiente. Caso precise enviar o código de outro branch, use
a ENV VAR `BRANCH` para indicar o branch que vai ser testado.
Outras rake tasks disponíveis, com nomes auto-explicativos:
`bundle exec rake deploy:production`
`bundle exec rake deploy:last_staging_release`
`bundle exec rake deploy:last_production_release`
`bundle exec rake deploy:staging_releases`
`bundle exec rake deploy:production_releases`
`bundle exec rake deploy:rollback:staging`
`bundle exec rake deploy:rollback:production`

#### Observações

- Antes de rodar a task de deploy no ambiente de `QA`, verifique com a equipe se há algum teste em andamento.
- Antes de rodar deploy no ambiente de produção, verifique o checklist nos Pull Requests que estão sendo publicados, se houver, ficando atento a fazer o deploy de novos serviços e addons antes de rodar o comando. Atenção
  também a existência e valores de variáveis de ambiente.
- Durante o deploy de produção, visualizar o log para garantir que as migrações foram rodadas.

Deploys para a produção só podem ser feitos após o merge do pull request
no master e a build passar no server de [Continuous Integration](https://semaphoreci.com/jadercorrea/backend-api).

#### Ferramentas Docker

Estão disponíveis imagens docker com a aplicação de backend para uso em
testes locais e execução dos testes de integração (detalhes na seção de testes abaixo).

Os containers utilizados estão descritos no `Dockerfile`, e a configuração de
ambiente está descrita no arquivo `docker-compose.yml`,
ambos presentes na raiz do projeto.
Os containers base estão hospedados no DockerHub (mesalva/backend-api).

Para rodar o container de backend, rode:

```
docker-compose up rails
```

Este comando irá inicializar 1 Postgres, 1 Redis, 1 Elasticsearch e a Aplicação.
O comando `docker-compose down` serve para desligar os containers, após a conclusão dos processos.

A aplicação ficará disponível no endpoint `localhost:3000`.

Para encerrar o processo, rode:

```
docker-compose down
```

##### Atualização dos Containers

Para atualizar o container presente no DockerHub (usado no servidor de CI):

- Criar uma conta no [DockerHub](https://hub.docker.com), e ser adicionado a organização 'mesalva'
- Instalar Docker
- No terminal, executar `docker login`, inserindo as credenciais do DockerHub
- Fazer as alterações necessárias no `Dockerfile` e realizar o **build** do container: `docker build -t mesalva/backend-api .`
- Enviar o novo container para o DockerHub `docker push mesalva/backend-api`
- A parte, caso sua imagem já exista localmente (build ou run já executado), é possível baixar a última versão da imagem com `docker pull mesalva/backend-api`

##### Solução de Problemas

ERROR: for <container> Cannot start service <container>
As vezes o docker-compose falha ao iniciar um container e deixa a porta ocupada
com o processo, use o seguinte comando para listar as portas abertas:

```
lsof -nP +c 15 | grep LISTEN

com.docker.slir 74440 jadercorrea   22u     IPv4 0x964888b3af5613a7         0t0     TCP :3000 (LISTEN)
com.docker.slir 74440 jadercorrea   23u     IPv6 0x964888b398850317         0t0     TCP [::1]:3000 (LISTEN)
```

Caso encontre este problema, rode `pkill com.docker.slirp` para liberar as portas.

Atenção:
A aplicação rails com Docker não irá rodar caso os arquivos de configuração
.env e config/database.yml estejam ausentes.

#### Testes

Usamos [RSpec](https://github.com/rspec/rspec-rails) para testes unitários e
[dredd](https://www.npmjs.com/package/dredd) para testes de integração da API.
Os testes de integração são rodados usando o shell script `bin/integration`,
que compila o blueprint da API a cada vez que é rodado em dois arquivos:
`blueprint/README.md` e `apiary.apib`.

Instalação dos pacotes do dredd:
`sudo apt-get install nodejs` ou `brew install nodejs` e em seguida:

```
npm install -g dredd
npm install -g aglio
npm install moment --save

** O pacote `crypto` já é incluído no NodeJS.
```

Ao terminar sua implementação, inclua ou atualize seu endpoint no [apiary](https://app.apiary.io/mesalva/editor)
dando push para o master no botão do apiary editor, para em seguida rodar os
seguintes comandos, garantindo o funcionamento do seu endpoint:

```
git pull
git checkout SEU_BRANCH
git rebase master
bundle exec rspec
sh bin/integration
```

#### Testes de Integração com Docker

Também é possível executar a rotina de testes de integração via um container Docker,
isolando o ambiente e tornando desnecessária a instalação de dependências no host.

Para executar a rotina de testes, a partir da raiz do projeto:

```
docker-compose up integration; docker-compose down
```

#### Qualidade de Código

Usamos [CodeClimate](https://www.codeclimate.com) para monitoramento e feedback
sobre a qualidade de nosso código. A cada commmit, nosso processo de build gera
um relatório que pode ser visualizado no próprio Github. Também é possível
executar as verificações de modo local, através dos seguintes passos:

Dependências:

- Docker
- Container CodeClimate CLI (codeclimate/codeclimate)
- Permissão o+rwx nos arquivos do projeto

Setup (no caso de ambiente linux):
`./bin/codeclimate setup`

Gerar report de qualidade:
`./bin/codeclimate`

Este processo leva em consideração as configurações presentes em `.codeclimate.yml`,
além de ser executado dentro de um container (isolado do restante do sistema).

#### Depuração (Debug)

É possível utilizar a `IDE Visual Studio Code` para realizar a depuração no projeto, utilizando as funcionalidades de gerenciar o projeto, de marcar breakpoints no código e de poder ir avançando conforme o necessário no processo de depuração. Para habilitar essa função basta seguir o processo abaixo:


1. **Instalação da extensão do Ruby**
    - Realizar a instalação [dessa extensão do Ruby](https://marketplace.visualstudio.com/items?itemName=rebornix.Ruby) na IDE Visual Studio Code.

2. **Passar a trabalhar localmente no modo de thread única**
    - Alterar a variável de ambiente `RAILS_MAX_THREADS` conforme abaixo:
        ```
        RAILS_MAX_THREADS=1
        ```
    - Alterar a variável de ambiente `WEB_CONCURRENCY` conforme abaixo:
        ```
        WEB_CONCURRENCY=0
        ```
    - Alterar a configuração de pool da conexão com o banco de dados para uma quantidade mínima aceitável para o projeto. O recomendado é que se defina conforme abaixo:
        ```
        pool: 10
        ```

Com essas configurações, já será possível depurar o projeto utilizando a `IDE Visual Studio Code`.

#### Rusky

Para habilitar as funcionalidades de Git Hooks do Rusky, como rodar o Rubocop antes de fazer o commit, por exemplo, é necessário inicializar o rusky com `rusky install`
Para desabilitar o rusky, use: `rusky uninstall`

#### Rubocop Daemon

É altamente sugerido que você rode o rubocop em forma de daemon através do `rubocop-daemon` para ter um ganho significativo para rodar o formatador. Para instalar siga as instruções no [repositório oficial](https://github.com/fohte/rubocop-daemon).

#### Benchmark

Apache benchmarking tool é a ferramenta para medição de tempos de resposta usada
na API. Para rodar o benchmark basta rodar o comando `sh bin/integration`, que
dispara um ambiente local na porta `3001` caso não haja um rodando. Para testar
as respostas do ambiente de QA, adicione o parametro: `sh bin/integration qa`

#### Style Guides e Docs

Use nomes que deem significado, tanto em seu branch quanto na nomenclatura de
classes, métodos, entidades e variáveis.

Links de referencia:

[Git style guide](https://github.com/agis-/git-style-guide)

[Ruby style guide](https://github.com/bbatsov/ruby-style-guide)

[API Blueprint](https://github.com/apiaryio/api-blueprint)

#### Requisições Abusivas

A implementação oferece ferramentas para evitar abusos de consumo usando Rack middleware
para bloqueio e limitação de requisições, que são habilitadas usando a variável `FEATURE_FLAG_RACK_ATTACK=true`

Esta funcionalidade, só deve ser usada em casos de ataques de DDOS ou mal uso,
casos em que podemos bloquear o IP de origem usando `IP_BLACKLIST` ou limitar a quantidade
de requisições oriundas do mesmo IP com `REQUEST_RATE_LIMIT` e deverá ser desabilitada
ou configurada de forma a não impactar usuarios normais durante o uso.

Valores válidos para as ENV VARS:

```
FEATURE_FLAG_RACK_ATTACK=true
IP_BLACKLIST = 1.2.3.4
REQUEST_RATE_LIMIT = 600
```

#### Atualização do Token Facebook

Um dos nossos testes de integração usa um token válido do facebook para teste de login. Este token expira a cada 5184000 segundos, sendo necessário uma renovação.
Para renovar, gere um [novo token de acesso de curto prazo](https://developers.facebook.com/apps/130050807168932/roles/test-users/).
Em seguida, usando o token recebido, atualize-o para um token de longo prazo, executando uma requisição GET para o endereço

```
https://graph.facebook.com/oauth/access_token?
        grant_type=fb_exchange_token&
        client_id={app-id}&
        client_secret={app-secret}&
        fb_exchange_token={short-lived-token}
```

Todos estes dados são encontrados no [painel do facebook developers](https://developers.facebook.com/apps/130050807168932/dashboard/)

#### Code Coverage em Produção

Para aferir quanto do código de produção está efetivamente sendo usado, usamos o [Coverband](https://github.com/danmayer/coverband).
Por padrão ele está desativado e pode ser ligado com os seguintes comandos no console de produção:

```
Coverband.configure
Coverband.start
```

A rota pra acessar o dashboard é

```
https://mesalva-api.herokuapp.com/admin/prod_coverage
```

E a senha (sem usuário é): `d400937f7f49707b35c331e11fa99bb8213950e6d5f094f329c0f7d318dffc51`

<br>

## Wikis

### Engenharia
- [Engenharia](https://github.com/mesalva/engenharia)

## Problemas reconhecidos

### Minemagic

```bash
Could not find MIME type database in the following locations: ["/usr/local/share/mime/packages/freedesktop.org.xml", "/opt/homebrew/share/mime/packages/freedesktop.org.xml", "/opt/local/share/mime/packages/freedesktop.org.xml", "/usr/share/mime/packages/freedesktop.org.xml"]
```

Para resolver esse problema você precisa criar uma variável de ambiente global `FREEDESKTOP_MIME_TYPES_PATH` com valor do caminho absoluto para o arquivo `freedesktop.org.xml` presente na raíz do projeto.

[Fórum com a resolução do problema](https://stackoverflow.com/questions/69248078/mimemagic-install-error-could-not-find-mime-type-database-in-the-following-loc)


### libxml2
Caso esse problema ocorra, rode esses comandos abaixo para instalar as libs:

```bash
sudo apt-get install libxml2-dev
```

```bash
sudo apt-get install libcurl4-openssl-dev
```

```bash
sudo apt-get install libpq-dev
```

[Fórum com a resolução do problema](https://stackoverflow.com/questions/49674564/package-configuration-for-libxml2-is-not-found)

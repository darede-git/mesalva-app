# Implementação do Novo Processo de Autenticação por Roles

   * [Motivação](#motivação)
   * [Funcionamento](#funcionamento)
        * [Modelo de Dados](#modelo-de-dados)
        * [Detalhamento da Nova Forma de Autenticação](#detalhamento-da-nova-forma-de-autenticação)
            * [Models](#models)
            * [Controllers](#controllers)
            * [Tests](#tests)
    * [Como Usar](#como-usar)
        * [Como Implementar em um Controller](#como-implementar-em-um-controller)
            * [Adaptação do Controller](#adaptação-do-controller)
            * [Adaptação do Teste do Controller](#adaptação-do-teste-do-controller)

## Motivação

Esse projeto foi necessário para repensar e reconstruir a maneira como são realizadas as autenticações dos usuários nos acessos aos endpoints das aplicações do Me Salva!. Originalmente, a autenticação era realizada através dos métodos `authenticate` e `authenticate_permalink_access` do `security.rb`, onde era considerado o parâmetro informado, que deveria ser um array informando quais os acessos seriam permitidos para determinados actions do controller. Essa implementação não permitia que um usuário possuísse várias roles, que ele possuísse roles dentro de uma plataforma específica, e nem que uma role possuísse várias authorizations.
Devido a isso, foi necessário realizar este projeto para repensar e reconstruir a maneira como são controladas e realizadas as autorizações de acessos.

## Funcionamento

A partir do novo processo de autenticação por roles que foi desenvolvido, passou a se cadastrar na tabela `permissions` as permissões aos endpoints individualmente. O acesso a um endpoint a um determinado usuário se dará a partir da localização de um registro de uma role para determinada permissão e também pela localização do acesso a uma plataforma.

### Modelo de Dados

A nova forma de autenticação foi desenvolvida a partir do modelo de dados abaixo:

![your-UML-diagram-name](http://www.plantuml.com/plantuml/png/ZP31QiCm44Jl-eejkSHGf_TWJ6X_eNUZM9j6HBBCIeA4qd-lufYkxIYXFednxhoPtVaWAKHhn8l2W-uGWjmRN9yBQ8tq7ivGLR3-V5qTXg-0kluRxKbRIPVcX9VhGXNhS_KMQt7K2i5YE3hbXV0dtVMIf1qTlmN0koE5zE6C8zWRsPwI9dw4kC5x9AkzrwxpnJ0-1MbL9ALrNI1d35BJIOj9aMr82-cnsMnoLaqQnuT-rv-DLkarsT2AxLZsswrMKCB2EicpLLZTYer1djB72WCAcCNEOxn47OKx_-YH_bjncELNRsGuEBAplimfOpdCpRBa-EpqC0EJiz0fPXaDIbFEy-REy3m1dzgR-CNSfUqIcoToyJnjxZyUKvLmrv8zTzYfQCql)

### Detalhamento da Nova Forma de Autenticação

Para permitir essa nova abordagem em relação ao controle de acesso, foi realizado o seguinte desenvolvimento:

#### Models

##### models/permission.rb

Foi criado o modelo de `permission`, onde:
- Os campos `context` e `action` foram definidos como obrigatórios;
- Ambos os campos, `context` e `action`, fazem parte de uma chave composta, onde os dois devem ser únicos em conjunto. Isso é necessário para que permissões duplicadas para um mesmo endpoint não sejam cadastradas;
- Foi criado o método `validate_user`, que recebe como parâmetros o nome do controller e da action onde está sendo requisitado o acesso, o ID do usuário que está requisitando e o platform slug do usuário em questão, caso o ele possua. A partir disso, o método verifica se existe um platform slug, onde: 
    - Caso ele não exista: é verificado se existe uma role com a permissão desejado para este usuário;
    - Caso ele exista: é verificado se existe uma role ou um acesso de plataforma com a permissão desejado para este usuário;

##### models/permission_role.rb

Foi criado o modelo de `permission_role`, para que sirva como intermediario para o relacionamento 'muitos para muitos' entre `permission` e `role`.

##### models/role.rb

Foi criado o modelo de `role` para cadastrar as roles que se relacionaram com os usuários e suas permissões.

##### models/user_role.rb

Foi criado o modelo de `user_role`, para que sirva como intermediario para o relacionamento 'muitos para muitos' entre `role` e `user`, e para relacionamento 'um para muitos' entre `user_platform` e `user`.

##### models/user.rb

Foi adaptado o modelo de `users` para criar o relacionamento entre `user` e `user_role`.

##### models/user_platforms.rb

Foi adaptado o modelo de `user_platform` para criar o relacionamento entre `user_platform` e `user_role`.

#### Controllers

##### controllers/concern/security.rb

Foi criado o método `authenticate_permission` no arquivo `security.rb`. Esse método realiza a chamada do método `validate_user` criado no modelo de `permission` para verificar se o usuário possui permissão para acessar o endpoint informado em seus parâmetros, onde:
- Caso não encontre a permissão, retorne um `render_unauthorized`;
- Caso encontre a permissão, retorne o registro encontrado pelas consultas do método `validate_user` do modelo de `permission` com a permissão.

#### Tests

Foram desenvolvidos os testes unitários para todos os modelos criados, além dos testes para o método `validate_user` do modelo de `permission`.
Todo arquivo de teste de um controller precisa ser adaptado para passar a funcionar com a nova forma de autenticação. O processo de adaptação está detalhado [aqui](#adaptação-dos-testes) dentro da seção `Como Implementar em um Novo Controller` desta documentação.

##### Factories

Foram criadas as seguintes factories para criação de dados para a realização dos testes unitários: 
- `permission_roles` no arquivo `permission_roles.rb`
- `permissions` no arquivo `permissions.rb`
- `roles` no arquivo `roles.rb`
- `user_roles` no arquivo `user_roles.rb`

##### Helpers

Foi criado o helper `permission_helper` no arquivo `permission_helper.rb`, para ser chamado nos testes nos arquivos `spec`, para tratar e inserir os dados para realização dos testes.

##### Spec

Foram desenvolvidos os testes unitários para todos os modelos criados, sendo eles 
- `models/permission_role_spec.rb`
- `models/permission_spec.rb`
- `models/role_spec.rb`
- `models/user_role_spec.rb`

## Como Usar

### Como Implementar em um Controller

Para implementar o novo processo de autenticação nos endpoints do projeto de API é necessário seguir dois passos, sendo eles:

#### Adaptação do Controller

É necessário adaptar o controller que irá receber o novo processo de autenticação realizando o seguinte:

1. No `before_action` que o controller possui a chamada para a autenticação antiga, podendo ser na chamada do método `authenticate` ou do método `authenticate_permalink_access`, substituir pela chamada do novo método, conforme exemplo abaixo:

    - Mudar de:
        ```
        before_action -> { authenticate_permalink_access(%w[user]) }
        ```
        ou
        ```
        before_action -> { authenticate(%w[user]) }
        ```

    - Para:
        ```
        before_action -> { authenticate_permission }
        ```

Realizando apenas essa mudança no `before action`, o controller em questão não irá mais realizar a autenticação pelo processo antigo e passará a utilizar este novo processo. É importante ressaltar que como o método `authenticate_permission` captura as informações do endpoint e usuário através das variáveis de seção, pela hash `params` e pelo `current_user`, nenhum parâmetro é necessário na chamada deste método.

#### Adaptação do Teste do Controller

É necessário realizar a adaptação dos testes unitários do controller onde o novo processo de autenticação foi implantado, pois é necessária a criação dos registros nas tabelas previamente explicadas neste documento, através das factories já citadas. Com isso, quando os testes dos controllers já alterados para o novo processo de autenticação forem executados, tudo será autenticado e funcionará conforme o esperado.
Para adaptar o teste de um controller, realizar o seguinte:

1. **Inclusão do helper**
    Realizar a inclusão do helper `PermissionHelper` do arquivo `permission_helper.rb`:
    ```
    include PermissionHelper
    ```

2. **Adaptação do Describe**
    É necessário que o antepenúltimo `describe/context` antes da execução do comando `it 'xxxxx' do` seja definido com o símbolo `#` seguido pelo nome da action que será testada. Por exemplo:
    - Definir o antepenúltimo `describe/context` conforme o exemplo abaixo:
        ```
        describe '#NOME_DO_ACTION' do
        ```
    - No caso do teste no exemplo abaixo, ficaria assim, com o describe exemplificado na primeira:
        ```
        ...
        describe '#NOME_DO_ACTION' do
            context 'texto de exemplo 1' do
            context 'texto de exemplo 2' do
                it 'texto de exemplo 3' do
                expect do
            end
        end
        ...    
    ```

3. **Chamada do Método do Helper**
    Realizar a chamada do método `create_permission` do helper `PermissionHelper` previamente incluido no arquivo, informando como parâmetros o `self` e o usuário que será relacionado à permissão do teste obrigatoriamente, e o `user_platform` opcionalmente em testes em que ele se aplica. Em casos onde o `user_platform` se aplica, é interessante informar o usuário através do `user_platform.user` para garantir que seja vinculado o usuário correto. A chamada deverá ser como o exemplo abaixo:
    - Para casos onde o `user_platform` se aplica:
        ```
        before { create_permission(self, user_platform.user, user_platform) }
        ```
    - Para casos onde o `user_platform` não se aplica:
        ```
        before { create_permission(self, user) }
        ```
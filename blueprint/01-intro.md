FORMAT: 1A
HOST: https://apiv2.mesalva.com

# Me Salva! API

Me Salva! API é uma api de acesso ao conteúdo do site https://mesalva.com com
o intuito de buscar todas as informações referentes a banco de dados e regras de negócio.

## Requisição

A API do Me Salva! segue o padrão REST, onde o webservice armazena e provê acesso
aos dados através de requisições HTTP.

Cada uma das URIs (também chamadas endpoints) identifica um recurso disponível no webservice.
Requisições HTTP ```POST, GET, PUT, DELETE``` permitem à aplicação cliente, criar, acessar,
alterar e remover um recurso respectivamente.

### Requisições permitidas

`POST`: Criar um recurso

`GET`: Obter informações de uma lista de recursos ou um recurso específico. Esses métodos
são indepotentes, o que significa que são usados apenas para fornecer informações, sem
modificar estado nos recursos.

`PUT`: Atualizar um recurso

`DELETE`: Deletar ou desabilitar um recurso

## Resposta

A API retorna uma resposta com corpo no padrão [JSON API](http://jsonapi.org),
exceção feita para respostas de consumo de APIs de terceiros, que seguem o
padrão original do serviço. Os seguintes status HTTP são retornados por padrão:

* 200 OK - A requisição foi realizada corretamente.
* 201 Created - A requisição foi realizada corretamente e o recurso criado.
* 204 No Content - A requisição foi realizada corretamente e não há nada a ser retornado.
* 400 Bad Request - A sintaxe da requisição está mal formulada ou está faltando parâmetros
requeridos na requisição.
* 401 Unauthorized - A autenticação falhou ou o usuário não possui as devidas permissões
para a requisição requisitada.
* 403 Forbidden - Acesso negado.
* 404 Not Found - O recurso requisitado não foi encontrado.
* 500 Internal Server Error - O servidor encontrou uma condição inesperada que o impediu
de satisfazer a requisição.

## Autenticação
A API foi desenvolvida utilizando o protocolo [OAuth 2.0](https://tools.ietf.org/html/rfc6749)
no formato [RFC 6750 Bearer Token](https://tools.ietf.org/html/rfc6750) para autenticação, usando
`bearer tokens` nas requisições HTTP para validar acesso a recursos protegidos
e retornando outro bearer token no cabeçalho da resposta para uso na próxima requisição.

## Caching
Os headers `Cache-Control` e `ETag` são disponibilizados para controle de cache
a nível de frontend e browser. Para rotas cacheadas, `Cache-Control` retorna
`private` ou `public`, com um valor de `max-age=3600` e `ETag` retorna um hash
MD5 do conteúdo. Já as rotas não cacheadas, retornam sempre `Cache-Control:no-cache, private`.

Rotas cacheadas não retornam tokens de autenticação.

Rotas cacheadas:
* [Segmentos de ensino](http://docs.mesalva.apiary.io/#reference/segmentos-de-ensino)
* [Objetivos](http://docs.mesalva.apiary.io/#reference/objetivos)
* [Níveis de ensino](http://docs.mesalva.apiary.io/#reference/niveis-de-ensino)
* [Navegação](http://docs.mesalva.apiary.io/#reference/navegacao)
* [Contadores](http://docs.mesalva.apiary.io/#reference/contadores)

## Codificação
Use a codificação UTF-8 ao enviar argumentos para os métodos da API.

## Redação
Respeite o fluxo dos estados de uma redação:

- awaiting_correction
    - correcting
    - cancelled
- correcting
    - awaiting_correction
    - corrected
    - uncorrectable
- corrected
    - awaiting_correction
    -  correcting
    -  delivered

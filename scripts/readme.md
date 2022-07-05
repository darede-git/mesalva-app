# __ATENÇÃO__

### Os scripts aqui podem estar desatualizados, antes de rodar cegamente , antente-se em sua data de modificação e a possibilidade de algo ter sido refatorado.

### Utilizou e modificou para funfar?
![](./pr.jpg)

https://docs.github.com/pt/github/collaborating-with-issues-and-pull-requests/creating-a-pull-request


## O que é esta pasta?

..Esta pasta tem o intuito de armazenar scripts que comumente nós devs acabamos criando para rodar uma tarefa que ainda não foi implementado no sistema, ou que não necessáriamente seria implementado , como a mudança manual de um valor em tabela.

## Padrão

Ainda esta em aberto qual deve ser o melhor padrão, leve isso em consideração e proponha sempre que achar válido. Neste tópico então temos:

* Atual:
    * Havendo 2+ scripts sobre uma mesma entidade:
        * Criar uma pasta com o nome da entidade.
    * Nomeclatura de arquivo:
        * Prefix da função + _ + entidade principal + _ + complementos.
    * Comentarios:
        * Quando trabalhamos dados estruturados por exemplo arrays multidimensionais adicionar comentario abaixo explicando a origem do dado ou o nome do campo, algo como:
            ```rb
                # base_mudar => [[ID_node_module, relevancy_novo, position_novo]]
            ```
    * Nomeclatura de funções/variaveis:
        * Ao criar métodos ou variaveis , considere sempre que o amiguinho não necessariamente conhece este processo ou o que passava pela sua cabeça quando criou, __NUNCA__ use numeros mágicos ou letras sortidas como o famos xtpo = xyz.


## Adicionando novos scripts

Nunca suba um novo script dentro de um pr com outras modificações, ou seja, abra uma branch a parte apenas com sua proposição de novo script.

Atente-se ao padrão em vigência ou proponha modificações durante o pr com o novo script, importante deixar essa proposição clara, por favor não tente subir algo fora do padrão sem levantar a discussão, o intuito aqui é sempre melhorar o conceito desta pasta e sua usabilidade. 
# MACACO INFINITO
---
title: "Macaco Infinito"
author: "Filipe Sacchet Kaizer"
date: "Sep 19, 2023"
---

## Descrição:
O teorema do macaco infinito foi originalmente desenvolvido em 1913 pelo matemático Émile Borel. O teorema em questão diz que se um macaco fosse colocado para digitar em um teclado infinitamente, em algum dado momento o mesmo acabaria escrevendo um texto previamente definido, como alguma obra de Shakespeare. 

Apesar da ideia de um macaco escritor ser pouco palpável, há a possibilidade de executar esse mesmo exercicio usando computadores e processos de geração de números/carcteres de forma randomica.  

O presente projeto consiste em um algoritmo em Haskell, que recebe um texto previamente estipulado pelo usuário de tamanho limitado a 5 carcteres (com sequência formada apenas por char) e que deverá obter
a mesma sequencia usando a biblioteca random presente no Haskell. 


## Escopo geral do codigo:
O presete codigo foi separado em duas funções principais em haskell: **Main** e **MacacoInfinito**. 

A funcao **Main** é responsável apenas para pelas boas-vindas ao programa e demonstra apenas um exemplo de funcionamento para quem ainda não leu o README.md. 

A função **MacacoInfinito** possuí todo o código principal do programa e é o ponto de partida do programa. 

Inicialmente, o código foi planejado ainda com o pensamento de um código estruturado. Pelos meus costumes, o início de um programa como esse deveria ser marcado por uma entrada e armazenamento em uma variável (palavra, por exemplo), seguida pela chamada de uma função composta por um laço de repetição que iria obter constantemente valores até que a sequência previamente informada pelo usuário fosse alcançada. O primeiro ponto negativo dessa abordagem é que a linguagem Haskell não possuí laços de repetição nativos na linguagem como for, while ou foreach. A única forma de realizar essa tarefa é usando funções recursivas, como visto no código abaixo [5]:

~~~Haskell
   maximum :: (Ord a) => [a] -> a  
maximum [] = error "maximum of empty list"  
maximum [x] = x  
maximum (x:xs)   
    | x > maxTail = x  
    | otherwise = maxTail  
    where maxTail = maximum xs  
~~~

### ___recursivo___:
Em vista disso, na função principal **MacacoInfinito** foi criada uma função recusiva chamada __recursivo__. A função recursivo atua como um laço while, recebendo a palavra informada pelo usuário ("ola", por exemplo), um número responsável pela contagem de tentativas e uma flag booleana responsável pela verificação. Assim como um laço while, é importante que haja uma condição de parada do laço. A condição de parada é feita com a verificação da flag booleana, sendo verificada a cada chamada recursiva. Abaixo é visto o codigo:

~~~Haskell
recursivo :: String -> Int -> Bool -> IO Int
recursivo _ tentativa True = return tentativa
recursivo texto tentativa sucesso = do
  let len = length texto
  sorteado <- gerarString len
  putStrLn sorteador
  if comparar sorteado texto 
    then
      recursivo texto tentativa True
    else 
      recursivo texto (tentativa + 1) False
~~~

Na primeira linha é definito a estrutura dessa função, sendo usados três variáveis de entrada (String, Int e Bool) e uma de saida (IO Int). Inicialmente foi definito um tipo de saída Int, mas percebi um problema nisso. Acontece que a saída da função recursivo é usada globalmente pela função principal **macacoInfinito**. Potanto, para que essa saída seja vista pelo programa de forma global, é importante adicionar o **IO**. 

Após isso, é adicionada a condição de parada da recursão, vista na segunda linha. Para que a recurão pare, a flag booleana deve ser True (verdadeira), indicando que a sequência obtida de forma randômica seja igual ao informado pelo usuário. Se essa condição for verdadeira, o programa deve parar a recursão e retornar o número mero de tentativas.  

Mais abaixo há um processo de chamada da função responsável pela geração da String com o tamanho igual a palavra informada pelo usuário e uma verificação usando outra função de comparação de strings. Caso sejam iguais, será realizada uma recursão com a flag de controle True e a tentativa corrente sem adição. Caso contrário, será feira uma recursão com a flag False, indicando a continuação do laço.


### ___gerarString___: 
Como visto na função anterior, é necessária uma função responsável pela geração de Strings de forma randômica. Existem muitas formas de geração randomica usando a biblioteca Random do Haskell, mas a mais interessante encontrada na documentação System-Random do Haskell foi o ___randomRs___. O randomRs consegue gerar grandes sequências de valores aleatórios com uma range de caracteres e números informadas em codigo. Abaixo há um exemplo de execução em Haskell disponível na documentação [2]:

~~~Haskell
>>> let gen = mkStdGen 2021
>>> fst $ randomR ('a', 'z') gen
't'
>>> fst $ randomR ('z', 'a') gen
't'
~~~

Assim como exemplos feitos em aula com o comando take, é possível obter uma sequência de caracteres com tamanho definido pelo usuário, como visto no exemplo abaixo obtido do School of Haskell [3]:

~~~Haskell
import System.Random

main = do
  g <- getStdGen
  print $ take 10 (randomRs ('a', 'z') g)
~~~

Conforme a própria documentação, se executarmos o codigo acima obteremos a mesma sequência todas as vezes. Isso acontece porque o mesmo é carregado uma única vez. Para isso, é importante usar o newStdGen. Como visto na linha abaixo, o mesmo obterá 10 caracteres gerados da sequência. 

Com isso, o código usado nesse projeto é bem similar, com a única diferença de que os valres obtidos com o take são recebidos por paramentro na função e é retornado um IO String. Como a função anterior, ele precisa ser do tipo IO para que a sua saída deja usada de forma global por outras funções. O código final é visto abaixo:

~~~Haskell
gerarString :: Int -> IO String
gerarString tamanho = do
gen <- newStdGen
return $ take tamanho $ randomRs ('a', 'z') gen 
~~~

Outro ponto que é muito importante de ressaltar é o uso da biblioteca System.Random. No início do projeto foi muito difícil adicionar essa biblioteca devido a forma como o replit funciona. Após analisar os códigos disponibilizados pela professora (**extra-haskell-story**) compreendi que era necessário adicionar uma referência para essa função no arquivo de configuração **replit.nix**. Para isso, apenas copiei o conteúdo do arquivo do projeto apresentado pela professora, como visto abaixo:

~~~nix
{ pkgs }: {
    deps = [
        (pkgs.haskellPackages.ghcWithPackages (pkgs: with pkgs; [
           scotty wai-extra  random random-shuffle

        ]))       
        pkgs.haskellPackages.ghc
        pkgs.haskell-language-server
    ];
}
~~~

### ___comparar___: 
essa função que tambem é essencial para o funcionamento da função recursiva, na verdade não precisava existir na forma de uma função. Ela se trata de uma condicional única que compara duas strings. Se tratando de um if, era possível executar esse processo dentro do próprio recursão, mas considerei mais adequado (e mais bonito) separar ela em uma função própria. O seu código pode ser visto abaixo:

~~~Haskell
comparar :: String -> String -> Bool
comparar textA textB = textA == textB
~~~

Assim como as demais funções, o mesmo recebe duas Strings e retorna um booleano (True ou False) resultado da comparação das duas Strings. No início essa verificação era feita usando if-then-else, mas foi possível simplifica-la. Diferente de muitas outras funções, não é necessário o IO antes do Bool. Isso acontece pois o código é mais simples e não possuí o "do" antes de todo o codigo. Possivelmente seria necessário se houvessem outras verificações como o textA possuir carcteres especiais ou números.


### ___macacoInfinito___: 
Essa é a principal função do código, responsável pela chamada da recursão e recebimento e verificação da palavra informada pelo usuário.
  
Como dito no início do projeto, há muitas dificuldades para tornar esse teorema praticável. Além da dificuldade de arranjar um macaco com logevidade suficiente para os testes, há a dificuldade de realizar testes com sequências cada vez maiores, mesmo que seja com o uso de computadores.

A título de curiosidade, se considerarmos o alfabeto com 26 caracteres, repetição de valores e uma sequência de 5 letras, teriamos 11.88 milhões de possibilidades \(P = 26^n\). Mesmo com a prensente capacidade dos computadores, existem limites quanto ao tamanho de Strings ou armazenamento de tentativas executadas em uma variável inteira. 

Devido aos limites impostos pelos hardwares presentes atualmente e pela plataforma replit, foi definido um limite de até 5 caracteres. No pior dos casos, e considerando que nenhuma String será repetida, o que número de tentativas será de 11,88 milhões. 

A função foi tipada com uma entrada do tipo String e uma saída do tipo IO Int. Foram feitos teste com apenas uma saida do tipo Int, mas encontrei erros ao executar. A string informada pelo usuário passa inicialmente por uma testagem que verifica o tamanho da String e, se for realmente menor ou igual a 5, será usada na função ___recursivo___. É importante observar a forma como essa função é chamada, sendo informada a palavra, o valor 1 que será o ponto de partida da contagem de tentativas e a flag False. 

Por padrão, a recursividade deve começar com False para que o código não pare logo na primeira verificação. Tudo isso pode ser visto no código abaixo:

~~~Haskell
macacoInfinito :: String -> IO Int
macacoInfinito palavra = do
  if length palavra >=5
    then do
      putStrLn "A palavra informada é muito grande."
      return 0
    else do
        putStrLn "Macaco digitando..."
        recursivo palavra 1 False
~~~



## Uso:
O código foi feito completamente no Replit pela facilidade de configuração e execução do código no sistema. Como dito no inicio deste documento, o programa é composto por duas funções, sendo apenas a função MacacoInfinito.hs a que de fato responde a proposta do trabalho. 

No Replit, é possível executar programas usando o Shell. Para que as função disponíveis no MacacoInfinito.hs seja usada, é necessário realizar alguns comandos.

Primeiramente clique no sinal de + no topo desta janela. Após isso, escreva Shell e aperte Enter. Seguindo esses passos, provavelmente você verá uma saída parecida com o codigo abaixo:

~~~Shell
~/Macaco$ 
~~~

Neste terminal, carregue a função MacacoInfinito (função esta que possuí os módulos responsáveis pelo funcionamento do código) como visto abaixo:

~~~Shell
~/Macaco$ ghci MacacoInfinito.hs 
GHCi, version 9.0.2: https://www.haskell.org/ghc/  :? for help
Loaded GHCi configuration from /home/runner/Macaco/.ghci
[1 of 1] Compiling Main             ( MacacoInfinito.hs, interpreted )
Ok, one module loaded.
 
~~~

Se a sua saída for parecida com a acima, o código foi carregado e você já pode usar as funções presentes no MacacoInfinito.hs. As funções são as mesmas descritas na sessão anterior, mas abaixo é possível ver alguns exemplos de uso:

~~~Shell
>> comparar "ola" "vivo"
False
>> comparar "ola" "ola"
True
 
>> gerarString 10
"krjbflcteu"
>> gerarString 5
"vkevs"
 
>> recursivo "ola" 1 False
6112
 
>> macacoInfinito "ola"
O macaco encontrou a sequencia na tentativa: 
28383
>> macacoInfinito "olamundo"
A palavra informada é muito grande.
0
~~~

Como visto, é possível testar individualmente cada função. Mas caso deseje testar todo o código desenvolvido, basta usar o macacoInfinito.

Apesar de haver um bloqueio da quantidade de carcteres, é possível aumentar o limite na função macacoInfinito (linha 25), trocando o 5 pelo número desejado. Mas tenha em mente que com palavras maiores, o número estimado de tentativas aumenta consideravelmente, ao ponto de o programa ser parado após um número de tentativas muito grande. 


## Bugs
É quase uma regra considerar que não existe software/código livre de falhas. Esse projeto não é uma exceção. Existem alguns problemas que não foram plenamente solucionados e que podem se manifestar caso a ordem do software seja alterada. A seguir são listados alguns problemas ou possíveis melhorias:

* ___gerarString___: Essa função apresenta um problema se for colocada no início ou no meio do código. O problema conhecido como "parse error" aparenta ocorrer devido a estrutura da função, que é executada com um "do". O código em questão não roda e diz faltar um "let" para separar as funções. A única solução encontrada foi colocar ela abaixo de todas as demais funções, de forma que uma função abaixo não seja confundida pelo Haskell como parte da mesma. Com relação a melhoria, a mesma só consegue gerar Strings compostas apenas por caracteres de 'a' até 'z', mas não possuí caracteres especiais ou números. Tentei diversas formas adicionar novos caracteres, mas não encontrei uma solução. Fica aí a possibilidade de adicionar essa funcionalidade em uma possível atualização do código.

* ___comparar___: Essa função não apresenta nenhum problema, mas, como dito anteriormente, ela não precisava ser adicionada no formato de uma função separada. Considerei melhor a sua separação devido problemas com o tipo de saída IO Int da função recursivo. Em uma possível atualização ela poderia ser removida e integrada na função recursivo.

* ___macacoInfinito___: Apesar de ser responsável apenas pela entrada de dados e testes, a prensente função não possuí uma saída muito bonita. Em alguns testes com palavras muito grandes, o Replit faz o Kill do processo e o resultado fica parecido com a saída abaixo. Uma possível melhoria seria adicionar novas verifições a respeito dos tipos de caracteres informados e uma verificação para garantir que o putStrLn seja executado APENAS após a obtenção do valor.

~~~Shell
>> macacoInfinito "olamundo"
Macaco digitando...
< Sequencia omitida >
Kill
~~~

## Código final:

~~~Haskell
import System.Random

recursivo :: String -> Int -> Bool -> IO Int
recursivo _ tentativa True = return tentativa
recursivo texto tentativa sucesso = do
  let len = length texto
  sorteado <- gerarString len
  putStrLn sorteado
  if comparar sorteado texto 
    then
      recursivo texto tentativa True
    else 
      recursivo texto (tentativa + 1) False

  
comparar :: String -> String -> Bool
comparar textA textB = textA == textB


macacoInfinito :: String -> IO Int
macacoInfinito palavra = do
  if length palavra >=5
    then do
      putStrLn "A palavra informada é muito grande."
      return 0
    else do
        putStrLn "Macaco digitando..."
        recursivo palavra 1 False 


gerarString :: Int -> IO String
gerarString tamanho = do
gen <- newStdGen
return $ take tamanho $ randomRs ('a', 'z') gen 
~~~



### Referencias: 
1. <https://hackage.haskell.org/package/random-1.2.1.1/docs/System-Random.html>
2. <https://hackage.haskell.org/package/random-1.2.1.1/docs/System-Random.html#v:randomR>
3. <https://www.schoolofhaskell.com/school/starting-with-haskell/libraries-and-frameworks/randoms>
4. <http://haskell.tailorfontela.com.br/input-and-output>
5. <http://learnyouahaskell.com/recursion>




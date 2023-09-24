import System.Random


-- Adicionei dessa forma, pois o haskell nao tem laco de repeticao. Entao ele chamara recursivamente enquando nao houver a ocorrencia. 
recursivo :: String -> Int -> Bool -> IO Int
recursivo _ tentativa True = return tentativa
recursivo texto tentativa sucesso = do
  let len = length texto
  sorteado <- gerarString len

  if comparar sorteado texto 
    then
      recursivo texto tentativa True
    else 
      recursivo texto (tentativa + 1) False
  
  
      
--Isso poderia rer sido feito dentro do proprio recursivo com um if-else. Mas o codigo ficaria mais complexo e recheado de bugs. Achei melhor colocar de forma separada
comparar :: String -> String -> Bool
comparar textA textB = textA == textB

--Apos varias tentativas, descobri que o melhor é colocar no formato de saida IO Int, assim o resultado confere com a saida da funcao recursivo
macacoInfinito :: String -> IO Int
macacoInfinito palavra = do
  if length palavra > 10 
    then do
      putStrLn "A palavra informada é muito grande."
      return 0
    else do
        putStrLn "O macaco encontrou a sequencia na tentativa: "
        recursivo palavra 1 False --Entendo que o serto seria concatenar tudo no putStrLn, mas encontrei multiplos problemas com o tipo de saida IO () e IO Int dessa funcao

-- A funcao deve ficar abaixo devido problema nao solucionado. Para desenvolver ela, me baseei no codigo de exemplo da professora.
gerarString :: Int -> IO String
gerarString tamanho = do
gen <- newStdGen
return $ take tamanho $ randomRs ('a', 'z') gen 

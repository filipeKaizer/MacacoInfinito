module Main where

main = do
  putStrLn ""

macacoInfinito :: String -> Int
macacoInfinito texto = if length texto > 10 then 0 else    --Verifica se o texto é muito grande, parando execução se for maior que 10 caracteres
  let 
    x = length texto
  in 
    x

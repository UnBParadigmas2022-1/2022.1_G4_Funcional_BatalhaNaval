module Hanking
( salvaRegistro
, recuperaRegistrosOrdenados
) where

import System.IO

salvaRegistro :: [Char] -> [Char] -> IO ()
salvaRegistro nome pontuacao = do
    let registro = nome ++ "\t" ++ pontuacao ++ "\n"
    appendFile "ranking.txt" registro

recuperaRegistrosOrdenados = do
    putStr "recuperandoRegistros"

main :: IO ()
main = do
    putStrLn "Digite o nome:"
    nome <- getLine
    putStrLn "Digite a pontuacao:"
    pontuacao <- getLine

    salvaRegistro nome pontuacao
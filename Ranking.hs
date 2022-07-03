module Ranking
( salvaRegistro
, recuperaRegistrosOrdenados
) where

import System.IO

import Control.Applicative ((<$>))
import Data.List (sortBy)
import Data.Ord (comparing, Down(..))

salvaRegistro :: [Char] -> [Char] -> IO ()
salvaRegistro nome pontuacao = do
    let registro = "(\"" ++ nome ++ "\", " ++ pontuacao ++ ")\n"
    appendFile "ranking.txt" registro

mostraRegistro :: (String, Int) -> String
mostraRegistro (nome, pontuacao) = nome ++ "\t" ++ show pontuacao ++ "\n"

recuperaRegistrosOrdenados = do
    putStr "RANKING\n"
    arquivo <- openFile "ranking.txt" ReadMode
    registros <- map read <$> lines <$> hGetContents arquivo :: IO [(String, Int)]
    let ordenados = sortBy (comparing (Down . snd)) registros
    putStrLn $ concatMap mostraRegistro ordenados

main :: IO ()
main = do
    recuperaRegistrosOrdenados

    --putStrLn "Digite o nome:"
    --nome <- getLine
    --putStrLn "Digite a pontuacao:"
    --pontuacao <- getLine

    --salvaRegistro nome pontuacao
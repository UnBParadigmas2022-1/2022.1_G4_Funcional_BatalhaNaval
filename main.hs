import System.Exit (exitFailure, exitSuccess)
import Data.Char (ord)
import Data.List (permutations)

checkOptions option = 
    if option == "1" then game
    else if option == "2" then ranking
    else if option == "0" then exitSuccess
    else do 
        putStrLn "Opção inválida!"
        main

entraNomeJogador :: IO String
entraNomeJogador = do
    putStrLn "Nome para o ranking"
    nome <- getLine
    return nome

imprimeTabuleiro = do
    putStrLn (take (12) (repeat 'H') ++1 "\nH" ++ take (10) (repeat ' ') ++ "H\n" ++ take (12) (repeat 'H') )
    putStrLn ""

game = do
    nomeJogador <- entraNomeJogador
    
    imprimeTabuleiro
    

ranking = putStrLn "RANKING ..."

apresentaMenu :: IO String
apresentaMenu = do
    putStrLn "Bem-vindo ao jogo de Batalha Naval!"
    putStrLn "Escolha a opção desejada:"
    putStrLn "1. JOGAR"
    putStrLn "2. RANKING"
    putStrLn "0. SAIR"
    option <- getLine
    return option

main :: IO ()
main = do
    option <- apresentaMenu
    checkOptions option
    -- main
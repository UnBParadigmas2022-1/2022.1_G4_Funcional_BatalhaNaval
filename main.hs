import System.Exit (exitFailure, exitSuccess)
import Data.Char (ord)
import Data.List (permutations)

verificandoOpcoes opcao = 
    if opcao == "1" then jogo
    else if opcao == "2" then ranking
    else if opcao == "0" then exitSuccess
    else do 
        putStrLn "Opção inválida!"
        main

entraNomeJogador :: IO String
entraNomeJogador = do
    putStrLn "Nome para o ranking"
    nome <- getLine
    return nome

imprimeTabuleiro = do
    putStrLn (take (12) (repeat '~') ++ "\n~" ++ take (10) (repeat ' ') ++ "~\n" ++ take (12) (repeat '~') )
    putStrLn ""

jogo = do
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
    opcao <- getLine
    return opcao

main :: IO ()
main = do
    opcao <- apresentaMenu
    verificandoOpcoes opcao
    -- main
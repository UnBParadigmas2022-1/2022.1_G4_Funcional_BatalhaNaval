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



imprimeCabecalhoTabuleiro listaCabecalho = do
    if (length listaCabecalho) == 0 then do
        return ()
    else do
        putStr (show (head listaCabecalho))
        putStr " "
        imprimeCabecalhoTabuleiro (tail listaCabecalho)

imprimeMarTabuleiro= do
    putStrLn ['~' | x <- [1..10]]
        

imprimeRestoTabuleiro listaResto = do
    if (length listaResto) == 0 then do
        return ()
    else do
        putStr (show (head listaResto))
        imprimeMarTabuleiro
        imprimeRestoTabuleiro (tail listaResto)


imprimeTabuleiroBatalhaNaval n = do
    let listaCabecalho = [0..n]
    let listaResto = [1..n]
    imprimeCabecalhoTabuleiro listaCabecalho
    putStrLn ""
    imprimeRestoTabuleiro listaResto
    putStrLn ""

entraNomeJogador :: IO String
entraNomeJogador = do
    putStrLn "Nome para o ranking (Máximo 5 caracteres):"
    nome <- getLine
    verificaNomeJogador nome
    return nome

verificaNomeJogador nome = do
    if (length nome) == 0 || (length nome) > 5 then do
        putStrLn "Nome inválido!"
        entraNomeJogador
    else do
        return nome

jogo = do
    nomeJogador <- entraNomeJogador
    imprimeTabuleiroBatalhaNaval 10

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

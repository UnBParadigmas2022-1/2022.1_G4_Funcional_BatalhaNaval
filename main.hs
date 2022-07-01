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


imprimeCoordenadaX indicesX = do
    if (length indicesX) == 0 then do
        return ()
    else do
        putStr (show (head indicesX))
        putStr " "
        imprimeCoordenadaX (tail indicesX)


imprimeTabuleiro n = do
    if n == 0 then do
        return ()
    else do
        putStr "~ "
        imprimeTabuleiro (n-1)


imprimeCoordenadaY indicesY n = do
    if (length indicesY) == 0 then do
        return ()
    else do
        putStr (show (head indicesY))
        putStr " "
        imprimeTabuleiro n
        putStrLn ""
        imprimeCoordenadaY (tail indicesY) n


imprimeTabuleiroBatalhaNaval n = do
    let indicesX = [0..n]
    let indicesY = tail indicesX
    imprimeCoordenadaX indicesX
    putStrLn ""
    imprimeCoordenadaY indicesY n
    putStrLn ""


entraNomeJogador :: IO String
entraNomeJogador = do
    putStrLn "Nome para o ranking (Máximo 10 caracteres):"
    nome <- getLine
    verificaNomeJogador nome
    return nome


verificaNomeJogador nome = do
    if (length nome) == 0 || (length nome) > 10 then do
        putStrLn "Nome inválido!"
        entraNomeJogador
    else do
        return nome

entraCoordenadaJogador :: IO Int
entraCoordenadaJogador = do
    putStrLn "Digite um número da coordenadaX (De 0 a 9): "
    coordX <- getLine
    let n = read coordX :: Int
    return n

entraCoordenadaJogadorY :: IO Int
entraCoordenadaJogadorY = do
    putStrLn "Digite um número coordenadaY (De 0 a 9): "
    coordY <- getLine
    let n = read coordY :: Int
    return n

jogo = do
    nomeJogador <- entraNomeJogador
    coordenadaX <- entraCoordenadaJogadorX
    coordenadaY <- entraCoordenadaJogadorY
    imprimeTabuleiroBatalhaNaval 9



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

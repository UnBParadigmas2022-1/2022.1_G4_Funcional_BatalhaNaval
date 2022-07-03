import System.Exit (exitFailure, exitSuccess)
import Data.Char (ord)
import Data.List (permutations)
import System.Random


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

entraCoordenadaJogadorX :: IO Int
entraCoordenadaJogadorX = do
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

imprimeLista lista = do
    print lista


geraCoordenadaSub pos_y n = do
    head <- randomRIO (1, (n-1))  :: IO Int
    let tail = (head + 1)
    return [(pos_y, head), (pos_y, tail)]

geraCoordenadaBarco pos_y n = do
    head <- randomRIO (1, (n-2))  :: IO Int
    let body = (head + 1)
    let tail = (head + 2)
    return [(pos_y, head), (pos_y, body), (pos_y, tail)]

geraCoordenadaNavio pos_y n = do
    head <- randomRIO (1, (n-3))  :: IO Int
    let body1 = (head + 1)
    let body2 = (head + 2)
    let tail = (head + 3)
    return [(pos_y, head), (pos_y, body1), (pos_y, body2), (pos_y, tail)]

encontraCoordenadaLista coordenadaX coordenadaY lista tipo = do
    if ((any (\(x, y) -> x == coordenadaX && y == coordenadaY) lista) && tipo == 4)
        then putStrLn "\nAcertou um navio! + 4 pontos\n"
    else if ((any (\(x, y) -> x == coordenadaX && y == coordenadaY) lista) && tipo == 3)
        then putStrLn "\nAcertou um barco! + 3 pontos\n"
    else if ((any (\(x, y) -> x == coordenadaX && y == coordenadaY) lista) && tipo == 2)
        then putStrLn "\nAcertou um sub! + 2 pontos\n"
    else putStrLn "\nErrou!\n"

jogo = do    
    nomeJogador <- entraNomeJogador
    imprimeTabuleiroBatalhaNaval 9

    -- cria embarcações no mapa
    sub1 <- geraCoordenadaSub 1 9
    sub2 <- geraCoordenadaSub 3 9
    barco1 <- geraCoordenadaBarco 4 9
    barco2 <- geraCoordenadaBarco 6 9
    navio1 <- geraCoordenadaNavio 7 9
    let listaSub = sub1 ++ sub2 
    let listaBarco = barco1 ++ barco2
    let listaNavio = navio1

    -- visualiza a lista gerada
    putStrLn "Lista de embarcações:\n"
    imprimeLista listaSub 
    imprimeLista listaBarco 
    imprimeLista listaNavio
    putStrLn "\n"

    -- solicita jogada
    coordenadaX <- entraCoordenadaJogadorX
    coordenadaY <- entraCoordenadaJogadorY

    -- 4 = navio
    -- 3 = barco
    -- 2 = sub
    -- verifica se a jogada acertou o navio 
    encontraCoordenadaLista coordenadaX coordenadaY listaBarco 3

    -- verificar onde já existe embarcação e mostrá-las
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

import System.Exit (exitFailure, exitSuccess)
import Data.Char (ord)
import Data.List (permutations)
import System.Random

converter :: String -> [[String]]
converter = map (map return) . lines

removeUltimoItem :: [[String]] -> [[String]]
removeUltimoItem = map init

removePrimeiroItem :: [[String]] -> [[String]]
removePrimeiroItem = map tail

converterListaParaTupla :: [[String]] -> [(Int, Int)]
converterListaParaTupla = map (\[a,b] -> (read a::Int, read b::Int))

filtrarEmbarcacao lista tipo = 
    filter (\x -> head x == tipo) lista

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

    -- Ler o arquivo de entrada aleatório
    arquivo <- randomRIO (0, 99) :: IO Int
    conteudo <- readFile ("maps/"++show arquivo++".txt")

    -- Converter o arquivo de entrada em uma lista de linhas
    let mapa = converter conteudo
    let mapaSemUltimo = removeUltimoItem mapa

    -- Filtrar o mapa para pegar apenas as linhas que contém embarcações
    let submarinosLista = filtrarEmbarcacao mapaSemUltimo "S"
    let submarinosSemLetra = removePrimeiroItem submarinosLista
    let listaSub = converterListaParaTupla submarinosSemLetra    

    let barcosLista = filtrarEmbarcacao mapaSemUltimo "B"
    let barcosSemLetra = removePrimeiroItem barcosLista
    let listaBarco = converterListaParaTupla barcosSemLetra

    let naviosLista = filtrarEmbarcacao mapaSemUltimo "N"
    let naviosSemLetra = removePrimeiroItem naviosLista
    let listaNavio = converterListaParaTupla naviosSemLetra

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

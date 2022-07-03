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


filtrarAlvosAtingidos lista xInserido yInserido = 
    filter (\(x, y) -> x == xInserido && y == yInserido) lista

filtrarAlvosNaoAtingidos lista xInserido yInserido = 
    filter (\(x, y) -> x /= xInserido || y /= yInserido) lista

rotinaJogo barcos sub navios barcosAtingidos naviosAtingidos subsAtingidos pontuacao tentativas = do
    
    imprimeTabuleiroBatalhaNaval 9

    -- solicita jogada
    coordenadaX <- entraCoordenadaJogadorX
    coordenadaY <- entraCoordenadaJogadorY



    -- 4 = navio
    -- 3 = barco
    -- 2 = sub
    -- verifica se a jogada acertou o barco
    let pontuacaoAtual = 0


    let encontrou = any (\(x, y) -> x == coordenadaX && y == coordenadaY) tentativas
    
    
    if (encontrou)
        then do 
            putStrLn "Esse ponto já foi atacado. Você está perdendo tempo na guerra. Coloque uma nova coordenada."
            rotinaJogo barcos sub navios barcosAtingidos naviosAtingidos subsAtingidos pontuacao tentativas
    
    else do
        let coordenadas = [(coordenadaX, coordenadaY)]
        let tentativasAtual = tentativas ++ coordenadas
        --print(coordenadas)
        --print(tentativasAtual)


        if (any (\(x, y) -> x == coordenadaX && y == coordenadaY) barcos)
            then do 
                let pontuacaoAtual = pontuacao + 3
                let barcosAtingidosAtual = coordenadas ++ barcosAtingidos
                print("Voce acertou um barco e ganhou 3 pontos!")
                putStr("B.A.A: ")
                print(barcosAtingidosAtual)
                rotinaJogo barcos sub navios barcosAtingidosAtual naviosAtingidos subsAtingidos pontuacaoAtual tentativasAtual

        else if (any (\(x, y) -> x == coordenadaX && y == coordenadaY) sub)
            then do 
                let pontuacaoAtual = pontuacao + 2
                let subsAtingidosAtual = coordenadas ++ subsAtingidos
                print("Voce acertou um submarino, ganhou 2 pontos e matou o Bob Esponja!")
                putStr("S.A.A: ")
                print(subsAtingidosAtual)
                rotinaJogo barcos sub navios barcosAtingidos naviosAtingidos subsAtingidosAtual pontuacaoAtual tentativasAtual

        else if (any (\(x, y) -> x == coordenadaX && y == coordenadaY) navios)
            then do 
                let pontuacaoAtual = pontuacao + 4
                let naviosAtingidosAtual = coordenadas ++ naviosAtingidos
                print("Voce acertou um navio e ganhou 4 pontos!")
                putStr("N.A.A: ")
                print(naviosAtingidosAtual)
                rotinaJogo barcos sub navios barcosAtingidos naviosAtingidosAtual subsAtingidos pontuacaoAtual tentativasAtual

        else
            if (pontuacao > 0)
                then do 
                    putStrLn "Poxa! Você não atingiu nenhuma embarcação e perdeu 1 ponto."
                    let pontuacaoAtual = pontuacao - 1
                    rotinaJogo barcos sub navios barcosAtingidos naviosAtingidos subsAtingidos pontuacaoAtual tentativasAtual
            else
                putStrLn "Poxa! Você não atingiu nenhuma embarcação."


        --(coordenadaX, coordenadaY):tentativas


        -- verificar onde já existe embarcação e mostrá-las

        -- let barcosAtingidos = filtrarAlvosNaoAtingidos(barcos, coordenadaX, coordenadaY)
        -- let naviosAtingidos = filtrarAlvosNaoAtingidos(navios, coordenadaX, coordenadaY)
        -- let subAtingidos = filtrarAlvosNaoAtingidos(sub, coordenadaX, coordenadaY)



        rotinaJogo barcos sub navios barcosAtingidos naviosAtingidos subsAtingidos pontuacaoAtual tentativasAtual


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

achouCoordenada coordenadaX coordenadaY lista 
    | (any (\(x, y) -> x == coordenadaX && y == coordenadaY) lista) = 1
    | otherwise = 0
    -- if ((any (\(x, y) -> x == coordenadaX && y == coordenadaY) lista))
    --     then 1
    -- else 0

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

    rotinaJogo listaBarco listaSub listaNavio [] [] [] 0 []


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

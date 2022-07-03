import System.Exit (exitFailure, exitSuccess)
import Data.Char (ord)
import Data.List (permutations)
import System.Random

import Ranking

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


imprimeTabuleiro matriz = do
    if length matriz == 0 then do
        return ()
    else do
        putStr (head matriz)
        putStr " "
        imprimeTabuleiro (tail matriz)


imprimeCoordenadaY indicesY matriz = do
    if (length indicesY) == 0 then do
        return ()
    else do
        putStr (show (head indicesY))
        putStr " "
        imprimeTabuleiro (head matriz)
        putStrLn ""
        imprimeCoordenadaY (tail indicesY) (tail matriz)

imprimeTabuleiroBatalhaNaval n matriz = do
    let indicesX = [0..n]
    putStr "  "
    imprimeCoordenadaX indicesX
    putStrLn ""
    imprimeCoordenadaY indicesX matriz
    putStrLn ""

imprimeTabuleiroDinamico subsAtingidos barcosAtingidos naviosAtingidos tentativas n = do
    let matriz = [[
            if (any (\(x, y) -> x == i && y == j) subsAtingidos) then "S"
            else if (any (\(x, y) -> x == i && y == j) barcosAtingidos) then "B"
            else if (any (\(x, y) -> x == i && y == j) naviosAtingidos) then "N"
            else if (any (\(x, y) -> x == i && y == j) tentativas) then "."
            else "~" | i <- [0..n] ] | j <- [0..n] ]

    imprimeTabuleiroBatalhaNaval n matriz


rotinaJogo barcos sub navios barcosAtingidos naviosAtingidos subsAtingidos pontuacao tentativas tentativasRestantes nomeJogador = do

    if (tentativasRestantes > 0)
        then do
    
        imprimeTabuleiroDinamico subsAtingidos barcosAtingidos naviosAtingidos tentativas 9

        putStr "\nSua pontuação atual é: "
        print(pontuacao)
        putStr "\n"

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
                rotinaJogo barcos sub navios barcosAtingidos naviosAtingidos subsAtingidos pontuacao tentativas (tentativasRestantes-1) nomeJogador
        
        else do
            let coordenadas = [(coordenadaX, coordenadaY)]
            let tentativasAtual = tentativas ++ coordenadas

            if (any (\(x, y) -> x == coordenadaX && y == coordenadaY) barcos)
                then do 
                    let pontuacaoAtual = pontuacao + 3
                    let barcosAtingidosAtual = coordenadas ++ barcosAtingidos
                    print("Voce acertou um barco e ganhou 3 pontos!")
                    putStr("B.A.A: ")
                    print(barcosAtingidosAtual)
                    rotinaJogo barcos sub navios barcosAtingidosAtual naviosAtingidos subsAtingidos pontuacaoAtual tentativasAtual (tentativasRestantes-1) nomeJogador

            else if (any (\(x, y) -> x == coordenadaX && y == coordenadaY) sub)
                then do 
                    let pontuacaoAtual = pontuacao + 2
                    let subsAtingidosAtual = coordenadas ++ subsAtingidos
                    print("Voce acertou um submarino, ganhou 2 pontos e matou o Bob Esponja!")
                    putStr("S.A.A: ")
                    print(subsAtingidosAtual)
                    rotinaJogo barcos sub navios barcosAtingidos naviosAtingidos subsAtingidosAtual pontuacaoAtual tentativasAtual (tentativasRestantes-1) nomeJogador

            else if (any (\(x, y) -> x == coordenadaX && y == coordenadaY) navios)
                then do 
                    let pontuacaoAtual = pontuacao + 4
                    let naviosAtingidosAtual = coordenadas ++ naviosAtingidos
                    print("Voce acertou um navio e ganhou 4 pontos!")
                    putStr("N.A.A: ")
                    print(naviosAtingidosAtual)
                    rotinaJogo barcos sub navios barcosAtingidos naviosAtingidosAtual subsAtingidos pontuacaoAtual tentativasAtual (tentativasRestantes-1) nomeJogador

            else
                if (pontuacao > 0)
                    then do 
                        putStrLn "Poxa! Você não atingiu nenhuma embarcação e perdeu 1 ponto."
                        let pontuacaoAtual = pontuacao - 1
                        rotinaJogo barcos sub navios barcosAtingidos naviosAtingidos subsAtingidos pontuacaoAtual tentativasAtual (tentativasRestantes-1) nomeJogador
                else
                    putStrLn "Poxa! Você não atingiu nenhuma embarcação."


            rotinaJogo barcos sub navios barcosAtingidos naviosAtingidos subsAtingidos pontuacaoAtual tentativasAtual (tentativasRestantes-1) nomeJogador
    
    else
        do
        imprimeTabuleiroDinamico subsAtingidos barcosAtingidos naviosAtingidos tentativas 9
        putStrLn ("\nFim de jogo! Você atingiu o máximo de tentativas possíveis.")
        putStr ("Jogador ")
        putStr (nomeJogador)
        putStr (", sua pontuação foi: ")
        putStr (show pontuacao)
        putStrLn "\n"

        salvaRegistro nomeJogador (show pontuacao)

        exitSuccess
        --putStrLn "\n\n"
        --return ()


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

jogo = do    
    nomeJogador <- entraNomeJogador

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
    putStrLn "Lista de embarcações (gabarito):\n"
    imprimeLista listaSub 
    imprimeLista listaBarco 
    imprimeLista listaNavio
    putStrLn "\n"

    rotinaJogo listaBarco listaSub listaNavio [] [] [] 0 [] 10 nomeJogador


ranking = recuperaRegistrosOrdenados


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

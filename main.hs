import System.Exit (exitFailure, exitSuccess)

checkOptions option = 
    if option == "1" then game
    else if option == "2" then ranking
    else if option == "0" then exitSuccess
    else do 
        putStrLn "Opção inválida!"
        main

game = putStrLn "JOGANDO ..."

ranking = putStrLn "RANKING ..."

main :: IO ()
main = do 
    putStrLn "Bem-vindo ao jogo de Batalha Naval!"
    putStrLn "Escolha a opção desejada:"
    putStrLn "1. JOGAR"
    putStrLn "2. RANKING"
    putStrLn "0. SAIR"
    option <- getLine
    checkOptions option
    main
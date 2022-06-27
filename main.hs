checkOptions option = 
    if option == "1" then game
    else if option == "2" then ranking
    else if option == "0" then return ()
    else putStrLn "Opção inválida!"

game = putStrLn "JOGANDO ..."

ranking = putStrLn "RANKING ..."

main :: IO ()
main = do 
    
    putStrLn "Escolha a opção desejada:"
    putStrLn "1. JOGAR"
    putStrLn "2. RANKING"
    putStrLn "0. SAIR"
    option <- getLine
    checkOptions option
    main
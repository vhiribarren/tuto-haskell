module Main where

import System.Random
import Text.Read

minSecretValue = 0
maxSecretValue = 1000

evalGuess :: Int -> Int -> Ordering 
evalGuess guess secret = compare guess secret 

guessAttempt :: Int -> IO (Ordering)
guessAttempt secret = do
  putStrLn "New guess?"
  inputStr <- getLine :: IO (String)
  let guessMay = readMaybe inputStr :: Maybe (Int) in
    case guessMay of
      Nothing -> do putStrLn "Bad input"; guessAttempt secret
      Just guess -> return $ evalGuess guess secret

displayHint :: Ordering -> IO ()
displayHint result = case result of
  LT -> putStrLn "You are below"
  GT -> putStrLn "You are above"
  EQ -> putStrLn "You found the good value"

gameLoop :: Int -> Int -> IO ()
gameLoop secret attemptCount = do
  result <- guessAttempt secret
  displayHint result
  if result == EQ
    then putStrLn $ "Found in " ++ show attemptCount ++ " attempts" 
    else gameLoop secret (attemptCount + 1)  

main :: IO ()
main = do
  secret <- getStdRandom $ randomR (minSecretValue, maxSecretValue)
  putStrLn $ "You must find a number between " ++ show minSecretValue ++ " and " ++ show maxSecretValue 
  gameLoop secret attemptCount
  where attemptCount = 1 

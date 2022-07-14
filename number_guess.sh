#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"
#generate random number 1 - 1000
SECRET_NUMBER=$(( RANDOM % 1000 + 1 ))
#get username
echo -e "\nEnter your username:"
read USERNAME
#get user_id from DB
USER_ID=$($PSQL "SELECT user_id FROM users WHERE name='$USERNAME'")
#if user is not found in DB
if [[ -z $USER_ID ]]
then
  #add new user in DB
  ADD_USER_RESULT=$($PSQL "INSERT INTO users (name) VALUES ('$USERNAME')")
  USER_ID=$($PSQL "SELECT user_id FROM users WHERE name='$USERNAME'")
  echo -e "Welcome, $USERNAME! It looks like this is your first time here."
else
  #get user's  total number of games and the best game result 
  GAMES_PLAYED=$($PSQL "SELECT COUNT(*) FROM games WHERE user_id=$USER_ID")
  BEST_GAME=$($PSQL "SELECT MIN(number_of_guesses) FROM games WHERE user_id=$USER_ID")
  echo -e "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
fi

echo -e "\nGuess the secret number between 1 and 1000:"
read USER_GUESS
NUMBER_OF_GUESSES=1

while [[ $SECRET_NUMBER -ne $USER_GUESS ]]
do
  if [[ ! $USER_GUESS =~ ^[0-9]+$ ]]
  then
    echo That is not an integer, guess again:
    read USER_GUESS
    continue
  fi
  if [[ $USER_GUESS -lt $SECRET_NUMBER ]]
  then
    echo -e "\nIt's lower than that, guess again:"   
  else
    echo -e "\nIt's higher than that, guess again:"
  fi
  read USER_GUESS
  NUMBER_OF_GUESSES=$((NUMBER_OF_GUESSES + 1))
done

echo -e "You guessed it in $NUMBER_OF_GUESSES tries. The secret number was $SECRET_NUMBER. Nice job!"
INSERT_GAME_RESULT=$($PSQL "INSERT INTO games (user_id, number_of_guesses) VALUES ($USER_ID, $NUMBER_OF_GUESSES)")
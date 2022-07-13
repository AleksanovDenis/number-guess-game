#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=<database_name> -t --no-align -c"
#generate random number 0 - 999
RANDOM_NUMBER=$(( RANDOM % 1000 ))
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
  echo -e "\nWelcome, $USERNAME! It looks like this is your first time here."
else
  #get user's  total number of games and the best game result 
  GAMES_PLAYED=$($PSQL "SELECT COUNT(*) FROM games WHERE user_id=$USER_ID")
  BEST_GAME=$($PSQL "SELECT MIN(number_of_guesses) FROM games WHERE user_id=$USER_ID")
  echo -e "\nWelcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
fi
#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=<database_name> -t --no-align -c"
RANDOM_NUMBER=$(( RANDOM % 1000 ))

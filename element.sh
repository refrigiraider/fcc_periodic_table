#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

if [[ -z $1 ]]
then
  echo  "Please provide an element as an argument."
else

if [[ $1 =~ ^[0-9]+$ ]]
  then
    INPUT_ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM properties INNER JOIN elements USING (atomic_number) INNER JOIN types USING (type_id) WHERE atomic_number = $1")
  else
    if [[ $1 =~ [a-z]|[A-Z] ]]
    then
      INPUT_ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM properties INNER JOIN elements USING (atomic_number) INNER JOIN types USING (type_id) WHERE name = INITCAP('$1') OR symbol = INITCAP('$1')")
    else
      INPUT_ATOMIC_NUMBER=""
    fi
  fi

  if [[ -z $INPUT_ATOMIC_NUMBER ]]
  then
    echo "I could not find that element in the database."
  else    
  #name
    INPUT_NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number = $INPUT_ATOMIC_NUMBER;")
  #symbol
    INPUT_SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number = $INPUT_ATOMIC_NUMBER;")
  #type
    INPUT_TYPE=$($PSQL "SELECT type FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE atomic_number = $INPUT_ATOMIC_NUMBER;")
  #mass
    INPUT_ATOMIC_MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number = $INPUT_ATOMIC_NUMBER;")
  #melting point
    INPUT_MELTING_POINT=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number = $INPUT_ATOMIC_NUMBER;")
  #boiling point
    INPUT_BOILING_POINT=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number = $INPUT_ATOMIC_NUMBER;")
  #formatted input  
    echo "The element with atomic number $INPUT_ATOMIC_NUMBER is $INPUT_NAME ($INPUT_SYMBOL). It's a $INPUT_TYPE, with a mass of $INPUT_ATOMIC_MASS amu. $INPUT_NAME has a melting point of $INPUT_MELTING_POINT celsius and a boiling point of $INPUT_BOILING_POINT celsius." | sed -E 's/ +/ /g;s/\( /\(/'
  fi
fi


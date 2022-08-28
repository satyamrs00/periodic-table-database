#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t -c"

if [[ $1 ]]
then
  if (( $1 > 0 ))
  then
    RESULT=$($PSQL "SELECT * FROM elements INNER JOIN properties USING (atomic_number) INNER JOIN types USING (type_id) WHERE atomic_number=$1;")
  else
    RESULT=$($PSQL "SELECT * FROM elements INNER JOIN properties USING (atomic_number) INNER JOIN types USING (type_id) WHERE symbol='$1';")
    if [[ -z $RESULT ]]
    then
      RESULT=$($PSQL "SELECT * FROM elements INNER JOIN properties USING (atomic_number) INNER JOIN types USING (type_id) WHERE name='$1';")
    fi
  fi

  if [[ -z $RESULT ]]
  then
    echo "I could not find that element in the database."
  else
    echo "$RESULT" | while IFS=" | " read TYPE_ID ATOMIC_NUMBER SYMBOL NAME ATOMIC_MASS MELTING_POINT BOILING_POINT TYPE
    do
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
    done
  fi
else
  echo "Please provide an element as an argument."
fi

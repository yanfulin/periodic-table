#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table --no-align --tuples-only -c"

if [[ $1 ]]
then 
if [[ $1 =~ ^[0-9]+$ ]]
  then
  ELEMENT=$($PSQL "SELECT * FROM elements WHERE atomic_number=$1")
  else
  ELEMENT=$($PSQL "SELECT * FROM elements WHERE symbol='$1' or name='$1'")
fi
if [[ -z $ELEMENT ]]
  then
    echo -e "I could not find that element in the database."
  else
    # break down the elements parts
    ATOMIC_NUM=$(echo $ELEMENT | sed -E 's/([0-9]+)\|(.*)\|(.*)/\1/')
    ATOMIC_SYM=$(echo $ELEMENT | sed -E 's/([0-9]+)\|(.*)\|(.*)/\2/')
    ATOMIC_NAM=$(echo $ELEMENT | sed -E 's/([0-9]+)\|(.*)\|(.*)/\3/')

    QUERY=$($PSQL "SELECT * from properties left join types using(type_id) where atomic_number=$ATOMIC_NUM")
    TYPE_ID=$(echo $QUERY | sed -E 's/([0-9]+)\|([0-9]+)\|(.*)\|(.*)\|(.*)\|(.*)/\1/')
    MASS=$(echo $QUERY | sed -E 's/([0-9]+)\|([0-9]+)\|(.*)\|(.*)\|(.*)\|(.*)/\3/')
    MELTING_CELSIUS=$(echo $QUERY | sed -E 's/([0-9]+)\|([0-9]+)\|(.*)\|(.*)\|(.*)\|(.*)/\4/')
    BOILING_CELSIUS=$(echo $QUERY | sed -E 's/([0-9]+)\|([0-9]+)\|(.*)\|(.*)\|(.*)\|(.*)/\5/')
    TYPE=$(echo $QUERY | sed -E 's/([0-9]+)\|([0-9]+)\|(.*)\|(.*)\|(.*)\|(.*)/\6/')

    TYPE=$(echo $QUERY | sed -E 's/([0-9]+)\|([0-9]+)\|(.*)\|(.*)\|(.*)\|(.*)/\6/')
    echo -e "The element with atomic number $ATOMIC_NUM is $ATOMIC_NAM ($ATOMIC_SYM). It's a $TYPE, with a mass of $MASS amu. $ATOMIC_NAM has a melting point of $MELTING_CELSIUS celsius and a boiling point of $BOILING_CELSIUS celsius."
  fi

else
    echo -e "Please provide an element as an argument."
fi    

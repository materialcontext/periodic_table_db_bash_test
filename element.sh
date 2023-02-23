#! /bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --tuples-only -c"

if [[ -z $1 ]]
then
  echo -e "Please provide an element as an argument."
  exit
fi
# if argument is atomic number
if [[ $1 =~ ^[1-9]+$ ]]
then
  element=$($PSQL "select atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius from elements join properties using(atomic_number) join types using(type_id) where atomic_number = '$1'")
else

# if argument is string
  element=$($PSQL "select atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius from elements join properties using(atomic_number) join types using(type_id) where name = '$1' or symbol = '$1'")
fi

# element not in db
if [[ -z $element ]]
then
  echo -e "I could not find that element in the database."
  exit
fi

# final output
echo $element | while IFS=" |" read num name sym typ mass mp bp 
do
  echo -e "The element with atomic number $num is $name ($sym). It's a $typ, with a mass of $mass amu. $name has a melting point of $mp celsius and a boiling point of $bp celsius."
done
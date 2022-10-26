#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE TABLE games, teams")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPP WINGOAL OPPGOAL
do
if [[ $YEAR != "year" ]]
then

WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")

if [[ -z $WINNER_ID ]]
then
INSERT_WINNER_RESULT=$($PSQL "INSERT INTO teams(name) VALUES ('$WINNER')")
if [[ $INSERT_WINNER_RESULT == "INSERT 0 1" ]]
then
echo Inserted into teams, $WINNER
fi


WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
fi

OPP_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPP'")

if [[ -z $OPP_ID ]]
then
INSERT_OPP_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPP')")
if [[ $INSERT_OPP_RESULT == "INSERT 0 1" ]]
then
echo inserted into teams, $OPP
fi

OPP_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPP'")
fi

INSERT_GAME_RESULT=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES('$YEAR', '$ROUND', '$WINNER_ID', '$OPP_ID', '$WINGOAL', '$OPPGOAL')")
if [[ $INSERT_GAME_RESULT == "INSERT 0 1" ]]
then
echo Inserted into games, $YEAR $ROUND $WINNER_ID $OPP_ID $WINGOAL $OPPGOAL
fi
fi
done

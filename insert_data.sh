#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE teams, games")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $WINNER != "winner" ]]
  then
    # get team_id
    WIN_NAME_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")

    # if not found
    if [[ -z $WIN_NAME_ID ]]
    then
       # insert winner team name
      INSERT_WIN_NAME_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
      if [[ $INSERT_WIN_NAME_RESULT == "INSERT 0 1" ]]
      then
        echo Inserted into name winner team, $WINNER
      fi
      # get new name  
      WIN_NAME_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER';")
    fi

    # get team_id
    OPP_NAME_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

    # if not found
    if [[ -z $OPP_NAME_ID ]]
    then
       # insert winner team name
      INSERT_OPP_NAME_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
      if [[ $INSERT_OPP_NAME_RESULT == "INSERT 0 1" ]]
      then
        echo Inserted into name winner team, $OPPONENT
      fi
      # get new name  
      OPP_NAME_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT';")
    fi
  fi
done

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $WINNER != "winner" ]]
  then
    # get team_id
    WIN_NAME_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    OPP_NAME_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

    # if not found
    if [[ -z $WIN_NAME_ID ]]
    then
       # set to null
       WIN_NAME_ID=ull
    fi
    # insert all other lines  
    INSERT_GAME_RESULT=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) 
    VALUES($YEAR, '$ROUND', $WIN_NAME_ID, $OPP_NAME_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
    if [[ $INSERT_GAME_RESULT == "INSERT 0 1" ]]
    then
      echo "Inserted into games, $YEAR $ROUND"
    fi
  fi
done
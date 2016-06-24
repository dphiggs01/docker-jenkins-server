#Default compose args
COMPOSE_ARGS=" -f jenkins.yml -p jenkins "

#set to "sudo" to use super user credentials
SUDO="sudo"
#Make sure old containers are gone
$SUDO docker-compose $COMPOSE_ARGS stop
$SUDO docker-compose $COMPOSE_ARGS rm --all --force -v


#build the system
$SUDO docker-compose $COMPOSE_ARGS build --no-cache
$SUDO docker-compose $COMPOSE_ARGS up -d --remove-orphans


#Run unit tests
# ### We have no unit tests to build Jenkins image ### #
#$SUDO docker-compose $COMPOSE_ARGS run --no-deps --rm -e ENV=UNIT {{SERVICE_NM}}
#ERR=$?

#Run system test if unit tests passed
if [ $ERR -eq 0 ]; then
  # ### Simple ping if system started
  IP=$($SUDO docker inspect -f {{.NetworkSettings.IPAddress}} jenkins_continuous-int_1)
  CODE=$(curl -sL -w "%{http_code}" $IP:8080 -o /dev/null) || true
  echo "XXXX after Run system tests"
  if [ $CODE -eq 200 ]; then
    echo "Test passed - Tagging"
    HASH=$(git rev-parse --short HEAD)
    $SUDO docker tag -f 'jenkins_continuous-int' 'dphiggs01/continuous-int:'$HASH
    $SUDO docker tag -f 'jenkins_continuous-int' 'dphiggs01/continuous-int:newest'
    echo "Pushing"
    $SUDO docker login -u dphiggs01 -p un1ik3ly!
    $SUDO docker push 'dphiggs01/continuous-int:'$HASH
    $SUDO docker push 'dphiggs01/continuous-int:newest'
  else
    echo "Site returned " $CODE
    ERR=1
  fi
fi

#Pull down the system
$SUDO docker-compose $COMPOSE_ARGS stop
$SUDO docker-compose $COMPOSE_ARGS rm --force -v

return $ERR

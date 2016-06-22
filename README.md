# Read Me
This project creates a simple Docker Container to perform Continuous integration with Jenkins.

It is based on content from the book [Using Docker by Adrian Mouat](https://www.amazon.com/Using-Docker-Developing-Deploying-Containers/dp/1491915765)


## Docker Container Setup
***Clone*** this project into a local machine, ensure docker is running and execute the following to get your continuous integration environment up and running quickly.

```
docker build -t continuous-int .

docker run --name jenkins-data continuous-int echo "Jenkins Data Container"

docker run -d --name jenkins -p 8080:8080 --volumes-from jenkins-data -v /var/run/docker.sock:/var/run/docker.sock continuous-int
``` 

## Project Setup
If you are a sophisticated Jenkins user you can monitor, build, test and deploy your apps per usual. If you desire to have some additional assistance in project integration configuration apply the following techniques  to your app development. 

* Customize the ***cmd.sh*** script (included in the repo) to execute __dev__, __test__ , or __prod__ startups based upon the **ENV** variable.
* create a ***jenkins.yml*** a special docker-compose file for the integration environment. (A sample is included)
* Last but certainly not least create your tests and check in


## Jenkins Setup
If you are using the project setup from above you will want to also use the ***sample_jenkins_build.sh*** provided in the repo and add this (paste the contents into) to the build step of your Jenkins project.
  
  
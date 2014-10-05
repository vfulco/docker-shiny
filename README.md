shiny
=====

shiny server: 1.2.1.362

Dockerfile to be use to build image for docker container with ubuntu 14.04 plus sshd service and Shiny-server


Shiny server : use to host and manage shiny application (R - powered web application)

To make it work :

docker run -d -p 3838 angelrr7702/shiny

To configured it :

Need to log in to the container by ssh (root:rootprovisional) and them : passwd  ==> to change root password

you can check http://rstudio.github.io/shiny-server/latest/#configuration-settings for more info about shiny-server


note : it was created by using angelrr7702/docker-ubuntu-14.04-sshd and installing the package R and Shiny-server from rstudio.com . RStudio is a trademark of RStudio, Inc.

#!/bin/bash


set -e

if [ -f /etc/configured ]; then
        echo 'already configured'
else
      #code that need to run only one time ....
        sed -i '114 a <h2><a href="./examples/">Other examples of Shiny application</a> </h2>' /srv/shiny-server/index.html
        #needed for fix problem with ubuntu and cron
        update-locale 
        date > /etc/configured
fi

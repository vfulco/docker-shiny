#name of container: docker-shiny
#versison of container: 0.5.6
FROM quantumobject/docker-baseimage:15.04
MAINTAINER Angel Rodriguez  "angel@quantumobject.com"

#add repository and update the container
#Installation of nesesary package/software for this containers...
RUN echo "deb http://archive.ubuntu.com/ubuntu vivid-backports main restricted universe" >> /etc/apt/sources.list
RUN (echo "deb http://cran.mtu.edu/bin/linux/ubuntu vivid/" >> /etc/apt/sources.list && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9)
RUN apt-get update && apt-get install -y -q r-base  \
                    r-base-dev \
                    gdebi-core \  
                    libapparmor1 \
                    sudo \
                    libssl0.9.8 \
                    libcurl4-openssl-dev \
                    && apt-get clean \
                    && rm -rf /tmp/* /var/tmp/*  \
                    && rm -rf /var/lib/apt/lists/*
                    
RUN R -e "install.packages('shiny', repos='http://cran.rstudio.com/')" \
          && update-locale  \
          && wget https://download3.rstudio.org/ubuntu-12.04/x86_64/shiny-server-1.5.0.730-amd64.deb \
          && gdebi --n shiny-server-1.5.0.730-amd64.deb \
          && rm shiny-server-1.5.0.730-amd64.deb \
          && mkdir -p /srv/shiny-server; sync  \
          && mkdir -p  /srv/shiny-server/examples; sync \
          && cp -R /usr/local/lib/R/site-library/shiny/examples/* /srv/shiny-server/examples/. 
          
RUN  R -e "install.packages('rmarkdown', repos='http://cran.rstudio.com/')" \
          && cp -R /usr/local/lib/R/site-library/markdown/examples/* /srv/shiny-server/examples/.

##startup scripts  
#Pre-config scrip that maybe need to be run one time only when the container run the first time .. using a flag to don't 
#run it again ... use for conf for service ... when run the first time ...
RUN mkdir -p /etc/my_init.d
COPY startup.sh /etc/my_init.d/startup.sh
RUN chmod +x /etc/my_init.d/startup.sh

##Adding Deamons to containers
RUN mkdir /etc/service/shiny-server /var/log/shiny-server ; sync 
RUN mkdir /etc/service/shiny-server/log
COPY shiny-server.sh /etc/service/shiny-server/run
COPY shiny-server-log.sh /etc/service/shiny-server/log/run
RUN chmod +x /etc/service/shiny-server/run /etc/service/shiny-server/log/run \
    && cp /var/log/cron/config /var/log/shiny-server/ \
    && chown -R shiny /var/log/shiny-server

#volume for Shiny Apps and static assets. Here is the folder for index.html(link) and sample apps.
VOLUME /srv/shiny-server

# to allow access from outside of the container  to the container service
# at that ports need to allow access from firewall if need to access it outside of the server. 
EXPOSE 3838

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

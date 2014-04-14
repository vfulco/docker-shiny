# Shiny container
# VERSION               0.1.0
FROM angelrr7702/ubuntu-13.10-sshd
MAINTAINER Angel Rodriguez  "angelrr7702@gmail.com"
RUN echo "deb http://archive.ubuntu.com/ubuntu saucy-backports main restricted universe" >> /etc/apt/sources.list
RUN (echo "deb http://cran.mtu.edu/bin/linux/ubuntu saucy/" >> /etc/apt/sources.list && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9)
RUN (DEBIAN_FRONTEND=noninteractive apt-get update && DEBIAN_FRONTEND=noninteractive apt-get upgrade -y -q && DEBIAN_FRONTEND=noninteractive apt-get dist-upgrade -y -q )
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y -q r-base r-base-dev gdebi-core libapparmor1 supervisor sudo libcurl4-openssl-dev
RUN R -e "install.packages('shiny', repos='http://cran.rstudio.com/')"
RUN (wget http://download3.rstudio.org/ubuntu-12.04/x86_64/shiny-server-1.0.0.42-amd64.deb && gdebi --n shiny-server-1.0.0.42-amd64.deb)
RUN (rm shiny-server-1.0.0.42-amd64.deb && mkdir -p /srv/shiny-server)
RUN cp -R /usr/local/lib/R/site-library/shiny/examples/* /srv/shiny-server/.
RUN mkdir -p /var/log/supervisor
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf
EXPOSE 3838 22
CMD ["/usr/bin/supervisord"]

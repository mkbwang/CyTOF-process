FROM r-base:3.6.3
LABEL maintainer="Mukai Wang <mkbobbywang@gmail.com>"  



# Make an R directory
RUN mkdir /home/prep

ARG WHEN

COPY install_packages.R /home/prep/install_packages.R



CMD cd /home/prep \ 
  && R -e "source('install_packages.R')"

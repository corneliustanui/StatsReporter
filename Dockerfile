# get base image of R shiny, use installed version of R
FROM rocker/shiny:4.3.1

# install all packages used by this app
RUN install2.r rsconnect tidyverse shinydashboard shinyWidgets shinycssloaders plotly DT magrittr renv 

# create image's work dir
WORKDIR /StatsReporter

# copy files from remote repo(GitHub) work dir to image ork dir
# to copy all files at once (keeping folder structure), use "COPY . .""
COPY ./app.R /StatsReporter/app.R
COPY ./deploy.R /StatsReporter/deploy.R

COPY ./Funs /StatsReporter/Funs/ 

# run the deploy script
CMD Rscript deploy.R
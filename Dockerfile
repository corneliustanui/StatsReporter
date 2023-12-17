# get base image of R shiny, use installed version of R
FROM rocker/shiny:4.3.1

# install all packages used by this app
RUN install2.r rsconnect tidyverse shinydashboard shinyWidgets shinycssloaders plotly DT magrittr renv markdown

# create image's work dir
WORKDIR /REPORTER

# copy files from remote repo(GitHub) work dir to image ork dir
# to copy all files at once (keeping folder structure), use "COPY . .""
COPY ./ui.R /REPORTER/ui.R
COPY ./server.R /REPORTER/server.R
COPY ./app.R /REPORTER/app.R
COPY ./deploy.R /REPORTER/deploy.R

COPY ./Funs /REPORTER/Funs/
COPY ./www /REPORTER/www/ 

# run the deploy script
CMD Rscript deploy.R

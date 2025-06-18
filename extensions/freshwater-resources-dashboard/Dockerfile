FROM r-base:4.2.2

## system libraries of general use
RUN apt-get update && apt-get install -y \
    sudo \
    curl \
    npm \
    libgtk2.0-0 \ 
    libgtk-3-0 \
    libgbm-dev \
    libnotify-dev \
    libgconf-2-4 \
    libnss3 \
    libxss1 \
    libasound2 \
    libxtst6 \
    xauth \
    xvfb \
    libcurl4-openssl-dev \
    libharfbuzz-dev \
    libfribidi-dev \
    gdal-bin \
    libgdal-dev \
    libfontconfig1-dev

ENV RENV_VERSION 0.17.3

## install node
RUN curl -sL https://deb.nodesource.com/setup_18.x | bash -
RUN apt-get install -y nodejs

## set up R Shiny
WORKDIR /renewflow
COPY . .
COPY .rhino/package.json .rhino/package.json
COPY .rhino/package-lock.json .rhino/package-lock.json

## setting up cypress and dependencies
WORKDIR /renewflow/.rhino
RUN npm install
WORKDIR /renewflow

## installing R packages
RUN R -e "install.packages('remotes', repos = c(CRAN = 'https://cloud.r-project.org'))"
RUN R -e "remotes::install_github('rstudio/renv@${RENV_VERSION}')"
RUN R -e "renv::restore();"
RUN R -e "rhino::lint_r();"
RUN R -e "rhino::lint_sass();"
RUN R -e "rhino::lint_js();"
RUN R -e "rhino::test_r();"
RUN R -e "rhino::test_e2e();"

## expose port for Shiny
EXPOSE 9999

## run R Shiny
CMD ["R", "-s", "-e", "shiny::runApp(host = '0.0.0.0', port = 9999)"]

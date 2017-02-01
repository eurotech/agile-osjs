FROM resin/raspberrypi2-debian:jessie-20161010

MAINTAINER Dagmawi Neway <d_mekuria@create-net.org>
USER root

## Initial update of image ##
RUN apt-get -y update

## Install dependencies and build tools. ##
RUN apt-get -y install git npm nodejs-legacy

## Clone the  Repo and install grunt ##
COPY OS.js OS.js
RUN npm install -g grunt-cli supervisor

## Install and build OS.js ##
WORKDIR OS.js/
RUN npm install --production
RUN grunt

## Install Grafana menu item
COPY agile-grafana-osjs src/packages/default/Grafana
RUN grunt manifest config packages:default/Grafana

## Install InfluxDB menu item
COPY agile-influxdb-osjs src/packages/default/InfluxDB
RUN grunt manifest config packages:default/InfluxDB

## Install Node red menu item
COPY osjs-nodered src/packages/default/NodeRed
RUN grunt manifest config packages:default/NodeRed

## Install Node red Dashboard
COPY agile-nodered-dashboard-osjs src/packages/default/NodeRedDashboard
RUN grunt manifest config packages:default/NodeRedDashboard

## Install Agile Device Manager
COPY agile-osjs-devicemanager src/packages/default/DeviceManager
RUN grunt manifest config packages:default/DeviceManager

## Start Application and Expose Port ##
## Note: you can change 'start-dev.sh' (Development Version) to 'start-dist.sh' (Production Version) ##

CMD ./bin/start-dev.sh
EXPOSE 8000:8000

FROM resin/raspberrypi2-debian:jessie-20161010

## Install dependencies and build tools. ##
RUN apt-get update && apt-get install --no-install-recommends -y \
  git \
  npm \
  nodejs-legacy \
  && apt-get clean && rm -rf /var/lib/apt/lists/*

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

## Install Node red Graphs
COPY agile-contri-ui-osjs src/packages/default/NodeRedUI
RUN grunt manifest config packages:default/NodeRedUI

## Install Agile Device Manager
COPY agile-osjs-devicemanager src/packages/default/DeviceManager
RUN grunt manifest config packages:default/DeviceManager

## Install Agile Kura
COPY agile-kura-osjs src/packages/default/Kura
RUN grunt manifest config packages:default/Kura

## Start Application and Expose Port ##
## Note: you can change 'start-dev.sh' (Development Version) to 'start-dist.sh' (Production Version) ##

CMD ./bin/start-dev.sh
EXPOSE 8000:8000

FROM centos:7

RUN apt-get update && apt-get install -y \
  epel-release \
  rpmbuild \
  nodejs \
  npm

RUN npm install -g gulp

CMD ["build"]
ENTRYPOINT 'gulp'

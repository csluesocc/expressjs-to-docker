FROM debian:wheezy

RUN apt-get update \
 && apt-get install -y --force-yes \
      apt-transport-https \
      build-essential \
      curl \
      lsb-release \
      python-all \
      rlwrap \
 && rm -rf /var/lib/apt/lists/*;

RUN curl https://deb.nodesource.com/node012/pool/main/n/nodejs/nodejs_0.12.0-1nodesource1~wheezy1_amd64.deb > node.deb \
 && dpkg -i node.deb \
 && rm node.deb

RUN npm install -g pangyp\
 && ln -s $(which pangyp) $(dirname $(which pangyp))/node-gyp\
 && npm cache clear\
 && node-gyp configure || echo ""

# Bundle app source
COPY . /usr/src/expressjs-to-docker

# Install app dependencies
RUN cd /usr/src/expressjs-to-docker; npm install

EXPOSE 8080

ENV NODE_ENV production

WORKDIR /usr/src/expressjs-to-docker

CMD ["npm","start"]

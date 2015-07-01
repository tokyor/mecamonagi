FROM rocker/hadleyverse

RUN install2.r \
	Rserve

RUN apt-get update && apt-get install -y nodejs npm
RUN update-alternatives --install /usr/bin/node node /usr/bin/nodejs 10
RUN npm install -g --upgrade npm
RUN npm install -g --unsafe-perm hubot coffee-script yo generator-hubot

# Create hubot user
RUN useradd -d /hubot -m -s /bin/bash -U hubot

# Log in as hubot user and change directory
USER    hubot
WORKDIR /hubot

# Install hubot
RUN yo hubot --owner="You" --name="HuBot" --description="HuBot on Docker" --defaults
RUN npm install hubot-slack rserve-client --save && npm install

ADD mecamonagi.coffee /hubot/scripts/
CMD R CMD Rserve --vanilla && bin/hubot -a slack

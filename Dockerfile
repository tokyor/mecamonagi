FROM rocker/hadleyverse

# Install R packages (please list up in alphabetical order) -----------
RUN install2.r \
	Rserve \
	choroplethr \
	choroplethrAdmin1 \
	ggmap \
	pipeR \
	rlist

RUN installGithub.r \
	dichika/jaguchi \
	hoxo-m/pforeach \
	sinhrks/ggfortify \
	uribo/Japan.useR

# Install Node.js -----------------------------------------------------
RUN apt-get update && apt-get install -y nodejs npm
RUN update-alternatives --install /usr/bin/node node /usr/bin/nodejs 10
RUN npm install -g --upgrade npm
RUN npm install -g --unsafe-perm hubot coffee-script yo generator-hubot

# Install hubot -------------------------------------------------------
# Create hubot user
RUN useradd -d /hubot -m -s /bin/bash -U hubot

# Log in as hubot user and change directory
USER    hubot
WORKDIR /hubot

# Install hubot
RUN yo hubot --owner="You" --name="HuBot" --description="HuBot on Docker" --defaults
RUN npm install hubot-slack rio --save && npm install

# Add scripts ---------------------------------------------------------
ADD mecamonagi.coffee /hubot/scripts/
COPY R /hubot/scripts/R
ADD .Rprofile /hubot/
ADD Rserv.conf /etc/

# Run Rserve and hubot (Note: use "env -i" to ignore env vars such as SLACK_WEB_API_TOKEN)
CMD env -i R CMD Rserve --vanilla && bin/hubot -a slack

A Docker Image for hubot that can talk R
========================================

*Note that the heart of this hubot is made by @teramonagi. Thanks for your great work!*

# Run

```sh
git clone https://github.com/yutannihilation/docker-hubot-rserve.git
docker build -t hubot-rserve docker-hubot-rserve
docker run -e HUBOT_SLACK_TOKEN=XXXXXXXXXX hubot-rserve -d
```

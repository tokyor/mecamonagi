A Docker Image for hubot that can talk R (a.k.a. mecamonagi)
========================================

**Note that the heart of this hubot is made by @teramonagi. Thanks for your great work!**

# Pull

hubot-rserve Docker image is now on Docker Hub: https://registry.hub.docker.com/u/yutannihilation/hubot-rserve/

```sh
docker pull yutannihilation/hubot-rserve
```

# Run

## 1. Configure Hubot Integration

You can configure the intagration here: https://YOURTEAM.slack.com/services/new/hubot

You will find "API Token", which you will use on the next step.

## 2. Run Docker

```sh
docker run -e HUBOT_SLACK_TOKEN=XXXXXXXXXX hubot-rserve -d
```

## 3. Talk To Hubot

This hubot can execute arbitary R scripts like this:

```sh
r! summary(lm(speed~dist,data=cars)) 
```

The hubot answers immediately like this:

![screen](screenshot.png)

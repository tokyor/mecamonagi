# Auther: @teramonagi
rio = require('rio')
path = require('path')

module.exports = (robot) ->
  robot.hear /ping/i, (res) ->
    res.emote "pong"
  
  robot.respond /ping/i, (res) ->
    res.reply "pong"

  robot.respond /open the (.*) doors/i, (res) ->
    doorType = res.match[1]
    if doorType is "pod bay"
      res.reply "I'm afraid I can't let you do that."
    else
      res.reply "Opening #{doorType} doors"
  
  robot.hear /I like pie/i, (res) ->
    res.emote "makes a freshly baked pie"
  
  robot.hear /^(r\!)(\s|\n)+([^\s\n][\s\S]*)/i, (msg)->
    params = {
      script: Buffer(msg.match[3].trim()).toString('base64')
    }

    rio.sourceAndEval(path.join(__dirname, "R", "simple_exec.R"), {
      entryPoint: "simple_exec",
      data: params,
      callback: (err, ans_raw) ->
        ans = JSON.parse(ans_raw)
        # debug
        console.log(JSON.stringify(ans))

        # err can be true when no output is aquired; so we have to rely on typeof
        if ans.error
          msg.emote "Error!"
          msg.emote "```\n" + ans.error + "\n```"
        if ans.warning
          msg.emote "Warning..."
          msg.emote "```\n" + ans.warning + "\n```"
        if ans.result
          msg.emote "```\n" + Buffer(ans.result, 'base64').toString() + "\n```"
        msg.emote "This is the result by mecamonagi :)"
    })

  robot.hear /^(weather\!)(\s|\n)+([^\s\n][\s\S]*)/i, (msg)->
    location = msg.match[3].trim()
    script = "library(jsonlite); library(RCurl); fromJSON(getURLContent(\"http://api.openweathermap.org/data/2.5/weather?q=#{location}\"))$weather$main"
    script_wrapped = "paste(capture.output({" + script + "}), collapse='\n')"
    rio.evaluate(script_wrapped, {callback: (err, ans) ->
      # debug
      console.log("Result:\n" + ans)
      console.log("Error:\n" + err)
	
      msg.emote "```\n" + ans + "\n```"
    })

  robot.hear /^(plot\!)(\s|\n)+([^\s\n][\s\S]*)/i, (msg)->
    params = {
      script: Buffer(msg.match[3].trim()).toString('base64'),
      web_api_token: process.env.SLACK_WEB_API_TOKEN,
      channel: msg.message.room
    }

    rio.sourceAndEval(path.join(__dirname, "R", "simple_exec.R"), {
      entryPoint: "simple_plot",
      data: params,
      callback: (err, ans_raw) ->
        ans = JSON.parse(ans_raw)
        # debug
        console.log(JSON.stringify(ans))

        # err can be true when no output is aquired; so we have to rely on typeof
        if ans.error
          msg.emote "Error!"
          msg.emote "```\n" + ans.error + "\n```"
        if ans.warning
          msg.emote "Warning..."
          msg.emote "```\n" + ans.warning + "\n```"
        if ans.result
          msg.emote "```\n" + ans.result + "\n```"
        msg.emote "This is the result by mecamonagi :)"
    })

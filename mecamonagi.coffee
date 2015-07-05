# Auther: @teramonagi
rio = require('rio')

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
    script = msg.match[3].trim()
    script_wrapped = "paste(capture.output({" + script + "}), collapse='\n')"
    rio.evaluate(script_wrapped, {callback: (err, ans) ->
      # debug
      console.log("Result:\n" + ans)
      console.log("Error:\n" + err)

      # err can be true when no output is aquired; so we have to rely on typeof
      if typeof err == "string"
        msg.emote "Error!\n```\n" + err + "```"
      else if ans?
        msg.emote "```\n" + ans + "\n```"
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
    script = msg.match[3].trim()
    script_wrapped = "f <- tempfile(fileext = '.png'); png(f);" +
                     script + ";" +
                     "dev.off();" +
                     "res <- knitr::imgur_upload(f, '" + process.env.IMGUR_CLIENT_ID + "');" +
                     "paste(capture.output({as.character(res)}))"
    rio.evaluate(script_wrapped, {callback: (err, ans) ->
      # debug
      console.log("Result:\n" + ans)
      console.log("Error:\n" + err)

      # err can be true when no output is aquired; so we have to rely on typeof
      if typeof err == "string"
        msg.emote "Error!\n```\n" + err + "```"
      else if ans?
        msg.emote ans 
      msg.emote "This is the result by mecamonagi :)"
    })


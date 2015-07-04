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
      msg.emote "```\n" + ans + "\n```"
      msg.emote "This is the result by mecamonagi :)"
      console.log(ans)
    })
 

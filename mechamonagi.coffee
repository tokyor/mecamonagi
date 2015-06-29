# Auther: @teramonagi

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
    head = "paste(capture.output({"    
    tail = "}), collapse='\n')"
    r = require('rserve-client')
    r.connect('localhost', 6311, (err, client) -> 
      client.evaluate( (head + script + tail), (err, ans) ->
        console.log(ans.toString())
        msg.emote(ans.toString())
        msg.emote "This is the result by mechamonagi :)"
        client.end()
      )
    )

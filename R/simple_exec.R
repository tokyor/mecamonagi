# simply run arbitrary script and get result
library(jsonlite)

wrap_func <- function(fun) {
  function(params) {
    warn <- err <- NULL
    params <- fromJSON(params)

    res <- withCallingHandlers(
             tryCatch(fun(params),
               error = function(e) {
                 err <<- conditionMessage(e)
                 NULL
               }),
               warning = function(w) {
                 warn <<- append(warn, conditionMessage(w))
                 invokeRestart("muffleWarning")
               })

    result_json <- toJSON(list(result = res, warning = warn, error = err),
                          auto_unbox = TRUE, null = "null")
  
    as.character(result_json)
  }
}


simple_exec_ <- function(params) {
  paste0(capture.output({
    eval(parse(text = RCurl::base64Decode(params$script)))
  }), collapse = "\n")
}

simple_exec <- wrap_func(simple_exec_)


simple_plot_ <- function(params) {
  f <- tempfile(fileext = '.png')
  png(f)
  print(eval(parse(text = RCurl::base64Decode(params$script))))
  dev.off()

  library(httr)
  channels_raw <- POST("https://slack.com/api/channels.list", body = list(token = params$web_api_token))
  channels <- fromJSON(content(channels_raw, as = "text"))$channels
  channel_id  <- channels[channels$name == params$channel, "id"]
  res <- POST(url = "https://slack.com/api/files.upload", add_headers(`Content-Type` = "multipart/form-data"), 
        body = list(file = upload_file(f), token = params$web_api_token, 
        channels = channel_id))
  NULL
}

simple_plot <- wrap_func(simple_plot_)

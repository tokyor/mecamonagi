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

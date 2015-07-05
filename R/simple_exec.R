# simply run arbitrary script and get result
library(jsonlite)

simple_exec <- function(params) {
  warn <- err <- NULL
  script <- fromJSON(params)$script

  res <- withCallingHandlers(
           tryCatch(eval(parse(text = script)),
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

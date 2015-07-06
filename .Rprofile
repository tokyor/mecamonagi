# avoid interaction when installing packages --------------------
user_dir <- Sys.getenv("R_LIBS_USER")

if (!dir.exists(user_dir)) dir.create(user_dir, recursive = TRUE)
.libPaths( c(Sys.getenv("R_LIBS_USER"), .libPaths()) )

repo_opt <- getOption("repos")
repo_opt["CRAN"] <- "http://cran.rstudio.com"
options(repos=repo_opt)


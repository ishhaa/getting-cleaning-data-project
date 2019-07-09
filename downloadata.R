source("utility.R")

download.data <- function () {
 
  current.wd <- get.filepath()
  dataset.folder <- file.path(current.wd, 'dataset')
  
  if (!file.exists(dataset.folder)){
    dir.create(dataset.folder)
  }
  
  zip.url <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
  zip.file <- file.path(dataset.folder, 'dataset.zip')
  
  download.file(zip.url, destfile=zip.file, method='curl')
  unzip(zip.file, exdir=current.wd)
}

download.data()

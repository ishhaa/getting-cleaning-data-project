get.filepath <- function() {
  
  frame_files <- lapply(sys.frames(), function(x) x$ofile)
  frame_files <- Filter(Negate(is.null), frame_files)
  path <- dirname(frame_files[[length(frame_files)]])
  path  
}

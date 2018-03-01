

rtpFunc <- function()
{
  # Create a randomized real time pricing scheme.
  rtp <- c(runif(16, min=0.1, max=0.5), runif(4, min=0.5, max=1.0), runif(4, min=0.1, max=0.5))
  #rtp <- mapply( time.frame, FUN=function(x) if( x %in% peak.hour ) 1 else 0.5 )
  return(rtp) 
}
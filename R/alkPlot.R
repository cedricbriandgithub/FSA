#' @title Plots to visualize age-length keys.
#' 
#' @description Various plots to visualize the proportion of fish of certain ages within length intervals in an age-length key.
#' 
#' @details A variety of plots can be used to visualize the proportion of fish of certain ages within length intervals of an age-length key.  The types of plots are described below and illustrated in the examples.
#' \itemize{
#'   \item A \dQuote{stacked} bar chart where vertical bars over length intervals sum to 1 but are segmented by the proportion of each age in that length interval is constructed with \code{type="barplot"}.  The ages will be labeled in the bar segments unless \code{showLegend=TRUE} is used.
#'   \item A \dQuote{stacked} area chart similar to the bar chart described above is constructed with \code{type="area"}.
#'   \item A plot with (differently colored) lines that connect the proportions of ages within each length interval is constructed with \code{type="lines"}.
#'   \item A plot with (differently colored) lines, as estimated by loess splines, that connect the proportions of ages within each length interval is constructed with \code{type="splines"}.
#'   \item A \dQuote{bubble} plot where circles whose size is proportional to the proportion of fish of each age in each length interval is constructed with \code{type="bubble"}.  The color of the bubbles can be controlled with \code{col=} and an underlying grid for ease of seeing the age and length interval for each bubble can be controlled with \code{grid=}.  Bubbles from a second age-length key can be overlaid on an already constructed bubble plot by using \code{add=TRUE} in a second call to \code{alkPlot}.
#' }
#' Note that all plots are \dQuote{vertically conditional} -- i.e., each represents the proportional ages WITHIN each length interval.
#' 
#' @param key A numeric matrix that contains the age-length key.
#' @param type A string that indicates the type of plot to construct.  See details.
#' @param xlab,ylab A string that contains the label for the x- or y-axis.
#' @param xlim,ylim A numeric of length 2 that provide the limits for the x-axis or y-axis.
#' @param showLegend A logical that indicates whether a legend should be displayed (not implemented for \code{type="bubble"}).  See examples.
#' @param lbl.cex A numeric character expansion value for labels inside the bars when \code{type="barplot"} or on the lines when \code{type="lines"} or \code{type="splines"}.  Only used if \code{showLegend=FALSE}.
#' @param leg.cex A numeric character expansion value for labels on the legend when \code{showLegend=TRUE}.
#' @param lwd A numeric that indicates the line width when \code{type="lines"} or \code{type="splines"}.
#' @param span A numeric that indicates the span value to use in \code{loess} when \code{type="splines"}.
#' @param pal A string that indicates the palette to generate colors for the bars, areas, lines, or spline lines.  The name of a palette must be one of \dQuote{rich}, \dQuote{cm}, \dQuote{default}, \dQuote{grey}, \dQuote{gray}, \dQuote{heat}, \dQuote{jet}, \dQuote{rainbow}, \dQuote{topo}, or \dQuote{terrain}.  See \code{\link{chooseColors}}.
#' @param grid A logical that indicates whether a grid should be placed under the bubbles when \code{type="bubble"} or a character or appropriate vector that identifies a color for the grid.  See examples.
#' @param col A string that indicates the color of the bubbles when \code{type="bubble"}.
#' @param buf A single numeric that indicates the relative width of the bubbles when \code{type="bubble"}.  A value of 0.5 means that two full-width bubbles would touch each other either in the x- or y-direction (i.e., this would represent half of the minimum of the physical distance between values one-unit apart on the x- and y-axes).  Set this to a value less than 0.5 so that the bubbles will not touch (the default is 0.45).
#' @param add A logical that indicates whether the data should be added to an already existing plot.  May be useful for visually comparing age-length keys.  Only implemented when \code{type="bubble"}.
#' @param \dots Additional arguments to pass to \code{plot} or \code{barplot}.
#' 
#' @return None, but a plot is constructed.
#' 
#' @author Derek H. Ogle, \email{derek@@derekogle.com}
#' 
#' @section IFAR Chapter: 5-Age-Length Key.
#' 
#' @seealso See \code{\link{alkIndivAge}} for using an age-length key to assign ages to individual fish.
#' 
#' @references Ogle, D.H.  2016.  \href{http://derekogle.com/IFAR}{Introductory Fisheries Analyses with R}.  Chapman & Hall/CRC, Boca Raton, FL.
#' 
#' @keywords plot
#' 
#' @examples
#' ## Make an example age-length key
#' data(WR79)
#' WR.age <- subset(WR79, !is.na(age))      # isolate the age sample
#' WR.age$LCat <- lencat(WR.age$len,w=5)    # add length intervals (width=5)
#' raw <- xtabs(~LCat+age,data=WR.age)      # create age-length key
#' ( WR.key <- prop.table(raw, margin=1) )
#'
#' ## Various visualizations of the age-length key
#' alkPlot(WR.key,"barplot")
#' alkPlot(WR.key,"barplot",pal="gray")
#' alkPlot(WR.key,"barplot",showLegend=TRUE)
#' alkPlot(WR.key,"area")
#' alkPlot(WR.key,"area",showLegend=TRUE)
#' alkPlot(WR.key,"area",pal="gray")
#' alkPlot(WR.key,"lines")
#' alkPlot(WR.key,"lines",pal="gray")
#' alkPlot(WR.key,"lines",showLegend=TRUE)
#' alkPlot(WR.key,"splines")
#' alkPlot(WR.key,"splines",span=0.2)
#' alkPlot(WR.key,"splines",pal="gray",showLegend=TRUE)
#' alkPlot(WR.key,"bubble")
#' alkPlot(WR.key,"bubble",grid=FALSE)
#' alkPlot(WR.key,"bubble",grid="blue")
#' alkPlot(WR.key,"bubble",grid=rgb(0,0,0,0.2),col=rgb(0,0,0,0.5))
#'
#' @export alkPlot
#' @rdname alkPlot
alkPlot <- function(key,type=c("barplot","area","lines","splines","bubble"),
                    xlab="Length",ylab=ifelse(type!="bubble","Proportion","Age"),
                    xlim=NULL,ylim=NULL,
                    showLegend=FALSE,lbl.cex=1.25,leg.cex=1,
                    lwd=2,span=0.25,
                    pal = paletteChoices(),
                    grid=TRUE,col="gray80",buf=0.45,add=FALSE,
                    ...) {
  ## Some checks
  type <- match.arg(type)
  pal <- match.arg(pal)
  key <- iCheckALK(key)
  ## construct the plots (all internal functions) # nocov start
  op <- graphics::par(mar=c(3.25,3.25,0.7,0.7),mgp=c(1.7,0.5,0),tcl=-0.2)
  switch(type,
         area=    { iALKPlotArea(key,xlab,ylab,xlim,ylim,showLegend,leg.cex,pal) },
         barplot= { iALKPlotBar(key,xlab,ylab,xlim,ylim,lbl.cex,showLegend,leg.cex,pal,...) },
         bubble=  { iALKPlotBubble(key,xlab,ylab,xlim,ylim,grid,buf,col,add,...) },
         lines=   { iALKPlotLines(key,lwd,xlab,ylab,xlim,ylim,lbl.cex,pal,showLegend,leg.cex,...) },
         splines= { iALKPlotSplines(key,lwd,xlab,ylab,xlim,ylim,lbl.cex,span,pal,showLegend,leg.cex,...) }
  )
  ## return to original graphing parameters
  graphics::layout(1)
  graphics::par(op) # nocov end
}


##############################################################
## INTERNAL -- Identify the ages and lengths in the key
##   and the number of each
##############################################################
iFindAgesAndLens <- function(key) {
  ages <- as.numeric(colnames(key))
  num.ages <- length(ages)  
  lens <- as.numeric(rownames(key))
  num.lens <- length(lens)
  list(num.ages=num.ages,ages=ages,num.lens=num.lens,lens=lens)
}

##############################################################
## INTERNAL -- Add a legend
##############################################################
iAddLegend <- function(alsum,leg.cex,col){ # nocov start
  graphics::layout(matrix(c(1,2),nrow=2),heights=c(1,14))
  tmp <- graphics::par("mar")
  op <- graphics::par(mar=c(0.1,1.5*tmp[2],0.1,4*tmp[4]))
  graphics::barplot(matrix(1,nrow=alsum$num.ages,ncol=1),col=col,horiz=TRUE,xaxt="n")
  graphics::text(c(1,alsum$num.ages)-0.5,c(0.75,0.75),range(alsum$ages),
                 col=c("white","black"),cex=leg.cex) 
  graphics::par(op)
}  # nocov end

##############################################################
## INTERNAL -- Add age labels to lines in line and spline plots
##############################################################
iLinesAddLabelsToLines <- function(maxvals,lbl.cex) { # nocov start
  graphics::text(maxvals[,1],maxvals[,2],maxvals[,3],cex=lbl.cex)
} # nocov end

##############################################################
## INTERNAL -- Add age labels to lines in line and spline plots
##############################################################
iAdjKey4xlim <- function(key,xlim) {
  if (!is.null(xlim)) {
    # make sure values are in ascending order
    xlim <- xlim[order(xlim)]
    # reduce rows of keys down to values that are between xlim values
    tmp <- as.numeric(row.names(key))
    key <- key[which(tmp>=xlim[1] & tmp<=xlim[2]),]
    # remove columns (ages) that don't have any values
    key <- key[,which(colSums(key)!=0)]
    if (!is.matrix(key)) STOP("'xlim' is too restrictive (only one age).")
  }
  key
}

##############################################################
## Internal function to make the area plot
##############################################################
iALKPlotArea <- function(key,xlab,ylab,xlim,ylim,showLegend,leg.cex,pal) { # nocov start
  if (any(is.na(rowSums(key)))) {
    tmp <- which(is.na(rowSums(key)))
    key[tmp,] <- 0
  }
  # adjust key for xlim values
  key <- iAdjKey4xlim(key,xlim)
  alsum <- iFindAgesAndLens(key)
  col <- chooseColors(pal,alsum$num.ages)
  if (showLegend) iAddLegend(alsum,leg.cex,col)
  # convert NULL y-axis limits to NA for use with stackpoly
  if (is.null(ylim)) ylim <- NA
  plotrix::stackpoly(key,stack=TRUE,col=col,axis4=FALSE,
                     xlab=xlab,ylab=ylab,xaxt="n",xat=0,ylim=ylim)
  graphics::axis(1,1:alsum$num.lens,alsum$lens)
}   # nocov end

##############################################################
## Internal function to make the bar plot
##############################################################
## ===========================================================
## INTERNAL -- Add age labels inside of bars on barplot
## ===========================================================
iBarplotAddLabelsToBars <- function(key,alsum,lbl.cex,col,...) { # nocov start
  # Make colors for the age labels inside the bars (dark on light, light on dark)
  age.clr <- rep("black",alsum$num.ages)
  age.clr[which(colMeans(grDevices::col2rgb(col))<120)] <- "white"
  # Add the age labels inside the bars    
  for (i in 1:alsum$num.lens) {
    if (!all(is.na(key[i,]))) { # don't put labels if length is all NA
      j <- 1
      if(key[i,j]>0) graphics::text(i-0.5,key[i,j]/2,alsum$ages[j],col=age.clr[j],cex=lbl.cex)
      prv <- key[i,j]
      while(prv<1 & j<alsum$num.ages) {
        j <- j+1
        if(key[i,j]>0) graphics::text(i-0.5,prv+key[i,j]/2,alsum$ages[j],col=age.clr[j],cex=lbl.cex)
        prv <- prv+key[i,j]
      }
    }
  }
} # nocov end

iALKPlotBar <- function(key,xlab,ylab,xlim,ylim,lbl.cex,showLegend,leg.cex,pal,...) { # nocov start
  # adjust key for xlim values
  key <- iAdjKey4xlim(key,xlim)
  alsum <- iFindAgesAndLens(key)
  col <- chooseColors(pal,alsum$num.ages)
  if (showLegend) iAddLegend(alsum,leg.cex,col)
  graphics::barplot(t(key),space=0,col=col,xlab=xlab,ylab=ylab,ylim=ylim,...)
  if (!showLegend) iBarplotAddLabelsToBars(key,alsum,lbl.cex,col)
} # nocov end

##############################################################
## Internal function to make the lines plot
##############################################################
iALKPlotLines <- function(key,lwd,xlab,ylab,xlim,ylim,lbl.cex,pal,showLegend,leg.cex,...) { # nocov start
  alsum <- iFindAgesAndLens(key)
  col <- chooseColors(pal,alsum$num.ages)
  if (showLegend) iAddLegend(alsum,leg.cex,col)
  if (is.null(xlim)) xlim <- range(alsum$lens)
  if (is.null(ylim)) ylim <- c(0,1)
  graphics::plot(NA,xlim=xlim,ylim=ylim,xlab=xlab,ylab=ylab,...)
  maxvals <- matrix(NA,nrow=alsum$num.ages,ncol=3)
  for(i in 1:alsum$num.ages) {
    graphics::lines(alsum$lens,key[,i],col=col[i],lwd=lwd)
    tmp <- min(which(key[,i]==max(key[,i],na.rm=TRUE)))
    maxvals[i,] <- c(alsum$lens[tmp],key[tmp,i],alsum$ages[i])
  }
  if (!showLegend) iLinesAddLabelsToLines(maxvals,lbl.cex)  
} # nocov end

##############################################################
## Internal function to make the splines plot
##############################################################
iALKPlotSplines <- function(key,lwd,xlab,ylab,xlim,ylim,lbl.cex,span,pal,showLegend,leg.cex,...) { # nocov start
  alsum <- iFindAgesAndLens(key)
  col <- chooseColors(pal,alsum$num.ages)
  if (showLegend) iAddLegend(alsum,leg.cex,col)
  if (is.null(xlim)) xlim <- range(alsum$lens)
  if (is.null(ylim)) ylim <- c(0,1)
  graphics::plot(NA,xlim=xlim,ylim=ylim,xlab=xlab,ylab=ylab,...)
  plens <- seq(min(alsum$lens),max(alsum$lens),0.1)
  maxvals <- matrix(NA,nrow=alsum$num.ages,ncol=3)
  lens <- alsum$lens  # needed for making predictions below    
  for(i in 1:alsum$num.ages) {
    tmp <- key[,i]
    options(warn=-1)
    tmp <- stats::loess(tmp~lens,span=span)
    options(warn=0)
    pprob <- stats::predict(tmp,data.frame(lens=plens))
    graphics::lines(plens,pprob,col=col[i],lwd=lwd)
    tmp <- min(which(pprob==max(pprob)))
    maxvals[i,] <- c(plens[tmp],pprob[tmp],alsum$ages[i])
  }
  if (!showLegend) iLinesAddLabelsToLines(maxvals,lbl.cex)
} # nocov end

##############################################################
## Internal function to create the bubble plot
##############################################################
## ===========================================================
## convert the key to a data.frame for the bubble plot
## ===========================================================
iBubbleUnmatKey <- function(key,alsum) {
  tmpK <- data.frame(len=rep(alsum$lens,times=alsum$num.ages),
                     age=rep(alsum$ages,each=alsum$num.lens),
                     prop=as.vector(key))
  tmpK[tmpK$prop>0,]
}

## ===========================================================
## find inches argument (scale of radius for bubbles)
## ===========================================================
iBubbleFindIn <- function(alsum,buf) {
  # find "inches" between concurrent values on the X,Y user scales
  tmpX <- graphics::grconvertX(alsum$lens[1:2],"user","inches")
  tmpY <- graphics::grconvertY(alsum$ages[1:2],"user","inches")
  # find minimum diff in X,Y inches per 1 concurrent set of values of user scale * the buffer
  min(diff(tmpX),diff(tmpY))*buf
}

## ===========================================================
## INTERNAL -- add bubles to an existing plot
## ===========================================================
iBubblesAdd <- function(key,alsum,buf,col) { # nocov start
  tmp <- iBubbleUnmatKey(key,alsum)
  with(tmp,symbols(len,age,circles=sqrt(tmp$prop),inches=iBubbleFindIn(alsum,buf),
                   bg=col,fg=grDevices::rgb(0,0,0,0.5),add=TRUE))
} # nocov end

iALKPlotBubble <- function(key,xlab,ylab,xlim,ylim,grid,buf,col,add,...) { # nocov start
  # if grid is a logical and is TRUE then give default color, if FALSE then set to NULL
  if (is.logical(grid)) {
    if (grid) grid <- "gray80"
    else grid <- NULL
  } 
  alsum <- iFindAgesAndLens(key)
  if (!add) {
    # not adding to an existing bubble plot, so make the base plot
    if (is.null(xlim)) xlim <- range(alsum$lens)+c(-1,1)*buf
    if (is.null(ylim)) ylim <- range(alsum$ages)+c(-1,1)*buf
    graphics::plot(NA,xlim=xlim,ylim=ylim,xlab=xlab,ylab=ylab,...)
    if (!is.null(grid)) {
      graphics::abline(h=alsum$ages,col=grid,lty=2)
      graphics::abline(v=alsum$lens,col=grid,lty=2)
    }
  }
  iBubblesAdd(key,alsum,buf,col)
} # nocov end

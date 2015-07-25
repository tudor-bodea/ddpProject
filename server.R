##### LOAD REQUIRED LIBRARIES
library(shiny)
##### COMPUTE IDEAL WEIGHT (IW)
iwc <- function(gender, ft, inch){
    ### USE DEVINE'S 1974 FORMULA TO COMPUTE THE IW BY GENDER AND HEIGHT
    iw <- ifelse(gender == "1", 50.0 + ((ft - 5) * 12 + inch) * 2.3, 45.5 + ((ft - 5) * 12 + inch) * 2.3)
    ### RETURN IW IN KILOGRAMS AND POUNDS
    return(list(formatC(iw, format="f", digits=1), formatC(iw * 2.2046, format="f", digits=1)))
}

##### COMPUTE HEIGHT IN METRIC SYSTEM
hms <- function(ft, inch){
    h <- 2.54 * (12 * ft + inch)
    return(formatC(h, format="f", digits=0))
}

##### PLOT IDEAL WEIGHT AS A FUNCTION OF HEIGHT
plotiw <- function(gender, ft, inch, age){
    par(mar=c(5,5,5,5)+.1)
    ### PLOT BY GENDER
    h <- seq(5*12, 9*12)
    if(gender == "1") {iw <- 50 + (h - 5*12) * 2.3} else {iw <- 45.5 + (h - 5*12) * 2.3}
    iwUS <- iw * 2.2046
    plot(h, iwUS, xlim=range(h), ylim=c(100, 360), xlab="Height (ft.)", ylab="Ideal Weight (lbs.)", type="l", col="blue", lwd=2, xaxt = "n")
    axis(1, at=seq(5*12, 9*12, 12), labels=seq(5,9))
    axis(3, at=seq(5*12, 9*12, 12), labels=formatC(seq(5*12, 9*12, 12)*2.54, format="f", digits=0))
    mtext("Height (cm)",side=3,line=3)
    axis(4, at=seq(100, 350, 50), labels=formatC(seq(100, 350, 50)/2.2046, format="f", digits=0))
    mtext("Ideal Weight (kg)",side=4,line=3)
    ### PLOT YOU
    hy <- ft * 12 + inch
    ihy <- ifelse(gender == "1", 2.2046 * (50.0 + ((ft - 5) * 12 + inch) * 2.3), 2.2046 * (45.5 + ((ft - 5) * 12 + inch) * 2.3))
    points(hy, ihy, col="blue", pch=5, cex=1.25)
    text(hy, ihy, labels="You", col="blue", font=2, pos=3, offset=1)
    abline(v=hy, h=ihy, lty=2, col="grey75")
    text(5*12, 350, labels="You:", pos=4, col="blue", font=2)
    text(5*12, 330, labels=paste(age, " years old", sep=""), pos=4, col="blue", font=1)
    text(5*12, 310, labels=ifelse(gender=="1", "Male", "Female"), pos=4, col="blue", font=1)
    text(5*12, 290, labels=paste(ft, "' ", inch, "'' (", hms(ft, inch), " cm)", sep=""), pos=4, col="blue", font=1)
    text(6.5*12, 350, labels="Your Ideal Weight:", pos=4, col="blue", font=2)
    text(6.5*12, 330, labels=paste(iwc(gender, ft, inch)[[2]], " lbs (", iwc(gender, ft, inch)[[1]], " kg)", sep=""), pos=4, col="blue", font=1)
    polygon(x=c(hy-3, hy+3, hy+3, hy-3), y=c(0,0,500,500), col=rgb(153, 204, 255, 75, maxColorValue = 255), border=NA)
    ### LEGEND
    legend("bottomright", legend=c("Ideal Weight Curve", "You", "Your Ideal Weight Peers"), 
           fill=c(NA, NA, rgb(153, 204, 255, 75, maxColorValue = 255)), border=NA, col="blue", lty=c(1,NA, NA), 
           lwd=c(2, NA, NA), pch=c(NA, 5, NA), bty="n")
}

shinyServer(function(input, output) {
    output$all <- renderText({ 
        paste("You are ", input$age, " years old.", 
              " You are a ", ifelse("1" %in% input$gender, "male.", "female."), 
              " Your height is ", input$ft, "' ", input$inch, "''", 
              " (or, ", hms(input$ft, input$inch), " cm).", sep="")
    })
    output$weight <- renderText({ 
        paste("Your ideal weight is ", iwc(input$gender, input$ft, input$inch)[[2]],
              " lbs (or, ", iwc(input$gender, input$ft, input$inch)[[1]], " kg).", sep="")
    })
    output$chart <- renderPlot({ 
        plotiw(input$gender, input$ft, input$inch, input$age)
    }, width=800, heigh=450)
})

library(shiny)
shinyUI(fluidPage(
    titlePanel(span(h1("Ideal Weight Calculator (IWC) App"), style = "color:blue")),
    sidebarLayout(
        sidebarPanel(   span(p(h4("Welcome to the IWC App!")), style = "color:blue"),
                        br(),
                        p("If IWC is new to you, please fill in the information below and we will get you started in no time. If you are a seasoned IWC user, please enjoy the ride."),
                        br(),
                        numericInput("age", label = strong("Specify Your Age (20 - 100)"), value = 30, min = 20, max = 100, step = 1),
                        br(),
                        radioButtons("gender", label = strong("Gender"),
                                     choices = list("Male" = 1, "Female" = 2), selected = 1),
                        br(),
                        sliderInput("ft", label = strong("Specify Your Height (ft. & in.)"),
                                    min = 5, max = 8, value = 5, step=1, post=" ft."),
                        sliderInput("inch", "",
                                    min = 0, max = 11, value = 10, step=1, post=" in."),
                        br(),
                        submitButton("Submit"),
                        br(),
                        p("To learn more about the Ideal Weight in the adult population, please ", a(href="http://halls.md/ideal-weight-formulas-broca-devine/", "Click Here!")),
                        p("To learn more about how to use the IWC calculator, please ", a(href="http://rpubs.com/TudB/FPresentation", "Click Here!")),
                        span(p("Donate to Fight Obesity. ", a(href="http://www.obesity.org/donate/donate.htm", "Contribute Now!")), style = "color:red"),
                        width=3
                    ),
        mainPanel(span(h2("You"), style = "color:blue"),
                  span(h4(textOutput("all")), style = "color:black"),
                  br(),
                  span(h2("Your Ideal Weight"), style = "color:blue"),
                  span(h4(textOutput("weight")), style = "color:black"),
                  br(),
                  span(h2("Ideal You vs. Your Ideal Weight Peers"), style = "color:blue"),
                  plotOutput("chart")
                  )
    )
))

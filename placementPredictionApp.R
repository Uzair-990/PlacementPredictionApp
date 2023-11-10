library(shiny)
library(shinyWidgets)
library(shinydashboard)


backgroundImageCSS <- " /*background-color: #cccccc;*/
                       height: 91vh;
                       background-position: center;
                       background-repeat: no-repeat;
                      /* background-size: cover;*/
                       background-image: url('%s');
                       "

ui <- shinyUI(
  
  
  navbarPage(id="Test", "Placement Prediction",
             header = tagList(
               useShinydashboard()
               
             ),
             tabPanel(
               "APP", value="predict",#style = sprintf(backgroundImageCSS,  "https://paradoxcat.com/wp-content/uploads/2021/06/img_pdx_header_ai.jpg"),
               fluidPage(sidebarPanel(numericInput('Age', 'Enter age  :', 22),
                                      selectInput('Gender', 'select gender :', c("Male","Female"),selected = NULL),
                                      selectInput('Stream', 'Select stream :', c("Civil","Computer Science","Electrical","Electronics And Communication","Information Technology","Mechanical"),selected = NULL),
                                      selectInput('Internships', 'Select no of interships :', c(0:3),selected = NULL),
                                      selectInput('CGPA', 'Select cgpa :', c(1:10),selected = NULL),
                                      selectInput('HistoryOfBacklogs', 'any history of blacklogs :', c(0,1)),
                                      submitButton("SUBMIT", ""),setBackgroundImage(
                                        src = "sbg.png"
                                      )),
                         mainPanel(br(),br(),br(),br(),br(),br(),p("Predicted outcome based on submitted values are:"),verbatimTextOutput('result'),
                                   tags$head(tags$style("#result{color: black;
                                 font-size: 30px;
                                 font-style: italic;
                                 font-align: center;
                                 }"
                                   ),
                                   setBackgroundImage(
                                     src = "bg.png"
                                   )
                                   ))
               ),
             )
             
             
  ))

server <- function(input, output) {
  
    output$result <- renderText({
      fir.rf <- load("model.RData")
      Age <- as.integer(input$Age)
      Gender <- factor(input$Gender)
      Stream <- factor(input$Stream)
      Internships <- factor(input$Internships)
      CGPA <- as.integer(input$CGPA)
      HistoryOfBacklogs <- factor(input$HistoryOfBacklogs)
      rundf <-data.frame(Age, Gender, Stream, Internships, CGPA, HistoryOfBacklogs)
      predictedvalue <- predict(fit.rf, rundf)
      sprintf("This student %s",ifelse(predictedvalue == 1, "may be placed", "may not be placed"))
    })
 
  
}

shinyApp(ui, server)

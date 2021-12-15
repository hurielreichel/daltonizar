library(shiny)
library(shinyFiles)
library(magick)
library(CVD)
library(png)

# Define UI ----
ui <- fluidPage(
  
  titlePanel("Daltonizar"),
  
  helpText("Esse aplicativo permite converter qualquer imagem .png",
  "para que ela se torne amigável à leitura de daltônicos.",
  "Basta dar upload numa imagem e escolher o tipo de daltonismo",
  "Não sabe o tipo do daltonimso, visite:",
  "https://www.arealme.com/color-blindness-test/pt/"),
  
  fileInput("upload", NULL, buttonLabel = "Upload"),
  tableOutput("files"),
  
  selectInput("select", h3("Tipo de Daltonismo"), 
              choices = list("Deuteranopia" = 'Deuteranope', 
                             "Protanopia" = 'Protanope',
                             "Tritanopia" = 'Tritanope'), selected = 1),
  
  plotOutput("img1", click = "plot_click"),
  verbatimTextOutput("info")
  
    )

server <- function(input, output, session) {
  

  #read input image
  output$img1 <- renderPlot({
    
    file <- input$upload
    ext <- tools::file_ext(file$datapath)
    validate(need(ext == "png", "Please upload a png file"))
  
    outfile <- tempfile(fileext = ".png")
    
    Color.Vision.Daltonize(file$datapath, outfile, input$select)
    
    #plot input image
    plot(image_read(outfile))
    
  }, height = 800, width = 800)

}

# Run the app ----
shinyApp(ui = ui, server = server)
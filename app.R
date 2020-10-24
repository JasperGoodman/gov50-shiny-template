library(shiny) # you may need to install.packages() this
library(tidyverse)

library(shiny)
library(fec16)

# This is just a normal object

state.names <- c("VT", "NY", "MA")

# Make change to your dataset
results_house <- results_house %>%
  select(-footnotes)

covid <- read_csv("Covid_data/all-states-history.csv")
view(covid)


######################################################################################
######################################################################################
#
# 1. Shiny Apps have two basic parts to them
#
#   - The user interface (UI) defines how the app should look.
#
#     -- For example, the text on the page, the placement of the elements, etc.
#
#   - The server defines how the app should behave.
#
#     -- This is how live elements are updated - like selecting a state from a list.
#
#   - Those two pieces are combined by running shinyApp(ui, server) to create the app.
#
#      -- You can also click the green "Run App" button on the top right or
#         run runApp() in the console

ui <- fluidPage(navbarPage(
  "Milestone 4",
  
  tabPanel(
    "Main",
    
    # - UIs are built from "panel" functions, which specify areas of your page.
    #
    #   -- There is a "main panel," a "sidebar," a "title," etc.
    
    # Here is a sidebar!
    
    
    
    # And here is your "main panel" for the page.
    
    mainPanel(

      plotOutput("state_plot")
    )
  ),
  tabPanel("About", 
           titlePanel("About"),
           h3("Covid-19's Impact on the 2020 Elelction"),
           p("I worked with my Covid data this week to look at different
           comparisons. I hope to use a plot similar to this one, where I can 
           use Shiny to allow users to filter by state, date, etc. to view 
           specific data. I plan to look at how areas that have been
             heavily affected by Covid-19 voted in the 2020 election compared to
             in the past. To look at Covid data, I have loaded in data from the
             Covid Tracking Project. I plan to compare this to election results,
             after we have them. For future milestones, I may use the fec16 
             dataset as a placeholder. Here is a link to my GitHub Repo: 
             https://github.com/JasperGoodman/milestone4.git"),
           h3("About Me"),
           p("My name is Jasper Goodman and I am a sophomroe studying Government. 
             You can reach me at jaspergoodman@college.harvard.edu.")))
  )

server <- function(input, output, session) {
  # - Then, you use these named objects to update the data on your site via the input object.
  #
  #   -- render() functions are what show content that will change live on your site.
  #
  #   -- so here, renderText() is updating live text based on your choice.
  
  output$state_message <- renderText({
    paste0("This is the state you chose: ", # this is just a string, so it will never change
           input$selected_state, "!")       # this is based on your input, selected_state defined above.
  })
  
  output$size_message <- renderText({
    paste0("This is the size you chose: ", # this is just a string, so it will never change
           input$selected_size, "!")       # this is based on your input, selected_state defined above.
  })
  
  output$color_message <- renderText({
    paste0("This is the color you chose: ", # this is just a string, so it will never change
           input$selected_color, "!")       # this is based on your input, selected_state defined above.
  })
  
  output$text_message <- renderText({
    paste0("This is the label you typed: ", # this is just a string, so it will never change
           input$entered_text, "!")       # this is based on your input, selected_state defined above.
  })
  
  # This line makes our dataset reactive.
  # That is, we can update it based on the values of input that define above.
  
  results <- reactive({
    results_house
  })
  
  # Just like renderText(), we can renderPlot()!
  
  output$state_plot <- renderPlot({
    
    ggplot(data = covid, mapping = aes(x = date, y = death, color = state)) +
      theme(legend.position = "none") +
      geom_line() +
      labs(title = "Number of Deaths by State",
           x = "Date",
           y = "Number of Deaths")
  })
  
}

shinyApp(ui, server)
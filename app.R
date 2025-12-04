#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

# non-alcoholic cocktile menu
library(shiny)
library(dplyr)

# filter data
cocktails <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/main/data/2020/2020-05-26/cocktails.csv')

non_alcoholic <- cocktails %>%
    filter(alcoholic %in% c("Non alcoholic", "Optional alcohol")) %>%
    filter(!is.na(ingredient))

# UI
ui <- fluidPage(
    titlePanel("Non-Alcoholic Drinks Menu"),
    h3("All Non-Alcoholic Drinks:"),
    tableOutput("table"),
    h3("Number of drinks by type:"),
    plotOutput("chart")
)


server <- function(input, output) {

    # Show all drinks
    output$table <- renderTable({
        non_alcoholic %>%
            distinct(drink, category) %>%
            head(20) %>%
            rename(Drink = drink, Type = category)
    })

    # chart
    output$chart <- renderPlot({
        counts <- non_alcoholic %>%
            distinct(drink, category) %>%
            count(category)

        barplot(counts$n,
                names.arg = counts$category,
                col = "red",
                ylab = "Number of Drinks")
    })
}

shinyApp(ui, server)



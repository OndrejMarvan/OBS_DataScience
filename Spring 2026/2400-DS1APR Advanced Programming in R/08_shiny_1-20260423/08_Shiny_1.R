#---------------------------------------------------------#
#                Advanced Programming in R                #
#                  Class 8: Shiny part 1                  #
#                 Academic year 2025/2026                 #
#                  Classes conducted by:                  #
#                Maria Kubara & Monika Kot                #
#---------------------------------------------------------#

Sys.setenv(LANG = "en")

library(shiny)

# 1. Why Shiny? ----------------------------------------------------------------

# Until now, most of our code was written for ourselves.
# We executed commands in the console, wrote scripts,
# and produced results that we then inspected manually.

# Shiny changes this perspective.
# With Shiny, we can create interactive applications,
# where the user:
# - chooses values,
# - clicks buttons,
# - types text,
# - and immediately sees updated results in the browser.

# In practice, Shiny is often used for:
# - dashboards,
# - interactive data exploration,
# - visualisation tools,
# - teaching apps,
# - and simple interfaces for statistical procedures.

# Important idea:
# Shiny allows us to create interactive web apps directly in R.
# We do not need to know HTML, CSS, or JavaScript to get started,
# although knowledge of them can be useful later.

# Useful links:
# - Posit Shiny Basics: intro
#   https://shiny.posit.co/r/getstarted/shiny-basics/lesson1/
# - Posit Shiny basics: building UI:
#   https://shiny.posit.co/r/getstarted/shiny-basics/lesson2/
# - Posit Shiny basics: widgets:
#   https://shiny.posit.co/r/getstarted/shiny-basics/lesson3/
# - Posit widget gallery:
#   https://shiny.posit.co/r/gallery/widgets/widget-gallery/
# - Shiny gallery with many examples:
#   https://shiny.posit.co/r/gallery/
# - Mastering Shiny by Hadley Wickham:
#   https://mastering-shiny.org/


# 2. The basic architecture of a Shiny app ------------------------------------

# Every Shiny app has two main parts:
# - ui     -> what the user sees,
# - server -> what R computes in the background.

# The simplest possible app:

ui <- fluidPage(
  "Hello, world!"
)

server <- function(input, output) {
}

shinyApp(ui, server)

# - fluidPage() creates the page shown in the browser.
# - server is a function containing the logic of the app.
# - shinyApp(ui, server) launches the app.

# This app is already valid.
# It is very simple, but it shows the essential structure.


# 3. Where do we put the code? -------------------------------------------------

# For now, we will keep everything in a SINGLE R script.
# This is the simplest and most transparent approach for learning.

# Our workflow today will always follow the same pattern:
# 1) define UI (what the user sees),
# 2) define server (what R does in the background),
# 3) run the application with shinyApp(ui, server).

# IMPORTANT:
# In real projects, Shiny apps are often split into multiple files
# (e.g. app.R, ui.R, server.R), but we will NOT do this yet.

# We first need to fully understand the basic structure.


# Creating apps using RStudio

# In practice, many users create Shiny apps directly in RStudio.

# This can be done via:
# File -> New File -> Shiny Web App

# RStudio will automatically generate a template app with:
# - UI structure,
# - server function,
# - example inputs and outputs.


# 4. Running Shiny apps --------------------------------------------------------

# During class we will usually use:
# shinyApp(ui, server)

# Another way is:
# shiny::runApp(appDir = ".", launch.browser = TRUE)

# runApp() is useful when the app is saved in a folder.
# For example, when the application is stored in app.R.


# 5. First graphical elements --------------------------------------------------

# We now move from a bare page to an actual user interface.

ui <- fluidPage(
  titlePanel("My first shiny app")
)

server <- function(input, output) {
}

shinyApp(ui, server)

# titlePanel() adds a title to the page.

# In this script, we repeatedly redefine ui and server.
# This is intentional:
# each block below is a separate small example app.

# 6. Formatting title and adding simple text ----------------------------------

# We can place multiple elements inside fluidPage().
# For example, some text below the title.

ui <- fluidPage(
  titlePanel("My first Shiny app"),
  "This is my first interactive page in R."
)

server <- function(input, output) {
}

shinyApp(ui, server)

# We can also use tags such as h1(), h2(), p(), br(), hr().
# These functions create simple HTML elements in R.

ui <- fluidPage(
  h1("Header level 1"),
  h2("Header level 2"),
  p("This is a paragraph."),
  br(),
  p("This paragraph starts after a line break."),
  hr(),
  p("A horizontal line was added above.")
)

server <- function(input, output) {
}

shinyApp(ui, server)


# 7. A very simple formatted block with div() ---------------------------------

# div() is a container.
# We can use it to group content and optionally add simple styling.

ui <- fluidPage(
  div(
    style = "background-color: #f5f5f5; padding: 15px; border-radius: 8px;",
    h2("A simple formatted block"),
    p("div() lets us group and format page content.")
  )
)

server <- function(input, output) {
}

shinyApp(ui, server)

# This is not essential for analysis,
# but it is useful to show that UI can be styled step by step.


# 8. The most common layout: sidebar + main panel ------------------------------

# A very common Shiny layout is:
# - controls on the left,
# - results on the right.

ui <- fluidPage(
  titlePanel("Sidebar layout example"),
  sidebarLayout(
    sidebarPanel(
      "Controls will go here"
    ),
    mainPanel(
      "Results will go here"
    )
  )
)

server <- function(input, output) {
}

shinyApp(ui, server)

# This layout is very useful for data analysis applications.
# Usually:
# - sidebarPanel() contains widgets,
# - mainPanel() contains plots, tables, text, summaries.


# 9. First widget: textInput ---------------------------------------------------

# Widgets are among the most important elements of every interface.
# They allow the user to provide data to the application.

# The value created by a widget is later available in server.
# The general rule is:
# - widget has inputId,
# - in server we refer to it as input$inputId.

ui <- fluidPage(
  titlePanel("Greeting app"),
  sidebarLayout(
    sidebarPanel(
      textInput(
        inputId = "name",
        label = "Enter your name:"
      )
    ),
    mainPanel(
      textOutput("greeting")
    )
  )
)

server <- function(input, output) {
  output$greeting <- renderText({
    paste("Hello", input$name)
  })
}

shinyApp(ui, server)

# Important:
# - textInput() creates a value stored in input$name
# - renderText() creates text stored in output$greeting
# - textOutput("greeting") displays it in UI

# input -> computation in server -> output displayed in UI


# 10. Understanding input and output more explicitly ---------------------------

# We can print the current input value directly.

ui <- fluidPage(
  titlePanel("Inspecting input"),
  sidebarLayout(
    sidebarPanel(
      textInput("name", "Enter your name:")
    ),
    mainPanel(
      verbatimTextOutput("raw_input")
    )
  )
)

server <- function(input, output) {
  output$raw_input <- renderPrint({
    input$name
  })
}

shinyApp(ui, server)

# renderPrint() is useful when we want to display printed output.


# 11. Choice lists with closed set of values ----------------------------------

# In the widgets materials, one large group of widgets is:
# choice lists with a closed set of values.
# We will discuss several of them:
# - checkboxInput()
# - selectInput()
# - radioButtons()
# - checkboxGroupInput()
# - sliderInput()


# 12. checkboxInput() ----------------------------------------------------------

ui <- fluidPage(
  titlePanel("checkboxInput example"),
  sidebarLayout(
    sidebarPanel(
      checkboxInput(
        inputId = "show_msg",
        label = "Show message",
        value = TRUE
      )
    ),
    mainPanel(
      textOutput("msg")
    )
  )
)

server <- function(input, output) {
  output$msg <- renderText({
    if (input$show_msg) {
      "The checkbox is checked."
    } else {
      "The checkbox is not checked."
    }
  })
}

shinyApp(ui, server)

# checkboxInput() returns a logical value:
# TRUE or FALSE


# 13. selectInput() ------------------------------------------------------------

ui <- fluidPage(
  titlePanel("selectInput example"),
  sidebarLayout(
    sidebarPanel(
      selectInput(
        inputId = "species",
        label = "Choose species:",
        choices = unique(iris$Species)
      )
    ),
    mainPanel(
      textOutput("chosen_species")
    )
  )
)

server <- function(input, output) {
  output$chosen_species <- renderText({
    paste("Selected species:", input$species)
  })
}

shinyApp(ui, server)

# selectInput() is useful when the user should choose exactly one value
# from a predefined set.


# 14. radioButtons() -----------------------------------------------------------

ui <- fluidPage(
  titlePanel("radioButtons example"),
  sidebarLayout(
    sidebarPanel(
      radioButtons(
        inputId = "engine",
        label = "Choose engine type:",
        choices = c("petrol", "diesel", "electric")
      )
    ),
    mainPanel(
      textOutput("engine_choice")
    )
  )
)

server <- function(input, output) {
  output$engine_choice <- renderText({
    paste("Chosen option:", input$engine)
  })
}

shinyApp(ui, server)

# radioButtons() is similar to selectInput(),
# but all choices are visible at once.


# 15. checkboxGroupInput() -----------------------------------------------------

ui <- fluidPage(
  titlePanel("checkboxGroupInput example"),
  sidebarLayout(
    sidebarPanel(
      checkboxGroupInput(
        inputId = "letters_choice",
        label = "Choose one or more letters:",
        choices = LETTERS[1:5],
        selected = c("A", "C")
      )
    ),
    mainPanel(
      verbatimTextOutput("group_choice")
    )
  )
)

server <- function(input, output) {
  output$group_choice <- renderPrint({
    input$letters_choice
  })
}

shinyApp(ui, server)

# checkboxGroupInput() returns a character vector,
# because the user may choose multiple values.


# 16. sliderInput() ------------------------------------------------------------

ui <- fluidPage(
  titlePanel("sliderInput example"),
  sidebarLayout(
    sidebarPanel(
      sliderInput(
        inputId = "n",
        label = "Choose a number:",
        min = 1,
        max = 20,
        value = 10
      )
    ),
    mainPanel(
      textOutput("slider_value")
    )
  )
)

server <- function(input, output) {
  output$slider_value <- renderText({
    paste("Current value:", input$n)
  })
}

shinyApp(ui, server)

# sliderInput() is convenient for numeric ranges.

# It can also return TWO values if we choose a range.

ui <- fluidPage(
  titlePanel("sliderInput range example"),
  sidebarLayout(
    sidebarPanel(
      sliderInput(
        inputId = "years",
        label = "Choose year range:",
        min = 2000,
        max = 2025,
        value = c(2010, 2020)
      )
    ),
    mainPanel(
      verbatimTextOutput("year_range")
    )
  )
)

server <- function(input, output) {
  output$year_range <- renderPrint({
    input$years
  })
}

shinyApp(ui, server)


# 17. Calendars ----------------------------------------------------------------

# Another group of widgets are calendar widgets.
# They are useful whenever the user should provide a date.


# 18. dateInput() --------------------------------------------------------------

ui <- fluidPage(
  titlePanel("dateInput example"),
  sidebarLayout(
    sidebarPanel(
      dateInput(
        inputId = "day",
        label = "Choose a date:"
      )
    ),
    mainPanel(
      textOutput("date_result")
    )
  )
)

server <- function(input, output) {
  output$date_result <- renderText({
    paste("Selected date:", input$day)
  })
}

shinyApp(ui, server)


# 19. dateRangeInput() ---------------------------------------------------------

ui <- fluidPage(
  titlePanel("dateRangeInput example"),
  sidebarLayout(
    sidebarPanel(
      dateRangeInput(
        inputId = "period",
        label = "Choose a date range:"
      )
    ),
    mainPanel(
      verbatimTextOutput("period_result")
    )
  )
)

server <- function(input, output) {
  output$period_result <- renderPrint({
    input$period
  })
}

shinyApp(ui, server)

# dateRangeInput() returns two dates:
# start and end.


# 20. Widgets with open values -------------------------------------------------

# Another important group of widgets are widgets where the user
# provides values more freely.
# We will discuss:
# - numericInput()
# - textAreaInput()
# - passwordInput()
# - fileInput() as a preview of later applications


# 21. numericInput() -----------------------------------------------------------

ui <- fluidPage(
  titlePanel("numericInput example"),
  sidebarLayout(
    sidebarPanel(
      numericInput(
        inputId = "num",
        label = "Choose a number:",
        value = 5,
        min = 1,
        max = 100,
        step = 1
      )
    ),
    mainPanel(
      textOutput("num_result")
    )
  )
)

server <- function(input, output) {
  output$num_result <- renderText({
    paste("Current number:", input$num)
  })
}

shinyApp(ui, server)

# numericInput() is useful when we want the user to type a number directly.


# 22. textAreaInput() ----------------------------------------------------------

ui <- fluidPage(
  titlePanel("textAreaInput example"),
  sidebarLayout(
    sidebarPanel(
      textAreaInput(
        inputId = "comment",
        label = "Write a comment:",
        rows = 5,
        placeholder = "Type something longer..."
      )
    ),
    mainPanel(
      verbatimTextOutput("comment_result")
    )
  )
)

server <- function(input, output) {
  output$comment_result <- renderPrint({
    input$comment
  })
}

shinyApp(ui, server)


# 23. passwordInput() ----------------------------------------------------------

ui <- fluidPage(
  titlePanel("passwordInput example"),
  sidebarLayout(
    sidebarPanel(
      passwordInput(
        inputId = "secret",
        label = "Enter password:"
      )
    ),
    mainPanel(
      textOutput("secret_info")
    )
  )
)

server <- function(input, output) {
  output$secret_info <- renderText({
    paste("Password length:", nchar(input$secret))
  })
}

shinyApp(ui, server)


# 24. fileInput() --------------------------------------------------------------

# fileInput() is very useful in real applications,
# because users often need to upload their own data.

ui <- fluidPage(
  titlePanel("fileInput example"),
  sidebarLayout(
    sidebarPanel(
      fileInput(
        inputId = "myfile",
        label = "Choose a file"
      )
    ),
    mainPanel(
      verbatimTextOutput("file_info")
    )
  )
)

server <- function(input, output) {
  output$file_info <- renderPrint({
    input$myfile
  })
}

shinyApp(ui, server)


# 25. Buttons ------------------------------------------------------------------

# Buttons are another important group of widgets.
# For now, we only preview them.
# In next classes we will use them for controlling reactivity.


# 26. actionButton() -----------------------------------------------------------

ui <- fluidPage(
  titlePanel("actionButton preview"),
  sidebarLayout(
    sidebarPanel(
      actionButton(
        inputId = "btn",
        label = "Click me"
      )
    ),
    mainPanel(
      textOutput("click_result")
    )
  )
)

server <- function(input, output) {
  output$click_result <- renderText({
    paste("Button clicked", input$btn, "time(s)")
  })
}

shinyApp(ui, server)

# actionButton() increases its value each time it is clicked.

# 27. Combining multiple widgets ----------------------------------------------

# We now create a slightly more realistic mini-app.

ui <- fluidPage(
  titlePanel("Combined widgets example"),
  sidebarLayout(
    sidebarPanel(
      textInput("name", "Enter name:"),
      sliderInput("n", "How many greetings?", min = 1, max = 5, value = 2),
      checkboxInput("uppercase", "Use upper case", value = FALSE)
    ),
    mainPanel(
      verbatimTextOutput("greeting_result")
    )
  )
)

server <- function(input, output) {
  output$greeting_result <- renderPrint({
    text <- paste(rep(paste("Hello", input$name), input$n), collapse = " ")

    if (input$uppercase) {
      text <- toupper(text)
    }

    text
  })
}

shinyApp(ui, server)


# 28. Tabs ---------------------------------------------------------------------

# Another useful UI tool is tabsetPanel().
# It allows us to divide the application into multiple tabs.

ui <- fluidPage(
  titlePanel("tabsetPanel example"),
  tabsetPanel(
    tabPanel(
      "Greeting",
      textInput("name", "Enter name:"),
      textOutput("greeting")
    ),
    tabPanel(
      "Random numbers",
      numericInput("n", "How many numbers?", value = 10, min = 1),
      tableOutput("numbers_tbl")
    )
  )
)

server <- function(input, output) {
  output$greeting <- renderText({
    paste("Hello", input$name)
  })

  output$numbers_tbl <- renderTable({
    data.frame(values = rnorm(input$n))
  })
}

shinyApp(ui, server)


# tabsetPanel() is not the only way to divide content into tabs.
# Shiny also provides layouts such as navlistPanel() and navbarPage().

# The next two examples mainly show alternative interface organization.
# The server logic is still the same idea as before.


# navlistPanel()
ui <- fluidPage(
  titlePanel("navlistPanel example"),
  navlistPanel(
    tabPanel("Tab 1", "Contents of tab 1"),
    tabPanel("Tab 2", "Contents of tab 2"),
    tabPanel("Tab 3", "Contents of tab 3")
  )
)

server <- function(input, output) {
}

shinyApp(ui, server)

# navbarPage()
ui <- navbarPage(
  title = "My page",
  tabPanel("Tab 1", "Contents of tab 1"),
  tabPanel("Tab 2", "Contents of tab 2"),
  tabPanel("Tab 3", "Contents of tab 3")
)

server <- function(input, output) {
}

shinyApp(ui, server)


# 29. First small data app: viewing selected rows from iris -------------------

ui <- fluidPage(
  titlePanel("Simple iris explorer"),
  sidebarLayout(
    sidebarPanel(
      selectInput(
        inputId = "species",
        label = "Choose species:",
        choices = unique(iris$Species)
      ),
      sliderInput(
        inputId = "n_rows",
        label = "How many rows to display?",
        min = 1,
        max = 50,
        value = 6
      )
    ),
    mainPanel(
      tableOutput("iris_table")
    )
  )
)

server <- function(input, output) {
  output$iris_table <- renderTable({
    data_species <- iris[iris$Species == input$species, ]
    head(data_species, input$n_rows)
  })
}

shinyApp(ui, server)


# 30. Case study: simple k-means visualisation of iris ------------------------

# We choose two variables and number of clusters,
# then display the scatterplot with cluster colours.

ui <- fluidPage(
  titlePanel("K-means on iris dataset"),
  sidebarLayout(
    sidebarPanel(
      selectInput("xcol", "X variable:", choices = names(iris)[1:4], selected = "Sepal.Length"),
      selectInput("ycol", "Y variable:", choices = names(iris)[1:4], selected = "Sepal.Width"),
      sliderInput("clusters", "Number of clusters:", min = 2, max = 6, value = 3)
    ),
    mainPanel(
      plotOutput("plot1")
    )
  )
)

server <- function(input, output) {
  output$plot1 <- renderPlot({
    selected_data <- iris[, c(input$xcol, input$ycol)]
    km <- kmeans(selected_data, centers = input$clusters)

    plot(
      selected_data,
      col = km$cluster,
      pch = 19,
      xlab = input$xcol,
      ylab = input$ycol,
      main = "K-means clustering of iris"
    )

    points(km$centers, col = 1:input$clusters, pch = 8, cex = 2)
  })
}

shinyApp(ui, server)


# 31. Another mini-app: scatterplot + histogram + head -------------------------

ui <- fluidPage(
  titlePanel("Iris mini explorer"),
  sidebarLayout(
    sidebarPanel(
      selectInput("xcol", "Choose X variable:", names(iris)[1:4]),
      selectInput("ycol", "Choose Y variable:", names(iris)[1:4], selected = names(iris)[2])
    ),
    mainPanel(
      plotOutput("scatter"),
      plotOutput("hist_x"),
      tableOutput("head_tbl")
    )
  )
)

server <- function(input, output) {
  output$scatter <- renderPlot({
    plot(iris[[input$xcol]], iris[[input$ycol]],
         xlab = input$xcol,
         ylab = input$ycol,
         main = "Scatterplot")
  })

  output$hist_x <- renderPlot({
    hist(iris[[input$xcol]],
         main = paste("Histogram of", input$xcol),
         xlab = input$xcol)
  })

  output$head_tbl <- renderTable({
    head(iris)
  })
}

shinyApp(ui, server)

# 32. A first plot with ggplot2 ------------------------------------------------

# Up to now, we have used base R plots such as plot() and hist().
# We can also use plotting packages such as ggplot2 inside shiny apps.

# IMPORTANT:
# If we want to use ggplot2 functions, we must load ggplot2 first.

library(ggplot2)

ui <- fluidPage(
  titlePanel("Histogram with ggplot2"),
  
  sidebarLayout(
    sidebarPanel(
      selectInput(
        inputId = "var",
        label = "Choose variable:",
        choices = names(iris)[1:4]
      ),
      
      sliderInput(
        inputId = "bins",
        label = "Number of bins:",
        min = 5,
        max = 40,
        value = 15
      ),
      
      selectInput(
        inputId = "color",
        label = "Choose color:",
        choices = c("steelblue", "tomato", "darkgreen", "purple")
      ),
      
      sliderInput(
        inputId = "alpha",
        label = "Transparency:",
        min = 0.2,
        max = 1,
        value = 0.8,
        step = 0.1
      )
    ),
    
    mainPanel(
      plotOutput("gg_hist")
    )
  )
)

server <- function(input, output) {
  
  output$gg_hist <- renderPlot({
    ggplot(iris, aes(x = .data[[input$var]])) +
      geom_histogram(
        bins = input$bins,
        fill = input$color,
        alpha = input$alpha
      ) +
      labs(
        title = paste("Histogram of", input$var),
        x = input$var,
        y = "Count"
      ) +
      theme_minimal()
  })
}

shinyApp(ui, server)

# .data[[input$var]] means:
# use the column selected by the user as the x variable in ggplot2

# EXERCISES ###################################################################

## Exercise 1 #################################################################

# Create an app that allows the user to generate a simple personal message.
# The app should:
# - use textInput() to collect the user's name,
# - use selectInput() to choose a greeting style:
#     * "Hello"
#     * "Good morning"
#     * "Welcome"
# - use checkboxInput() to decide whether the message should be written
#   in upper case,
# - display the final message in the main panel.

# Hint:
# You will need:
# - one text widget,
# - one choice widget,
# - one logical widget,
# - renderText().


## Exercise 2 #################################################################

# Create an app with two tabs using tabsetPanel().
#
# In the first tab:
# - the user chooses one variable from the first four columns of iris,
# - the app displays a histogram of the selected variable.
#
# In the second tab:
# - the user chooses one species from iris,
# - the app displays the first 8 rows for that species in a table.

# Hint:
# Use:
# - plotOutput() and renderPlot() in the first tab,
# - tableOutput() and renderTable() in the second tab.


## Exercise 3 #################################################################

# Create an app using mtcars data that:
# - lets the user choose one numeric variable,
# - lets the user choose the number of bins,
# - lets the user choose a fill color,
# - displays a histogram created with ggplot2.
#
# Additional requirement:
# - remember to load ggplot2.

# Hint:
# Use:
# - selectInput(),
# - sliderInput(),
# - renderPlot(),
# - ggplot() + geom_histogram().



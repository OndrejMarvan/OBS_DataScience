#---------------------------------------------------------#
#                Advanced Programming in R                #
#                  Class 9: Shiny part 2                  #
#                 Academic year 2025/2026                 #
#                  Classes conducted by:                  #
#                Maria Kubara & Monika Kot                #
#---------------------------------------------------------#

Sys.setenv(LANG = "en")

library(shiny)
library(ggplot2)
library(dplyr)

# In this class we move from "what Shiny apps look like"
# to "how Shiny apps react and how they should be structured".

# The key topics today are:
# - reactive programming,
# - reducing unnecessary computation,
# - understanding where code should be placed,
# - building more structured and more efficient apps,
# - and using richer layout tools.


# 1. What did we learn before? -------------------------------------------------

# In the previous class we learned:
# - the structure of a Shiny app,
# - the distinction between UI and server,
# - basic widgets,
# - basic outputs,
# - and simple layouts such as sidebarLayout().

# Today we focus on the next important step:
# - what reactivity really means,
# - why some Shiny apps are inefficient,
# - how to avoid repeating calculations,
# - how to control updates,
# - and how to structure more advanced applications.


# 2. Architecture reminder -----------------------------------------------------

# ui -> defines layout and inputs
# server -> defines logic

# ui:
# *Output() functions

# output:
# render*() functions

# Examples:
# - renderText()    <-> textOutput()
# - renderPrint()   <-> verbatimTextOutput()
# - renderPlot()    <-> plotOutput()
# - renderTable()   <-> tableOutput()


# All render functions start with "render"
# All UI outputs end with "Output"

# This matters because every visible result in the app follows this pattern:
# input -> computation in server -> output -> display in UI


# 3. First reminder: Shiny reacts automatically --------------------------------

# The core idea of Shiny is:
# when an input changes, outputs depending on that input update automatically.

ui <- fluidPage(
  titlePanel("Automatic updates in Shiny"),
  sidebarLayout(
    sidebarPanel(
      sliderInput("n", "Number of points:", min = 10, max = 200, value = 50)
    ),
    mainPanel(
      plotOutput("plot")
    )
  )
)

server <- function(input, output) {
  
  output$plot <- renderPlot({
    # Every time input$n changes, this code is executed again.
    # So the plot is recomputed automatically.
    plot(rnorm(input$n), rnorm(input$n),
         main = "This plot updates automatically")
  })
}

shinyApp(ui, server)

# This automatic update is the essence of reactive programming.
# It is powerful, but if we place code badly,
# the application may recompute too much.


# 4. A first inefficiency: duplicated computation -------------------------------

# Suppose that two outputs use the same underlying data.
# If we compute that data separately in each render*(),
# we may be repeating the same work.

ui <- fluidPage(
  titlePanel("Repeated computation"),
  sidebarLayout(
    sidebarPanel(
      sliderInput("n", "Number of observations:", min = 10, max = 200, value = 50)
    ),
    mainPanel(
      plotOutput("plot1"),
      plotOutput("plot2")
    )
  )
)

server <- function(input, output) {
  
  output$plot1 <- renderPlot({
    # Here we generate random data.
    x <- rnorm(input$n)
    plot(x, main = "Plot of x")
  })
  
  output$plot2 <- renderPlot({
    # Here we generate another random vector AGAIN.
    # Even though the logic is very similar,
    # we are recomputing the same type of object a second time.
    x <- rnorm(input$n)
    hist(x, main = "Histogram of x")
  })
}

shinyApp(ui, server)

# Problem:
# - computation is duplicated,
# - structure becomes harder to understand,
# - and in real apps the repeated computation can be expensive.


# 5. reactive() – reducing duplication -----------------------------------------

# Reactive expressions are used to reduce recomputation
# and make the structure of the app easier to understand.

# reactive() creates a REACTIVE OBJECT.
# It is not output shown directly to the user.
# Instead, it stores a computation that can be reused.

ui <- fluidPage(
  titlePanel("Using reactive()"),
  sidebarLayout(
    sidebarPanel(
      sliderInput("n", "Number of observations:", min = 10, max = 200, value = 50)
    ),
    mainPanel(
      plotOutput("plot1"),
      plotOutput("plot2")
    )
  )
)

server <- function(input, output) {
  
  random_data <- reactive({
    # This code depends on input$n.
    # Shiny remembers this dependency.
    # When input$n changes, random_data() is recomputed.
    rnorm(input$n)
  })
  
  output$plot1 <- renderPlot({
    plot(random_data(), main = "Plot of shared reactive data")
  })
  
  output$plot2 <- renderPlot({
    hist(random_data(), main = "Histogram of shared reactive data")
  })
}

shinyApp(ui, server)

# IMPORTANT:
# - reactive() does not create visible output,
# - it creates an object that changes when its inputs change,
# - and we refer to it with parentheses: random_data()

# This is one of the most important syntax rules in Shiny:
# reactive_object_name()


# 6. Why reactive() matters ----------------------------------------------------

# reactive() improves at least three things:
# 1) efficiency
#    because we avoid repeating the same computation,
# 2) readability
#    because intermediate objects have names,
# 3) structure
#    because the server becomes easier to organize.


# This is why reactive() is so important:
# it creates a smart intermediate layer between input and output.


# 7. The concept of "zones" ----------------------------------------------------

# Not all code in a Shiny app should be placed in the same location. 
# We can divide Shiny code into Zone 1, Zone 2, and Zone 3.

# Why do zones matter?
# Because different parts of the code are executed:
# - a different number of times,
# - in a different context,
# - and with different consequences for performance.

# If we put expensive code in the wrong place,
# the app may become slow or unnecessarily repetitive.


## Zone 1 ----------------------------------------------------------------------

# Zone 1 is OUTSIDE server().
# Code here is executed once - when the app starts.

# This is the place for:
# - library() calls,
# - datasets that do not change,
# - helper functions,
# - constants,
# - and any preparation that should not be repeated for every user.

# Example:

########### ZONE 1 ##############

library(ggplot2)

data(iris)

helper_mean <- function(x) {
  mean(x, na.rm = TRUE)
}

########### ZONE 1 ##############

# Why this belongs here:
# - libraries should be loaded once,
# - stable datasets should be loaded once,
# - helper functions do not depend on input,
# - so there is no reason to rebuild them later.


## Zone 2 ----------------------------------------------------------------------

# Zone 2 is INSIDE server(), but OUTSIDE render*().

# This is where we usually place:
# - reactive() expressions,
# - eventReactive() expressions,
# - reactiveVal() and reactiveValues(),
# - helper objects that are specific to one user session.

# Zone 2 is useful because:
# - we can refer to input$... here,
# - but we are still outside any single output,
# - so one computation can be reused by many outputs.

# Example:

server <- function(input, output) {
  
  ########### ZONE 2 ##############
  
  selected_data <- reactive({
    iris[[input$var]]
  })
  
  ########### ZONE 2 ##############
  
  output$plt <- renderPlot({
    hist(selected_data())
  })
}

# Why this belongs here:
# - selected_data depends on input$var,
# - but it is not itself a plot or table,
# - it is a reusable intermediate object,
# - therefore Zone 2 is the natural place.


## Zone 3 ----------------------------------------------------------------------

# Zone 3 is INSIDE render*().

# This is where final output is created.
# In other words:
# - renderPlot() builds the final plot,
# - renderTable() builds the final table,
# - renderText() builds the final text, etc.

# Example:

server <- function(input, output) {
  
  output$plt <- renderPlot({
    
    ########### ZONE 3 ##############
    
    hist(iris[[input$var]])
    
    ########### ZONE 3 ##############
    
  })
}

# Why this belongs here:
# - plotting is part of the final visible output,
# - so it should be inside renderPlot(),
# - which belongs to Zone 3.

# A short summary:
# - Zone 1 = setup, executed once
# - Zone 2 = reactive intermediate layer
# - Zone 3 = final output


# 8. Demonstrating inefficiency with print() -----------------------------------

# We simulate an "expensive operation".
# Imagine this is:
# - downloading data from the internet,
# - reading a large file,
# - running a complex model.

# We can imitate an expensive operation with a helper function.

download_data <- function() {
  print("Downloading or loading data...")
  Sys.sleep(1)
  data.frame(x = rnorm(100))
}

# Version A: good placement in Zone 1 ------------------------------------------

# IMPORTANT:
# This line is OUTSIDE server()
# -> it runs ONCE when the app starts
# -> NOT when the user clicks anything

loaded_data_once <- download_data()

ui <- fluidPage(
  titlePanel("Zone 1 example"),
  actionButton("go", "Show mean"),
  verbatimTextOutput("txt")
)

server <- function(input, output) {
  output$txt <- renderPrint({
    # This creates a dependency on the button:
    # every click re-runs this block
    input$go
    
    # BUT the data is NOT recomputed!
    # We reuse the same object created at app startup.
    
    cat("Button clicked:", input$go, "time(s)\n")
    cat("Mean:", mean(loaded_data_once$x), "\n")
  })
}

shinyApp(ui, server)

# What happens?
# - the message "Downloading or loading data..." appears once,
# - because the data was prepared outside server.


# Version B: bad placement inside render (Zone 3) ------------------------------

ui <- fluidPage(
  titlePanel("Zone 3 example"),
  actionButton("go", "Show mean"),
  verbatimTextOutput("txt")
)

server <- function(input, output) {
  
  output$txt <- renderPrint({
    
    # Again, dependency on button
    input$go
    
    # PROBLEM:
    # This line is inside render*
    # -> it runs EVERY time the output updates
    # -> i.e. every button click
    
    loaded_data_render <- download_data()
    
    cat("Button clicked:", input$go, "time(s)\n")
    cat("Mean:", mean(loaded_data_render$x), "\n")
  })
}

shinyApp(ui, server)

# This example is NOT about the mean.
# It is about WHEN code runs.

# Zone 1 (outside server):
# -> runs once
# -> best for loading data

# Zone 3 (inside render):
# -> runs many times
# -> should be lightweight

# If we put heavy code in Zone 3:
# -> the app becomes slow
# -> we waste computation
# -> user experience becomes worse


# 9. Gumtree example: inefficient version --------------------------------------

# Now we move from a toy example (rnorm) to a more realistic scenario:
# working with a real dataset.

# We will build an app that:
# - filters data based on user input,
# - and displays multiple outputs (plot, table, summary).

# BUT we will do it in an INEFFICIENT way on purpose.

# WHY?
# Because this is a very common beginner mistake in Shiny:
# repeating the same computation inside multiple render*() functions.

# In this example:
# - we filter the dataset THREE times,
# - once for each output,
# - even though the filtering logic is identical.

gumtree <- readRDS("gumtree_en.rds")

ui <- fluidPage(
  titlePanel("Gumtree app - inefficient version"),
  
  sidebarLayout(
    sidebarPanel(
      sliderInput("price_max", "Maximum price:", min = 0,
                  max = max(gumtree$price, na.rm = TRUE),
                  value = max(gumtree$price, na.rm = TRUE)),
      sliderInput("footage_min", "Minimum footage:", min = 0,
                  max = max(gumtree$footage, na.rm = TRUE),
                  value = 20)
    ),
    
    mainPanel(
      plotOutput("scatter"),
      tableOutput("head_tbl"),
      verbatimTextOutput("summary_txt")
    )
  )
)

server <- function(input, output) {
  
  output$scatter <- renderPlot({
    
    # PROBLEM 1:
    # We filter the dataset here...
    # This operation depends on input and may be costly.
    
    selected_data <- gumtree[
      gumtree$price <= input$price_max &
        gumtree$footage >= input$footage_min, 
    ]
    
    ggplot(selected_data, aes(footage, price)) +
      geom_point() +
      labs(title = "Price vs footage")
  })
  
  
  output$head_tbl <- renderTable({
    
    # PROBLEM 2:
    # The SAME filtering logic is repeated again.
    
    selected_data <- gumtree[
      gumtree$price <= input$price_max &
        gumtree$footage >= input$footage_min, 
    ]
    
    head(selected_data)
  })
  
  
  output$summary_txt <- renderPrint({
    
    # PROBLEM 3:
    # And again — identical filtering logic for the third time.

    # If we ever want to change this logic,
    # we must remember to update it in THREE places.

    # This increases the risk of bugs.
    
    selected_data <- gumtree[
      gumtree$price <= input$price_max &
        gumtree$footage >= input$footage_min, 
    ]
    
    summary(selected_data[, c("price", "footage")])
  })
}

shinyApp(ui, server)

# What is inefficient here?
# - filtering is repeated three times,
# - if filtering becomes more complex, the problem becomes worse,
# - the server also becomes harder to read.


# 10. Gumtree example: improved with reactive() --------------------------------

# We now FIX the previous app.

# The idea is:
# - build the filtered dataset ONCE,
# - store it in a reactive object,
# - reuse it in multiple outputs.


ui <- fluidPage(
  titlePanel("Gumtree app - improved with reactive()"),
  
  sidebarLayout(
    sidebarPanel(
      sliderInput("price_max", "Maximum price:", min = 0,
                  max = max(gumtree$price, na.rm = TRUE),
                  value = max(gumtree$price, na.rm = TRUE)),
      sliderInput("footage_min", "Minimum footage:", min = 0,
                  max = max(gumtree$footage, na.rm = TRUE),
                  value = 20)
    ),
    
    mainPanel(
      plotOutput("scatter"),
      tableOutput("head_tbl"),
      verbatimTextOutput("summary_txt")
    )
  )
)

server <- function(input, output) {
  
  # We move the shared filtering logic into ONE reactive object.
  # This object:
  # - depends on input$price_max and input$footage_min,
  # - is recomputed only when those inputs change,
  # - can be reused in many outputs.
  
  selected_data <- reactive({
    gumtree[
      gumtree$price <= input$price_max &
        gumtree$footage >= input$footage_min,
    ]
  })
  
  
  output$scatter <- renderPlot({

    # We do NOT repeat the filtering code here.
    
    selected_data() %>%
      ggplot(aes(footage, price)) +
      geom_point() +
      xlab(expression("Footage [" * m^2 * "]")) +
      ylab("Price [PLN]") +
      ggtitle("Filtered Gumtree advertisements")
  })
  
  
  output$head_tbl <- renderTable({
    
    # Again: no repeated filtering,
    # only reuse of the same reactive object.
    
    head(selected_data())
  })
  
  
  output$summary_txt <- renderPrint({
    
    # And again: the same shared filtered dataset
    # is used in a third output.
    
    summary(selected_data()[, c("price", "footage")])
  })
}

shinyApp(ui, server)


# 11. isolate() – controlling automatic updates --------------------------------

# Shiny reacts to EVERY change in input,
# even very small ones (like typing a single letter).

# This behavior is usually good,
# but sometimes it leads to too many updates.

ui <- fluidPage(
  titlePanel("Title updates letter by letter"),
  sidebarLayout(
    sidebarPanel(
      textInput("plot_title", "Plot title:", value = "My histogram")
    ),
    mainPanel(
      plotOutput("plot")
    )
  )
)

server <- function(input, output) {
  
  output$plot <- renderPlot({
    # input$plot_title is used directly here.
    # This creates a reactive dependency:
    # -> renderPlot() depends on input$plot_title
    # So EVERY change in the text input triggers recomputation.
    hist(rnorm(100), main = input$plot_title)
  })
}

shinyApp(ui, server)

# Every new letter triggers a new recomputation.

# Why this can be a problem?

# 1) Too many computations:
#    If the plot is expensive, the app may become slow.

# 2) Bad user experience:
#    The plot keeps changing while the user is still typing.

# 3) Unnecessary updates:
#    Often we want the user to finish typing first,
#    and then update the output only once.


# Using isolate() ---------------------------------------------------------------

ui <- fluidPage(
  titlePanel("Using isolate()"),
  sidebarLayout(
    sidebarPanel(
      textInput("plot_title", "Plot title:", value = "My histogram"),
      actionButton("update_btn", "Update plot")
    ),
    mainPanel(
      plotOutput("plot")
    )
  )
)

server <- function(input, output) {
  
  output$plot <- renderPlot({
    # This line creates a dependency on the button.
    input$update_btn
    
    # isolate() reads the text input without making
    # the plot automatically react to every new letter.
    current_title <- isolate(input$plot_title)
    
    hist(rnorm(100), main = current_title)
  })
}

shinyApp(ui, server)

# - isolate() lets us read an input
#   without making the current expression react to every change,
# - it is useful when we want the user to confirm an update with a button.


# 12. eventReactive() ----------------------------------------------------------

# Sometimes we do NOT want automatic reactivity.

# Instead of:
# - updating outputs continuously,
# we want:
# - updates only when the user explicitly requests them.

# eventReactive() is designed exactly for this purpose:
# it links a computation to a specific event (e.g., a button click).

ui <- fluidPage(
  titlePanel("eventReactive() example"),
  sidebarLayout(
    sidebarPanel(
      textInput("plot_title", "Plot title:", value = "Histogram"),
      sliderInput("n", "Number of observations:", min = 50, max = 500, value = 100),
      actionButton("go", "Generate")
    ),
    mainPanel(
      plotOutput("plot")
    )
  )
)

server <- function(input, output) {
  
  plot_data <- eventReactive(input$go, {
    # This code is run only when the button is clicked.
    list(
      x = rnorm(input$n),
      title = input$plot_title
    )
  })
  
  output$plot <- renderPlot({
    hist(plot_data()$x, main = plot_data()$title)
  })
}

shinyApp(ui, server)

# Why this is useful:
# - the event (button click) is clearly separated,
# - the generated object is reusable,
# - and the syntax is often cleaner than manual isolate().


# 13. observe() and observeEvent() ---------------------------------------------

# So far, all our reactive code produced something visible:
# - plots,
# - tables,
# - text.

# In all those cases we used render*() functions:
# - renderPlot(),
# - renderTable(),
# - renderText(), etc.

# These functions are designed to RETURN something
# that is then displayed in the UI.

# But sometimes we want something different:
# we want Shiny to DO something, not SHOW something.

# Examples:
# - save a file,
# - print a message,
# - update values,
# - trigger an action.

# In these cases, render*() is not appropriate,
# because there is no output to display.

# Instead, we use OBSERVERS:
# - observe()
# - observeEvent()

# -----------------------------------------------------------------------------#
# Key idea:
#
# render*()  -> returns a value -> used for OUTPUT (UI)
# observe*() -> performs action -> used for SIDE EFFECTS
# -----------------------------------------------------------------------------#


# 13.1 observe() vs observeEvent() ---------------------------------------------

# Both observe() and observeEvent():
# - do NOT return a value,
# - do NOT create output in UI,
# - are used for actions (side effects).

# The key difference is WHEN they are triggered:

# observe():
# - runs whenever ANY reactive value inside it changes
# - reacts continuously

# observeEvent():
# - runs ONLY when a specific event occurs
# - most often used with buttons


# 13.2 Minimal example: seeing the difference ----------------------------------

ui <- fluidPage(
  titlePanel("observe() vs observeEvent()"),
  sidebarLayout(
    sidebarPanel(
      sliderInput("n", "Choose a number:", min = 1, max = 100, value = 10),
      actionButton("btn", "Click me")
    ),
    mainPanel(
      p("Check the R console to see what happens.")
    )
  )
)

server <- function(input, output) {
  
  # observe(): triggered EVERY time input$n changes
  observe({
    cat("observe() triggered - n =", input$n, "\n")
  })
  
  # observeEvent(): triggered ONLY when button is clicked
  observeEvent(input$btn, {
    cat("observeEvent() triggered by button!\n")
  })
}

shinyApp(ui, server)


# What to notice:
# - moving the slider triggers observe() many times,
# - clicking the button triggers only observeEvent().

# This shows:
# observe()      -> continuous reaction
# observeEvent() -> event-driven reaction


# 13.3 Practical example: saving a file ----------------------------------------

# A very common use case for observeEvent() is reacting to a button click.

ui <- fluidPage(
  titlePanel("observeEvent() example"),
  sidebarLayout(
    sidebarPanel(
      actionButton("save_btn", "Save mtcars to CSV")
    ),
    mainPanel(
      p("Click the button and check the console & working directory.")
    )
  )
)

server <- function(input, output) {
  
  observeEvent(input$save_btn, {
    
    # Action: save data to file
    write.csv(mtcars, "mtcars_saved.csv", row.names = FALSE)
    
    # Action: print message in console
    print("Data saved to mtcars_saved.csv")
  })
}

shinyApp(ui, server)


# Important:
# - observeEvent() does not create output in the UI,
# - it performs actions in response to user interaction.


# 13.4 Rule of thumb -----------------------------------------------------------

# - use render*() when you want to DISPLAY something,
# - use observeEvent() for buttons and user-triggered actions,
# - use observe() only when you want to react to ANY change.

# In practice:
# If there is a button -> use observeEvent().


# 14. reactiveTimer() ----------------------------------------------------------

# So far, all our reactive logic depended on user input:
# - sliders,
# - text input,
# - buttons.

# But sometimes we want the app to update automatically,
# even when the user does nothing.

# Examples:
# - refreshing data every few seconds,
# - simulating new observations,
# - creating simple animations.

# reactiveTimer() allows us to introduce time
# as a trigger for reactivity.

ui <- fluidPage(
  titlePanel("reactiveTimer() example"),
  plotOutput("plot")
)

server <- function(input, output) {
  
  timer <- reactiveTimer(1000)  # 1000 ms = 1 second
  
  output$plot <- renderPlot({
    # This line makes the plot depend on time.
    timer()
    
    hist(rnorm(100), main = "This plot refreshes every second")
  })
}

shinyApp(ui, server)

# 15. Integrated example: a richer regression app ------------------------------

# We now combine several ideas from this class into one larger application.

# This app will include:
# - multiple inputs,
# - eventReactive() to control when the model is fitted,
# - reactive() objects reused in multiple outputs,
# - multiple outputs based on the same model,
# - and observeEvent() for a side effect.

# The goal is not only to build a model,
# but also to show how a somewhat larger Shiny app can be structured.

ui <- fluidPage(
  titlePanel("Regression app on iris data"),
  
  sidebarLayout(
    sidebarPanel(
      
      # Input 1
      selectInput(
        "xcol",
        "X variable:",
        choices = names(iris)[1:4],
        selected = "Sepal.Length"
      ),
      
      # Input 2
      selectInput(
        "ycol",
        "Y variable:",
        choices = names(iris)[1:4],
        selected = "Sepal.Width"
      ),
      
      # Input 3
      checkboxInput(
        "show_smooth",
        "Show regression line",
        value = TRUE
      ),
      
      # Input 4
      textInput(
        "plot_title",
        "Plot title:",
        value = "Regression on iris data"
      ),
      
      # Action button 1
      actionButton(
        "fit_btn",
        "Fit model"
      ),
      
      # Two break lines
      br(), br(),
      
      # Action button 1
      actionButton(
        "info_btn",
        "Print selected variables to console"
      )
    ),
    
    # 4 outputs
    mainPanel(
      plotOutput("scatter"),
      plotOutput("resid_hist"),
      verbatimTextOutput("model_summary"),
      tableOutput("coef_table")
    )
  )
)

server <- function(input, output) {
  
  # This observer does not create UI output.
  # It performs a side effect:
  # it prints a message in the console when the user clicks the button.
  observeEvent(input$info_btn, {
    cat("Current selection:\n")
    cat("X variable:", input$xcol, "\n")
    cat("Y variable:", input$ycol, "\n")
  })
  
  
  # We use eventReactive() because we do NOT want the model
  # to refit after every small change immediately.
  # Instead, the user first chooses settings,
  # and only then clicks "Fit model".
  model_data <- eventReactive(input$fit_btn, {
    
    # Build a small data frame based on selected variables.
    df <- data.frame(
      x = iris[[input$xcol]],
      y = iris[[input$ycol]]
    )
    
    # Fit the model once the event happens.
    fit <- lm(y ~ x, data = df)
    
    # Return several elements together.
    list(
      data = df,
      model = fit,
      title = input$plot_title,
      xname = input$xcol,
      yname = input$ycol
    )
  })
  
  
  output$scatter <- renderPlot({
    
    # model_data() is available only after button click.
    obj <- model_data()
    
    plot(
      obj$data$x,
      obj$data$y,
      xlab = obj$xname,
      ylab = obj$yname,
      main = obj$title,
      pch = 19
    )
    
    # Optional layer controlled by checkbox input.
    if (input$show_smooth) {
      abline(obj$model, col = "red", lwd = 2)
    }
  })
  
  
  output$resid_hist <- renderPlot({
    obj <- model_data()
    
    hist(
      residuals(obj$model),
      main = "Histogram of residuals",
      xlab = "Residuals"
    )
  })
  
  
  output$model_summary <- renderPrint({
    obj <- model_data()
    summary(obj$model)
  })
  
  
  output$coef_table <- renderTable({
    obj <- model_data()
    
    coef_df <- data.frame(
      Term = names(coef(obj$model)),
      Estimate = as.numeric(coef(obj$model))
    )
    
    coef_df
  })
}

shinyApp(ui, server)



# 16. shinydashboard -----------------------------------------------------------

# Until now, we controlled layout manually.

# shinydashboard provides a structured template
# for building dashboard-style applications:
# - header,
# - sidebar,
# - main body.

# This is especially useful for larger, more professional apps.

# More info:
# https://rstudio.github.io/shinydashboard/index.html

# install.packages("shinydashboard")

library(shinydashboard)

ui <- dashboardPage(
  dashboardHeader(title = "Simple dashboard"),
  
  dashboardSidebar(
    sliderInput("n", "Number of observations:", min = 10, max = 200, value = 50)
  ),
  
  dashboardBody(
    fluidRow(
      box(width = 6, title = "Histogram", status = "primary", solidHeader = TRUE,
          plotOutput("hist")),
      box(width = 6, title = "Summary", status = "primary", solidHeader = TRUE,
          verbatimTextOutput("summary_txt"))
    )
  )
)

server <- function(input, output) {
  
  x_reactive <- reactive({
    rnorm(input$n)
  })
  
  output$hist <- renderPlot({
    hist(x_reactive(), main = "Histogram from dashboard")
  })
  
  output$summary_txt <- renderPrint({
    summary(x_reactive())
  })
}

shinyApp(ui, server)

# - dashboardPage() replaces fluidPage(),
# - dashboardHeader() creates the top bar,
# - dashboardSidebar() creates the side menu / controls,
# - dashboardBody() contains the main content,
# - box() is a convenient container for outputs.


# 17. shinydashboard with value boxes ------------------------------------------

ui <- dashboardPage(
  dashboardHeader(title = "Gumtree dashboard"),
  
  dashboardSidebar(
    sliderInput("price_max", "Maximum price [PLN]:",
                min = 0,
                max = max(gumtree$price, na.rm = TRUE),
                value = max(gumtree$price, na.rm = TRUE)),
    sliderInput("footage_min", "Minimum footage:",
                min = 0,
                max = max(gumtree$footage, na.rm = TRUE),
                value = 20)
  ),
  
  dashboardBody(
    fluidRow(
      valueBoxOutput("n_ads"),
      valueBoxOutput("mean_price"),
      valueBoxOutput("mean_footage")
    ),
    fluidRow(
      box(width = 4, title = "Scatterplot", status = "primary", solidHeader = TRUE,
          plotOutput("scatter")),
      box(width = 8, title = "Preview", status = "primary", solidHeader = TRUE,
          tableOutput("tbl"))
    )
  )
)

server <- function(input, output) {
  
  selected_data <- reactive({
    gumtree[gumtree$price <= input$price_max &
              gumtree$footage >= input$footage_min, ]
  })
  
  output$n_ads <- renderValueBox({
    valueBox(
      value = nrow(selected_data()),
      subtitle = "Number of ads"
    )
  })
  
  output$mean_price <- renderValueBox({
    valueBox(
      value = round(mean(selected_data()$price, na.rm = TRUE), 2),
      subtitle = "Mean price"
    )
  })
  
  output$mean_footage <- renderValueBox({
    valueBox(
      value = round(mean(selected_data()$footage, na.rm = TRUE), 2),
      subtitle = "Mean footage"
    )
  })
  
  output$scatter <- renderPlot({
    selected_data() %>%
      ggplot(aes(footage, price)) +
      geom_point() +
      xlab(expression("Footage [" * m^2 * "]")) +
      ylab("Price [PLN]") +
      ggtitle("Filtered Gumtree ads")
  })
  
  output$tbl <- renderTable({
    head(selected_data())
  })
}

shinyApp(ui, server)


# EXERCISES ###################################################################


## Exercise 1 #################################################################

# Create an app using iris data that:
# - allows the user to choose one numeric variable from the first four columns,
# - creates one reactive object with the selected variable,
# - displays:
#     * a histogram,
#     * a boxplot,
#     * a table with the first 10 values,
#     * and summary() of this variable.
#
# Additional requirement:
# - add a textOutput() showing the name of the currently selected variable.
#
# Goal:
# practice creating one reactive object
# and reusing it in several outputs.


## Exercise 2 #################################################################

# Create an app using gumtree_en.rds that:
# - allows the user to choose:
#     * maximum price,
#     * minimum footage,
#     * and number of rows to display in the table,
# - creates one reactive filtered dataset,
# - displays:
#     * a scatterplot of footage vs price,
#     * a table with the chosen number of first rows,
#     * the number of filtered advertisements,
#     * and mean price of filtered advertisements.
#
# Additional requirement:
# - if no rows satisfy the conditions,
#   show an informative message instead of summary numbers.
#
# Goal:
# practice filtering data reactively
# and using one reactive dataset in multiple outputs.


## Exercise 3 #################################################################

# Create an app using mtcars data that:
# - allows the user to choose one variable for the x-axis
#   and one variable for the y-axis,
# - displays a scatterplot of the selected variables,
# - includes a checkbox:
#     * if checked, add the regression line,
# - includes an actionButton("info_btn", ...).
#
# After clicking the button, the app should:
# - print to the console which variables are currently selected.
#
# Goal:
# practice the difference between:
# - outputs shown in the UI,
# - and actions performed with observeEvent().

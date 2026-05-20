# =============================================================================
#  ChessSimulator - SHINY DASHBOARD
#  File: inst/shiny/app.R
#
#  Launched from R via:
#    library(ChessSimulator)
#    launch_dashboard()
#
#  This file uses functions and classes from the ChessSimulator package.
#  The package must be loaded (library(ChessSimulator)) before runApp()
#  is called - launch_dashboard() handles this automatically.
# =============================================================================

# Note: NO source() calls here. The R6 classes and wrapper functions are
# part of the package namespace and available once the package is loaded.

library(shiny)
library(shinydashboard)

# Colour palette
LIGHT_SQUARE <- "#F0D9B5"
DARK_SQUARE  <- "#B58863"
WHITE_PIECE  <- "#FFFFFF"
BLACK_PIECE  <- "#000000"

# Unicode chess symbols
PIECE_SYMBOLS <- list(
  white = c(K = "\u2654", Q = "\u2655", R = "\u2656",
            B = "\u2657", N = "\u2658", P = "\u2659"),
  black = c(K = "\u265A", Q = "\u265B", R = "\u265C",
            B = "\u265D", N = "\u265E", P = "\u265F")
)


# =============================================================================
#  UI
# =============================================================================
ui <- dashboardPage(
  skin = "black",

  dashboardHeader(title = "Chess Simulator", titleWidth = 220),

  dashboardSidebar(
    width = 220,
    sidebarMenu(
      menuItem("Play a Game",    tabName = "play",       icon = icon("chess")),
      menuItem("Tournament",     tabName = "tournament", icon = icon("trophy")),
      menuItem("About",          tabName = "about",      icon = icon("info-circle"))
    )
  ),

  dashboardBody(
    tabItems(

      # --- PLAY TAB ----------------------------------------------------------
      tabItem(tabName = "play",
        fluidRow(

          box(
            title = "Game Configuration", width = 3,
            status = "primary", solidHeader = TRUE,

            h4("White player"),
            selectInput("white_type", "Type:",
                        choices = c("Random" = "random", "Minimax AI" = "minimax"),
                        selected = "random"),
            textInput("white_name", "Name:", value = "White"),
            conditionalPanel(
              condition = "input.white_type == 'minimax'",
              sliderInput("white_depth", "Search depth:",
                          min = 1, max = 5, value = 3, step = 1)
            ),

            hr(),
            h4("Black player"),
            selectInput("black_type", "Type:",
                        choices = c("Random" = "random", "Minimax AI" = "minimax"),
                        selected = "random"),
            textInput("black_name", "Name:", value = "Black"),
            conditionalPanel(
              condition = "input.black_type == 'minimax'",
              sliderInput("black_depth", "Search depth:",
                          min = 1, max = 5, value = 3, step = 1)
            ),

            hr(),
            h4("Controls"),
            actionButton("btn_new_game", "New Game",
                         icon = icon("play"),
                         class = "btn-primary btn-block"),
            br(), br(),
            actionButton("btn_next_move", "Next Move",
                         icon = icon("step-forward"),
                         class = "btn-default btn-block"),
            br(),
            checkboxInput("auto_play", "Auto-play", value = FALSE),
            sliderInput("auto_speed", "Speed (ms):",
                        min = 100, max = 2000, value = 500, step = 100),
            hr(),
            actionButton("btn_full_game", "Play Full Game",
                         icon = icon("forward"),
                         class = "btn-warning btn-block")
          ),

          box(
            title = "Board", width = 6,
            status = "success", solidHeader = TRUE,
            uiOutput("board_ui"),
            br(),
            div(style = "text-align: center; font-size: 16px; font-weight: bold;",
                textOutput("game_status_text"))
          ),

          box(
            title = "Game Info", width = 3,
            status = "info", solidHeader = TRUE,
            fluidRow(
              valueBoxOutput("vbox_moves",   width = 12),
              valueBoxOutput("vbox_balance", width = 12)
            ),
            hr(),
            h4("Move History"),
            div(style = "max-height: 350px; overflow-y: auto;",
                tableOutput("move_history_tbl"))
          )
        )
      ),

      # --- TOURNAMENT TAB ----------------------------------------------------
      tabItem(tabName = "tournament",
        fluidRow(

          box(
            title = "Tournament Setup", width = 4,
            status = "primary", solidHeader = TRUE,
            h4("Players"),
            p("Each plays every other player as both colours."),

            div(style = "background:#f5f5f5; padding:10px; border-radius:5px; margin-bottom:8px;",
              strong("Player 1"),
              textInput("t_name1", NULL, value = "Random_A"),
              selectInput("t_type1", NULL,
                          choices = c("Random"="random","Minimax"="minimax"),
                          selected = "random"),
              conditionalPanel("input.t_type1 == 'minimax'",
                sliderInput("t_depth1", "Depth:", 1, 5, 2, step=1))
            ),

            div(style = "background:#f5f5f5; padding:10px; border-radius:5px; margin-bottom:8px;",
              strong("Player 2"),
              textInput("t_name2", NULL, value = "Random_B"),
              selectInput("t_type2", NULL,
                          choices = c("Random"="random","Minimax"="minimax"),
                          selected = "random"),
              conditionalPanel("input.t_type2 == 'minimax'",
                sliderInput("t_depth2", "Depth:", 1, 5, 3, step=1))
            ),

            div(style = "background:#f5f5f5; padding:10px; border-radius:5px; margin-bottom:8px;",
              strong("Player 3"),
              textInput("t_name3", NULL, value = "Minimax_3"),
              selectInput("t_type3", NULL,
                          choices = c("Random"="random","Minimax"="minimax"),
                          selected = "minimax"),
              conditionalPanel("input.t_type3 == 'minimax'",
                sliderInput("t_depth3", "Depth:", 1, 5, 3, step=1))
            ),

            hr(),
            sliderInput("t_rounds", "Number of rounds:", 1, 5, 1, step=1),
            actionButton("btn_run_tournament", "Run Tournament",
                         icon = icon("flag-checkered"),
                         class = "btn-danger btn-block")
          ),

          box(
            title = "Leaderboard", width = 8,
            status = "success", solidHeader = TRUE,
            fluidRow(
              valueBoxOutput("t_vbox_games",  width = 4),
              valueBoxOutput("t_vbox_leader", width = 4),
              valueBoxOutput("t_vbox_rounds", width = 4)
            ),
            hr(),
            h4("Standings"),
            tableOutput("leaderboard_tbl"),
            hr(),
            h4("All Games"),
            div(style = "max-height: 300px; overflow-y: auto;",
                tableOutput("all_games_tbl"))
          )
        )
      ),

      # --- ABOUT TAB ---------------------------------------------------------
      tabItem(tabName = "about",
        fluidRow(
          box(
            title = "Chess Simulator - Advanced R Project",
            width = 12, status = "info", solidHeader = TRUE,
            h3("Project overview"),
            p("Final project for", strong("Advanced Programming in R"),
              "at WNE UW. Demonstrates:"),
            tags$ul(
              tags$li(strong("R6 OOP"), "- inheritance and polymorphism"),
              tags$li(strong("Rcpp (C++)"), "- minimax with alpha-beta pruning"),
              tags$li(strong("Shiny"), "- this interactive dashboard"),
              tags$li(strong("R Package"), "- roxygen2 documentation")
            ),
            hr(),
            h3("How to use"),
            tags$ol(
              tags$li("Configure two players (Random or Minimax AI)."),
              tags$li("Click", strong("New Game"), "to initialise."),
              tags$li("Click", strong("Next Move"), "to advance one move,",
                      "or enable", strong("Auto-play"), "for animation."),
              tags$li("Or click", strong("Play Full Game"), "to skip to the end.")
            ),
            hr(),
            p(em("Student: Ondrej Marvan | ID: 477001"))
          )
        )
      )
    )
  )
)


# =============================================================================
#  SERVER
# =============================================================================
server <- function(input, output, session) {

  # --- Reactive state -------------------------------------------------------
  game_rv       <- reactiveVal(NULL)
  tournament_rv <- reactiveVal(NULL)

  auto_timer <- reactive({
    reactiveTimer(input$auto_speed)
  })

  # --- Helper ---------------------------------------------------------------
  make_play_player <- function(type, name, depth, colour) {
    ChessSimulator::make_player(
      strategy = type, name = name, colour = colour,
      depth = depth %||% 3L
    )
  }

  # %||% available inside server too
  `%||%` <- function(x, y) if (!is.null(x)) x else y

  # --- New Game -------------------------------------------------------------
  observeEvent(input$btn_new_game, {

    white <- isolate(make_play_player(
      input$white_type, input$white_name, input$white_depth, "white"
    ))
    black <- isolate(make_play_player(
      input$black_type, input$black_name, input$black_depth, "black"
    ))

    new_game <- ChessSimulator::Game$new(white, black, max_moves = 300L)
    game_rv(new_game)

    showNotification(
      paste("New game started:", white$name, "vs", black$name),
      type = "message", duration = 3
    )
  })

  # --- Next Move ------------------------------------------------------------
  observeEvent(input$btn_next_move, {

    game <- game_rv()
    if (is.null(game)) {
      showNotification("Start a new game first!", type = "warning")
      return()
    }
    if (game$get_status() != "ongoing") {
      showNotification("Game is already over.", type = "warning")
      return()
    }

    game$play_one_turn(verbose = FALSE)
    game_rv(game)
  })

  # --- Auto-play ------------------------------------------------------------
  observe({
    auto_timer()()
    if (!isTRUE(input$auto_play)) return()
    game <- game_rv()
    if (is.null(game)) return()
    if (game$get_status() != "ongoing") {
      updateCheckboxInput(session, "auto_play", value = FALSE)
      return()
    }
    game$play_one_turn(verbose = FALSE)
    game_rv(game)
  })

  # --- Full Game ------------------------------------------------------------
  observeEvent(input$btn_full_game, {

    game <- game_rv()
    if (is.null(game)) {
      showNotification("Start a new game first!", type = "warning")
      return()
    }
    if (game$get_status() != "ongoing") {
      showNotification("Game is already over.", type = "warning")
      return()
    }

    withProgress(message = "Playing game...", value = 0, {
      game$play(verbose = FALSE)
      setProgress(1)
    })

    game_rv(game)
    showNotification(
      paste("Game over:", game$get_status()),
      type = "message", duration = 4
    )
  })

  # --- Board UI -------------------------------------------------------------
  output$board_ui <- renderUI({

    game <- game_rv()
    if (is.null(game)) {
      return(div(
        style = "text-align:center; padding:60px; color:#999;",
        "Click 'New Game' to start."
      ))
    }

    board     <- game$get_board()
    board_mat <- board$to_matrix()

    rows <- lapply(1:8, function(i) {
      rank_label <- 9L - i

      cells <- lapply(1:8, function(j) {
        file <- letters[j]
        sq   <- ChessSimulator::Square$new(file, rank_label)
        bg   <- if (sq$is_light_square()) LIGHT_SQUARE else DARK_SQUARE
        symbol <- board_mat[i, j]

        cell_content <- if (symbol != ".") {
          colour <- if (symbol == toupper(symbol)) "white" else "black"
          type   <- toupper(symbol)
          unicode <- PIECE_SYMBOLS[[colour]][[type]]
          span(
            style = paste0(
              "font-size:32px; color:",
              if (colour == "white") WHITE_PIECE else BLACK_PIECE,
              "; text-shadow: 1px 1px 2px rgba(0,0,0,0.4);"),
            unicode
          )
        } else ""

        tags$td(
          style = paste0(
            "width:60px; height:60px; text-align:center; ",
            "vertical-align:middle; background-color:", bg,
            "; border:1px solid #333;"),
          cell_content
        )
      })

      rank_cell <- tags$td(
        style = "width:20px; font-size:12px; color:#666; padding-right:4px;",
        rank_label)

      tags$tr(c(list(rank_cell), cells))
    })

    file_labels <- tags$tr(
      tags$td(""),
      lapply(letters[1:8], function(f) {
        tags$td(style = "text-align:center; font-size:12px; color:#666;", f)
      })
    )

    div(style = "display: inline-block;",
      tags$table(style = "border-collapse:collapse; border:2px solid #333;",
                 c(rows, list(file_labels))))
  })

  # --- Status text ----------------------------------------------------------
  output$game_status_text <- renderText({
    game <- game_rv()
    if (is.null(game)) return("")
    status <- game$get_status()
    reason <- game$get_result_reason()

    if (status == "ongoing") {
      paste("To move:",
            if (nrow(game$get_move_log()) %% 2 == 0) "White" else "Black")
    } else if (status == "white_wins") {
      paste("White wins by", reason, "!")
    } else if (status == "black_wins") {
      paste("Black wins by", reason, "!")
    } else {
      paste("Draw -", reason)
    }
  })

  # --- Value boxes ----------------------------------------------------------
  output$vbox_moves <- renderValueBox({
    game <- game_rv()
    n    <- if (is.null(game)) 0 else nrow(game$get_move_log())
    valueBox(n, "Moves played", icon = icon("list"), color = "blue")
  })

  output$vbox_balance <- renderValueBox({
    game    <- game_rv()
    balance <- if (is.null(game)) 0 else game$get_board()$material_balance()
    colour  <- if (balance > 0) "green" else if (balance < 0) "red" else "yellow"
    label   <- if (balance > 0) paste("+", balance, "White")
               else if (balance < 0) paste(balance, "Black")
               else "Equal"
    valueBox(label, "Material", icon = icon("balance-scale"), color = colour)
  })

  output$move_history_tbl <- renderTable({
    game <- game_rv()
    if (is.null(game)) return(data.frame())
    log <- game$get_move_log()
    if (nrow(log) == 0) return(data.frame(Message = "No moves yet"))
    tail_log <- tail(log, 20)
    tail_log <- tail_log[nrow(tail_log):1, ]
    tail_log[, c("move_number", "colour", "notation")]
  }, striped = TRUE, hover = TRUE, bordered = TRUE, spacing = "xs")

  # --- Tournament -----------------------------------------------------------
  observeEvent(input$btn_run_tournament, {

    players <- list(
      make_play_player(input$t_type1, input$t_name1, input$t_depth1, "white"),
      make_play_player(input$t_type2, input$t_name2, input$t_depth2, "white"),
      make_play_player(input$t_type3, input$t_name3, input$t_depth3, "white")
    )

    t <- ChessSimulator::Tournament$new(players, rounds = input$t_rounds)

    withProgress(message = "Running tournament...", value = 0, {
      t$run(verbose = FALSE)
      setProgress(1)
    })

    tournament_rv(t)

    showNotification(
      paste("Tournament complete!", nrow(t$get_results()), "games played."),
      type = "message", duration = 4
    )
  })

  output$t_vbox_games <- renderValueBox({
    t <- tournament_rv()
    n <- if (is.null(t)) 0 else nrow(t$get_results())
    valueBox(n, "Games played", icon = icon("chess-board"), color = "blue")
  })

  output$t_vbox_leader <- renderValueBox({
    t  <- tournament_rv()
    lb <- if (is.null(t)) NULL else t$leaderboard()
    leader <- if (is.null(lb)) "-" else lb$player[1]
    valueBox(leader, "Leader", icon = icon("trophy"), color = "yellow")
  })

  output$t_vbox_rounds <- renderValueBox({
    valueBox(input$t_rounds %||% 1, "Rounds", icon = icon("sync"), color = "green")
  })

  output$leaderboard_tbl <- renderTable({
    t <- tournament_rv()
    if (is.null(t)) return(data.frame(Message = "Run a tournament to see results."))
    lb <- t$leaderboard()
    if (is.null(lb)) return(data.frame())
    lb
  }, striped = TRUE, hover = TRUE, bordered = TRUE)

  output$all_games_tbl <- renderTable({
    t <- tournament_rv()
    if (is.null(t)) return(data.frame())
    res <- t$get_results()
    if (nrow(res) == 0) return(data.frame(Message = "No games yet."))
    res
  }, striped = TRUE, hover = TRUE, bordered = TRUE, spacing = "xs")
}


# =============================================================================
#  LAUNCH
# =============================================================================
shinyApp(ui, server)

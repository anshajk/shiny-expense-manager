library(shinycssloaders)
library(shiny)
library(plotly)
library(shinythemes)
library(shinyTime)
library(DT)

shinyUI(
  navbarPage(title = "Expense Manager & Visualizer",
             theme = shinytheme("yeti"),
  tabPanel("Expense Logger",
           icon = icon("dollar"),
           sidebarPanel(
             h3("Log Expenses"),
             dateInput("expenseDate","Transaction date",Sys.Date()),
             timeInput("expenseTime","Transaction time", Sys.time() + 5.5*3600),
             selectInput("expenseType","Type of expense",
                         c("Expense","Income","Transfer"),"Expense"),
             numericInput("amount","Amount", 0,0),
             conditionalPanel(condition = "input.expenseType == 'Expense'",
                              selectInput("expenseMode", "Mode of payment",
                                          c("Cash","Card","Paytm","LazyPay",
                                            "Ola Money"),
                                          "Card")),
             conditionalPanel(condition = "input.expenseType == 'Expense'",
                              radioButtons("expenseNeed", "Expense Need",
                                          c("Neccessary","Unnecessary"),
                                          inline = TRUE)),
             uiOutput("transactionCategories"),
             actionButton("submit","Submit",
                          icon = icon("ok",lib = "glyphicon"))
           ),
           mainPanel(
             tabsetPanel(
               tabPanel(p(icon("table"), "Log"),
                        withSpinner(DTOutput("logTable"))
               )
             )
        )
    )
)
)

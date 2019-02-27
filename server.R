library(shiny)
library(DT)
library(anytime)

shinyServer(function(input, output) {
  read_data = reactive({
    transaction_data = read.csv("./transactions.csv")
    transaction_data
  })

  categories = reactive({
    if(input$expenseType == "Expense"){
      choices = read.csv("./expenseCategories.csv")
      selectInput("category","Category",choices = choices)
    }
  })

  observeEvent(input$submit,{
    transaction_data = read_data()
    need = ifelse(input$expenseNeed != "", input$expenseNeed,"")
    mode = ifelse(input$expenseMode != "", input$expenseMode,"")
    new_data = data.frame('date' = input$expenseDate,
                          'time' = input$expenseTime,
                          'type' = input$expenseType,
                          'amount' = input$amount,
                          'need' = need,
                          'category' = input$category,
                          'mode' = mode)
    transaction_data = rbind(transaction_data,new_data)
    write.csv(transaction_data, './transactions.csv')
  })

  output$transactionCategories = renderUI({
    categories()
  })
  output$logTable = renderDT({
    data = read_data()
    data$date = anydate(data$date)
    data$time = anytime(data$time,tz = "Asia/Kolkata")
    data$time = strftime(data$time,format = "%I:%M %p",tz = "Asia/Kolkata")
    data$X = NULL
    data
  })
})

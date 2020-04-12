# Title     : TODO
# Objective : TODO
# Created by: mayank
# Created on: 12/4/2020

two_hour_deadline <- function(hour){
    if (hour >= 0 && hour <= 1){
       result <- '12am-2am'
    }
    else if (hour >= 2 && hour <= 3){

      result <- '2am-4am'
    }
    else if (hour >= 4 && hour <= 5){
       result <- '4am-6am'
    }
    else if (hour >= 6 && hour <= 7){
       result <- '6am-8am'
    }
    else if (hour >= 8 && hour <= 9){
       result <- '8am-10am'
    }
    else if  (hour >= 10 && hour <= 11){
        result <- '10am-12pm'
    }
    else if (hour >= 12 && hour <= 13){
       result <- '12pm-2pm'
    }
    else if (hour >= 14 && hour <= 15){
       result <- '2pm-4pm'
    }
    else if (hour >= 16 && hour <= 17){
       result <- '4pm-6pm'
    }
    else if (hour >= 18 && hour <= 19){
        result <- '6pm-8pm'
    }
   else if (hour >= 20 && hour <= 21){
        result <- '8pm-10pm'
    }
   else if (hour >= 22 && hour <= 23){
        result <- '10pm-12am'
    }
   return(result)
}


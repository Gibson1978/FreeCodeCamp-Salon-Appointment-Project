#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ MY SALON ~~~~~\n"

echo -e "Welcome to My Salon, how can I help you?\n"
MAIN_MENU(){
  if [[ $1 ]]
  then
    echo -e "\n$1\n"
  fi
  APPOINTMENT_MENU
}

APPOINTMENT_MENU(){
  #get available services
  AVAILABLE_SERVICES=$($PSQL "SELECT service_id,name FROM services")
  
  #if no services available
  if [[ -z $AVAILABLE_SERVICES ]]
  then
    #send to main menu
    MAIN_MENU "Sorry, we don't have any services at this moment."
  else
    #Display available services
    echo "$AVAILABLE_SERVICES" | while read SERVICE_ID BAR NAME
    do
      #Format variables to remove trailing spaces using sed with -E extended regular expression
      SERVICE_ID_FORMATTED=$(echo $SERVICE_ID | sed 's/^ *| *$//g')
      NAME_FORMATTED=$(echo $NAME | sed 's/^ *| *$//g')
      echo "$SERVICE_ID_FORMATTED) $NAME_FORMATTED"
    done

    #read input services
    read SERVICE_ID_SELECTED

    #if input not a number
    if [[ ! $SERVICE_ID_SELECTED =~ ^[0-9]+$ ]]
    then
      #send to main menu
      MAIN_MENU "I could not find that service. What would you like today?"
    else
      # if input is a number but not an available service
      SERVICE_ID_CHECK=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")
      if [[ -z $SERVICE_ID_CHECK ]]
      then
        #send back to menu
        MAIN_MENU "I could not find that service. What would you like today?"
      else
        #get customer phone number
        echo -e "\nWhat's your phone number?"
        read CUSTOMER_PHONE

        #get customer name
        CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")
        CUSTOMER_NAME_FORMATTED=$(echo $CUSTOMER_NAME | sed 's/^ *| *$//g')
        
        #if customer name doesnt exist
        if [[ -z $CUSTOMER_NAME_FORMATTED ]]
        then
          #get new customer name
          echo -e "\nI don't have a record for that phone number, what's your name?"
          read CUSTOMER_NAME

          #insert new customer
          INSERT_CUSTOMER_RESULTS=$($PSQL "INSERT INTO customers(name,phone) VALUES('$CUSTOMER_NAME_FORMATTED','$CUSTOMER_PHONE')")
        fi

        #ask for time for appointment
        echo -e "\nWhat time would you like your cut, $CUSTOMER_NAME_FORMATTED"
        read SERVICE_TIME
        
        #get customer id
        CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")

        #insert appointment
        INSERT_APPOINTMENT_RESULTS=$($PSQL "INSERT INTO appointments(customer_id,service_id,time) VALUES('$CUSTOMER_ID','$SERVICE_ID_SELECTED','$SERVICE_TIME')")

        #get service name
        SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")
        SERVICE_NAME_FORMATTED=$(echo $SERVICE_NAME | sed 's/^ *| *$//g')

        echo "I have put you down for a $SERVICE_NAME_FORMATTED at $SERVICE_TIME, $CUSTOMER_NAME_FORMATTED."
        exit 0
      fi
    fi
  fi
  
}

MAIN_MENU


#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=salon --tuples-only -c"
echo -e "\n~~~~~ MY SALON ~~~~~\n"

echo -e "Welcome to My Salon, how can I help you?\n" 
# display services
DISPLAY_SERVICES(){
SERVICES_LIST=$($PSQL "SELECT service_id, name FROM services")
 
  #show service list
  echo "$SERVICES_LIST" | while read SERVICE_ID BAR SERVICE
  do
    echo "$SERVICE_ID) $SERVICE"
  done
}


# main menu
MAIN_MENU(){
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi


 # get service requested
  DISPLAY_SERVICES
  read SERVICE_ID_SELECTED

  # check if service requested is a number
   if [[ ! $SERVICE_ID_SELECTED =~ ^[0-9]+$ ]]
    then  
    MAIN_MENU "I could not find that service. What would you like today?"
    else

  # get service name if one exists
  SERVICE_NAME=$($PSQL"SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")
  # check if service name exisits
  if [[ -z $SERVICE_NAME ]]
  then
    # If it doesn't then return to the main menu
    MAIN_MENU "I could not find that service. What would you like today?"
  fi

  echo -e "\nWhat's your phone number?"
  read CUSTOMER_PHONE
  # Get customer id
  CUSTOMER_ID=$($PSQL"SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
  if [[ -z $CUSTOMER_ID ]]
  then
    echo "I don't have a record for that phone number, what's your name?"
    read CUSTOMER_NAME
    # add customer's name and phone
    INSERT_CUSTOMER_INFO=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE')")
    CUSTOMER_ID=$($PSQL"SELECT customer_id FROM customers WHERE name='$CUSTOMER_NAME'")
  else
   CUSTOMER_NAME=$($PSQL"SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")
  fi
  
  echo -e "\nWhat time would you like your$SERVICE_NAME,$CUSTOMER_NAME?"
  read SERVICE_TIME
  # Insert appointment
  INSERT_APPOINTMENT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")

 echo -e "\nI have put you down for a$SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."

    fi

}



CUT(){
  MAIN_MENU
}

COLOR(){
  MAIN_MENU
}

PERM(){
MAIN_MENU
}

STYLE(){
  MAIN_MENU
}
TRIM(){
  MAIN_MENU
}



MAIN_MENU

#!/bin/bash

DATE=$(date -d "-$(date +%d) days  month" +"%m/%Y")
HOURS=160
PRODUCT_NAME="Usługi informatyczne %s - %s godzin"

printf -v PRODUCT_NAME "$PRODUCT_NAME" $DATE $HOURS
SELL_DATE=$(date -d "-$(date +%d) days  month" +"%Y-%m-%d")
ISSUE_DATE=$SELL_DATE
PAYMENT_TO=$(date --date="+ 7 days $ISSUE_DATE" +"%Y-%m-%d")

CONTENT='{
  "api_token": "'"$API_TOKEN"'",
  "invoice": {
   "sell_date": "'"$SELL_DATE"'",
   "issue_date": "'"$ISSUE_DATE"'",
   "payment_to": "'"$PAYMENT_TO"'",
   "client_id": "'"$CLIENT_ID"'",
   "positions":[
   {"product_id": "'"$PRODUCT_ID"'", "name": "'"$PRODUCT_NAME"'", "quantity":1}
   ]
  }}'


# generate FV
#curl -s https:///${YOUR_DOMAIN}.fakturownia.pl/invoices.json \
#  -H 'Accept: application/json' \
#  -H 'Content-Type: application/json' \
#  -d "$CONTENT" > invoice_result.json
  
#INVOICE_ID=$(jq '.id' ./invoice_result.json)  
#INVOCIE_NUMBER=$(jq '.number' ./invoice_result.json)
INVOICE_ID=94485037
INVOICE_NUMBER="3/02/2021"
INVOICE_FILENAME="faktura-vat-${INVOICE_NUMBER//'/'/'-'}.pdf" 
#echo "https://$YOUR_DOMAIN.fakturownia.pl/invoices/$INVOICE_ID.pdf?api_token=$API_TOKEN -o $INVOICE_FILENAME"
# download FV
curl -X GET "https://$YOUR_DOMAIN.fakturownia.pl/invoices/$INVOICE_ID.pdf?api_token=$API_TOKEN" -o $INVOICE_FILENAME

# send to SAMBA SHARE
#smbclient //192.168.0.1/Office/fv/2021/ -c 'cd $INVOICE_FILENAME ; put local-file'

echo "curl --upload-file $INVOICE_FILENAME  -u 'DOMAIN\andrzej' smb://192.168.0.1/Office/fv/2021/"
ls -l

# send mail with FV
#INVOICE_ID=100
#curl -X POST "https://$YOUR_DOMAIN.fakturownia.pl/invoices/$INVOICE_ID/send_by_email.json?api_token=$API_TOKEN"

#rm invoice_result.json
echo "Created Invoice with number $INVOICE_NUMBER, and id $INVOICE_ID, you can check it at https://$YOUR_DOMAIN.fakturownia.pl/invoices/$INVOICE_ID"

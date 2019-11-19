echo 'Instantiating Pre-requisites for Client Application..'

npm i fabric-ca-client

npm i fabric-network

npm install express body-parser --save
npm install ejs --save
npm install

rm -rf wallet

echo 'Enrolling Admin...'

node enrollAdmin.js

echo 'Registering User..'

node registerUser.js salman

echo 'All Done..'
echo 'You can Also Use API server for Querying or invoking Calls .. Run *node server.js salman * and then Point to your Localhost Port 80..'
echo 'Note: If You are caking calls from outside your serving environment, you need to specify your serving environment IP Address instead Lcalhost in *app.html*..'
echo 'Thatsall from Me..Bye..!!'
exit 1

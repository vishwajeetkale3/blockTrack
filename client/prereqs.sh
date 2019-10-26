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
echo 'You can Also Use API server for Querying or invoking Calls .. Run *node server.js* and then Point to your Localhost Port 80..'

exit 1

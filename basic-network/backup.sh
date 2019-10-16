set -ev

sudo rm -rf backup
mkdir backup
#Copying Certificates and Configuration files
sleep 5
cp -r crypto-config backup
cp -r config backup

cd backup
mkdir peer
mkdir orderer
cd ..
#Copying Peer and orderer data
sleep 5
sudo docker cp peer0.org1.example.com:/var/hyperledger/production/ backup/peer/
sudo docker cp orderer.example.com:/var/hyperledger/production/orderer/ backup/orderer/

#All done
exit 1

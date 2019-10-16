echo "Removing key from key store..."

rm -rf ./hfc-key-store

# Remove chaincode docker image
sudo docker rmi -f dev-peer0.org1.example.com-mycc-1.0-384f11f484b9302df90b453200cfb25174305fce8f53f4e94d45ee3b6cab0ce9
sleep 2

cd ../basic-network
./start.sh

# Now launch the CLI container in order to install, instantiate chaincode
# and prime the ledger with our 10 cars
sudo docker-compose -f ./docker-compose.yml up -d cli
sudo docker ps -a



echo 'Installing chaincode..'
sudo docker exec -e "CORE_PEER_LOCALMSPID=Org1MSP" -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp" cli peer chaincode install -n mycc -v 1.0 -p "/opt/gopath/src/github.com/" -l "node"

echo 'Instantiating chaincode..'
sudo docker exec -e "CORE_PEER_LOCALMSPID=Org1MSP" -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp" cli peer chaincode instantiate -o orderer.example.com:7050 -C mychannel -n mycc -l "node" -v 1.0 -c '{"Args":["salman279","12345","Salman","+1324793693"]}' -P "OR ('Org1MSP.member','Org2MSP.member')"
echo 'Getting things ready for Chaincode Invocation..should take only 10 seconds..'
sleep 10
echo 'Adding Consignment..'

sudo docker exec -e “CORE_PEER_LOCALMSPID=Org1MSP” -e “CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp” cli peer chaincode invoke -o orderer.example.com:7050 -C mychannel -n mycc -c '{"function":"bookConsignment","Args":["Guntur","Hyderabad","KiranKumar","6-14/7C,Mill Road, Guntur","91697737397","Kalpana","2-14/A,Near Mandal Office,Hyderabad","91467683763","DoubleCot Bed","250Kg",525","16/10/19"]}'

sleep 5
echo 'Querying Invoice.. and Tracking..'

sudo docker exec -e “CORE_PEER_LOCALMSPID=Org1MSP” -e “CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp” cli peer chaincode invoke -o orderer.example.com:7050 -C mychannel -n mycc -c '{"function":"trackConsignment","Args":["I916977373971"]}'


sudo docker exec -e “CORE_PEER_LOCALMSPID=Org1MSP” -e “CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp” cli peer chaincode invoke -o orderer.example.com:7050 -C mychannel -n mycc -c '{"function":"trackConsignment","Args":["T914676837631"]}'
sleep 5 

echo 'Updating Shipment '

sudo docker exec -e “CORE_PEER_LOCALMSPID=Org1MSP” -e “CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp” cli peer chaincode invoke -o orderer.example.com:7050 -C mychannel -n mycc -c '{"function":"UpdateShipment","Args":["salman279","12345","T916977373971","Reached Suryapet"]}'

sleep 5
 echo "querying Again To track.."
sudo docker exec -e “CORE_PEER_LOCALMSPID=Org1MSP” -e “CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp” cli peer chaincode invoke -o orderer.example.com:7050 -C mychannel -n mycc -c '{"function":"trackConsignment","Args":["T914676837631"]}'

sleep 5
# Starting docker logs of chaincode container

sudo docker logs -f dev-peer0.org1.example.com-mycc-1.0



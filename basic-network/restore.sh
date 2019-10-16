set -ev

#bringing network down and clearing volumes

sudo docker-compose -f docker-compose.yml down

sudo docker volume prune

sudo docker network prune

#Bringing network Up with Previous Backup

sudo docker-compose -f restore-network.yml up -d
#All done...
sleep 20

#querying Data

sudo docker exec -e “CORE_PEER_LOCALMSPID=Org1MSP” -e “CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp” cli peer chaincode invoke -o orderer.example.com:7050 -C mychannel -n mycc -c '{"function":"queryMarks","Args":["Alice"]}'

exit 1

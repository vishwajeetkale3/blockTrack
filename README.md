# blockTrack
Goods transport and tracking system on Hyperledger Fabric

#### Quick demo

```
git clone https://github.com/Salmandabbakuti/blockTrack.git

cd blockTrack/client
chmod 777 start.sh
chmod 777 prereqs.sh
./start.sh  #(Container level operations Starting network,chaincode deployment and chaincode operations)
./prereqs.sh #(Nodejs Server Setup)

node server.js salman #(Application frontend and Server Runs at port 80)
```

>Note: if you are Using Cloud instance, you need to specify machine IP address in ```client/app.html``` file instead of local host


#### Tracking Info
<img align=center src="https://github.com/Salmandabbakuti/blockTrack/blob/master/track.png">

#### Invoice Info
<img align=center src="https://github.com/Salmandabbakuti/blockTrack/blob/master/inv.jpg">



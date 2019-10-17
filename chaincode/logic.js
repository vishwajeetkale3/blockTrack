'use strict';
let Id = 0;
const shim = require('fabric-shim');
const util = require('util');
let Chaincode = class {

	async Init(stub, args) {
		try {
                 let ret = stub.getFunctionAndParameters();
                 console.info(ret);
                 let arg= ret.params;
			let adminData = {
			UserId: arg[0],
                        Type:'admin',
			AccessKey: arg[1],
			Name: arg[2],
			Mobile: arg[3]
		}
		await stub.putState(arg[0], Buffer.from(JSON.stringify(adminData)));
		console.info('===Admin Added ===');

                return shim.success();
		} catch (err) {
			console.log(err);
			return shim.error(err);
		}

     }
	async Invoke(stub) {
		let ret = stub.getFunctionAndParameters();
		console.info(ret);

		let method = this[ret.fcn];
		if (!method) {
			console.error('no function of name:' + ret.fcn + ' found');
			throw new Error('Received unknown function ' + ret.fcn + ' invocation');
		}
		try {
			let payload = await method(stub, ret.params);
			return shim.success(payload);
		} catch (err) {
			console.log(err);
			return shim.error(err);
		}
	}
	async trackConsignment(stub, args) {

		let consignmentAsBytes = await stub.getState(args[0]);
		if (!consignmentAsBytes || consignmentAsBytes.toString().length <= 0) {
			throw new Error('Item With this Id Doesnt Exist..!');
		}
		let consignmentCheck = JSON.parse(consignmentAsBytes);
		if (consignmentCheck.Type!= 'consignment') {

			throw new Error("Not a Consignment..!");

		} else {

			let consignment = JSON.parse(consignmentAsBytes.toString());
			console.log(consignment);
			return consignmentAsBytes;

		}


	}
	async bookConsignment(stub, args) {
		let UID = ++Id;
		let invoiceId = 'I' + args[4] + UID;
		let trackingId = 'T' + args[7] + UID;

		let consignmentData = {
			From: args[0],
			To: args[1],
			Type: 'consignment',
			consignerName: args[2],
			consignerAddress: args[3],
			consignerMobile: args[4],
			consigneeName: args[5],
			consigneeAddress: args[6],
			consigneeMobile: args[7],
			ItemName: args[8],
			ItemWeight: args[9],
			FrieghtCharges: args[10],
			InvoiceId: invoiceId,
			TrackingId: trackingId,
			Date: args[11]
		}

		let trackingData = {
			ItemName: args[8],
			From: args[0],
			Type: 'consignment',
			To: args[1],
			ShipmentDetails: [],
			CurrentLocation: 'Not Yet Shipped'
		};

		await stub.putState(trackingId, Buffer.from(JSON.stringify(trackingData)));
		await stub.putState(invoiceId, Buffer.from(JSON.stringify(consignmentData)));
		console.info("Consignment Added Succesfully.. Your Invoice Id is " + invoiceId + " And Tracking Id is " + trackingId);
		console.log("Consignment Added Succesfully.. Your Invoice Id is " + invoiceId + " And Tracking Id is " + trackingId);


	}

	async UpdateShipment(stub, args) {

		let adminAsBytes = await stub.getState(args[0]);
		let consignmentAsBytes = await stub.getState(args[2]);

		if (!adminAsBytes || adminAsBytes.toString().length <= 0) {
			throw new Error('Incorrect Admin Id..!');
		}
		let admin = JSON.parse(adminAsBytes);

		if (admin.AccessKey != args[1]) {

			throw new Error("Incorrect AccesKey...!");
		}

		if (!consignmentAsBytes || consignmentAsBytes.toString().length <= 0) {
			throw new Error('Consignment With this Id Does not Existed..!');
		} else {
			let consignment = JSON.parse(consignmentAsBytes);

			consignment.ShipmentDetails.push(args[3]);
			consignment.CurrentLocation = args[3];
			await stub.putState(args[2], Buffer.from(JSON.stringify(consignment)));
			console.info("Consignment Details Updated Succesfully");

		}
	}
}

shim.start(new Chaincode());

//Developed by Salman Dabbakuti

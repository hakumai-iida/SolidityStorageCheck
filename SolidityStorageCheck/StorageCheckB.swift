//
//  StorageCheckB.swift
//  SolidityStorageCheck
//
//  Created by 飯田白米 on 2020/03/12.
//  Copyright © 2020 飯田白米. All rights reserved.
//

import Foundation
import UIKit
import BigInt
import web3swift

//-------------------------------------------------------------
// [StorageCheckB.sol]
//-------------------------------------------------------------
class StorageCheckB {
    //--------------------------------
    // [abi]ファイルの内容
    //--------------------------------
    internal let abiString = """
[
  {
    "constant": true,
    "inputs": [
      {
        "internalType": "uint256",
        "name": "",
        "type": "uint256"
      }
    ],
    "name": "arrData",
    "outputs": [
      {
        "internalType": "uint256",
        "name": "userId",
        "type": "uint256"
      },
      {
        "internalType": "uint256",
        "name": "publicKey",
        "type": "uint256"
      },
      {
        "internalType": "uint256",
        "name": "hash",
        "type": "uint256"
      },
      {
        "internalType": "uint256",
        "name": "option",
        "type": "uint256"
      }
    ],
    "payable": false,
    "stateMutability": "view",
    "type": "function"
  },
  {
    "constant": true,
    "inputs": [],
    "name": "getTotalData",
    "outputs": [
      {
        "internalType": "uint256",
        "name": "",
        "type": "uint256"
      }
    ],
    "payable": false,
    "stateMutability": "view",
    "type": "function"
  },
  {
    "constant": false,
    "inputs": [
      {
        "internalType": "uint256",
        "name": "_val256",
        "type": "uint256"
      }
    ],
    "name": "createWithMemory",
    "outputs": [],
    "payable": false,
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "constant": false,
    "inputs": [
      {
        "internalType": "uint256",
        "name": "_val256",
        "type": "uint256"
      }
    ],
    "name": "createWithStorage",
    "outputs": [],
    "payable": false,
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "constant": false,
    "inputs": [
      {
        "internalType": "uint256",
        "name": "_at",
        "type": "uint256"
      },
      {
        "internalType": "uint256",
        "name": "_val256",
        "type": "uint256"
      }
    ],
    "name": "updateDirect",
    "outputs": [],
    "payable": false,
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "constant": false,
    "inputs": [
      {
        "internalType": "uint256",
        "name": "_at",
        "type": "uint256"
      },
      {
        "internalType": "uint256",
        "name": "_val256",
        "type": "uint256"
      }
    ],
    "name": "updateWithStorage",
    "outputs": [],
    "payable": false,
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "constant": false,
    "inputs": [
      {
        "internalType": "uint256",
        "name": "_at",
        "type": "uint256"
      },
      {
        "internalType": "uint256",
        "name": "_val256",
        "type": "uint256"
      }
    ],
    "name": "updateWithMemory",
    "outputs": [],
    "payable": false,
    "stateMutability": "nonpayable",
    "type": "function"
  }
]
"""

    //--------------------------------
    // コントラクトの取得
    //--------------------------------
    internal func getContract( _ helper:Web3Helper ) -> web3.web3contract? {
        var address:String
        
        // FIXME ご自身がデプロイしたコントラクトのアドレスに置き換えてください
        // メモ：[rinkeby]のアドレスは実際に存在するコントラクトなので、そのままでも利用できます
        switch helper.getCurTarget()! {
        case Web3Helper.target.mainnet:
            address = ""
            
        case Web3Helper.target.ropsten:
            address = ""

        case Web3Helper.target.kovan:
            address = ""

        case Web3Helper.target.rinkeby:
            address = "0x084E8be241db42C965bC560D37d3ee1485CED579"
        }
        
        let contractAddress = EthereumAddress( address )
        
        let web3 = helper.getWeb3()
        
        let contract = web3!.contract( abiString, at: contractAddress, abiVersion: 2 )
        
        return contract
    }
    
    //---------------------------------------------------
    // arrData
    //---------------------------------------------------
    public func arrData( _ helper:Web3Helper, id:BigUInt ) throws -> [String:Any]{
        let contract = getContract( helper )
        
        let parameters = [id] as [AnyObject]
        let tx = contract!.read( "arrData", parameters:parameters )
        let response = try tx!.callPromise().wait()
        
        return response
    }

    //---------------------------------------------------
    // getTotalData
    //---------------------------------------------------
    public func getTotalData( _ helper:Web3Helper ) throws -> BigUInt?{
        let contract = getContract( helper )

        let tx = contract!.read( "getTotalData" )
        let response = try tx!.callPromise().wait()
        
        return response["0"] as? BigUInt
    }
    
    //---------------------------------------------------
    // createWithMemory
    //---------------------------------------------------
    public func createWithMemory( _ helper:Web3Helper, password:String, val256:BigUInt ) throws -> String{
        let contract = getContract( helper )
        
        let parameters = [val256] as [AnyObject]
        let data = Data()
        var options = TransactionOptions.defaultOptions
        options.from = helper.getCurAddress()
        let tx = contract!.write( "createWithMemory", parameters:parameters, extraData:data, transactionOptions:options )
        let response = try tx!.sendPromise( password: password ).wait()
        
        return response.hash
    }
    
    //---------------------------------------------------
    // createWithStorage
    //---------------------------------------------------
    public func createWithStorage( _ helper:Web3Helper, password:String, val256:BigUInt ) throws -> String{
        let contract = getContract( helper )
        
        let parameters = [val256] as [AnyObject]
        let data = Data()
        var options = TransactionOptions.defaultOptions
        options.from = helper.getCurAddress()
        let tx = contract!.write( "createWithStorage", parameters:parameters, extraData:data, transactionOptions:options )
        let response = try tx!.sendPromise( password: password ).wait()
        
        return response.hash
    }

    //---------------------------------------------------
    // updateDirect
    //---------------------------------------------------
    public func updateDirect( _ helper:Web3Helper, password:String, id:BigUInt, val256:BigUInt ) throws -> String{
        let contract = getContract( helper )
        
        let parameters = [id, val256] as [AnyObject]
        let data = Data()
        var options = TransactionOptions.defaultOptions
        options.from = helper.getCurAddress()
        let tx = contract!.write( "updateDirect", parameters:parameters, extraData:data, transactionOptions:options )
        let response = try tx!.sendPromise( password: password ).wait()

        return response.hash
    }

    //---------------------------------------------------
    // updateWithStorage
    //---------------------------------------------------
    public func updateWithStorage( _ helper:Web3Helper, password:String, id:BigUInt, val256:BigUInt ) throws -> String{
        let contract = getContract( helper )
        
        let parameters = [id, val256] as [AnyObject]
        let data = Data()
        var options = TransactionOptions.defaultOptions
        options.from = helper.getCurAddress()
        let tx = contract!.write( "updateWithStorage", parameters:parameters, extraData:data, transactionOptions:options )
        let response = try tx!.sendPromise( password: password ).wait()

        return response.hash
    }

    //---------------------------------------------------
    // updateWithMemory
    //---------------------------------------------------
    public func updateWithMemory( _ helper:Web3Helper, password:String, id:BigUInt, val256:BigUInt ) throws -> String{
        let contract = getContract( helper )
        
        let parameters = [id, val256] as [AnyObject]
        let data = Data()
        var options = TransactionOptions.defaultOptions
        options.from = helper.getCurAddress()
        let tx = contract!.write( "updateWithMemory", parameters:parameters, extraData:data, transactionOptions:options )
        let response = try tx!.sendPromise( password: password ).wait()

        return response.hash
    }
}

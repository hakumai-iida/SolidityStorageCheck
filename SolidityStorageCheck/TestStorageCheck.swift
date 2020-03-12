//
//  TestStorageCheck.swift
//  SolidityStorageCheck
//
//  Created by 飯田白米 on 2020/03/12.
//  Copyright © 2020 飯田白米. All rights reserved.
//

import Foundation
import UIKit
import BigInt
import web3swift

class TestStorageCheck {
    //-------------------------
    // メンバー
    //-------------------------
    let helper: Web3Helper              // [web3swift]利用のためのヘルパー
    let keyFile: String                 // 直近に作成されたキーストアを保持するファイル
    let password: String                // アカウント作成時のパスワード
    let targetNet: Web3Helper.target    // 接続先
    var isBusy = false                  // 重複呼び出し回避用

    //-------------------------
    // イニシャライザ
    //-------------------------
    public init(){
        // ヘルパー作成
        self.helper = Web3Helper()
    
        // キーストアファイル
        self.keyFile = "key.json"

        // FIXME ご自身のパスワードで置き換えてください
        // メモ：このコードはテスト用なのでソース内にパスワードを書いていますが、
        //      公開を前提としたアプリを作る場合、ソース内にパスワードを書くことは大変危険です！
        self.password = "password"
                
        // FIXME ご自身のテストに合わせて接続先を変更してください
        self.targetNet = Web3Helper.target.rinkeby
    }

    //-------------------------
    // テストの開始
    //-------------------------
    public func test() {
        // テスト中なら無視
        if( self.isBusy ){
            print( "@ TestStorageCheck: busy!" )
            return;
        }
        self.isBusy = true;
        
        // キュー（メインとは別のスレッド）で処理する
        let queue = OperationQueue()
        queue.addOperation {
            self.execTest()
            self.isBusy = false;
        }
    }

    //-------------------------
    // テストの開始
    //-------------------------
    func execTest() {
        print( "@-----------------------------" )
        print( "@ TestStorageCheck: start..." )
        print( "@-----------------------------" )

        do{
            // 接続先の設定
            self.setTarget()
            
            // キーストア（イーサリアムアドレス）の設定
            self.setKeystore()
            
            // 残高の確認
            self.checkBalance()

            // ストレージの確認
            try self.checkStorageA()
            try self.checkStorageB()
            try self.checkStorageC()
        } catch {
            print( "@ TestStorageCheck: error:", error )
        }
        
        print( "@-----------------------------" )
        print( "@ TestStorageCheck: finished" )
        print( "@-----------------------------" )
    }

    //-----------------------------------------
    // JSONファイルの保存
    //-----------------------------------------
    func saveKeystoreJson( json : String ) -> Bool{
        let userDir = NSSearchPathForDirectoriesInDomains( .documentDirectory, .userDomainMask, true )[0]
        let keyPath = userDir + "/" + self.keyFile
        return FileManager.default.createFile( atPath: keyPath, contents: json.data( using: .ascii ), attributes: nil )
    }
    
    //-----------------------------------------
    // JSONファイルの読み込み
    //-----------------------------------------
    func loadKeystoreJson() -> String?{
        let userDir = NSSearchPathForDirectoriesInDomains( .documentDirectory, .userDomainMask, true )[0]
        let keyPath = userDir + "/" + self.keyFile
        return try? String( contentsOfFile: keyPath, encoding: String.Encoding.ascii )
    }

    //-----------------------------------------
    // 接続先設定
    //-----------------------------------------
    func setTarget(){
        print( "@------------------" )
        print( "@ setTarget" )
        print( "@------------------" )
        _ = self.helper.setTarget( target: self.targetNet )
        
        let target = self.helper.getCurTarget()
        print( "@ target:", target! )
    }

    //-----------------------------------------
    // キーストア設定
    //-----------------------------------------
    func setKeystore() {
        print( "@------------------" )
        print( "@ setKeystore" )
        print( "@------------------" )

        // キーストアのファイルを読み込む
        if let json = self.loadKeystoreJson(){
            print( "@ loadKeystoreJson: json=", json )

            let result = helper.loadKeystore( json: json )
            print( "@ loadKeystore: result=", result )
        }
        
        // この時点でヘルパーが無効であれば新規キーストアの作成
        if !helper.isValid() {
            if helper.createNewKeystore(password: self.password){
                print( "@ CREATE NEW KEYSTORE" )
                
                let json = helper.getCurKeystoreJson()
                print( "@ Write down below json code to import generated account into your wallet apps(e.g. MetaMask)" )
                print( json! )

                let privateKey = helper.getCurPrivateKey( password : self.password )
                print( "@ privateKey:", privateKey! )

                // 出力
                let result = self.saveKeystoreJson( json: json! )
                print( "@ saveKeystoreJson: result=", result )
            }
        }

        // イーサリアムアドレスの確認
        let ethereumAddress = helper.getCurEthereumAddress()
        print( "@ CURRENT KEYSTORE" )
        print( "@ ethereumAddress:", ethereumAddress! )
    }

    //------------------------
    // 残高確認
    //------------------------
    func checkBalance() {
        print( "@------------------" )
        print( "@ checkBalance" )
        print( "@------------------" )
        
        let balance = self.helper.getCurBalance()
        print( "@ balance:", balance!, "wei" )
    }
    
    //--------------------------
    // ストレージチェック：Ａ
    //--------------------------
    func checkStorageA() throws{
        print( "@------------------" )
        print( "@ checkStorage:A" )
        print( "@------------------" )

        let contract = StorageCheckA()
        var hash: String

        // 要素数取得
        let total = try contract.getTotalData( self.helper )
        print( "@ getTotalData:", total! )

        // データの確認：直近５個）
        var start: BigUInt;
        if total! <= 4 {
            start = 0
        }else{
            start = total! - 5
        }
        
        for i in start ..< total! {
            let structData = try contract.arrData( self.helper, id:i )
            print( "@ arrData(id=\(i)):", structData  )
        }

        // create with memory
        hash = try contract.createWithMemory( self.helper, password:self.password, val256:( total!+0 ) )
        print( "@ createWithMemory(id=\(total!)):", hash )

        // create with storage
        hash = try contract.createWithStorage( self.helper, password:self.password, val256:( total!+1 ) )
        print( "@ createWithStorage(id=\(total!+1)):", hash )

        // update directly
        if total! >= 3 {
            hash = try contract.updateDirect( self.helper, password:self.password, id:(total!-3), val256:100*( total!-3 ) )
            print( "@ updateDirect(id=\(total!-3)):", hash )
        }

        // update with strorage
        if total! >= 2 {
            hash = try contract.updateWithStorage( self.helper, password:self.password, id:(total!-2), val256:10*(total!-2) )
            print( "@ updateWithStorage(id=\(total!-2)):", hash )
        }

        // update with memory
        if total! >= 1 {
            hash = try contract.updateWithMemory( self.helper, password:self.password, id:(total!-1), val256:10*(total!-1) )
            print( "@ updateWithMemory(id=\(total!-1)):", hash )
        }
    }
    
    //--------------------------
    // ストレージチェック：Ｂ
    //--------------------------
    func checkStorageB() throws{
        print( "@------------------" )
        print( "@ checkStorage:B" )
        print( "@------------------" )

        let contract = StorageCheckB()
        var hash: String

        // 要素数取得
        let total = try contract.getTotalData( self.helper )
        print( "@ getTotalData:", total! )

        // データの確認：直近５個）
        var start: BigUInt;
        if total! <= 4 {
            start = 0
        }else{
            start = total! - 5
        }
        
        for i in start ..< total! {
            let structData = try contract.arrData( self.helper, id:i )
            print( "@ arrData(id=\(i)):", structData  )
        }

        // create with memory
        hash = try contract.createWithMemory( self.helper, password:self.password, val256:( total!+0 ) )
        print( "@ createWithMemory(id=\(total!)):", hash )

        // create with storage
        hash = try contract.createWithStorage( self.helper, password:self.password, val256:( total!+1 ) )
        print( "@ createWithStorage(id=\(total!+1)):", hash )

        // update directly
        if total! >= 3 {
            hash = try contract.updateDirect( self.helper, password:self.password, id:(total!-3), val256:100*( total!-3 ) )
            print( "@ updateDirect(id=\(total!-3)):", hash )
        }

        // update with strorage
        if total! >= 2 {
            hash = try contract.updateWithStorage( self.helper, password:self.password, id:(total!-2), val256:10*(total!-2) )
            print( "@ updateWithStorage(id=\(total!-2)):", hash )
        }

        // update with memory
        if total! >= 1 {
            hash = try contract.updateWithMemory( self.helper, password:self.password, id:(total!-1), val256:10*(total!-1) )
            print( "@ updateWithMemory(id=\(total!-1)):", hash )
        }
    }

    //--------------------------
    // ストレージチェック：Ｃ
    //--------------------------
    func checkStorageC() throws{
        print( "@------------------" )
        print( "@ checkStorage:C" )
        print( "@------------------" )

        let contract = StorageCheckC()
        var hash: String

        // 要素数取得
        let total = try contract.getTotalData( self.helper )
        print( "@ getTotalData:", total! )

        // データの確認：直近５個）
        var start: BigUInt;
        if total! <= 4 {
            start = 0
        }else{
            start = total! - 5
        }
        
        for i in start ..< total! {
            let structData = try contract.arrData( self.helper, id:i )
            print( "@ arrData(id=\(i)):", structData  )
        }

        // create with memory
        hash = try contract.createWithMemory( self.helper, password:self.password, val256:( total!+0 ) )
        print( "@ createWithMemory(id=\(total!)):", hash )

        // create with storage
        hash = try contract.createWithStorage( self.helper, password:self.password, val256:( total!+1 ) )
        print( "@ createWithStorage(id=\(total!+1)):", hash )

        // update directly
        if total! >= 3 {
            hash = try contract.updateDirect( self.helper, password:self.password, id:(total!-3), val256:100*( total!-3 ) )
            print( "@ updateDirect(id=\(total!-3)):", hash )
        }

        // update with strorage
        if total! >= 2 {
            hash = try contract.updateWithStorage( self.helper, password:self.password, id:(total!-2), val256:10*(total!-2) )
            print( "@ updateWithStorage(id=\(total!-2)):", hash )
        }

        // update with memory
        if total! >= 1 {
            hash = try contract.updateWithMemory( self.helper, password:self.password, id:(total!-1), val256:10*(total!-1) )
            print( "@ updateWithMemory(id=\(total!-1)):", hash )
        }
    }
}

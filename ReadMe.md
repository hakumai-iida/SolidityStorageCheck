## はじめに  
**iOS** で **Ethereum** ブロックチェーンへアクセスし、**storage** 変数経由、**memory** 変数経由等でのブロックチェーン書き込みをするテストアプリです。  

イーサリアムクライアントとして [**web3swift**](https://github.com/matter-labs/web3swift)  ライブラリを利用させていただいております。     

----
## 手順  
### ・**CocoaPods** の準備
　ターミナルを開き下記のコマンドを実行します  
　`$ sudo gem install cocoapods`  

### ・**web3swift** のインストール
　ターミナル上で **SolidityStorageCheck** フォルダ(※ **Podfile** のある階層)へ移動し、下記のコマンドを実行します  
　`$ pod install`  
　
### ・ワークスペースのビルド
　**SolidityStorageCheck.xcworkspace** を **Xcode** で開いてビルドします  
　（※間違えて **SolidityStorageCheck.xcodeproj** のほうを開いてビルドするとエラーになるのでご注意ください）
　
### ・動作確認
　**Xcode** から **iOS** 端末にてアプリを起動し、画面をタップするとテストが実行されます  
　**Xcode** のデバッグログに下記のようなログが表示されるのでソースコードと照らし合わせてご確認下さい

---

> @-----------------------------  
> @ TestStorageCheck: start...  
> @-----------------------------  
> @------------------  
> @ setTarget  
> @------------------  
> @ target: rinkeby  
> @------------------  
> @ setKeystore  
> @------------------  
> @ loadKeystoreJson: json= {"version":3,"id":"3cc36c34-a5e1-4820-b564-9b557369f2fd","crypto":{"ciphertext":"ac66a745db2e2c24e66aec10a23f5fa1482affde451cce542b5524114b2e93df","cipherparams":{"iv":"6d9587c2aa7be4bbee414c73d834f434"},"kdf":"scrypt","kdfparams":{"r":6,"p":1,"n":4096,"dklen":32,"salt":"f7adf2106474a94bb5bbe206eb09ba9fda3b5ea093cf9ca49858e40b86f95ac4"},"mac":"095d02b1e96c55389ff16444a5c5f427cca88b22cbb82b32c26dc04eb18913e8","cipher":"aes-128-ctr"},"address":"0xe2c383920cf6040264efe20896308d05ca6c9a58"}  
> @ loadKeystore: result= true  
> @ CURRENT KEYSTORE  
> @ ethereumAddress: 0xE2c383920Cf6040264EFe20896308D05CA6C9A58  
> @------------------  
> @ checkBalance  
> @------------------  
> @ balance: 190484851000000000 wei  
> @------------------  
> @ checkStorage:A  
> @------------------  
> @ getTotalData: 38  
> @ arrData(id=33): ["3": 3300, "maxPrice": 3300, "minPrice": 3300, "2": 3300, "1": 3300, "ownerId": 3300, "serialNo": 3300, "0": 3300]  
> @ arrData(id=34): ["3": 340, "minPrice": 340, "ownerId": 340, "2": 340, "0": 340, "serialNo": 340, "maxPrice": 340, "1": 340]  
> @ arrData(id=35): ["minPrice": 350, "3": 350, "maxPrice": 350, "ownerId": 350, "2": 350, "0": 350, "1": 350, "serialNo": 350]  
> @ arrData(id=36): ["0": 36, "minPrice": 36, "2": 36, "1": 36, "ownerId": 36, "serialNo": 36, "maxPrice": 36, "3": 36]  
> @ arrData(id=37): ["maxPrice": 37, "serialNo": 37, "2": 37, "1": 37, "0": 37, "3": 37, "minPrice": 37, "ownerId": 37]  
> @ createWithMemory(id=38): 0xc72481d658263a33c47a968665ec9efa043ebbba72308dfeb0c9720de5ec6d0e  
> @ createWithStorage(id=39): 0xc805943d9468cf0cddd75d3749aeecd6e187dcf329dbb0719a017dcf6642c74d  
> @ updateDirect(id=35): 0xaaf573a873e730169f5eb0457baeb05fa6ea6391d2be6067550141453f28ca10  
> @ updateWithStorage(id=36): 0xc9882a873c71eeb3240950ebe9782e417a2ae94eb65b9efad662c252c7571628  
> @ updateWithMemory(id=37): 0xd0b1f8bc5234c8293ff8cfd0fea2fcf0baee50d1baad38815817e19375929088  
> @------------------  
> @ checkStorage:B  
> @------------------  
> @ getTotalData: 14  
> @ arrData(id=9): ["publicKey": 900, "hash": 900, "3": 900, "option": 900, "userId": 900, "0": 900, "2": 900, "1": 900]  
> @ arrData(id=10): ["userId": 100, "option": 100, "hash": 100, "2": 100, "1": 100, "publicKey": 100, "0": 100, "3": 100]  
> @ arrData(id=11): ["hash": 110, "0": 110, "userId": 110, "1": 110, "publicKey": 110, "3": 110, "option": 110, "2": 110]  
> @ arrData(id=12): ["publicKey": 12, "userId": 12, "2": 12, "3": 12, "0": 12, "1": 12, "hash": 12, "option": 12]  
> @ arrData(id=13): ["option": 13, "1": 13, "0": 13, "3": 13, "2": 13, "hash": 13, "userId": 13, "publicKey": 13]  
> @ createWithMemory(id=14): 0x857cfc4a62bd37722fc56ec46dae317e24c2536730424e194c8954a4c8cbe5dc  
> @ createWithStorage(id=15): 0x183b77943c5d900c7cf6aad8c4292a98ee80e1e87db27553443b882b9e194824  
> @ updateDirect(id=11): 0x374d304bf1fee7b9d3c5677504e8f4798b980f785382d9ddda53afa26f09af19  
> @ updateWithStorage(id=12): 0x088b30cceccdcd9a4bf0049b1c36b6e9a197b690037a4407812fb220e9a8f522  
> @ updateWithMemory(id=13): 0x689d5c88f8622e319ae79baf9327f335ec048cebad104d4aeef670b1b61abf07  
> @------------------  
> @ checkStorage:C  
> @------------------  
> @ getTotalData: 14  
> @ arrData(id=9): ["3": 900, "2": 900, "guard": 900, "6": 900, "speed": 900, "luck": 900, "mp": 900, "5": 900, "rscId": 900, "attack": 900, "0": 900, "1": 900, "4": 900, "hp": 900]  
> @ arrData(id=10): ["rscId": 100, "2": 100, "3": 100, "1": 100, "speed": 100, "6": 100, "4": 100, "hp": 100, "5": 100, "0": 100, "guard": 100, "attack": 100, "mp": 100, "luck": 100]  
> @ arrData(id=11): ["hp": 110, "6": 110, "2": 110, "speed": 110, "4": 110, "attack": 110, "guard": 110, "0": 110, "5": 110, "rscId": 110, "mp": 110, "3": 110, "1": 110, "luck": 110]  
> @ arrData(id=12): ["luck": 12, "rscId": 12, "5": 12, "mp": 12, "1": 12, "6": 12, "attack": 12, "4": 12, "3": 12, "guard": 12, "0": 12, "2": 12, "hp": 12, "speed": 12]  
> @ arrData(id=13): ["speed": 13, "5": 13, "1": 13, "guard": 13, "2": 13, "luck": 13, "mp": 13, "4": 13, "3": 13, "6": 13, "0": 13, "hp": 13, "attack": 13, "rscId": 13]  
> @ createWithMemory(id=14): 0x2e9d2b8960cee08f727291c05af7a243a9dfe57b60cfb853bcd29f4cc3468637  
> @ createWithStorage(id=15): 0xa319441b7a35399ed45fe633a76feee950029688579e297d8c039c6869f5f4e8  
> @ updateDirect(id=11): 0x39c02b16fb92a7d38424da76a4b57c96f6f7931c974128d9aa41f0ca9ec8c31a  
> @ updateWithStorage(id=12): 0x7c6b3138c17aa2f96d451e317b71e6a85e44874daad82da389642f67598371e0  
> @ updateWithMemory(id=13): 0xe375da21f58afaecdc00f4f3b71641d49c072546f924779a6b93ff7cdcb19c68  
> @-----------------------------  
> @ TestStorageCheck: finished  
> @-----------------------------  

---

## 補足

テスト用のコードが **TestStorageCheck.swift**、簡易ヘルパーが **Web3Helper.swift**、 イーサリアム上のコントラクトに対応するコードが、各 **StorageCheckX.swift**となります。  

その他のソースファイルは **Xcode** の **Game** テンプレートが吐き出したコードそのまんまとなります。ただし、画面タップでテストを呼び出すためのコードが **GameScene.swift** に２行だけ追加してあります。

**sol/StorageCheckX.sol** が各コントラクトのソースとなります。**Xcode** では利用していません。

テストが開始されると、デフォルトで **Rinkeby** テストネットへ接続します。  

初回の呼び出し時であればアカウントを作成し、その内容をアプリのドキュメント領域に **key.json** の名前で出力します。二度目以降の呼び出し時は **key.json** からアカウント情報を読み込んで利用します。  

コントラクトへの書き込みテストは、対象のアカウントに十分な残高がないとエラーとなります。**Xcode** のログにアカウント情報が表示されるので、適宜、対象のアカウントに送金してテストしてください。
  
----
## メモ
　2020年3月12日の時点で、下記の環境で動作確認を行なっています。  

#### 実装環境
　・**macOS Mojave 10.14.4**  
　・**Xcode 11.3.1(11C504)**

#### 確認端末
　・**iPad**(第六世代) **iOS 12.2**  

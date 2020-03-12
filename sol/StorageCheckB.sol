pragma solidity ^0.5.12;

//----------------------
// ストレージ確認：Ｂ
//----------------------
contract StorageCheckB{

  //------------------------------------------
  // テストデータ：シンプルだけど４ワード使う構成
  //------------------------------------------
  struct  MyData{
    uint256    userId;
    uint256    publicKey;
    uint256    hash;
    uint256    option;
  }

  // データ配列（※内容を確認したいので公開）
  MyData[] public arrData;

  //-------------------------------------------
  // データ数の取得
  //-------------------------------------------
  function getTotalData() public view returns( uint256 ){
    return arrData.length;
  }

  //-------------------------------------------
  // メモリ上でデータを作成したあとに追加
  //-------------------------------------------
  function createWithMemory( uint256 _val256 ) public{
    // メモリ上で値を設定
    MyData memory newData = MyData({
      userId:_val256,
      publicKey:_val256,
      hash:_val256,
      option:_val256
    });

    // 設定したデータを追加
		arrData.push( newData );
	}

  //-------------------------------------------
  // データを追加した後でストレージ上で設定
  //-------------------------------------------
  function createWithStorage( uint256 _val256 ) public{
    // 配列の要領を増やす（※末尾に空要素が追加される）
    arrData.length += 1;

    // ストレージ変数として取り出して設定
    MyData storage lastData = arrData[arrData.length-1];
    lastData.userId = _val256;
    lastData.publicKey = _val256;
    lastData.hash = _val256;
    lastData.option = _val256;
  }

  //-------------------------------------------
  // データを直接更新
  //-------------------------------------------
  function updateDirect( uint256 _at, uint256 _val256 ) public{
    require( _at >= 0 && _at < arrData.length );

    arrData[_at].userId = _val256;
    arrData[_at].publicKey = _val256;
    arrData[_at].hash = _val256;
    arrData[_at].option = _val256;
  }

  //-------------------------------------------
  // ストレージ変数を利用して更新
  //-------------------------------------------
  function updateWithStorage( uint256 _at, uint256 _val256 ) public{
    require( _at >= 0 && _at < arrData.length );

    MyData storage storageData = arrData[_at];
    storageData.userId = _val256;
    storageData.publicKey = _val256;
    storageData.hash = _val256;
    storageData.option = _val256;
  }

  //-------------------------------------------
  // メモリ変数を利用して更新した後に上書き
  //-------------------------------------------
  function updateWithMemory( uint256 _at, uint256 _val256 ) public{
    require( _at >= 0 && _at < arrData.length );

    MyData memory memoryData = arrData[_at];
    memoryData.userId = _val256;
    memoryData.publicKey = _val256;
    memoryData.hash = _val256;
    memoryData.option = _val256;

    arrData[_at] = memoryData;
  }
}

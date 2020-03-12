pragma solidity ^0.5.12;

//----------------------
// ストレージ確認：Ｃ
//----------------------
contract StorageCheckC{

  //------------------------------------------
  // テストデータ：１ワードに色々と詰め込んだ構成
  //------------------------------------------
  struct  MyData{
    uint32    rscId;
    uint16    hp;
    uint16    mp;
    uint16    attack;
    uint16    guard;
    uint16    speed;
    uint16    luck;
    uint8[16] arrDNA;
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
      rscId:uint32(_val256),
      hp:uint16(_val256),
      mp:uint16(_val256),
      attack:uint16(_val256),
      guard:uint16(_val256),
      speed:uint16(_val256),
      luck:uint16(_val256),
      arrDNA:[
        uint8(_val256), uint8(_val256), uint8(_val256), uint8(_val256),
        uint8(_val256), uint8(_val256), uint8(_val256), uint8(_val256),
        uint8(_val256), uint8(_val256), uint8(_val256), uint8(_val256),
        uint8(_val256), uint8(_val256), uint8(_val256), uint8(_val256)
      ]
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
    lastData.rscId = uint32(_val256);
    lastData.hp = uint16(_val256);
    lastData.mp = uint16(_val256);
    lastData.attack = uint16(_val256);
    lastData.guard = uint16(_val256);
    lastData.speed = uint16(_val256);
    lastData.luck = uint16(_val256);
    for( uint i=0; i<16; i++ ){
      lastData.arrDNA[i] = uint8( _val256 );
    }
  }

  //-------------------------------------------
  // データを直接更新
  //-------------------------------------------
  function updateDirect( uint256 _at, uint256 _val256 ) public{
    require( _at >= 0 && _at < arrData.length );

    arrData[_at].rscId = uint32(_val256);
    arrData[_at].hp = uint16(_val256);
    arrData[_at].mp = uint16(_val256);
    arrData[_at].attack = uint16(_val256);
    arrData[_at].guard = uint16(_val256);
    arrData[_at].speed = uint16(_val256);
    arrData[_at].luck = uint16(_val256);
    for( uint i=0; i<16; i++ ){
      arrData[_at].arrDNA[i] = uint8(_val256);
    }
  }

  //-------------------------------------------
  // ストレージ変数を利用して更新
  //-------------------------------------------
  function updateWithStorage( uint256 _at, uint256 _val256 ) public{
    require( _at >= 0 && _at < arrData.length );

    MyData storage storageData = arrData[_at];
    storageData.rscId = uint32(_val256);
    storageData.hp = uint16(_val256);
    storageData.mp = uint16(_val256);
    storageData.attack = uint16(_val256);
    storageData.guard = uint16(_val256);
    storageData.speed = uint16(_val256);
    storageData.luck = uint16(_val256);
    for( uint i=0; i<16; i++ ){
      storageData.arrDNA[i] = uint8(_val256);
    }
  }

  //-------------------------------------------
  // メモリ変数を利用して更新した後に上書き
  //-------------------------------------------
  function updateWithMemory( uint256 _at, uint256 _val256 ) public{
    require( _at >= 0 && _at < arrData.length );

    MyData memory memoryData = arrData[_at];
    memoryData.rscId = uint32(_val256);
    memoryData.hp = uint16(_val256);
    memoryData.mp = uint16(_val256);
    memoryData.attack = uint16(_val256);
    memoryData.guard = uint16(_val256);
    memoryData.speed = uint16(_val256);
    memoryData.luck = uint16(_val256);
    for( uint i=0; i<16; i++ ){
      memoryData.arrDNA[i] = uint8(_val256);
    }

    arrData[_at] = memoryData;
  }
}

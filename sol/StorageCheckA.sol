pragma solidity ^0.5.12;

//----------------------
// ストレージ確認：Ａ
//----------------------
contract StorageCheckA{
  //------------------------------------------
  // テストデータ：１ワードのシンプルな構成
  //------------------------------------------
  struct  MyData{
    uint128   serialNo;
    uint64    ownerId;
    uint32    maxPrice;
    uint32    minPrice;
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
      serialNo:uint128(_val256),
      ownerId:uint64(_val256),
      maxPrice:uint32(_val256),
      minPrice:uint32(_val256)
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
    lastData.serialNo = uint128(_val256);
    lastData.ownerId = uint64(_val256);
    lastData.maxPrice = uint32(_val256);
    lastData.minPrice = uint32(_val256);
  }

	//-------------------------------------------
 	// データを直接更新
	//-------------------------------------------
  function updateDirect( uint256 _at, uint256 _val256 ) public{
    require( _at >= 0 && _at < arrData.length );

    arrData[_at].serialNo = uint128(_val256);
    arrData[_at].ownerId = uint64(_val256);
    arrData[_at].maxPrice = uint32(_val256);
    arrData[_at].minPrice = uint32(_val256);
  }

  //-------------------------------------------
 	// ストレージ変数を利用して更新
  //-------------------------------------------
  function updateWithStorage( uint256 _at, uint256 _val256 ) public{
    require( _at >= 0 && _at < arrData.length );

    MyData storage storageData = arrData[_at];
    storageData.serialNo = uint128(_val256);
    storageData.ownerId = uint64(_val256);
    storageData.maxPrice = uint32(_val256);
    storageData.minPrice = uint32(_val256);
  }

	//-------------------------------------------
 	// メモリ変数を利用して更新した後に上書き
	//-------------------------------------------
  function updateWithMemory( uint256 _at, uint256 _val256 ) public{
    require( _at >= 0 && _at < arrData.length );

    MyData memory memoryData = arrData[_at];
    memoryData.serialNo = uint128(_val256);
    memoryData.ownerId = uint64(_val256);
    memoryData.maxPrice = uint32(_val256);
    memoryData.minPrice = uint32(_val256);

    arrData[_at] = memoryData;
  }
}

# -*- coding: utf-8 -*-
require 'test/unit'
require_relative '../lib/statement.rb'

class STMTServiceTest < Test::Unit::TestCase
  LinkID = "TESTER"
  SecretKey = "SwWxqU+0TErBXy/9TVjIPEnI0VTUMMSQZtJf3Ed8q3I="

  ServiceID = "POPBILL_TEST"
  AccessID = "1234567890"
  ITEMCODE = 121

  STInstance = StatementService.instance(STMTServiceTest::LinkID, STMTServiceTest::SecretKey)

  STInstance.setIsTest(true)

  def test_01ServiceInstance
    stInstance = StatementService.instance(
      STMTServiceTest::LinkID,
      STMTServiceTest::SecretKey,
    )
    assert_not_nil(stInstance)
  end

  def test_02getChargeInfo
    response = STInstance.getChargeInfo(
      STMTServiceTest::AccessID,
      121,
    )
    puts response
    assert_not_nil(response)
  end

  def test_03getURL
    url = STInstance.getURL(
      STMTServiceTest::AccessID,
      "TBOX",
    )
    puts url
    assert_not_nil(url)
  end

  def test_04getUnitCost
    response = STInstance.getUnitCost(
      STMTServiceTest::AccessID,
      121,
    )

    puts response
    assert_not_nil(response)
  end

  def test_05checkMgtKeyInUse
    response = STInstance.checkMgtKeyInUse(
      STMTServiceTest::AccessID,
      121,
      "20170118-01",
    )

    puts response
    assert_equal(false, response)
  end


  def test_06faxSend
    # statement = {
    #   "itemCode" => 121,
    #   "mgtKey" => "20170117-02",
    #   "writeDate" => "20170117",
    #   "taxType" => "과세",
    #   "purposeType" => "영수",
    #   "taxTotal" => "2000",
    #   "supplyCostTotal" => "20000",
    #
    #   "senderCorpNum" => "1234567890",
    #   "senderCorpName" => "발행자 상호",
    #   "senderCEOName" => "발행자 대표자명",
    #
    #   "receiverCorpNum" => "8888888888",
    #   "receiverCorpName" =>"수신자 상호",
    #   "receiverContactName" =>"수신자 성명",
    #
    #
    #   "detailList" => [
    #     {
    #       "serialNum" => 1,
    #       "itemName" => "테스트1",
    #       "purchaseDT" => "20170117",
    #       "supplyCost" => "10000",
    #       "tax" => "1000",
    #     },
    #     {
    #       "serialNum" => 2,
    #       "itemName" => "테스트1",
    #       "purchaseDT" => "20170117",
    #       "supplyCost" => "10000",
    #       "tax" => "1000",
    #     },
    #   ],
    #
    #   "propertyBag" => {
    #     "CBalance" => "12345667"
    #   }
    # }
    #
    # receiptNum = STInstance.faxSend(
    #   STMTServiceTest::AccessID,
    #   statement,
    #   "07043042991",
    #   "07043042999",
    # )
    #
    # puts receiptNum
    #
    # assert_not_nil(receiptNum)
  end

  def test_07registIssue
    statement = {
      "itemCode" => 121,
      "mgtKey" => "20170117-02",
      "writeDate" => "20170117",
      "taxType" => "과세",
      "purposeType" => "영수",
      "taxTotal" => "2000",
      "supplyCostTotal" => "20000",

      "senderCorpNum" => "1234567890",
      "senderCorpName" => "발행자 상호",
      "senderCEOName" => "발행자 대표자명",

      "receiverCorpNum" => "8888888888",
      "receiverCorpName" =>"수신자 상호",
      "receiverContactName" =>"수신자 성명",


      "detailList" => [
        {
          "serialNum" => 1,
          "itemName" => "테스트1",
          "purchaseDT" => "20170117",
          "supplyCost" => "10000",
          "tax" => "1000",
        },
        {
          "serialNum" => 2,
          "itemName" => "테스트1",
          "purchaseDT" => "20170117",
          "supplyCost" => "10000",
          "tax" => "1000",
        },
      ],

      "propertyBag" => {
        "CBalance" => "12345667"
      }
    }

    response = STInstance.registIssue(
      STMTServiceTest::AccessID,
      statement,
      "발행메9모",
    )
    puts response
    assert_not_nil(response)
  end

  def test_08register
    statement = {
      "itemCode" => 121,
      "mgtKey" => "20170118-01",
      "writeDate" => "20170118",
      "taxType" => "과세",
      "purposeType" => "영수",
      "taxTotal" => "2000",
      "supplyCostTotal" => "20000",

      "senderCorpNum" => "1234567890",
      "senderCorpName" => "발행자 상호",
      "senderCEOName" => "발행자 대표자명",

      "receiverCorpNum" => "8888888888",
      "receiverCorpName" =>"수신자 상호",
      "receiverContactName" =>"수신자 성명",


      "detailList" => [
        {
          "serialNum" => 1,
          "itemName" => "테스트1",
          "purchaseDT" => "20170117",
          "supplyCost" => "10000",
          "tax" => "1000",
        },
        {
          "serialNum" => 2,
          "itemName" => "테스트1",
          "purchaseDT" => "20170117",
          "supplyCost" => "10000",
          "tax" => "1000",
        },
      ],

      "propertyBag" => {
        "CBalance" => "12345667"
      }
    }

    response = STInstance.register(
      STMTServiceTest::AccessID,
      statement,
    )
    puts response
    assert_not_nil(response)
  end

  def test_09update
    statement = {
      "itemCode" => 121,
      "mgtKey" => "20170118-01",
      "writeDate" => "20170118",
      "taxType" => "과세",
      "purposeType" => "영수",
      "taxTotal" => "2000",
      "supplyCostTotal" => "20000",

      "senderCorpNum" => "1234567890",
      "senderCorpName" => "발행자 상호수정",
      "senderCEOName" => "발행자 대표자명수정",

      "receiverCorpNum" => "8888888888",
      "receiverCorpName" =>"수신자 상호",
      "receiverContactName" =>"수신자 성명",


      "detailList" => [
        {
          "serialNum" => 1,
          "itemName" => "테스트1",
          "purchaseDT" => "20170117",
          "supplyCost" => "10000",
          "tax" => "1000",
        },
        {
          "serialNum" => 2,
          "itemName" => "테스트1",
          "purchaseDT" => "20170117",
          "supplyCost" => "10000",
          "tax" => "1000",
        },
      ],

      "propertyBag" => {
        "CBalance" => "12345667"
      }
    }

    response = STInstance.update(
      STMTServiceTest::AccessID,
      121,
      "20170118-01",
      statement,
    )
    puts response
    assert_not_nil(response)
  end

  def test_10issue
    response = STInstance.issue(
      STMTServiceTest::AccessID,
      121,
      "20170118-01",
      "발행메모",
      "메일 제목",
    )

    puts response
    assert_not_nil(response)
  end

  def test_11cancel
    response = STInstance.cancel(
      STMTServiceTest::AccessID,
      121,
      "20170118-01",
      "취소메모",
    )

    puts response
    assert_not_nil(response)
  end


  def test_12delete
    response = STInstance.delete(
      STMTServiceTest::AccessID,
      121,
      "20170118-01",
    )

    puts response
    assert_not_nil(response)
  end

  def test_13search
    dType = "W"
    sDate = "20160601"
    eDate = "20161201"
    state = ["3**", "6**"]
    itemCode = [121, 122, 123, 124, 125, 126]
    page = 1
    perPage = 1
    order = "D"
    queryString = ""

    response = STInstance.search(
      STMTServiceTest::AccessID,
      dType, sDate, eDate, state, itemCode, page, perPage, order, queryString,
    )
    puts response
    assert_not_nil(response)
  end

  def test_14getInfo
    response = STInstance.getInfo(
      STMTServiceTest::AccessID,
      121,
      "20170117-02",
    )

    puts response
    assert_not_nil(response)
  end

  def test_15getInfos
    mgtKeyList = ["20170118-01","20161206-02"]
    response = STInstance.getInfos(
      STMTServiceTest::AccessID,
      121,
      mgtKeyList,
    )

    puts response
    assert_not_nil(response)
  end


  def test_16sendEmail
    response = STInstance.sendEmail(
      STMTServiceTest::AccessID,
      121,
      "20170117-02",
      "test@gmail.com",
    )

    puts response
    assert_not_nil(response)
  end

  def test_17sendSMS
    # response = STInstance.sendSMS(
    #   STMTServiceTest::AccessID,
    #   121,
    #   "20170117-02",
    #   "07043042991",
    #   "01043245117",
    #   "문자메시지 테스트",
    # )
    #
    # puts response
    # assert_not_nil(response)
  end

  def test_18sendSMS
    response = STInstance.sendFax(
      STMTServiceTest::AccessID,
      121,
      "20170117-02",
      "07043042991",
      "070000111",
    )

    puts response
    assert_not_nil(response)
  end


  def test_19getLogs
    response = STInstance.getLogs(
      STMTServiceTest::AccessID,
      121,
      "20170117-02",
    )
    puts response
    assert_not_nil(response)
  end


  def test_20attachFile
    response = STInstance.attachFile(
      STMTServiceTest::AccessID,
      121,
      "20170117-06",
      "/Users/John/Documents/WorkSpace/ruby project/popbill/lib/statement.rb"
    )
    puts response
    assert_not_nil(response)
  end

  def test_21getFiles
    response = STInstance.getFiles(
      STMTServiceTest::AccessID,
      121,
      "20170117-06"
    )
    puts response
    assert_not_nil(response)
  end


  def test_22deleteFile
    response = STInstance.deleteFile(
      STMTServiceTest::AccessID,
      121,
      "20170117-06",
      "8FDDEF0A-0117-4ED8-A09B-1141C2ADF562.PBF",
    )
    puts response
    assert_not_nil(response)
  end

  def test_23getPopUpURL
    response = STInstance.getPopUpURL(
      STMTServiceTest::AccessID,
      121,
      "20170117-06",
    )
    puts response
    assert_not_nil(response)
  end

  def test_24getPrintURL
    response = STInstance.getPrintURL(
      STMTServiceTest::AccessID,
      121,
      "20170117-06",
    )
    puts response
    assert_not_nil(response)
  end

  def test_25getEPrintURL
    response = STInstance.getEPrintURL(
      STMTServiceTest::AccessID,
      121,
      "20170117-06",
    )
    puts response
    assert_not_nil(response)
  end

  def test_26getMailURL
    response = STInstance.getMailURL(
      STMTServiceTest::AccessID,
      121,
      "20170117-06",
    )
    puts response
    assert_not_nil(response)
  end

  def test_27attachStatement
    response = STInstance.attachStatement(
      STMTServiceTest::AccessID,
      121,
      "20170117-06",
      121,
      "20161206-02"
    )
    puts response
    assert_not_nil(response)
  end

  def test_28detachStatement
    response = STInstance.detachStatement(
      STMTServiceTest::AccessID,
      121,
      "20170117-06",
      121,
      "20161206-02"
    )
    puts response
    assert_not_nil(response)
  end

end # end of test Class

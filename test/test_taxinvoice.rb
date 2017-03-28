# -*- coding: utf-8 -*-
require 'test/unit'
require 'date'
require_relative '../lib/popbill/taxinvoice.rb'

class TIServiceTest < Test::Unit::TestCase
  LinkID = "TESTER"
  SecretKey = "SwWxqU+0TErBXy/9TVjIPEnI0VTUMMSQZtJf3Ed8q3I="

  ServiceID = "POPBILL_TEST"
  AccessID = "1234567890"
  Scope = ["member","110"]

  TIInstance = TaxinvoiceService.instance(TIServiceTest::LinkID, TIServiceTest::SecretKey)

  TIInstance.setIsTest(true)

  def test_01ServiceInstance
    tiInstance = TaxinvoiceService.instance(
      TIServiceTest::LinkID,
      TIServiceTest::SecretKey,
    )
    assert_not_nil(tiInstance)
  end

  def test_02getChargeInfo
    response = TIServiceTest::TIInstance.getChargeInfo(TIServiceTest::AccessID)
    puts response
    assert_not_nil(response)
  end

  def test_03getURL
    url = TIServiceTest::TIInstance.getURL(
      TIServiceTest::AccessID,
      "PBOX",
      "testkorea00000"
    )
    puts url
    assert_not_nil(url)
  end

  def test_04getUnitCost
    cost = TIServiceTest::TIInstance.getUnitCost(TIServiceTest::AccessID)
    puts cost
    assert_not_nil(cost)
  end

  def test_05getCertificateExpireDate
    expiration = TIServiceTest::TIInstance.getCertificateExpireDate(TIServiceTest::AccessID)
    puts expiration
    assert_not_nil(expiration)
  end

  def test_06getEmailPublicKeys
    emailPublicKeys = TIServiceTest::TIInstance.getEmailPublicKeys(TIServiceTest::AccessID)
    puts emailPublicKeys[0]
    assert_not_nil(emailPublicKeys)
  end

  def test_07checkMgtKeyInUse
    checkMgtKeyInUse = TIServiceTest::TIInstance.checkMgtKeyInUse(
      TIServiceTest::AccessID,
      MgtKeyType::SELL,
      "20161221-0311"
    )

    puts checkMgtKeyInUse
    assert_not_nil(checkMgtKeyInUse)
  end

  def test_08register
    taxinvoice = {
     "writeDate" => "20170117",
     "issueType" => "정발행",
     "taxType" => "과세",
     "issueTiming" => "직접발행",
     "chargeDirection" => "정과금",
     "purposeType" => "영수",
     "supplyCostTotal" => "20000",
     "taxTotal" => "2000",
     "totalAmount" => "22000",

     "invoicerMgtKey" => "20170117-06",
     "invoicerCorpNum" => TIServiceTest::AccessID,
     "invoicerCorpName" => "상호명",
     "invoicerCEOName" => "대표자명",

     "invoiceeType" => "사업자",
     "invoiceeCorpNum" => "8888888888",
     "invoiceeCorpName" => "공급받는자 상호",
     "invoiceeCEOName" => "대표자 성명",

     "addContactList" => [
       {
         "serialNum" => 1,
         "contactName" => "담당자여",
         "email" => "test@test.com",
       },
       {
         "serialNum" => 2,
         "contactName" => "담당자여",
         "email" => "test@test.com",
       }
     ],

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
     ]


    }

    response = TIServiceTest::TIInstance.register(
      TIServiceTest::AccessID,
      taxinvoice,
      false,
    )

    puts response

    assert_not_nil(response)
  end

  def test_09registIssue
    taxinvoice = {
     "writeDate" => "20170117",
     "issueType" => "정발행",
     "taxType" => "과세",
     "issueTiming" => "직접발행",
     "chargeDirection" => "정과금",
     "purposeType" => "영수",
     "supplyCostTotal" => "20000",
     "taxTotal" => "2000",
     "totalAmount" => "22000",

     "invoicerMgtKey" => "20170117-09",
     "invoicerCorpNum" => TIServiceTest::AccessID,
     "invoicerCorpName" => "상호명",
     "invoicerCEOName" => "대표자명",

     "invoiceeType" => "사업자",
     "invoiceeCorpNum" => "8888888888",
     "invoiceeCorpName" => "공급받는자 상호",
     "invoiceeCEOName" => "대표자 성명",
     "invoiceeEmail1" => "frenchofkiss@gmail.com",

     "addContactList" => [
       {
         "serialNum" => 1,
         "contactName" => "담당자여",
         "email" => "test@test.com",
       },
       {
         "serialNum" => 2,
         "contactName" => "담당자여",
         "email" => "test@test.com",
       }
     ],

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
     ]


    }

    response = TIServiceTest::TIInstance.registIssue(
      TIServiceTest::AccessID,
      taxinvoice,
      false,
      false,
      '',
      "발행메모",
      "메일 제목",
      "testkorea"
    )

    puts response

    assert_not_nil(response)
  end

  def test_10updateTest
    taxinvoice = {
     "writeDate" => "20170117",
     "issueType" => "정발행",
     "taxType" => "과세",
     "issueTiming" => "직접발행",
     "chargeDirection" => "정과금",
     "purposeType" => "영수",
     "supplyCostTotal" => "20000",
     "taxTotal" => "2000",
     "totalAmount" => "22000",

     "invoicerMgtKey" => "20170117-06",
     "invoicerCorpNum" => TIServiceTest::AccessID,
     "invoicerCorpName" => "상호명1234",
     "invoicerCEOName" => "대표자명1234",

     "invoiceeType" => "사업자",
     "invoiceeCorpNum" => "8888888888",
     "invoiceeCorpName" => "공급받는자 상호1234",
     "invoiceeCEOName" => "대표자 성명1234",

     "addContactList" => [
       {
         "serialNum" => 1,
         "contactName" => "담당자여",
         "email" => "test@test.com",
       },
       {
         "serialNum" => 2,
         "contactName" => "담당자여",
         "email" => "test@test.com",
       }
     ],

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
     ]


    }

    response = TIServiceTest::TIInstance.update(
      TIServiceTest::AccessID,
      MgtKeyType::SELL,
      "20170117-06",
      taxinvoice,
    )

    puts response

    assert_equal(response["code"], 1)
  end

  def test_11getInfo
    response = TIServiceTest::TIInstance.getInfo(
      TIServiceTest::AccessID,
      MgtKeyType::SELL,
      "20170117-09"
    )
    puts response
    assert_not_nil(response)
  end

  def test_11getDetailInfo
    response = TIServiceTest::TIInstance.getDetailInfo(
      TIServiceTest::AccessID,
      MgtKeyType::SELL,
      "20170117-09"
    )
    puts response
    assert_not_nil(response)
  end


  def test_12delete
    response = TIServiceTest::TIInstance.delete(
      TIServiceTest::AccessID,
      MgtKeyType::SELL,
      "20170117-09"
    )
    puts response
    assert_not_nil(response)
  end

  def test_13send
    response = TIServiceTest::TIInstance.send(
      TIServiceTest::AccessID,
      MgtKeyType::SELL,
      "20170117-05",
      "메모",
      "발행메일",
      "testkorea",
    )
    puts response

    assert_not_nil(response)
  end

  def test_14cancelSend
    response = TIServiceTest::TIInstance.cancelSend(
      TIServiceTest::AccessID,
      MgtKeyType::SELL,
      "20170117-05",
      "취소메모",
    )
    puts response
    assert_not_nil(response)
  end

  def test_15accept
    response = TIServiceTest::TIInstance.accept(
      TIServiceTest::AccessID,
      MgtKeyType::SELL,
      "20170117-05",
      "승인메모",
    )
    puts response
    assert_not_nil(response)
  end

  def test_15deny
    response = TIServiceTest::TIInstance.deny(
      TIServiceTest::AccessID,
      MgtKeyType::SELL,
      "20170117-05",
      "거부메모",
    )
    puts response
    assert_not_nil(response)
  end

  def test_16issue
    response = TIServiceTest::TIInstance.issue(
      TIServiceTest::AccessID,
      MgtKeyType::SELL,
      "20170117-06",
      false,
      "메모",
      "메일제목",
      "testkorea"
    )

    puts response
    assert_not_nil(response)
  end


  def test_17cancelIssue
    response = TIServiceTest::TIInstance.cancelIssue(
      TIServiceTest::AccessID,
      MgtKeyType::SELL,
      "20170117-06",
      "메모",
    )

    puts response
    assert_not_nil(response)
  end

  def test_18request
    response = TIServiceTest::TIInstance.request(
      TIServiceTest::AccessID,
      MgtKeyType::SELL,
      "20170117-06",
      "메모",
    )

    puts response
    assert_not_nil(response)
  end

  def test_19refuse
    response = TIServiceTest::TIInstance.refuse(
      TIServiceTest::AccessID,
      MgtKeyType::SELL,
      "20170117-06",
      "메모",
    )

    puts response
    assert_not_nil(response)
  end


  def test_20cancelRequest
    response = TIServiceTest::TIInstance.cancelRequest(
      TIServiceTest::AccessID,
      MgtKeyType::SELL,
      "20170117-06",
      "메모",
    )

    puts response
    assert_not_nil(response)
  end

  def test_21sendToNTS
    response = TIServiceTest::TIInstance.sendToNTS(
      TIServiceTest::AccessID,
      MgtKeyType::SELL,
      "20170117-09"
    )

    puts response
    assert_not_nil(response)
  end

  def test_22sendEmail
    response = TIServiceTest::TIInstance.sendEmail(
      TIServiceTest::AccessID,
      MgtKeyType::SELL,
      "20170117-09",
      "test@test.com",
    )
    puts response
    assert_equal(1, response["code"])
  end
#  def sendSMS(corpNum, mgtKeyType, mgtKey, senderNum, receiverNum, contents, userID = '')

  def test_23sendSMS
    response = TIServiceTest::TIInstance.sendSMS(
      TIServiceTest::AccessID,
      MgtKeyType::SELL,
      "20170117-09",
      "07043042991",
      "010000111",
      "메시지 내용입니다",
    )
    puts response
    assert_equal(1, response["code"])
  end

  def test_24sendFAX
    response = TIServiceTest::TIInstance.sendFax(
      TIServiceTest::AccessID,
      MgtKeyType::SELL,
      "20170117-09",
      "07043042991",
      "010000111",
    )
    puts response
    assert_equal(1, response["code"])
  end

  def test_25getLogs
    #def getLogs(corpNum, mgtKeyType, mgtKey, userID = '')
    response = TIServiceTest::TIInstance.getLogs(
      TIServiceTest::AccessID,
      MgtKeyType::SELL,
      "20170117-09"
    )
    puts response[0]
    assert_not_nil(response[0])
  end

  def test_26attachFile
    response = TIServiceTest::TIInstance.attachFile(
      TIServiceTest::AccessID,
      MgtKeyType::SELL,
      "20170117-04",
      "/Users/John/Documents/WorkSpace/ruby project/popbill/test/test_BaseService.rb"
    )
    puts response
    assert_equal(1, response["code"])
  end


  def test_27getFiles
    response = TIServiceTest::TIInstance.getFiles(
      TIServiceTest::AccessID,
      MgtKeyType::SELL,
      "20170117-04",
    )

    puts response
    assert_not_nil(response)
  end

  def test_28deleteFile
    response = TIServiceTest::TIInstance.deleteFile(
      TIServiceTest::AccessID,
      MgtKeyType::SELL,
      "20170117-04",
      "3A7F1AA2-EAE0-4FC2-97CE-BF865482C4B8.PBF",
    )

    puts response
    assert_not_nil(response)
  end

  def test_29getPopUPURl
    url = TIServiceTest::TIInstance.getPopUpURL(
      TIServiceTest::AccessID,
      MgtKeyType::SELL,
      "20170117-04"
    )
    puts url
    assert_not_nil(url)
  end

  def test_30getPrintURL
    url = TIServiceTest::TIInstance.getPrintURL(
      TIServiceTest::AccessID,
      MgtKeyType::SELL,
      "20170117-04"
    )
    puts url
    assert_not_nil(url)
  end

  def test_31getEPrintURL
    url = TIServiceTest::TIInstance.getEPrintURL(
      TIServiceTest::AccessID,
      MgtKeyType::SELL,
      "20170117-04"
    )
    puts url
    assert_not_nil(url)
  end

  def test_32getMailURL
    url = TIServiceTest::TIInstance.getMailURL(
      TIServiceTest::AccessID,
      MgtKeyType::SELL,
      "20170117-06"
    )
    puts url
    assert_not_nil(url)
  end


  def test_33getInfos
    mgtKeyList = ["20170117-01", "20170117-02", "20170117-03", "20170117-04"]

    infos = TIServiceTest::TIInstance.getInfos(
      TIServiceTest::AccessID,
      MgtKeyType::SELL,
      mgtKeyList,
    )
    puts infos
    assert_not_nil(infos)
  end

  def test_34getMassPrintURL
    mgtKeySub = ["20170117-01", "20170117-02", "20170117-03", "20170117-04"]

    url = TIServiceTest::TIInstance.getMassPrintURL(
      TIServiceTest::AccessID,
      MgtKeyType::SELL,
      mgtKeySub,
    )
    puts url
    assert_not_nil(url)
  end

  def test_35search
    dType = "W"
    sDate = "20160601"
    eDate = "20161201"
    state = ["3**", "6**"]
    type = ["N", "M"]
    taxType = ["T", "N", "Z"]
    lateOnly = ''
    taxRegIDYN = ''
    taxRegIDType = 'S'
    taxRegID = ''
    page = 1
    perPage = 5
    order = "D"
    queryString = ""
    interOPYN = ""
    testUserID = ""

    response = TIServiceTest::TIInstance.search(
      TIServiceTest::AccessID,
      MgtKeyType::SELL,
      dType, sDate, eDate, state, type, taxType, lateOnly, taxRegIDYN,
      taxRegIDType, taxRegID, page, perPage, order, queryString, testUserID, interOPYN,
    )

    puts response
    assert_not_nil(response)
  end

  def test_36attachStatement
    response = TIServiceTest::TIInstance.attachStatement(
      TIServiceTest::AccessID,
      MgtKeyType::SELL,
      "20170117-06",
      121,
      "20161206-02",
    )
    puts response
    assert_not_nil(response)
  end

  def test_37detachStatement
    response = TIServiceTest::TIInstance.detachStatement(
      TIServiceTest::AccessID,
      MgtKeyType::SELL,
      "20170117-06",
      121,
      "20161206-02",
    )
    puts response
    assert_not_nil(response)
  end


end # end of test Class

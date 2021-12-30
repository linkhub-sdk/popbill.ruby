# -*- coding: utf-8 -*-
require 'test/unit'
require_relative '../lib/popbill/cashbill.rb'

class CBServiceTest < Test::Unit::TestCase
  LinkID = "TESTER"
  SecretKey = "SwWxqU+0TErBXy/9TVjIPEnI0VTUMMSQZtJf3Ed8q3I="

  ServiceID = "POPBILL_TEST"
  AccessID = "1234567890"
  Scope = ["member","110"]

  CBInstance = CashbillService.instance(CBServiceTest::LinkID, CBServiceTest::SecretKey)

  CBInstance.setIsTest(true)
  CBInstance.setIpRestrictOnOff(true)

  # def test_01ServiceInstance
  #   cbInstance = CashbillService.instance(
  #     CBServiceTest::LinkID,
  #     CBServiceTest::SecretKey,
  #   )
  #   puts cbInstance
  #   assert_not_nil(cbInstance)
  # end
  #
  # def test_02getChargeInfo
  #   response = CBInstance.getChargeInfo(
  #     CBServiceTest::AccessID,
  #     "testkorea",
  #   )
  #   puts response
  #   assert_not_nil(response)
  # end
  #
  # def test_03getURL
  #   url = CBInstance.getURL(
  #     CBServiceTest::AccessID,
  #     "WRITE",
  #   )
  #
  #   puts url
  #   assert_not_nil(url)
  # end
  #
  # def test_04getUnitCost
  #   unitCost = CBInstance.getUnitCost (
  #     CBServiceTest::AccessID
  #   )
  #
  #   puts unitCost
  #   assert_equal("10", unitCost)
  # end
  #
  # def test_05checkMgtKeyInUse
  #   inUsed = CBInstance.checkMgtKeyInUse(
  #     CBServiceTest::AccessID,
  #     "20170117-01",
  #   )
  #   puts inUsed
  #   assert_equal(true, inUsed)
  #
  # end
  #
  # def test_06registIssue
  #   cashbill = {
  #     "mgtKey" => "20211230-Ruby005",
  #     "tradeUsage" => "소득공제용",
  #     "tradeType" => "승인거래",
  #     "taxationType" => "과세",
  #     "supplyCost" => "20000",
  #     "tax" => "2000",
  #     "serviceFee" => "0",
  #     "totalAmount" => "22000",
  #
  #     "franchiseCorpNum" => "1234567890",
  #     "franchiseTaxRegID" => "",
  #     "franchiseCorpName" => "가맹점 상호",
  #     "franchiseCEOName" => "가맹점 대표자 성명",
  #     "identityNum" => "01043042991",
  #     "email" => "code@test.com",
  #   }
  #
  #   response = CBInstance.registIssue(
  #     CBServiceTest::AccessID,
  #     cashbill,
  #     "memo",
  #     "",
  #     ""
  #   )
  #
  #   puts response
  #   assert_equal(1, response["code"])
  # end

  # def test_07register
  #   cashbill = {
  #     "mgtKey" => "20170117-02",
  #     "tradeUsage" => "소득공제용",
  #     "tradeType" => "승인거래",
  #     "taxationType" => "과세",
  #     "supplyCost" => "20000",
  #     "tax" => "2000",
  #     "serviceFee" => "0",
  #     "totalAmount" => "22000",
  #
  #     "franchiseCorpNum" => "1234567890",
  #     "franchiseCorpName" => "가맹점 상호",
  #     "franchiseCEOName" => "가맹점 대표자 성명",
  #     "identityNum" => "01043042991",
  #   }
  #
  #   response = CBInstance.register(
  #     CBServiceTest::AccessID,
  #     cashbill,
  #   )
  #
  #   puts response
  #   assert_equal(1, response["code"])
  #
  # end
  #
  # def test_08update
  #   cashbill = {
  #     "mgtKey" => "20170117-02",
  #     "tradeUsage" => "소득공제용",
  #     "tradeType" => "승인거래",
  #     "taxationType" => "과세",
  #     "supplyCost" => "20000",
  #     "tax" => "2000",
  #     "serviceFee" => "0",
  #     "totalAmount" => "22000",
  #
  #     "franchiseCorpNum" => "1234567890",
  #     "franchiseCorpName" => "가맹점 상호",
  #     "franchiseCEOName" => "가맹점 대표자 성명",
  #     "identityNum" => "01043042991",
  #   }
  #
  #   response = CBInstance.update(
  #     CBServiceTest::AccessID,
  #     "20170117-02",
  #     cashbill,
  #   )
  #   puts response
  #   assert_equal(1, response["code"])
  # end
  #
  # def test_09issue
  #   response = CBInstance.issue(
  #     CBServiceTest::AccessID,
  #     "20170117-02",
  #   )
  #
  #   puts response
  #   assert_not_nil(response)
  # end
  #
  # def test_10cancelIssue
  #   response = CBInstance.cancelIssue(
  #     CBServiceTest::AccessID,
  #     "20170117-02",
  #   )
  #   puts response
  #   assert_equal(1, response["code"])
  #
  # end
  #
  # def test_11delete
  #   response = CBInstance.delete(
  #     CBServiceTest::AccessID,
  #     "20170117-02",
  #   )
  #
  #   puts response
  #   assert_equal(1, response["code"])
  # end
  #
  def test_12search
    dType = "T"
    sDate = "20211201"
    eDate = "20211230"
    state = ["2**", "3**"]
    tradeType = ["N", "C"]
    tradeUsage = ["P", "C"]
    taxationType = ["T", "N"]
    page = 1
    perPage = 15
    order = "D"
    queryString = ""
    userID = "testkorea"
    tradeOpt = ["N", "B", "T"]
    franchiseTaxRegID = ""


    response = CBInstance.search(
      CBServiceTest::AccessID,
      dType, sDate, eDate, state, tradeType, tradeUsage, taxationType, page,
      perPage, order, queryString, userID, tradeOpt, franchiseTaxRegID
    )

    puts response["code"]
    puts response["total"]

  end
  #
  # def test_13getInfo
  #   response = CBInstance.getInfo(
  #     CBServiceTest::AccessID,
  #     "20161220-01"
  #   )
  #   puts response
  #   assert_not_nil(response["itemKey"])
  # end
  #
  #
  # def test_14getInfos
  #   mgtKeyList = ["20161220-01", "20161206-01", "20170117-01"]
  #   response = CBInstance.getInfos(
  #     CBServiceTest::AccessID,
  #     mgtKeyList
  #   )
  #
  #   puts response
  #   assert_not_nil(response)
  # end
  #
  # def test_15getDetailInfo
  #   response = CBInstance.getInfo(
  #     CBServiceTest::AccessID,
  #     "20161220-01"
  #   )
  #   puts response
  #   assert_not_nil(response)
  # end
  #
  #
  # def test_16sendEmail
  #   response = CBInstance.sendEmail(
  #     CBServiceTest::AccessID,
  #     "20161220-01",
  #     "test@test.com"
  #   )
  #   puts response
  #   assert_not_nil(response)
  # end
  #
  # def test_17sendSMS
  #   response = CBInstance.sendSMS(
  #     CBServiceTest::AccessID,
  #     "20161220-01",
  #     "070-4304-2991",
  #     "010-000-111",
  #     "메시지 내용",
  #   )
  #   puts response
  #   assert_not_nil(response)
  # end
  #
  # def test_18sendFAX
  #   response = CBInstance.sendFax(
  #     CBServiceTest::AccessID,
  #     "20161220-01",
  #     "070-4304-2991",
  #     "070-111-222",
  #   )
  #   puts response
  #   assert_not_nil(response)
  # end
  #
  #
  # def test_19getLogs
  #   response = CBInstance.getLogs(
  #     CBServiceTest::AccessID,
  #     "20161220-01"
  #   )
  #   puts response[0]
  #   assert_not_nil(response)
  # end
  #
  # def test_20getPopUpURL
  #   response = CBInstance.getPopUpURL(
  #     CBServiceTest::AccessID,
  #     "20161220-01"
  #   )
  #   puts response
  #   assert_not_nil(response)
  # end
  #
  # def test_21getPrintURL
  #   response = CBInstance.getPrintURL(
  #     CBServiceTest::AccessID,
  #     "20161220-01"
  #   )
  #   puts response
  #   assert_not_nil(response)
  # end
  #
  # def test_22getEPrintURL
  #   response = CBInstance.getEPrintURL(
  #     CBServiceTest::AccessID,
  #     "20161220-01"
  #   )
  #   puts response
  #   assert_not_nil(response)
  # end
  #
  #
  # def test_23getMassPrintURL
  #   mgtKeyList = ["20161220-01", "20161206-01", "20170117-01"]
  #   response = CBInstance.getMassPrintURL(
  #     CBServiceTest::AccessID,
  #     mgtKeyList
  #   )
  #
  #   puts response
  #   assert_not_nil(response)
  # end
  #
  # def test_24revokeRegistIssue
  #   mgtKey = "20171114-10"
  #   orgConfirmNum = "125186756"
  #   orgTradeDate = "20170623"
  #   smssendYN = false
  #   memo = ""
  #   userID = ""
  #   isPartCancel = true
  #   cancelType = 1
  #   supplyCost = "5000"
  #   tax = "0"
  #   serviceFee = "5000"
  #   totalAmount = "10000"
  #
  #   response = CBInstance.revokeRegistIssue(
  #     CBServiceTest::AccessID,
  #     mgtKey,
  #     orgConfirmNum,
  #     orgTradeDate,
  #     smssendYN,
  #     memo,
  #     "testkorea",
  #     isPartCancel,
  #     cancelType,
  #     supplyCost,
  #     tax,
  #     serviceFee,
  #     totalAmount
  #   )
  #
  #   puts response
  #   assert_equal(1, response["code"])
  # end
  #
  #
  # def test_25revokeRegister
  #   mgtKey = "20171114-11"
  #   orgConfirmNum = "820116333"
  #   orgTradeDate = "20170711"
  #   smssendYN = false
  #   userID = "testkorea"
  #   isPartCancel = true
  #   cancelType = 1
  #   supplyCost = "5000"
  #   tax = "0"
  #   serviceFee = "0"
  #   totalAmount = "5000"
  #
  #   response = CBInstance.revokeRegister(
  #     CBServiceTest::AccessID,
  #     mgtKey,
  #     orgConfirmNum,
  #     orgTradeDate,
  #     smssendYN,
  #     userID,
  #     isPartCancel,
  #     cancelType,
  #     supplyCost,
  #     tax,
  #     serviceFee,
  #     totalAmount,
  #   )
  #
  #   puts response
  #   assert_equal(1, response["code"])
  # end
  #
  # def test_listEmailConfig
  #   response = CBInstance.listEmailConfig(CBServiceTest::AccessID)
  #   puts response
  # end
  #
  # def test_updateEmailConfig
  #   response = CBInstance.updateEmailConfig(
  #       CBServiceTest::AccessID,
  #       "CSH_ISSUE",
  #       false,
  #       "testkorea"
  #   )
  #   assert_not_nil(response)
  # end

end # end of test Class

# -*- coding: utf-8 -*-
require 'test/unit'
require_relative '../lib/popbill/htCashbill.rb'

class HTCashbillTest < Test::Unit::TestCase
  LinkID = "TESTER"
  SecretKey = "SwWxqU+0TErBXy/9TVjIPEnI0VTUMMSQZtJf3Ed8q3I="

  ServiceID = "POPBILL_TEST"
  AccessID = "6798700433"
  Scope = ["member","110"]

  HTCBInstance = HTCashbillService.instance(HTCashbillTest::LinkID, HTCashbillTest::SecretKey)
  HTCBInstance.setIsTest(true)

  def test_01ServiceInstance
    msgInstance = HTCashbillService.instance(
      HTCashbillTest::LinkID,
      HTCashbillTest::SecretKey,
    )
    puts msgInstance
    assert_not_nil(msgInstance)
  end

  def test_02getChargeInfo
    response = HTCBInstance.getChargeInfo(
      HTCashbillTest::AccessID,
    )
    puts response
    assert_not_nil(response)
  end

  def test_03requestJob
    # type = "BUY"
    # sDate = "20160101"
    # eDate = "20170301"
    #
    # jobID = HTCBInstance.requestJob(
    #   HTCashbillTest::AccessID,
    #   type, sDate, eDate
    # )
    # puts jobID
    # assert_not_nil(jobID)
  end

  def test_04getJobState
    jobID = "017012517000000003"

    jobState = HTCBInstance.getJobState(
      HTCashbillTest::AccessID,
      jobID,
    )
    puts jobState
    assert_not_nil(jobState)
  end

  def test_05listActiveJob
    response = HTCBInstance.listActiveJob(
      HTCashbillTest::AccessID,
    )
    puts response
    assert_not_nil(response)
  end

  def test_06search
    jobID = "017012517000000003"
    tradeType = ["N", "M"]
    tradeUsage = ["P", "C"]
    page = 1
    perPage = 10
    order = "D"

    response = HTCBInstance.search(
      HTCashbillTest::AccessID,
      jobID,
      tradeType,
      tradeUsage,
      page,
      perPage,
      order
    )

    puts response
    assert_not_nil(response)
  end


  def test_07summary
    jobID = "017012517000000003"
    tradeType = ["N", "M"]
    tradeUsage = ["P", "C"]

    response = HTCBInstance.summary(
      HTCashbillTest::AccessID,
      jobID,
      tradeType,
      tradeUsage,
    )

    puts response
    assert_not_nil(response)
  end

  def test_08flatRatePopUpURL
    url = HTCBInstance.getFlatRatePopUpURL(
      HTCashbillTest::AccessID,
    )

    puts url
    assert_not_nil(url)
  end

  def test_09getCertificatePopUpURL
    url = HTCBInstance.getCertificatePopUpURL(
      HTCashbillTest::AccessID,
    )
    puts url
    assert_not_nil(url)
  end

  def test_10getFlatRateState
    response = HTCBInstance.getFlatRateState(
      HTCashbillTest::AccessID,
    )
    puts response
    assert_not_nil(response)
  end

  def test_11getCertificateExpireDate
    response = HTCBInstance.getCertificateExpireDate(
      HTCashbillTest::AccessID,
    )
    puts response
    assert_not_nil(response)
  end

  def test_12checkCertValidation
    response = HTCBInstance.checkCertValidation(
        HTCashbillTest::AccessID,
        )
    puts response
  end

  def test_13registDeptUser
    response = HTCBInstance.registDeptUser(
        HTCashbillTest::AccessID,
        "ruby_deptid_cash",
        "ruby_deptpwd_cash",
        )
    puts response
  end

  def test_14checkDeptUser
    response = HTCBInstance.checkDeptUser(
        HTCashbillTest::AccessID,
        )
    puts response
  end

  def test_15checkLoginDeptUser
    response = HTCBInstance.checkLoginDeptUser(
        HTCashbillTest::AccessID,
        )
    puts response
  end

  def test_16deleteDeptUser
    response = HTCBInstance.deleteDeptUser(
        HTCashbillTest::AccessID,
        )
    puts response
  end
end # end of test Class

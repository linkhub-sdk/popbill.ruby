# -*- coding: utf-8 -*-
require 'test/unit'
require_relative '../lib/popbill/bizinfocheck.rb'

class BizInfoCheckServiceTest < Test::Unit::TestCase
  LinkID = "TESTER"
  SecretKey = "SwWxqU+0TErBXy/9TVjIPEnI0VTUMMSQZtJf3Ed8q3I="

  ServiceID = "POPBILL_TEST"
  AccessID = "1234567890"
  Scope = ["member","171"]

  CDInstance = BizInfoCheckService.instance(BizInfoCheckServiceTest::LinkID, BizInfoCheckServiceTest::SecretKey)
  CDInstance.setIsTest(true)

  def test_01ServiceInstance
    msgInstance = BizInfoCheckService.instance(
      BizInfoCheckServiceTest::LinkID,
      BizInfoCheckServiceTest::SecretKey,
    )
    puts msgInstance
    assert_not_nil(msgInstance)
  end

  def test_02getChargeInfo
    response = CDInstance.getChargeInfo(
      BizInfoCheckServiceTest::AccessID,
    )
    puts response
    assert_not_nil(response)
  end

  def test_03getUnitCost
    response = CDInstance.getUnitCost(
      BizInfoCheckServiceTest::AccessID,
    )
    puts response
    assert_not_nil(response)
  end

  def test_04CheckBizInfo
    response = CDInstance.checkBizInfo(
      BizInfoCheckServiceTest::AccessID,
      "401-03-94930"
    )
    puts response
    assert_not_nil(response)
  end

  def test_05getBalance
    response = CDInstance.getBalance(
      BizInfoCheckServiceTest::AccessID,
    )
    puts response
    assert_not_nil(response)
  end

end # end of test Class

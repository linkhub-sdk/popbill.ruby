# -*- coding: utf-8 -*-
require 'test/unit'
require_relative '../lib/popbill/accountCheck.rb'

class AccountCheckServiceTest < Test::Unit::TestCase
  LinkID = "TESTER"
  SecretKey = "SwWxqU+0TErBXy/9TVjIPEnI0VTUMMSQZtJf3Ed8q3I="

  ServiceID = "POPBILL_TEST"
  AccessID = "1234567890"
  Scope = ["member","110"]

  ACInstance = AccountCheckService.instance(AccountCheckServiceTest::LinkID, AccountCheckServiceTest::SecretKey)
  ACInstance.setIsTest(true)
  ACInstance.setUseStaticIP(true)

  def test_01ServiceInstance
    msgInstance = AccountCheckService.instance(
      AccountCheckServiceTest::LinkID,
      AccountCheckServiceTest::SecretKey,
    )
    puts msgInstance
    assert_not_nil(msgInstance)
  end

  def test_02getChargeInfo
    response = ACInstance.getChargeInfo(
      AccountCheckServiceTest::AccessID,
    )
    puts response
    assert_not_nil(response)
  end

  def test_03getUnitCost
    response = ACInstance.getUnitCost(
      AccountCheckServiceTest::AccessID,
    )
    puts response
    assert_not_nil(response)
  end

  def test_04checkAccountInfo
    response = ACInstance.checkAccountInfo(
      AccountCheckServiceTest::AccessID,
      "0004",
      "94324511758",
    )
    puts response
    assert_not_nil(response)
  end

end # end of test Class

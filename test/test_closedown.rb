# -*- coding: utf-8 -*-
require 'test/unit'
require_relative '../lib/popbill/closedown.rb'

class ClosedownServiceTest < Test::Unit::TestCase
  LinkID = "TESTER"
  SecretKey = "SwWxqU+0TErBXy/9TVjIPEnI0VTUMMSQZtJf3Ed8q3I="

  ServiceID = "POPBILL_TEST"
  AccessID = "1234567890"
  Scope = ["member","110"]

  CDInstance = ClosedownService.instance(ClosedownServiceTest::LinkID, ClosedownServiceTest::SecretKey)
  CDInstance.setIsTest(true)

  def test_01ServiceInstance
    msgInstance = ClosedownService.instance(
      ClosedownServiceTest::LinkID,
      ClosedownServiceTest::SecretKey,
    )
    puts msgInstance
    assert_not_nil(msgInstance)
  end

  def test_02getChargeInfo
    response = CDInstance.getChargeInfo(
      ClosedownServiceTest::AccessID,
    )
    puts response
    assert_not_nil(response)
  end

  def test_03getUnitCost
    response = CDInstance.getUnitCost(
      ClosedownServiceTest::AccessID,
    )
    puts response
    assert_not_nil(response)
  end

  def test_04checkCorpNum
    response = CDInstance.checkCorpNum(
      ClosedownServiceTest::AccessID,
      "401-03-94930"
    )
    puts response
    assert_not_nil(response)
  end

  def test_05checkCorpNums
    corpNumList = ["4108600477", "401-03-94930"]

    response = CDInstance.checkCorpNums(
      ClosedownServiceTest::AccessID,
      corpNumList,
    )
    puts response
    assert_not_nil(response)
  end

  def test_06getBalance
    response = CDInstance.getBalance(
      ClosedownServiceTest::AccessID,
    )
    puts response
    assert_not_nil(response)
  end

end # end of test Class

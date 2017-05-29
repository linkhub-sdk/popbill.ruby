# -*- coding: utf-8 -*-
require 'test/unit'
require_relative '../lib/popbill/fax.rb'

class FaxServiceTest < Test::Unit::TestCase
  LinkID = "TESTER"
  SecretKey = "SwWxqU+0TErBXy/9TVjIPEnI0VTUMMSQZtJf3Ed8q3I="

  ServiceID = "POPBILL_TEST"
  AccessID = "1234567890"
  Scope = ["member","110"]

  FaxInstance = FaxService.instance(FaxServiceTest::LinkID, FaxServiceTest::SecretKey)
  FaxInstance.setIsTest(true)

  def test_01ServiceInstance
    msgInstance = FaxService.instance(
      FaxServiceTest::LinkID,
      FaxServiceTest::SecretKey,
    )
    puts msgInstance
    assert_not_nil(msgInstance)
  end

  def test_02getChargeInfo
    response = FaxInstance.getChargeInfo(
      FaxServiceTest::AccessID,
    )

    puts response
    assert_not_nil(response)
  end

  def test_03getURL
    url = FaxInstance.getURL(
      FaxServiceTest::AccessID,
      "BOX"
    )
    puts url
    assert_not_nil(url)
  end

  def test_04getUnitCost
    response = FaxInstance.getUnitCost(
      FaxServiceTest::AccessID,
    )

    puts response
    assert_not_nil(response)
  end

  def test_13search
    sDate = "20170118"
    eDate = "20170118"
    state = [1, 2, 3, 4]
    reserveYN = ''
    senderYN = ''
    page = 1
    perPage = 100
    order = "D"

    response = FaxInstance.search(
      FaxServiceTest::AccessID,
      sDate, eDate, state, reserveYN, senderYN, page, perPage, order,
    )
    puts response
    assert_not_nil(response)
  end


  def test_14sendFax
    response = FaxInstance.sendFax(
      FaxServiceTest::AccessID,
      "07043042991",
      "발신자명",
      "070111222",
      "수신자명",
      ["/Users/John/Documents/WorkSpace/ruby project/popbill/test/test.pdf"]
    )
    puts response
    assert_not_nil(response)
  end

  def test_15resendFax

    receivers =
      [
        {
          "rcv" => "01055565",
          "rcvnm" => "John",
        },
        {
          "rcv" => "010111222",
          "rcvnm" => "John2",
        },
      ]

    receivers = nil

    receiptNum = "017021011564500001"
    response = FaxInstance.resendFax_multi(
      FaxServiceTest::AccessID,
      receiptNum,
      "07043042991",
      "발신자명",
      receivers,
      "20170210200000",
    )
    begin
      puts response
      assert_not_nil(response)
    rescue PopbillException => pe

    end
  end


  def test_15sendFax_multi
    receivers =
    [
      {
        "rcv" => "010111222",
        "rcvnm" => "John",
      },
      {
        "rcv" => "010111222",
        "rcvnm" => "John2",
      },
    ]
    response = FaxInstance.sendFax_multi(
      FaxServiceTest::AccessID,
      "07043042991",
      "발신자명",
      receivers,
      ["/Users/John/Documents/WorkSpace/ruby project/popbill/test/test.pdf"]
    )
    puts response
    assert_not_nil(response)
  end

  def test_16getFaxDetail
    response = FaxInstance.getFaxDetail(
      FaxServiceTest::AccessID,
      "017011914233400001",
    )

    puts response
    assert_not_nil(response)
  end

  def test_17cancelReserve
    response = FaxInstance.cancelReserve(
      FaxServiceTest::AccessID,
      "017011914233400001",
    )

    puts response
    assert_not_nil(response)
  end

  def test_18resendFax

    receiptNum = "017021011564500001"
    response = FaxInstance.resendFax(
      FaxServiceTest::AccessID,
      receiptNum,
      "07043042991",
      "발신자명",
      "",
      "",
      "",
    )

    puts response
    assert_not_nil(response)

  end

  def test_19getSenderNumberList
    response = FaxInstance.getSenderNumberList(
      FaxServiceTest::AccessID,
    )
    puts response
    assert_not_nil(response)
  end



end # end of test Class

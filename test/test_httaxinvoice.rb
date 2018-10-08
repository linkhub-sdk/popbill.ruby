# -*- coding: utf-8 -*-
require 'test/unit'
require_relative '../lib/popbill/htTaxinvoice.rb'

class HTTaxinvoiceTest < Test::Unit::TestCase
  LinkID = "TESTER"
  SecretKey = "SwWxqU+0TErBXy/9TVjIPEnI0VTUMMSQZtJf3Ed8q3I="

  ServiceID = "POPBILL_TEST"
  AccessID = "6798700433"
  Scope = ["member","110"]

  HTTIInstance = HTTaxinvoiceService.instance(HTTaxinvoiceTest::LinkID, HTTaxinvoiceTest::SecretKey)
  HTTIInstance.setIsTest(true)

  def test_01ServiceInstance
    msgInstance = HTTaxinvoiceService.instance(
      HTTaxinvoiceTest::LinkID,
      HTTaxinvoiceTest::SecretKey,
    )
    puts msgInstance
    assert_not_nil(msgInstance)
  end

  def test_02getChargeInfo
    response = HTTIInstance.getChargeInfo(
      HTTaxinvoiceTest::AccessID,
    )
    puts response
    assert_not_nil(response)
  end

  def test_03requestJob
    dType = "W"
    sDate = "20160101"
    eDate = "20170120"

    jobID = HTTIInstance.requestJob(
      HTTaxinvoiceTest::AccessID,
      KeyType::SELL,
      dType,
      sDate,
      eDate,
    )

    puts jobID
    assert_not_nil(jobID)
  end

  def test_04getJobState
    jobID = "017012515000000004"

    response = HTTIInstance.getJobState(
      HTTaxinvoiceTest::AccessID,
      jobID,
    )

    puts response
    assert_not_nil(response)
  end


  def test_05listActiveJob
    response = HTTIInstance.listActiveJob(
      HTTaxinvoiceTest::AccessID,
    )

    puts response
    assert_not_nil(response)
  end

  def test_06search
    jobID = "017012515000000004"
    type = ["N", "M"]
    taxType = ["T", "N", "Z"]
    purposeType = ["R", "C", "N"]
    taxRegIDType = 'S'
    taxRegIDYN = ''
    taxRegID = ''
    page = 1
    perPage = 1
    order = "D"

    response = HTTIInstance.search(
      HTTaxinvoiceTest::AccessID,
      jobID, type, taxType, purposeType, taxRegIDType, taxRegIDYN, taxRegID,
      page, perPage, order
    )

    puts response
    assert_not_nil(response)
  end


  def test_07sumary
    jobID = "017012515000000004"
    type = ["N", "M"]
    taxType = ["T", "N", "Z"]
    purposeType = ["R", "C", "N"]
    taxRegIDType = 'S'
    taxRegIDYN = ''
    taxRegID = ''

    response = HTTIInstance.summary(
      HTTaxinvoiceTest::AccessID,
      jobID, type, taxType, purposeType, taxRegIDType, taxRegIDYN, taxRegID,
    )

    puts response
    assert_not_nil(response)
  end

  def test_08getTaxinvoice
    ntsConfirmNum = "2016123141000203000101bb"
    response = HTTIInstance.getTaxinvoice(
      HTTaxinvoiceTest::AccessID,
      ntsConfirmNum,
    )
    puts response
    assert_not_nil(response)
  end

  def test_09getXML
    ntsConfirmNum = "2016123141000203000101bb"
    response = HTTIInstance.getXML(
      HTTaxinvoiceTest::AccessID,
      ntsConfirmNum,
    )
    puts response
    assert_not_nil(response)
  end

  def test_10getFlatRatePopUpURL
    url = HTTIInstance.getFlatRatePopUpURL(
      HTTaxinvoiceTest::AccessID,
    )
    puts url
    assert_not_nil(url)
  end

  def test_11getCertificatePopUpURL
    url = HTTIInstance.getCertificatePopUpURL(
      HTTaxinvoiceTest::AccessID,
    )
    puts url
    assert_not_nil(url)
  end

  def test_12getFlatRateState
    response = HTTIInstance.getFlatRateState(
      HTTaxinvoiceTest::AccessID,
    )
    puts response
    assert_not_nil(response)
  end

  def test_13getCertificateExpireDate
    response = HTTIInstance.getCertificateExpireDate(
      HTTaxinvoiceTest::AccessID,
    )
    puts response
    assert_not_nil(response)
  end

  def test_14getPopUpURL
    url = HTTIInstance.getPopUpURL(
        HTTaxinvoiceTest::AccessID,
        "201809194100020300000cd5"
        )
    puts url
  end

end # end of test Class

# -*- coding: utf-8 -*-
require 'test/unit'
require_relative '../lib/popbill/easyFinBank.rb'

class EasyFinBankTest < Test::Unit::TestCase
  LinkID = "TESTER"
  SecretKey = "SwWxqU+0TErBXy/9TVjIPEnI0VTUMMSQZtJf3Ed8q3I="

  ServiceID = "POPBILL_TEST"
  AccessID = "1234567890"
  Scope = ["member","180"]

  EasyFinBank = EasyFinBankService.instance(EasyFinBankTest::LinkID, EasyFinBankTest::SecretKey)
  EasyFinBank.setIsTest(true)

  # def test_01ServiceInstance
  #   msgInstance = EasyFinBankService.instance(
  #     EasyFinBankTest::LinkID,
  #     EasyFinBankTest::SecretKey,
  #   )
  #   puts msgInstance
  #   assert_not_nil(msgInstance)
  # end
  #
  # def test_12registBankAccount
  #   accountInfo = {
  #     "BankCode" => "",
  #     "AccountNumber" => "",
  #     "AccountPWD" => "",
  #     "AccountType" => "",
  #     "IdentityNumber" => "",
  #     "AccountName" => "",
  #     "BankID" => "",
  #     "FastID" => "",
  #     "FastPWD" => "",
  #     "UsePeriod" => "1",
  #     "Memo" => "",
  #   }
  #
  #
  #   response = EasyFinBank.registBankAccount(
  #     EasyFinBankTest::AccessID,
  #     accountInfo
  #   )
  #   assert_not_nil(response)
  #
  # end
  #
  # def test_updateBankAccount
  #   accountInfo = {
  #     "BankCode" => "0039",
  #     "AccountNumber" => "2070064402404",
  #     "AccountPWD" => "2018",
  #     "AccountName" => "별칭_02",
  #     "BankID" => "",
  #     "FastID" => "",
  #     "FastPWD" => "",
  #     "Memo" => "메모_02",
  #   }
  #
  #
  #   response = EasyFinBank.updateBankAccount(
  #     EasyFinBankTest::AccessID,
  #     accountInfo
  #   )
  #   assert_not_nil(response)
  # end
  #
  #
  # def test_getBankAccountInfo
  #   bankCode = "0039"
  #   accountNumber = "2070064402404"
  #
  #   response = EasyFinBank.getBankAccountInfo(
  #     EasyFinBankTest::AccessID,
  #     bankCode, accountNumber, "",
  #   )
  #
  #   puts response
  #   assert_not_nil(response)
  # end
  #
  # def test_closeBankAccount
  #   bankCode = "0039"
  #   accountNumber = "2070064402404"
  #   closeType = "중도"
  #
  #   response = EasyFinBank.closeBankAccount(
  #     EasyFinBankTest::AccessID,
  #     bankCode, accountNumber, closeType,
  #   )
  #
  #   puts response
  #   assert_not_nil(response)
  # end
  #
  # def test_revokeCloseBankAccount
  #   bankCode = "0039"
  #   accountNumber = "2070064402404"
  #
  #   response = EasyFinBank.revokeCloseBankAccount(
  #     EasyFinBankTest::AccessID,
  #     bankCode, accountNumber,
  #   )
  #
  #   puts response
  #   assert_not_nil(response)
  # end
  #
  # def test_02getChargeInfo
  #   response = EasyFinBank.getChargeInfo(
  #     EasyFinBankTest::AccessID,
  #   )
  #   puts response
  #   assert_not_nil(response)
  # end
  #
  # def test_03getBankAccountMgtURL
  #   url = EasyFinBank.getBankAccountMgtURL(
  #     EasyFinBankTest::AccessID,
  #   )
  #
  #   puts url
  #   assert_not_nil(url)
  # end
  #
  # def test_04listBankAccount
  #   response = EasyFinBank.listBankAccount(
  #     EasyFinBankTest::AccessID,
  #   )
  #
  #   puts response
  #   assert_not_nil(response)
  # end
  #
  # def test_05requestJob
  #   bankCode = "0048"
  #   accountNumber = "131020538645"
  #   sDate = "20191101"
  #   eDate = "20200107"
  #
  #   jobID = EasyFinBank.requestJob(
  #     EasyFinBankTest::AccessID,
  #     bankCode,
  #     accountNumber,
  #     sDate,
  #     eDate,
  #   )
  #
  #   puts jobID
  #   assert_not_nil(jobID)
  # end
  #
  # def test_06getJobState
  #   jobID = "020010711000000006"
  #
  #   response = EasyFinBank.getJobState(
  #     EasyFinBankTest::AccessID,
  #     jobID,
  #   )
  #
  #   puts response
  #   assert_not_nil(response)
  # end
  #
  # def test_07listActiveJob
  #   response = EasyFinBank.listActiveJob(
  #     EasyFinBankTest::AccessID,
  #   )
  #
  #   puts response
  #   assert_not_nil(response)
  # end
  #
  # def test_08search
  #   jobID = "020010711000000007"
  #   tradeType = ["I", "O"]
  #   searchString = ""
  #   page = 1
  #   perPage = 10
  #   order = "D"
  #
  #   response = EasyFinBank.search(
  #     EasyFinBankTest::AccessID,
  #     jobID, tradeType, searchString, page, perPage, order, "",
  #   )
  #
  #
  #   puts response
  #   assert_not_nil(response)
  # end
  #
  # def test_09summary
  #   jobID = "020010711000000007"
  #   tradeType = ["I", "O"]
  #   searchString = ""
  #
  #   response = EasyFinBank.summary(
  #     EasyFinBankTest::AccessID,
  #     jobID, tradeType, searchString, "",
  #   )
  #
  #   puts response
  #   assert_not_nil(response)
  # end
  #
  # def test_10saveMemo
  #   tid = "01912181100000000120191231000001"
  #   memo = "ruby-test"
  #
  #   response = EasyFinBank.saveMemo(
  #     EasyFinBankTest::AccessID,
  #     tid, memo, "",
  #   )
  #
  #   puts response
  #   assert_not_nil(response)
  # end
  #
  # def test_11getFlatRatePopUpURL
  #   url = EasyFinBank.getFlatRatePopUpURL(
  #     EasyFinBankTest::AccessID,
  #   )
  #
  #   puts url
  #   assert_not_nil(url)
  # end
  #
  # def test_12getFlatRateState
  #   bankCode = "0048"
  #   accountNumber = "131020538645"
  #
  #   response = EasyFinBank.getFlatRateState(
  #     EasyFinBankTest::AccessID,
  #     bankCode, accountNumber, "",
  #   )
  #
  #   puts response
  #   assert_not_nil(response)
  # end

  def test_deleteBankAccount
    bankCode = ""
    accountNumber = ""

    response = EasyFinBank.deleteBankAccount(
      EasyFinBankTest::AccessID,
      bankCode, accountNumber, ""
    )

    puts response
  end


end

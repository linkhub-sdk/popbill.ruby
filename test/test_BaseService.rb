# -*- coding: utf-8 -*-
require 'test/unit'
require 'date'
require 'linkhub'
require_relative '../lib/popbill.rb'

class BaseServiceTest < Test::Unit::TestCase
  LinkID = "TESTER"
  SecretKey = "SwWxqU+0TErBXy/9TVjIPEnI0VTUMMSQZtJf3Ed8q3I="

  ServiceID = "POPBILL_TEST"
  AccessID = "1234567890"
  Scope = ["member","110"]

  LinkhubInstance = BaseService.instance(BaseServiceTest::LinkID, BaseServiceTest::SecretKey)
  LinkhubInstance.addScope("110")
  LinkhubInstance.isTest = true
  LinkhubInstance.setUseLocalTimeYN(false)

  # def test_01getTimeCompare
  #   auth = Linkhub.instance(BaseServiceTest::LinkID, BaseServiceTest::SecretKey)
  #   expiration = auth.getSessionToken(BaseServiceTest::ServiceID,
  #     BaseServiceTest::AccessID, BaseServiceTest::Scope)['expiration']
  #   sessionExpireTime = DateTime.parse(expiration)
  #
  #   serverTime = auth.getTime
  #   apiServerTime = DateTime.strptime(serverTime)
  #
  #   puts sessionExpireTime.to_s + ' ' + apiServerTime.to_s
  #   puts "Session Expiration : " + (apiServerTime < sessionExpireTime).to_s
  #   assert_not_nil(expiration)
  # end
  #
  # def test_02singleton
  #   base = BaseService.instance(BaseServiceTest::LinkID, BaseServiceTest::SecretKey)
  #   base2 = BaseService.instance(BaseServiceTest::LinkID, BaseServiceTest::SecretKey)
  #   assert_equal(base, base2, "Popbill Singleton Instance Failure")
  # end
  #
  # def test_03checkTokenTable
  #   base_instance = BaseService.instance(BaseServiceTest::LinkID, BaseServiceTest::SecretKey)
  #   base_instance.addScope("110")
  #   base_instance.isTest = true
  #   token = base_instance.getSession_Token("1234567890")
  #   token2 = base_instance.getSession_Token("1234567890")
  #
  #   assert_equal(token, token2)
  # end
  #
  def test_04getBalance
    base_instance = BaseService.instance(BaseServiceTest::LinkID, BaseServiceTest::SecretKey)
    base_instance.addScope("110")
    base_instance.isTest = true
    base_instance.useGAIP = false
    base_instance.setUseLocalTimeYN = false
    # base_instance.useLocalTimeYN = false
    balance = base_instance.getBalance(BaseServiceTest::AccessID)
    assert_not_nil(balance)
  end
  #
  # def test_05getPartnerBalance
  #   base_instance = BaseService.instance(BaseServiceTest::LinkID, BaseServiceTest::SecretKey)
  #   base_instance.addScope("110")
  #   base_instance.isTest = true
  #
  #   assert_raise PopbillException do
  #     partnerBalance = base_instance.getPartnerBalance("1111")
  #     assert_not_nil(response)
  #   end
  # end
  #
  # def test_06joinMember
  #   joinInfo = {
  #    "ID" => "testkorea",
  #    "PWD" => "testkorea",
  #    "LinkID" => "TESTER",
  #    "CorpNum" => "1234567890",
  #   }
  #   begin
  #     response = BaseServiceTest::LinkhubInstance.joinMember(joinInfo)
  #     assert_not_nil(response)
  #   rescue PopbillException => pe
  #     assert_equal(-10001000, pe.code)
  #   end
  # end
  #
  # def test_07checkID
  #   response = BaseServiceTest::LinkhubInstance.checkID('testkorea')
  #   puts "[" + response['code'].to_s + "] " + response['message']
  #   assert_equal(1, response['code'])
  # end
  #
  # def test_08getPopbillURL
  #   url = BaseServiceTest::LinkhubInstance.getPopbillURL("1234567890", "CHRG")
  #   puts url
  #   assert_not_nil(url)
  # end
  #
  # def test_09checkIsMember
  #   response = BaseServiceTest::LinkhubInstance.checkIsMember("1234567890", "TESTER")
  #   puts "[" + response['code'].to_s + "] " + response['message']
  #   assert_not_nil(response)
  # end
  #
  # def test_10listContact
  #   response = BaseServiceTest::LinkhubInstance.listContact("1234567890")
  #   puts response[1]
  #   assert_not_nil(response[1])
  # end
  #
  # def test_11updateContact
  #   contactInfo = {
  #    "personName" => "담당자명170116",
  #    "tel" => "070-4324-5117",
  #    "hp" => "010-1111-2222",
  #    "fax" => "070-1111-2222",
  #    "email" => "frenchofkiss@gmail.com",
  #   }
  #
  #   response = BaseServiceTest::LinkhubInstance.updateContact(
  #     BaseServiceTest::AccessID,
  #     contactInfo,
  #     "testkorea",
  #   )
  #   puts "[" + response['code'].to_s + "] " + response['message']
  #   assert_not_nil(response)
  #
  # end
  #
  # def test_12registContact
  #   contactInfo = {
  #    "id" => "testkorea170116",
  #    "pwd" => "test05028342",
  #    "personName" => "담당자명170116",
  #    "tel" => "070-4324-5117",
  #    "hp" => "010-1111-2222",
  #    "fax" => "070-1111-2222",
  #    "email" => "frenchofkiss@gmail.com",
  #   }
  #
  #   assert_raise PopbillException do
  #     response = BaseServiceTest::LinkhubInstance.registContact(
  #       BaseServiceTest::AccessID,
  #       contactInfo,
  #     )
  #     assert_not_nil(response)
  #   end
  # end
  #
  # def test_13getCorpInfo
  #   response = BaseServiceTest::LinkhubInstance.getCorpInfo("1234567890")
  #   puts response["ceoname"]
  #   assert_not_nil(response)
  # end
  #
  # def test_14updateCorpInfo
  #   corpInfo = {
  #    "ceoname" => "대표자명170116",
  #    "corpName" => "상호170116",
  #    "addr" => "주소170116",
  #    "bizType" => "업태170116",
  #    "bizClass" => "종목170116",
  #   }
  #
  #   response = BaseServiceTest::LinkhubInstance.updateCorpInfo(
  #     BaseServiceTest::AccessID,
  #     corpInfo,
  #   )
  #   puts "[" + response['code'].to_s + "] " + response['message']
  #   assert_not_nil(response)
  # end
  #
  # def test_15getPartnerURL
  #   url = BaseServiceTest::LinkhubInstance.getPartnerURL("1234567890", "CHRG")
  #   puts url
  #   assert_not_nil(url)
  # end

  # def test_getContactInfo
  #   contactInfo = BaseServiceTest::LinkhubInstance.getContactInfo("1234567890", "testkorea", "")
  #   puts contactInfo
  #   assert_not_nil(contactInfo)
  # end

  # def test_getPaymentURL
  #   url = BaseServiceTest::LinkhubInstance.getPaymentURL("1234567890", "testkorea")
  #   puts url
  # end
  #
  # def test_getUseHistoryURL
  #   url = BaseServiceTest::LinkhubInstance.getUseHistoryURL("1234567890", "testkorea")
  #   puts url
  # end


end

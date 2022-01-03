require 'test/unit'
require_relative '../lib/popbill/kakaotalk.rb'

class KakaoServiceTest < Test::Unit::TestCase
  LinkID = "TESTER"
  SecretKey = "SwWxqU+0TErBXy/9TVjIPEnI0VTUMMSQZtJf3Ed8q3I="

  ServiceID = "POPBILL_TEST"
  AccessID = "1234567890"
  Scope = ["member", "153", "154", "155"]

  KakaoInstance = KakaoService.instance(LinkID, SecretKey)
  KakaoInstance.setIsTest(true)

  # def test_ServiceInstance
  #   kakaoInstance = KakaoService.instance(
  #       LinkID,
  #       SecretKey
  #   )
  #   puts kakaoInstance
  #   assert_not_nil(kakaoInstance)
  # end
  #
  # def test_getURL
  #   response = KakaoInstance.getURL(
  #       AccessID,
  #       "BOX"
  #   )
  #   puts response
  # end
  #
  #
  # def test_listPlusFriendID
  #   response = KakaoInstance.listPlusFriendID(
  #       AccessID,
  #   )
  #   puts response
  # end
  #
  #
  # def test_getSenderNumberList
  #   response = KakaoInstance.getSenderNumberList(
  #       AccessID,
  #   )
  #   puts response
  # end
  #
  #
  def test_getATStemplate
    response = KakaoInstance.getATSTemplate(
      AccessID,
      "021110000491",
      "testkorea"
    )
    puts response
  end
  # def test_listATSTemplate
  #   response = KakaoInstance.listATSTemplate(
  #       AccessID,
  #   )
  #   puts response[2]
  # end
  #
  # def test_sendATS_one
  #   response = KakaoInstance.sendATS_one(
  #       "1234567890",
  #       "019090000047",
  #       "070-4304-2991",
  #       "테스트, 2018년 6월 15일 에 정상적으로 팝빌에 가입되었습니다. 가입에 감사드리며, 문의사항은 고객센터 및 아래 버튼을 통하여 연락주시면 친절히 상담해드리겠습니다.",
  #       "대체문자",
  #       "",
  #       "",
  #       "010111222",
  #       "테스트",
  #       "",
  #       "",
  #   )
  #   puts response
  # end
  #
  #
  # def test_sendATS_multi
  #   msg = [
  #       {
  #           "rcv" => "010123456",
  #           "rcvnm" => "popbill",
  #           "msg" => "김현진님, 2018년 6월 15일 에 정상적으로 팝빌에 가입되었습니다. 가입에 감사드리며, 문의사항은 고객센터 및 아래 버튼을 통하여 연락주시면 친절히 상담해드리겠습니다.",
  #           "altmsg" => "대체문자1",
  #       },
  #       {
  #           "rcv" => "010890456",
  #           "rcvnm" => "linkhub",
  #           "msg" => "김상훈님, 2018년 6월 15일 에 정상적으로 팝빌에 가입되었습니다. 가입에 감사드리며, 문의사항은 고객센터 및 아래 버튼을 통하여 연락주시면 친절히 상담해드리겠습니다.",
  #           "altmsg" => "대체문자2",
  #       },
  #   ]
  #   response = KakaoInstance.sendATS_multi(
  #       AccessID,
  #       "019090000047",
  #       "07043042991",
  #       "",
  #       "20180630120030",
  #       msg,
  #       "",
  #       "testkorea",
  #       "",
  #   )
  #   puts response
  # end
  #
  #
  # def test_sendATS_same
  #   msg = [
  #       {
  #           "rcv" => "010123456",
  #           "rcvnm" => "popbill",
  #       },
  #       {
  #           "rcv" => "010333999",
  #           "rcvnm" => "linkhub",
  #       },
  #   ]
  #
  #   response = KakaoInstance.sendATS_same(
  #       AccessID,
  #       "019090000047",
  #       "07043042991",
  #       "회원님, 2018년 6월 15일 에 정상적으로 팝빌에 가입되었습니다. 가입에 감사드리며, 문의사항은 고객센터 및 아래 버튼을 통하여 연락주시면 친절히 상담해드리겠습니다.",
  #       "대체문자",
  #       "A",
  #       "20180509120000",
  #       msg,
  #       "",
  #       "testkorea",
  #       ""
  #   )
  #   puts response
  # end
  #
  #
  # $btns = [
  #     {
  #         "n" => "앱링크",
  #         "t" => "AL",
  #         "u1" => "http://www.popbill.com",
  #         "u2" => "http://www.popbill.com",
  #     },
  #     {
  #         "n" => "팝빌 바로가기",
  #         "t" => "WL",
  #         "u1" => "http://www.popbill.com",
  #         "u2" => "http://www.popbill.com",
  #     }
  # ]
  #
  # def test_sendFTS_one
  #   response = KakaoInstance.sendFTS_one(
  #       "1234567890",
  #       "@링크허브",
  #       "070-4304-2991",
  #       "친구톡 텍스트 테스트 입니다.",
  #       "친구톡 텍스트 대체문자 입니다.",
  #       "A",
  #       "",
  #       "010111222",
  #       "김현진",
  #       $btns,
  #       "",
  #       "",
  #       "testkorea",
  #   )
  #   puts response
  # end
  #
  #
  # def test_sendTS_multi
  #   msg = [
  #       {
  #           "rcv" => "010123456",
  #           "rcvnm" => "popbill",
  #           "msg" => "친구톡 텍스트 입니다.1",
  #           "altmsg" => "대체문자1",
  #       },
  #       {
  #           "rcv" => "010890456",
  #           "rcvnm" => "linkhub",
  #           "msg" => "친구톡 텍스트 입니다.2",
  #           "altmsg" => "대체문자2",
  #       },
  #   ]
  #   response = KakaoInstance.sendFTS_multi(
  #       AccessID,
  #       "@팝빌",
  #       "070-4304-2991",
  #       "",
  #       "",
  #       msg,
  #       $btns,
  #       "",
  #       "",
  #       "testkorea"
  #   )
  #   puts response
  # end
  #
  #
  # def test_sendTS_same
  #   msg = [
  #       {
  #           "rcv" => "010123456",
  #           "rcvnm" => "popbill",
  #       },
  #       {
  #           "rcv" => "010890456",
  #           "rcvnm" => "linkhub",
  #       },
  #   ]
  #   response = KakaoInstance.sendFTS_same(
  #       AccessID,
  #       "@팝빌",
  #       "070-4304-2991",
  #       "친구톡 텍스트 동보 입니다.",
  #       "친구톡 텍스트 동보 대채 문자 입니다.",
  #       "A",
  #       "20180701120000",
  #       msg,
  #       $btns,
  #       "",
  #       "",
  #       "testkorea"
  #   )
  #   puts response
  # end
  #
  # def test_sendFMS_one
  #   response = KakaoInstance.sendFMS_one(
  #       AccessID,
  #       "@팝빌",
  #       "070-4304-2991",
  #       "친구톡 이미지 입니다.",
  #       "친구톡 이미지 대체 문자 입니다.",
  #       "A",
  #       "",
  #       "/Users/kimhyunjin/SDK/popbill.sdk.example.ruby/popbill.ruby/test/test.jpg",
  #       "http://www.popbill.co.kr",
  #       "01083490706",
  #       "김현진",
  #       $btns,
  #       "",
  #       "",
  #       "testkorea",
  #   )
  #   puts response
  # end
  #
  #
  # def test_sendFMS_multi
  #   msg = [
  #       {
  #           "rcv" => "010123456",
  #           "rcvnm" => "popbill",
  #           "msg" => "친구톡 이미지 입니다.1",
  #           "altmsg" => "대체문자1",
  #       },
  #       {
  #           "rcv" => "010890456",
  #           "rcvnm" => "linkhub",
  #           "msg" => "친구톡 이미지 입니다.2",
  #           "altmsg" => "대체문자2",
  #       },
  #   ]
  #   response = KakaoInstance.sendFMS_multi(
  #       AccessID,
  #       "@팝빌",
  #       "070-4304-2991",
  #       "A",
  #       "",
  #       "/Users/kimhyunjin/SDK/popbill.sdk.example.ruby/popbill.ruby/test/test.jpg",
  #       "http://www.popbill.co.kr",
  #       msg,
  #       $btns,
  #       "",
  #       "",
  #       "testkorea",
  #   )
  #   puts response
  # end
  #
  #
  # def test_sendFMS_same
  #   msg = [
  #       {
  #           "rcv" => "010123456",
  #           "rcvnm" => "popbill",
  #       },
  #       {
  #           "rcv" => "010890456",
  #           "rcvnm" => "linkhub",
  #       },
  #   ]
  #   response = KakaoInstance.sendFMS_same(
  #       AccessID,
  #       "@팝빌",
  #       "070-4304-2991",
  #       "친구톡 이미지 동보 입니다.",
  #       "친구톡 이미지 대체 문자 입니다.",
  #       "A",
  #       "20180616160342",
  #       "/Users/kimhyunjin/SDK/popbill.sdk.example.ruby/popbill.ruby/test/test.jpg",
  #       "http://www.popbill.co.kr",
  #       msg,
  #       $btns,
  #       "",
  #       "20180618094043-002",
  #       "testkorea",
  #   )
  #   puts response
  # end
  #
  #
  # def test_cancelReserve
  #   response = KakaoInstance.cancelReserve(
  #       AccessID,
  #       "018061516035000001",
  #       "testkorea",
  #   )
  #   puts response
  # end
  #
  # def test_cancelReserveRN
  #   response = KakaoInstance.cancelReserveRN(
  #       AccessID,
  #       "20180618094043-001",
  #       "testkorea",
  #   )
  #   puts response
  # end
  #
  # def test_getMessages
  #   response = KakaoInstance.getMessages(
  #       AccessID,
  #       "018061809422400001",
  #       "testkorea"
  #   )
  #   puts response
  # end
  #
  # def test_getMessagesRN
  #   response = KakaoInstance.getMessagesRN(
  #       AccessID,
  #       "FMS_requestNum_001",
  #       "testkorea"
  #   )
  #   puts response
  # end
  #
  # def test_search
  #   sDate = "20180301"
  #   eDate = "20180630"
  #   state = [1, 2, 3, 4, 5]
  #   item = %w(ATS FTS FMS)
  #   reserveYN = ''
  #   senderYN = ''
  #   page = 1
  #   perPage = 100
  #   order = "D"
  #   qString = ""
  #
  #   response = KakaoInstance.search(
  #       AccessID, sDate, eDate, state, item, reserveYN, senderYN, page, perPage, order, "testkorea", qString
  #   )
  #   puts response.to_json
  # end
  #
  # def test_getUnitCost
  #   response = KakaoInstance.getUnitCost(
  #       AccessID,
  #       "ATS",
  #       "testkorea"
  #   )
  #   puts response
  # end
  #
  # def test_getChargeInfo
  #   response = KakaoInstance.getChargeInfo(
  #       AccessID,
  #       "FMS",
  #       "testkorea"
  #   )
  #   puts response
  # end
  #
  # def test_getSenderNumberMgtURL
  #   url = KakaoInstance.getSenderNumberMgtURL(
  #       AccessID,
  #       "testkorea"
  #   )
  #   puts url
  # end
  #
  # def test_getPlusFriendMgtURL
  #   url = KakaoInstance.getPlusFriendMgtURL(
  #       AccessID,
  #       "testkorea"
  #   )
  #   puts url
  # end
  #
  # def test_getATSTemplateMgtURL
  #   url = KakaoInstance.getATSTemplateMgtURL(
  #       AccessID,
  #       "testkorea"
  #   )
  #   puts url
  # end
  #
  # def test_getSentListURL
  #   url = KakaoInstance.getSentListURL(
  #       AccessID,
  #       "testkorea"
  #   )
  #   puts url
  # end
end

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

  def test_ServiceInstance
    kakaoInstance = KakaoService.instance(
        LinkID,
        SecretKey
    )
    puts kakaoInstance
    assert_not_nil(kakaoInstance)
  end

  def test_getURL
    response = KakaoInstance.getURL(
        AccessID,
        "BOX"
    )
    puts response
  end


  def test_listPlusFriendID
    response = KakaoInstance.listPlusFriendID(
        AccessID,
    )
    puts response
  end


  def test_getSenderNumberList
    response = KakaoInstance.getSenderNumberList(
        AccessID,
    )
    puts response
  end


  def test_listATSTemplate
    response = KakaoInstance.listATSTemplate(
        AccessID,
    )
    puts response
  end

  def test_sendATS_one
    response = KakaoInstance.sendATS_one(
        "1234567890",
        "018020000010",
        "070-4304-2991",
        "김현진님, 2018년 6월 15일 에 정상적으로 팝빌에 가입되었습니다. 가입에 감사드리며, 문의사항은 고객센터 및 아래 버튼을 통하여 연락주시면 친절히 상담해드리겠습니다.",
        "대체문자",
        "",
        "20180630120030",
        "010111222",
        "김현진",
        "",
        "testkorea",
    )
    puts response
  end


  def test_sendATS_multi
    msg = [
        {
            "rcv" => "010123456",
            "rcvnm" => "popbill",
            "msg" => "김현진님, 2018년 6월 15일 에 정상적으로 팝빌에 가입되었습니다. 가입에 감사드리며, 문의사항은 고객센터 및 아래 버튼을 통하여 연락주시면 친절히 상담해드리겠습니다.",
            "altmsg" => "대체문자1",
        },
        {
            "rcv" => "010890456",
            "rcvnm" => "linkhub",
            "msg" => "김상훈님, 2018년 6월 15일 에 정상적으로 팝빌에 가입되었습니다. 가입에 감사드리며, 문의사항은 고객센터 및 아래 버튼을 통하여 연락주시면 친절히 상담해드리겠습니다.",
            "altmsg" => "대체문자2",
        },
    ]
    response = KakaoInstance.sendATS_multi(
        AccessID,
        "018020000010",
        "07043042991",
        "",
        "20180630120030",
        msg,
        "",
        "testkorea",
    )
    puts response
  end


  def test_sendATS_same
    msg = [
        {
            "rcv" => "010123456",
            "rcvnm" => "popbill",
        },
        {
            "rcv" => "010333999",
            "rcvnm" => "linkhub",
        },
    ]

    response = KakaoInstance.sendATS_same(
        AccessID,
        "018020000010",
        "07043042991",
        "회원님, 2018년 6월 15일 에 정상적으로 팝빌에 가입되었습니다. 가입에 감사드리며, 문의사항은 고객센터 및 아래 버튼을 통하여 연락주시면 친절히 상담해드리겠습니다.",
        "대체문자",
        "A",
        "20180509120000",
        msg,
        "",
        "testkorea"
    )
    puts response
  end


  $btns = [
      {
          "n" => "앱링크",
          "t" => "AL",
          "u1" => "http://www.popbill.com",
          "u2" => "http://www.popbill.com",
      },
      {
          "n" => "팝빌 바로가기",
          "t" => "WL",
          "u1" => "http://www.popbill.com",
          "u2" => "http://www.popbill.com",
      }
  ]

  def test_sendFTS_one
    response = KakaoInstance.sendFTS_one(
        "1234567890",
        "@링크허브",
        "070-4304-2991",
        "친구톡 텍스트 테스트 입니다.",
        "친구톡 텍스트 대체문자 입니다.",
        "A",
        "",
        "010111222",
        "김현진",
        $btns,
        "",
        "",
        "testkorea",
    )
    puts response
  end


  def test_sendTS_multi
    msg = [
        {
            "rcv" => "010123456",
            "rcvnm" => "popbill",
            "msg" => "친구톡 텍스트 입니다.1",
            "altmsg" => "대체문자1",
        },
        {
            "rcv" => "010890456",
            "rcvnm" => "linkhub",
            "msg" => "친구톡 텍스트 입니다.2",
            "altmsg" => "대체문자2",
        },
    ]
    response = KakaoInstance.sendFTS_multi(
        AccessID,
        "@팝빌",
        "070-4304-2991",
        "",
        "",
        msg,
        $btns,
        "",
        "",
        "testkorea"
    )
    puts response
  end


  def test_sendTS_same
    msg = [
        {
            "rcv" => "010123456",
            "rcvnm" => "popbill",
        },
        {
            "rcv" => "010890456",
            "rcvnm" => "linkhub",
        },
    ]
    response = KakaoInstance.sendFTS_same(
        AccessID,
        "@팝빌",
        "070-4304-2991",
        "친구톡 텍스트 동보 입니다.",
        "친구톡 텍스트 동보 대채 문자 입니다.",
        "A",
        "20180701120000",
        msg,
        $btns,
        "",
        "",
        "testkorea"
    )
    puts response
  end


  def test_getMessages
    response = KakaoInstance.getMessages(
        AccessID,
        "018061418262100001",
        "testkorea"
    )
    puts response
  end

  def test_getMessagesRN
    response = KakaoInstance.getMessagesRN(
        AccessID,
        "FMS_requestNum_001",
        "testkorea"
    )
    puts response
  end


end
# -*- coding: utf-8 -*-
require 'test/unit'
require_relative '../lib/popbill/fax.rb'

class FaxServiceTest < Test::Unit::TestCase
  LinkID = "TESTER"
  SecretKey = "SwWxqU+0TErBXy/9TVjIPEnI0VTUMMSQZtJf3Ed8q3I="

  ServiceID = "POPBILL_TEST"
  AccessID = "1234567890"
  Scope = ["member", "110"]

  FaxInstance = FaxService.instance(FaxServiceTest::LinkID, FaxServiceTest::SecretKey)
  FaxInstance.setIsTest(true)
  FaxInstance.setUseLocalTimeYN(true)

  # def test_01ServiceInstance
  #   msgInstance = FaxService.instance(
  #       FaxServiceTest::LinkID,
  #       FaxServiceTest::SecretKey,
  #   )
  #   puts msgInstance
  #   assert_not_nil(msgInstance)
  # end
  #
  # def test_02getChargeInfo
  #   response = FaxInstance.getChargeInfo(
  #       FaxServiceTest::AccessID,
  #   )
  #
  #   puts response
  #   assert_not_nil(response)
  # end
  #
  # def test_03getURL
  #   url = FaxInstance.getURL(
  #       FaxServiceTest::AccessID,
  #       "BOX"
  #   )
  #   puts url
  #   assert_not_nil(url)
  # end
  #
  # def test_04getUnitCost
  #   response = FaxInstance.getUnitCost(
  #       FaxServiceTest::AccessID,
  #   )
  #
  #   puts response
  #   assert_not_nil(response)
  # end
  #
  # def test_13search
  #   sDate = "20180331"
  #   eDate = "20180699"
  #   state = [1, 2, 3, 4]
  #   reserveYN = ''
  #   senderYN = ''
  #   page = 1
  #   perPage = 100
  #   order = "D"
  #   qString = "팝빌담당"
  #
  #   response = FaxInstance.search(
  #       FaxServiceTest::AccessID,
  #       sDate, eDate, state, reserveYN, senderYN, page, perPage, order, "testkorea", qString
  #   )
  #   puts response
  #   assert_not_nil(response)
  # end
  #
  # def test_14sendFax
  #   response = FaxInstance.sendFax(
  #       FaxServiceTest::AccessID,
  #       "07043042992",
  #       "발신자명",
  #       "070111222",
  #       "수신자명",
  #       ["./test.pdf"],
  #       "20210103000000",
  #       "",
  #       true,
  #       "팩스전송제목"
  #   )
  #   puts response
  #   assert_not_nil(response)
  # end
  # #
  # def test_15resendFax
  #
  #   receivers =
  #       [
  #           {
  #               "rcv" => "01055565",
  #               "rcvnm" => "John",
  #           },
  #           {
  #               "rcv" => "010111222",
  #               "rcvnm" => "John2",
  #           },
  #       ]
  #
  #   receivers = nil
  #
  #   receiptNum = "017071815425000001"
  #   response = FaxInstance.resendFax_multi(
  #       FaxServiceTest::AccessID,
  #       receiptNum,
  #       "07043042991",
  #       "발신자명",
  #       receivers,
  #       "",
  #       "",
  #       "팩스 재전송 제목",
  #   )
  #   begin
  #     puts response
  #     assert_not_nil(response)
  #   rescue PopbillException => pe
  #
  #   end
  # end
  #
  #
  # def test_15sendFax_multi
  #   receivers =
  #       [
  #           {
  #               "rcv" => "070111222",
  #               "rcvnm" => "John",
  #           },
  #           {
  #               "rcv" => "070111222",
  #               "rcvnm" => "John2",
  #           },
  #       ]
  #   response = FaxInstance.sendFax_multi(
  #       FaxServiceTest::AccessID,
  #       "07043042991",
  #       "발신자명",
  #       receivers,
  #       ["/Users/John/Documents/WorkSpace/ruby project/popbill/test/test.pdf"],
  #       "",
  #       "",
  #       true,
  #   )
  #   puts response
  #   assert_not_nil(response)
  # end
  #
  # def test_16getFaxDetail
  #   response = FaxInstance.getFaxDetail(
  #       FaxServiceTest::AccessID,
  #       "017011914233400001",
  #   )
  #
  #   puts response
  #   assert_not_nil(response)
  # end
  #
  # def test_17cancelReserve
  #   response = FaxInstance.cancelReserve(
  #       FaxServiceTest::AccessID,
  #       "018062013531800001",
  #   )
  #
  #   puts response
  #   assert_not_nil(response)
  # end
  #
  # def test_18resendFax
  #
  #   receiptNum = "017021011564500001"
  #   response = FaxInstance.resendFax(
  #       FaxServiceTest::AccessID,
  #       receiptNum,
  #       "07043042991",
  #       "발신자명",
  #       "",
  #       "",
  #       "",
  #   )
  #
  #   puts response
  #   assert_not_nil(response)
  #
  # end
  #
  # def test_19getSenderNumberList
  #   response = FaxInstance.getSenderNumberList(
  #       FaxServiceTest::AccessID,
  #   )
  #   puts response
  #   assert_not_nil(response)
  # end
  #
  #
  # def test_20sendFax
  #   response = FaxInstance.sendFax(
  #       FaxServiceTest::AccessID,
  #       "07043042992",
  #       "발신자명",
  #       "070111222",
  #       "수신자명",
  #       ["/Users/kimhyunjin/SDK/popbill.sdk.example.ruby/popbill.ruby/test/test.jpg"],
  #       "",
  #       "",
  #       true,
  #       "팩스전송제목",
  #       "20180618182928"
  #   )
  #   puts response
  #   assert_not_nil(response)
  # end
  #
  #
  # def test_21resendFax
  #
  #   receiptNum = "018061815385900001"
  #   response = FaxInstance.resendFax(
  #       FaxServiceTest::AccessID,
  #       receiptNum,
  #       "07043042991",
  #       "발신자명",
  #       "",
  #       "",
  #       "20180718154556",
  #       "testkorea",
  #       "팩스전송제목",
  #       "20180620-001"
  #   )
  #
  #   puts response
  #   assert_not_nil(response)
  #
  # end
  #
  #
  # def test_22getFaxDetailRN
  #   response = FaxInstance.getFaxDetailRN(
  #       FaxServiceTest::AccessID,
  #       "20180618_001",
  #   )
  #
  #   puts response
  #   assert_not_nil(response)
  # end
  #
  # def test_23cancelReserveRN
  #   response = FaxInstance.cancelReserveRN(
  #       FaxServiceTest::AccessID,
  #       "20180620132918-1",
  #   )
  #
  #   puts response
  #   assert_not_nil(response)
  # end
  #
  #
  # def test_24ResendFAXRN
  #   response = FaxInstance.resendFAXRN(
  #       FaxServiceTest::AccessID,
  #       "20180620-002",
  #       "07043042991",
  #       "발신자명",
  #       "010333444",
  #       "수신자명",
  #       "20180620132802",
  #       "testkorea",
  #       "팩스전송제목",
  #       # ""
  #   )
  #   puts response
  # end
  #
  # def test_25ResendFAXRN_multi
  #   receivers =
  #       [
  #           {
  #               "rcv" => "070211222",
  #               "rcvnm" => "JIN",
  #           },
  #           {
  #               "rcv" => "070311222",
  #               "rcvnm" => "HYUN",
  #           },
  #       ]
  #   response = FaxInstance.resendFAXRN_multi(
  #       FaxServiceTest::AccessID,
  #       "20180620-100",
  #       "07043042991",
  #       "발신자명",
  #       receivers,
  #       "20180630132922",
  #       "testkorea",
  #       "팩스전송제목",
  #       # "20180620132918-1"
  #   )
  #   puts response
  # end
  #
  # def test_getSenderNumberMgtURL
  #   url = FaxInstance.getSenderNumberMgtURL(
  #       AccessID,
  #       "testkorea"
  #   )
  #   puts url
  # end
  #
  # def test_getSentListURL
  #   url = FaxInstance.getSentListURL(
  #       AccessID,
  #       "testkorea"
  #   )
  #   puts url
  # end
  #
  # def test_getPreviewURL
  #   url = FaxInstance.getPreviewURL(
  #       AccessID,
  #       "018103015555500001",
  #       "testkorea",
  #   )
  #
  #   puts url
  # end

  def test_sendFaxBinary
    reserveDT = "2022010414000000"
    userID = "testkorea"
    adsYN = false
    title = "팩스제목들어가나요"
    requestNum = ""

    fileDatas = []
    io = File.open('./test.pdf', "rb")

    io2 = File.open('./test.txt', "r")

    receiver = [
        {
            "rcv" => '070111222',
            "rcvnm" => '테스트맨'
        },
        {
            "rcv" => '070111333',
            "rcvnm" => '테스트맨2222'
        }
    ]
    fileDatas = [
      {
        "fileName" => 'test.pdf',
        "fileData" => io.read
      },
      {
        "fileName" => 'test.txt',
        # "fileData" => io2.read
        "fileData" => io2.read
      },
    ]
    io.close
    io2.close
    resposne = FaxInstance.sendFaxBinary_multi(
      FaxServiceTest::AccessID,
      "07043042992",
      "발신자명",
      receiver,
      fileDatas,
      reserveDT,
      userID,
      adsYN,
      title,
      requestNum
    )
    puts resposne
  end


end # end of test Class

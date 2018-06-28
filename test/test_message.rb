# -*- coding: utf-8 -*-
require 'test/unit'
require_relative '../lib/popbill/message.rb'

class MSGServiceTest < Test::Unit::TestCase
  LinkID = "TESTER"
  SecretKey = "SwWxqU+0TErBXy/9TVjIPEnI0VTUMMSQZtJf3Ed8q3I="

  ServiceID = "POPBILL_TEST"
  AccessID = "1234567890"
  Scope = ["member","110"]

  MSGInstance = MessageService.instance(MSGServiceTest::LinkID, MSGServiceTest::SecretKey)
  MSGInstance.setIsTest(true)

  def test_01ServiceInstance
    msgInstance = MessageService.instance(
      MSGServiceTest::LinkID,
      MSGServiceTest::SecretKey,
    )
    puts msgInstance
    assert_not_nil(msgInstance)
  end

  def test_02getChargeInfo
    response = MSGInstance.getChargeInfo(
      MSGServiceTest::AccessID,
      MsgType::SMS,
    )

    puts response
    assert_not_nil(response)
  end

  def test_03sendSMS_single
    sender = "07043042991"
    senderName = "kimhyunjin"
    receiver = "010000111"
    receiverName = "MyPhone"
    contents = "message send Test"

    response = MSGInstance.sendSMS(
      MSGServiceTest::AccessID, sender, senderName, receiver, receiverName, contents,
    )

    puts response

    assert_not_nil(response)
  end

  def test_04sendSMS_multi
    sender = "07043042991"
    senderName = "John"
    contents = "message send Test"

    receivers =
    [
      {
        "rcv" => "010000111",
        "rcvnm" => "John",
      },
      {
        "rcv" => "010000111",
        "rcvnm" => "John2",
      },
    ]

    response = MSGInstance.sendSMS_multi(
      MSGServiceTest::AccessID, sender, senderName, contents, receivers,
    )

    puts response
    assert_not_nil(response)
  end

  def test_05sendLMS_single
    sender = "07043042991"
    senderName = "John"
    receiver = "010000111"
    receiverName = "MyPhone"
    subject = "This is subject"
    contents = "message send Test"

    response = MSGInstance.sendLMS(
      MSGServiceTest::AccessID, sender, senderName, receiver, receiverName,
      subject, contents,
    )

    puts response

    assert_not_nil(response)
  end

  def test_06sendLMS_multi
    sender = "07043042991"
    senderName = "John"
    subject = "This is subject"
    contents = "message send Test LMS Multi"

    receivers =
    [
      {
        "rcv" => "01000111",
        "rcvnm" => "John",
      },
      {
        "rcv" => "010000111",
        "rcvnm" => "John2",
      },
    ]

    response = MSGInstance.sendLMS_multi(
      MSGServiceTest::AccessID, sender, senderName, subject, contents, receivers,
    )

    puts response
    assert_not_nil(response)
  end

  def test_07sendMMS_single
    sender = "07043042991"
    senderName = "John"
    receiver = "010000111"
    receiverName = "MyPhone"
    subject = "This is subject"
    contents = "message send Test"
    filePath = "/Users/John/Documents/WorkSpace/ruby project/popbill/test/test.jpg"

    response = MSGInstance.sendMMS(
      MSGServiceTest::AccessID, sender, senderName, receiver, receiverName,
      subject, contents, filePath,
    )

    puts response

    assert_not_nil(response)
  end

  def test_08sendXMS_single
    sender = "07043042991"
    senderName = "John"
    receiver = "010111222"
    receiverName = "MyPhone"
    subject = "This is subject"
    contents = "message send"

    response = MSGInstance.sendXMS(
      MSGServiceTest::AccessID, sender, senderName, receiver, receiverName,
      subject, contents,
    )

    puts response

    assert_not_nil(response)
  end

  def test_09sendXMS_multi
    sender = "07043042991"
    senderName = "John"
    subject = "This is subject"
    contents = "message send Test LMS Multi"

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

    response = MSGInstance.sendXMS_multi(
      MSGServiceTest::AccessID, sender, senderName, subject, contents, receivers,
    )

    puts response
    assert_not_nil(response)
  end

  def test_10getMessages
    response = MSGInstance.getMessages(
      MSGServiceTest::AccessID,
      "017011817000000134",
    )

    puts response
    assert_not_nil(response)
  end

  def test_11cancelReserve
    response = MSGInstance.cancelReserve(
      MSGServiceTest::AccessID,
      "017011817000000134",
    )

    puts response
    assert_not_nil(response)
  end

  def test_12getURL
    response = MSGInstance.getURL(
      MSGServiceTest::AccessID,
      "BOX",
    )
    puts response
    assert_not_nil(response)
  end

  def test_13search
    sDate = "20180301"
    eDate = "20180628"
    state = [1, 2, 3, 4]
    item = ["SMS", "LMS", "MMS"]
    reserveYN = ''
    senderYN = ''
    page = 1
    perPage = 100
    order = "D"
    qString = ""

    response = MSGInstance.search(
      MSGServiceTest::AccessID,
      sDate, eDate, state, item, reserveYN, senderYN, page, perPage, order, "testkorea", qString
    )
    puts response["total"]
    assert_not_nil(response)
  end

  def test_14getSenderNumberList
    response = MSGInstance.getSenderNumberList(
      MSGServiceTest::AccessID,
    )

    puts response
    assert_not_nil(response)
  end

  def test_15sendSMS_single
    sender = "07043042991"
    senderName = "John"
    receiver = "010000111"
    receiverName = "MyPhone"
    contents = "message send Test"

    response = MSGInstance.sendSMS(
        MSGServiceTest::AccessID, sender, senderName, receiver, receiverName, contents, '', '', 'testkorea', '20180628160446')

    puts response

    assert_not_nil(response)
  end

  def test_16sendSMS_multi
    sender = "07043042991"
    senderName = "John"
    contents = "message send Test"

    receivers =
        [
            {
                "rcv" => "010000111",
                "rcvnm" => "John",
            },
            {
                "rcv" => "010000111",
                "rcvnm" => "John2",
            },
        ]

    response = MSGInstance.sendSMS_multi(
        MSGServiceTest::AccessID, sender, senderName, contents, receivers, '', '', '', '20180618140850'
        )

    puts response
    assert_not_nil(response)
  end

  def test_17sendLMS_single
    sender = "07043042991"
    senderName = "John"
    receiver = "010000111"
    receiverName = "MyPhone"
    subject = "This is subject"
    contents = "message send Test"

    response = MSGInstance.sendLMS(
        MSGServiceTest::AccessID, sender, senderName, receiver, receiverName,
        subject, contents, '', '', 'testkorea', '20180618141203'
        )

    puts response

    assert_not_nil(response)
  end

  def test_18sendLMS_multi
    sender = "07043042991"
    senderName = "John"
    subject = "This is subject"
    contents = "message send Test LMS Multi"

    receivers =
        [
            {
                "rcv" => "01000111",
                "rcvnm" => "John",
            },
            {
                "rcv" => "010000111",
                "rcvnm" => "John2",
            },
        ]

    response = MSGInstance.sendLMS_multi(
        MSGServiceTest::AccessID, sender, senderName, subject, contents, receivers, '', true, 'testkorea', '20180618141241'
        )

    puts response
    assert_not_nil(response)
  end

  def test_19sendXMS_single
    sender = "07043042991"
    senderName = "John"
    receiver = "010111222"
    receiverName = "MyPhone"
    subject = "This is subject"
    contents = "message send"

    response = MSGInstance.sendXMS(
        MSGServiceTest::AccessID, sender, senderName, receiver, receiverName,
        subject, contents, '', '', 'cream99', '20180618141557'
        )

    puts response

    assert_not_nil(response)
  end

  def test_20sendXMS_multi
    sender = "07043042991"
    senderName = "John"
    subject = "This is subject"
    contents = "message send Test LMS Multi"

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

    response = MSGInstance.sendXMS_multi(
        MSGServiceTest::AccessID, sender, senderName, subject, contents, receivers, '', '', 'testkorea', '20180618141615'
        )

    puts response
    assert_not_nil(response)
  end

  def test_21sendMMS_single
    sender = "07043042991"
    senderName = "John"
    receiver = "010000111"
    receiverName = "MyPhone"
    subject = "This is subject"
    contents = "message send Test"
    filePath = "/Users/kimhyunjin/SDK/popbill.sdk.example.ruby/popbill.ruby/test/test.jpg"

    response = MSGInstance.sendMMS(
        MSGServiceTest::AccessID, sender, senderName, receiver, receiverName,
        subject, contents, filePath, '', '', 'testkorea', ''
        )

    puts response

    assert_not_nil(response)
  end

  def test_22sendMMS_single
    sender = "07043042991"
    senderName = "John"
    receiver = "010000111"
    receiverName = "MyPhone"
    subject = "This is subject"
    contents = "message send Test"
    filePath = "/Users/kimhyunjin/SDK/popbill.sdk.example.ruby/popbill.ruby/test/test.jpg"

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

    response = MSGInstance.sendMMS_multi(
        MSGServiceTest::AccessID, sender, senderName,
        subject, contents, receivers, filePath, '20180718142739', '', 'testkorea', '20180618182506'
    )

    puts response

    assert_not_nil(response)
  end


  def test_23getMessagesRN
    response = MSGInstance.getMessagesRN(
        MSGServiceTest::AccessID,
        "20180618-MMS",
        )

    puts response
    assert_not_nil(response)
  end

  def test_24cancelReserveRN
    response = MSGInstance.cancelReserveRN(
        MSGServiceTest::AccessID,
        "20180618-MMS",
        )

    puts response
    assert_not_nil(response)
  end

  def test_25getStates

    reciptNumList = %w(018061814000000039 018061815000000002)

    response = MSGInstance.getStates(
        MSGServiceTest::AccessID,
        reciptNumList,
        "testkorea",
    )
    puts response
  end

end # end of test Class

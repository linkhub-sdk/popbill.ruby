# -*- coding: utf-8 -*-
require_relative '../popbill.rb'

# 팝빌 문자 API Service Implementation
class MessageService < BaseService
  class << self
    def instance(linkID, secretKey)
      super(linkID, secretKey)
      @instance ||= new
      @instance.addScope("150")
      @instance.addScope("151")
      @instance.addScope("152")
      return @instance
    end

    private :new
  end

  def getChargeInfo(corpNum, msgType, userID = '')
    if corpNum.length != 10
      raise PopbillException.new(-99999999, "사업자등록번호가 올바르지 않습니다.")
    end
    httpget("/Message/ChargeInfo?Type=#{msgType}", corpNum, userID)
  end

  def getAutoDenyList(corpNum, userID = '')
    if corpNum.length != 10
      raise PopbillException.new(-99999999, "사업자등록번호가 올바르지 않습니다.")
    end
    httpget("/Message/Denied", corpNum, userID)
  end

  def getSenderNumberList(corpNum, userID = '')
    if corpNum.length != 10
      raise PopbillException.new(-99999999, "사업자등록번호가 올바르지 않습니다.")
    end
    httpget("/Message/SenderNumber", corpNum, userID)
  end

  def getUnitCost(corpNum, msgType, userID = '')
    if corpNum.length != 10
      raise PopbillException.new(-99999999, "사업자등록번호가 올바르지 않습니다.")
    end
    httpget("/Message/UnitCost?Type=#{msgType}", corpNum, userID)['unitCost']
  end


  def sendMessage(msgType, corpNum, sender, senderName, subject, contents,
                  messages, reserveDT, adsYN = false, userID = '', requestNum = '')

    if corpNum.length != 10
      raise PopbillException.new(-99999999, "사업자등록번호가 올바르지 않습니다.")
    end

    req = {}

    if sender.to_s != ''
      req["snd"] = sender
    end
    if senderName.to_s != ''
      req["sndnm"] = senderName
    end
    if subject.to_s != ''
      req["subject"] = subject
    end
    if contents.to_s != ''
      req["content"] = contents
    end
    if reserveDT.to_s != ''
      req["sndDT"] = reserveDT
    end
    if messages.to_s != ''
      req["msgs"] = messages
    end
    if adsYN
      req["adsYN"] = true
    end
    if requestNum.to_s != ''
      req["requestNum"] = requestNum
    end

    postData = req.to_json

    httppost("/#{msgType}", corpNum, postData, "", userID)['receiptNum']
  end


  def sendSMS(corpNum, sender, senderName, receiver, receiverName, contents,
              reserveDT = '', adsYN = false, userID = '', requestNum = '')

    messages = [
        {
            "snd" => sender,
            "sndName" => senderName,
            "rcv" => receiver,
            "rcvnm" => receiverName,
            "msg" => contents,
        }
    ]
    sendMessage("SMS", corpNum, '', '', '', '', messages, reserveDT,
                adsYN, userID, requestNum
    )
  end

  def sendSMS_multi(corpNum, sender, senderName, contents, messages, reserveDT = '',
                    adsYN = false, userID = '', requestNum = '')

    sendMessage("SMS", corpNum, sender, senderName, '', contents, messages, reserveDT,
                adsYN, userID, requestNum
    )
  end


  def sendLMS(corpNum, sender, senderName, receiver, receiverName, subject, contents,
              reserveDT = '', adsYN = false, userID = '', requestNum)

    messages = [
        {
            "snd" => sender,
            "sndName" => senderName,
            "rcv" => receiver,
            "rcvnm" => receiverName,
            "msg" => contents,
            "sjt" => subject,
        }
    ]

    sendMessage("LMS", corpNum, '', '', '', '', messages, reserveDT,
                adsYN, userID, requestNum
    )
  end

  def sendLMS_multi(corpNum, sender, senderName, subject, contents, messages,
                    reserveDT = '', adsYN = false, userID = '', requestNum)

    sendMessage("LMS", corpNum, sender, senderName, subject, contents, messages,
                reserveDT, adsYN, userID, requestNum
    )
  end


  def sendXMS(corpNum, sender, senderName, receiver, receiverName, subject, contents,
              reserveDT = '', adsYN = false, userID = '', requestNum)

    messages = [
        {
            "snd" => sender,
            "sndName" => senderName,
            "rcv" => receiver,
            "rcvnm" => receiverName,
            "msg" => contents,
            "sjt" => subject,
        }
    ]

    sendMessage("XMS", corpNum, '', '', '', '', messages, reserveDT,
                adsYN, userID, requestNum
    )
  end

  def sendXMS_multi(corpNum, sender, senderName, subject, contents, messages,
                    reserveDT = '', adsYN = false, userID = '', requestNum)

    sendMessage("XMS", corpNum, sender, senderName, subject, contents, messages,
                reserveDT, adsYN, userID, requestNum
    )
  end


  def sendMMS(corpNum, sender, senderName, receiver, receiverName, subject, contents,
              filePath, reserveDT = '', adsYN = false, userID = '', requestNum)

    messages = [
        {
            "snd" => sender,
            "sndnm" => senderName,
            "rcv" => receiver,
            "rcvnm" => receiverName,
            "msg" => contents,
            "sjt" => subject,
        }
    ]

    sendMMS_multi(corpNum, sender, senderName, subject, contents, messages, filePath,
                  reserveDT, adsYN, userID, requestNum
    )
  end

  def sendMMS_multi(corpNum, sender, senderName, subject, contents, messages, filePath,
                    reserveDT = '', adsYN = false, userID = '', requestNum)

    if corpNum.length != 10
      raise PopbillException.new(-99999999, "사업자등록번호가 올바르지 않습니다.")
    end

    req = {}

    if sender.to_s != ''
      req["snd"] = sender
    end
    if senderName.to_s != ''
      req["sndnm"] = senderName
    end
    if subject.to_s != ''
      req["subject"] = subject
    end
    if contents.to_s != ''
      req["content"] = contents
    end
    if reserveDT.to_s != ''
      req["sndDT"] = reserveDT
    end
    if messages.to_s != ''
      req["msgs"] = messages
    end
    if adsYN
      req["adsYN"] = true
    end

    if requestNum.to_s != ''
      req["requestNum"] = requestNum
    end

    httppostfile("/MMS", corpNum, req, [filePath], userID)['receiptNum']
  end

  def getMessages(corpNum, receiptNum, userID = '')
    if corpNum.length != 10
      raise PopbillException.new(-99999999, "사업자등록번호가 올바르지 않습니다.")
    end
    if receiptNum.to_s == ''
      raise PopbillException.new(-99999999, "접수번호(receiptNum)가 입력되지 않았습니다.")
    end

    httpget("/Message/#{receiptNum}", corpNum, userID)
  end

  def getMessagesRN(corpNum, requestNum, userID = '')
    if corpNum.length != 10
      raise PopbillException.new(-99999999, "사업자등록번호가 올바르지 않습니다.")
    end
    if requestNum.to_s == ''
      raise PopbillException.new(-99999999, "요청번호(requestNum)가 입력되지 않았습니다.")
    end

    httpget("/Message/Get/#{requestNum}", corpNum, userID)
  end

  def cancelReserve(corpNum, receiptNum, userID = '')
    if corpNum.length != 10
      raise PopbillException.new(-99999999, "사업자등록번호가 올바르지 않습니다.")
    end
    if receiptNum.to_s == ''
      raise PopbillException.new(-99999999, "접수번호(receiptNum)가 입력되지 않았습니다.")
    end

    httpget("/Message/#{receiptNum}/Cancel", corpNum, userID)
  end

  def cancelReserveRN(corpNum, requestNum, userID = '')
    if corpNum.length != 10
      raise PopbillException.new(-99999999, "사업자등록번호가 올바르지 않습니다.")
    end
    if requestNum.to_s == ''
      raise PopbillException.new(-99999999, "요청번호(requestNum)가 입력되지 않았습니다.")
    end

    httpget("/Message/Cancel/#{requestNum}", corpNum, userID)
  end

  def getURL(corpNum, togo, userID = '')
    if corpNum.length != 10
      raise PopbillException.new(-99999999, "사업자등록번호가 올바르지 않습니다.")
    end

    httpget("/Message/?TG=#{togo}", corpNum, userID)['url']
  end

  def search(corpNum, sDate, eDate, state, item, reserveYN, senderYN, page, perPage,
             order, userID = '')
    if corpNum.length != 10
      raise PopbillException.new('-99999999', '사업자등록번호가 올바르지 않습니다.')
    end
    if sDate.to_s == ''
      raise PopbillException.new('-99999999', '시작일자가 입력되지 않았습니다.')
    end
    if eDate.to_s == ''
      raise PopbillException.new('-99999999', '종료일자가 입력되지 않았습니다.')
    end

    uri = "/Message/Search?SDate=#{sDate}&EDate=#{eDate}"
    uri += "&State=" + state.join(',')
    uri += "&Item=" + item.join(',')
    uri += "&ReserveYN=" + reserveYN
    uri += "&SenderYN=" + senderYN
    uri += "&Page=" + page.to_s
    uri += "&PerPage=" + perPage.to_s
    uri += "&Order=" + order

    httpget(URI.escape(uri), corpNum, userID)
  end

  def getStates(corpNum, reciptNumList, userID ='')
    if corpNum.length != 10
      raise PopbillException.new(-99999999, "사업자등록번호가 올바르지 않습니다.")
    end
    unless reciptNumList.any?
      raise PopbillException.new(-99999999, "접수번호 배열이 올바르지 않습니다.")
    end

    postData = reciptNumList.to_json

    httppost("/Message/States", corpNum, postData, "", userID)

  end

end # end of MessageService

module MsgType
  SMS = "SMS"
  LMS = "LMS"
  MMS = "MMS"
end

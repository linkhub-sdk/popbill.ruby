# -* coding: utf-8 -*-
require_relative '../popbill.rb'

# 팝빌 카카오톡 API Service Implementation
class KakaoService < BaseService
  class << self
    def instance(linkID, secretKey)
      super(linkID, secretKey)
      @instance ||= new
      @instance.addScope("153")
      @instance.addScope("154")
      @instance.addScope("155")
      return @instance
    end

    private :new
  end

  def getURL(corpNum, togo, userID = '')
    if corpNum.length != 10
      raise PopbillException.new(-99999999, "사업자등록번호가 올바르지 않습니다.")
    end

    if togo == "SENDER"
      httpget("/Message/?TG=#{togo}", corpNum, userID)['url']
    else
      httpget("/KakaoTalk/?TG=#{togo}", corpNum, userID)['url']
    end
  end

  def listPlusFriendID(corpNum, userID = '')
    if corpNum.length != 10
      raise PopbillException.new(-99999999, "사업자등록번호가 올바르지 않습니다.")
    end

    httpget("/KakaoTalk/ListPlusFriendID", corpNum, userID)
  end

  def getSenderNumberList(corpNum, userID = '')
    if corpNum.length != 10
      raise PopbillException.new(-99999999, "사업자등록번호가 올바르지 않습니다.")
    end

    httpget("/Message/SenderNumber", corpNum, userID)
  end

  def listATSTemplate(corpNum, userID = '')
    if corpNum.length != 10
      raise PopbillException.new(-99999999, "사업자등록번호가 올바르지 않습니다.")
    end

    httpget("/KakaoTalk/ListATSTemplate", corpNum, userID)
  end

  def sendATS_one(corpNum, templateCode, snd, content, altContent, altSendType, sndDT, receiver, receiverName, requestNum = '', userID = '')
    msg = [
        {
            "rcv" => receiver,
            "rcvnm" => receiverName,
            "msg" => content,
            "altmsg" => altContent,
        }
    ]
    sendATS_same(corpNum, templateCode, snd, content, altContent, altSendType, sndDT, msg, requestNum, userID)
  end

  def sendATS_multi(corpNum, templateCode, snd, altSendType, sndDT, msgs, requestNum = '', userID = '')
    sendATS_same(corpNum, templateCode, snd, "", "", altSendType, sndDT, msgs, requestNum, userID)
  end

  def sendATS_same(corpNum, templateCode, snd, content, altContent, altSendType, sndDT, msgs, requestNum = '', userID = '')

    if corpNum.length != 10
      raise PopbillException.new(-99999999, "사업자등록번호가 올바르지 않습니다.")
    end

    req = {}

    if templateCode.to_s != ''
      req["templateCode"] = templateCode
    end
    if snd.to_s != ''
      req["snd"] = snd
    end
    if content.to_s != ''
      req["content"] = content
    end
    if altContent.to_s != ''
      req["altContent"] = altContent
    end
    if altSendType.to_s != ''
      req["altSendType"] = altSendType
    end
    if sndDT.to_s != ''
      req["sndDT"] = sndDT
    end
    if requestNum.to_s != ''
      req["requestNum"] = requestNum
    end
    if msgs.to_s != ''
      req["msgs"] = msgs
    end

    postData = req.to_json
    httppost("/ATS", corpNum, postData, "", userID)

  end

  def sendFTS_one(corpNum, plusFriendID, snd, content, altContent, altSendType, sndDT, receiver, receiverName, btns, adsYN = false, requestNum = '', userID = '')
    msg = [
        {
            "rcv" => receiver,
            "rcvnm" => receiverName,
            "msg" => content,
            "altmsg" => altContent,
        }
    ]
    sendFTS_same(corpNum, plusFriendID, snd, content, altContent, altSendType, sndDT, msg, btns, adsYN, requestNum, userID)
  end

  def sendFTS_multi(corpNum, plusFriendID, snd, altSendType, sndDT, msgs, btns, adsYN = false, requestNum = '', userID = '')
    sendFTS_same(corpNum, plusFriendID, snd, "", "", altSendType, sndDT, msgs, btns, adsYN, requestNum, userID)
  end

  def sendFTS_same(corpNum, plusFriendID, snd, content, altContent, altSendType, sndDT, msgs, btns, adsYN = false, requestNum = '', userID = '')
    if corpNum.length != 10
      raise PopbillException.new(-99999999, "사업자등록번호가 올바르지 않습니다.")
    end

    req = {}

    if plusFriendID.to_s != ''
      req["plusFriendID"] = plusFriendID
    end
    if snd.to_s != ''
      req["snd"] = snd
    end
    if content.to_s != ''
      req["content"] = content
    end
    if altContent.to_s != ''
      req["altContent"] = altContent
    end
    if altSendType.to_s != ''
      req["altSendType"] = altSendType
    end
    if sndDT.to_s != ''
      req["sndDT"] = sndDT
    end
    if msgs.to_s != ''
      req["msgs"] = msgs
    end
    if btns.to_s != ''
      req["btns"] = btns
    end
    if adsYN.to_s != ''
      req["adsYN"] = adsYN
    end
    if requestNum.to_s != ''
      req["requestNum"] = requestNum
    end

    postData = req.to_json
    httppost("/FTS", corpNum, postData, "", userID)
  end

  def sendFMS_one(corpNum, plusFriendID, snd, content, altContent, altSendType, sndDT, filePath, imageURL, receiver, receiverName, btns, adsYN = false, requestNum = '', userID = '')
    msg = [
        {
            "rcv" => receiver,
            "rcvnm" => receiverName,
            "msg" => content,
            "altmsg" => altContent,
        }
    ]
    sendFMS_same(corpNum, plusFriendID, snd, content, altContent, altSendType, sndDT, filePath, imageURL, msg, btns, adsYN, requestNum, userID)
  end

  def sendFMS_multi(corpNum, plusFriendID, snd, altSendType, sndDT, filePath, imageURL, msgs, btns, adsYN = false, requestNum = '', userID = '')
    sendFMS_same(corpNum, plusFriendID, snd, "", "", altSendType, sndDT, filePath, imageURL, msgs, btns, adsYN, requestNum, userID)
  end

  def sendFMS_same(corpNum, plusFriendID, snd, content, altContent, altSendType, sndDT, filePath, imageURL, msgs, btns, adsYN = false, requestNum = '', userID = '')
    if corpNum.length != 10
      raise PopbillException.new(-99999999, "사업자등록번호가 올바르지 않습니다.")
    end

    req = {}

    if plusFriendID.to_s != ''
      req["plusFriendID"] = plusFriendID
    end
    if snd.to_s != ''
      req["snd"] = snd
    end
    if content.to_s != ''
      req["content"] = content
    end
    if altContent.to_s != ''
      req["altContent"] = altContent
    end
    if altSendType.to_s != ''
      req["altSendType"] = altSendType
    end
    if sndDT.to_s != ''
      req["sndDT"] = sndDT
    end
    if msgs.to_s != ''
      req["msgs"] = msgs
    end
    if btns.to_s != ''
      req["btns"] = btns
    end
    if adsYN.to_s != ''
      req["adsYN"] = adsYN
    end
    if requestNum.to_s != ''
      req["requestNum"] = requestNum
    end
    if userID.to_s != ''
      req["userID"] = userID
    end

    httppostfile("/FMS", corpNum, req, [filePath], userID)
  end

  def cancelReserve(corpNum, receiptNum, userID = '')
    if corpNum.length != 10
      raise PopbillException.new(-99999999, "사업자등록번호가 올바르지 않습니다.")
    end
    if receiptNum.to_s == ''
      raise PopbillException.new(-99999999, "접수번호(receiptNum)가 입력되지 않았습니다.")
    end

    httpget("/KakaoTalk/#{receiptNum}/Cancel", corpNum, userID)
  end

  def cancelReserveRN(corpNum, requestNum, userID = '')
    if corpNum.length != 10
      raise PopbillException.new(-99999999, "사업자등록번호가 올바르지 않습니다.")
    end
    if requestNum.to_s == ''
      raise PopbillException.new(-99999999, "요청번호(requestNum)가 입력되지 않았습니다.")
    end

    httpget("/KakaoTalk/Cancel/#{requestNum}", corpNum, userID)
  end


  def getMessages(corpNum, receiptNum, userID = '')
    if corpNum.length != 10
      raise PopbillException.new(-99999999, "사업자등록번호가 올바르지 않습니다.")
    end
    if receiptNum.to_s == ''
      raise PopbillException.new(-99999999, "접수번호(receiptNum)가 입력되지 않았습니다.")
    end

    httpget("/KakaoTalk/#{receiptNum}", corpNum, userID)
  end

  def getMessagesRN(corpNum, requestNum, userID = '')
    if corpNum.length != 10
      raise PopbillException.new(-99999999, "사업자등록번호가 올바르지 않습니다.")
    end
    if requestNum.to_s == ''
      raise PopbillException.new(-99999999, "요청번호(requestNum)가 입력되지 않았습니다.")
    end

    httpget("/KakaoTalk/Get/#{requestNum}", corpNum, userID)
  end

  def search(corpNum, sDate, eDate, state, item, reserveYN, senderYN, page, perPage, order, userID = '')
    if corpNum.length != 10
      raise PopbillException.new('-99999999', '사업자등록번호가 올바르지 않습니다.')
    end
    if sDate.to_s == ''
      raise PopbillException.new('-99999999', '시작일자가 입력되지 않았습니다.')
    end
    if eDate.to_s == ''
      raise PopbillException.new('-99999999', '종료일자가 입력되지 않았습니다.')
    end

    uri = "/KakaoTalk/Search?SDate=#{sDate}&EDate=#{eDate}"
    uri += "&State=" + state.join(',')
    uri += "&Item=" + item.join(',')
    uri += "&ReserveYN=" + reserveYN
    uri += "&SenderYN=" + senderYN
    uri += "&Page=" + page.to_s
    uri += "&PerPage=" + perPage.to_s
    uri += "&Order=" + order

    httpget(URI.escape(uri), corpNum, userID)
  end

  def getUnitCost(corpNum, msgType, userID = '')
    if corpNum.length != 10
      raise PopbillException.new(-99999999, "사업자등록번호가 올바르지 않습니다.")
    end
    httpget("/KakaoTalk/UnitCost?Type=#{msgType}", corpNum, userID)
  end

  def getChargeInfo(corpNum, msgType, userID = '')
    if corpNum.length != 10
      raise PopbillException.new(-99999999, "사업자등록번호가 올바르지 않습니다.")
    end
    httpget("/KakaoTalk/ChargeInfo?Type=#{msgType}", corpNum, userID)
  end

end


module KakaoMsgType
  ATS = "ATS"
  FTS = "FTS"
  FMS = "FMS"
end

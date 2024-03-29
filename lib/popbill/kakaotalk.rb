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
    raise PopbillException.new(-99999999, "사업자등록번호가 올바르지 않습니다.") if corpNum.length != 10

    (togo == "SENDER") ?
        httpget("/Message/?TG=#{togo}", corpNum, userID)['url'] :
        httpget("/KakaoTalk/?TG=#{togo}", corpNum, userID)['url']
  end

  # 플러스친구 계정관리 팝업 URL
  def getPlusFriendMgtURL(corpNum, userID)
    if corpNum.length != 10
      raise PopbillException.new(-99999999, "사업자등록번호가 올바르지 않습니다.")
    end

    response = httpget("/KakaoTalk/?TG=PLUSFRIEND", corpNum, userID)
    response['url']
  end

  # 발신번호 관리 팝업 URL
  def getSenderNumberMgtURL(corpNum, userID)
    if corpNum.length != 10
      raise PopbillException.new(-99999999, "사업자등록번호가 올바르지 않습니다.")
    end

    response = httpget("/Message/?TG=SENDER", corpNum, userID)
    response['url']
  end

  # 알림톡 템플릿관리 팝업 URL
  def getATSTemplateMgtURL(corpNum, userID)
    if corpNum.length != 10
      raise PopbillException.new(-99999999, "사업자등록번호가 올바르지 않습니다.")
    end

    response = httpget("/KakaoTalk/?TG=TEMPLATE", corpNum, userID)
    response['url']
  end

  # 카카오톡 전송내역 팝업 URL
  def getSentListURL(corpNum, userID)
    if corpNum.length != 10
      raise PopbillException.new(-99999999, "사업자등록번호가 올바르지 않습니다.")
    end

    response = httpget("/KakaoTalk/?TG=BOX", corpNum, userID)
    response['url']
  end

  def listPlusFriendID(corpNum, userID = '')
    raise PopbillException.new(-99999999, "사업자등록번호가 올바르지 않습니다.") if corpNum.length != 10

    httpget("/KakaoTalk/ListPlusFriendID", corpNum, userID)
  end

  def getSenderNumberList(corpNum, userID = '')
    raise PopbillException.new(-99999999, "사업자등록번호가 올바르지 않습니다.") if corpNum.length != 10

    httpget("/Message/SenderNumber", corpNum, userID)
  end

  def getATSTemplate(corpNum, templateCode, userID = '')
    raise PopbillException.new(-99999999, "사업자등록번호가 올바르지 않습니다.") if corpNum.length != 10
    raise PopbillException.new(-99999999, "템플릿 코드가 입력되지 않았습니다.")if templateCode.to_s == ''
    
    httpget("/KakaoTalk/GetATSTemplate/#{templateCode}", corpNum, userID)
  end

  def listATSTemplate(corpNum, userID = '')
    raise PopbillException.new(-99999999, "사업자등록번호가 올바르지 않습니다.") if corpNum.length != 10

    httpget("/KakaoTalk/ListATSTemplate", corpNum, userID)
  end

  def sendATS_one(corpNum, templateCode, snd, content, altContent, altSendType, sndDT, receiver, receiverName, requestNum = '', userID = '', btns = '')
    msg = [
        {
            "rcv" => receiver,
            "rcvnm" => receiverName,
            "msg" => content,
            "altmsg" => altContent,
        }
    ]
    sendATS_same(corpNum, templateCode, snd, "", "", altSendType, sndDT, msg, requestNum, userID, btns)
  end

  def sendATS_multi(corpNum, templateCode, snd, altSendType, sndDT, msgs, requestNum = '', userID = '', btns = '')
    sendATS_same(corpNum, templateCode, snd, "", "", altSendType, sndDT, msgs, requestNum, userID, btns)
  end

  def sendATS_same(corpNum, templateCode, snd, content, altContent, altSendType, sndDT, msgs, requestNum = '', userID = '', btns = '')
    raise PopbillException.new(-99999999, "사업자등록번호가 올바르지 않습니다.") if corpNum.length != 10
    raise PopbillException.new(-99999999, "알림톡 템플릿코드가 입력되지 않았습니다.") if templateCode.to_s == ''
    raise PopbillException.new(-99999999, "발신번호가 입력되지 않았습니다.") if snd.to_s == ''

    req = {}
    req["templateCode"] = templateCode if templateCode.to_s != ''
    req["snd"] = snd if snd.to_s != ''
    req["content"] = content if content.to_s != ''
    req["altContent"] = altContent if altContent.to_s != ''
    req["altSendType"] = altSendType if altSendType.to_s != ''
    req["sndDT"] = sndDT if sndDT.to_s != ''
    req["requestNum"] = requestNum if requestNum.to_s != ''
    req["msgs"] = msgs if msgs.to_s != ''
    req["btns"] = btns if btns.to_s != ''

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
    sendFTS_same(corpNum, plusFriendID, snd, "", "", altSendType, sndDT, msg, btns, adsYN, requestNum, userID)
  end

  def sendFTS_multi(corpNum, plusFriendID, snd, altSendType, sndDT, msgs, btns, adsYN = false, requestNum = '', userID = '')
    sendFTS_same(corpNum, plusFriendID, snd, "", "", altSendType, sndDT, msgs, btns, adsYN, requestNum, userID)
  end

  def sendFTS_same(corpNum, plusFriendID, snd, content, altContent, altSendType, sndDT, msgs, btns, adsYN = false, requestNum = '', userID = '')
    raise PopbillException.new(-99999999, "사업자등록번호가 올바르지 않습니다.") if corpNum.length != 10
    raise PopbillException.new(-99999999, "플러스친구 아이디가 입력되지 않았습니다.") if plusFriendID.to_s == ''
    raise PopbillException.new(-99999999, "발신번호가 입력되지 않았습니다.") if snd.to_s == ''

    req = {}
    req["plusFriendID"] = plusFriendID if plusFriendID.to_s != ''
    req["snd"] = snd if snd.to_s != ''
    req["content"] = content if content.to_s != ''
    req["altContent"] = altContent if altContent.to_s != ''
    req["altSendType"] = altSendType if altSendType.to_s != ''
    req["sndDT"] = sndDT if sndDT.to_s != ''
    req["msgs"] = msgs if msgs.to_s != ''
    req["btns"] = btns if btns.to_s != ''
    req["adsYN"] = adsYN if adsYN.to_s != ''
    req["requestNum"] = requestNum if requestNum.to_s != ''

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
    sendFMS_same(corpNum, plusFriendID, snd, "", "", altSendType, sndDT, filePath, imageURL, msg, btns, adsYN, requestNum, userID)
  end

  def sendFMS_multi(corpNum, plusFriendID, snd, altSendType, sndDT, filePath, imageURL, msgs, btns, adsYN = false, requestNum = '', userID = '')
    sendFMS_same(corpNum, plusFriendID, snd, "", "", altSendType, sndDT, filePath, imageURL, msgs, btns, adsYN, requestNum, userID)
  end

  def sendFMS_same(corpNum, plusFriendID, snd, content, altContent, altSendType, sndDT, filePath, imageURL, msgs, btns, adsYN = false, requestNum = '', userID = '')
    raise PopbillException.new(-99999999, "사업자등록번호가 올바르지 않습니다.") if corpNum.length != 10
    raise PopbillException.new(-99999999, "플러스친구 아이디가 입력되지 않았습니다.") if plusFriendID.to_s == ''
    raise PopbillException.new(-99999999, "발신번호가 입력되지 않았습니다.") if snd.to_s == ''

    req = {}
    req["plusFriendID"] = plusFriendID if plusFriendID.to_s != ''
    req["snd"] = snd if snd.to_s != ''
    req["content"] = content if content.to_s != ''
    req["altContent"] = altContent if altContent.to_s != ''
    req["altSendType"] = altSendType if altSendType.to_s != ''
    req["sndDT"] = sndDT if sndDT.to_s != ''
    req["imageURL"] = imageURL if imageURL.to_s != ''
    req["msgs"] = msgs if msgs.to_s != ''
    req["btns"] = btns if btns.to_s != ''
    req["adsYN"] = adsYN if adsYN.to_s != ''
    req["requestNum"] = requestNum if requestNum.to_s != ''

    httppostfile("/FMS", corpNum, req, [filePath], userID)
  end

  def cancelReserve(corpNum, receiptNum, userID = '')
    raise PopbillException.new(-99999999, "사업자등록번호가 올바르지 않습니다.") if corpNum.length != 10
    raise PopbillException.new(-99999999, "접수번호(receiptNum)가 입력되지 않았습니다.") if receiptNum.to_s == ''

    httpget("/KakaoTalk/#{receiptNum}/Cancel", corpNum, userID)
  end

  def cancelReserveRN(corpNum, requestNum, userID = '')
    raise PopbillException.new(-99999999, "사업자등록번호가 올바르지 않습니다.") if corpNum.length != 10
    raise PopbillException.new(-99999999, "요청번호(requestNum)가 입력되지 않았습니다.") if requestNum.to_s == ''

    httpget("/KakaoTalk/Cancel/#{requestNum}", corpNum, userID)
  end


  def getMessages(corpNum, receiptNum, userID = '')
    raise PopbillException.new(-99999999, "사업자등록번호가 올바르지 않습니다.") if corpNum.length != 10
    raise PopbillException.new(-99999999, "접수번호(receiptNum)가 입력되지 않았습니다.") if receiptNum.to_s == ''

    httpget("/KakaoTalk/#{receiptNum}", corpNum, userID)
  end

  def getMessagesRN(corpNum, requestNum, userID = '')
    raise PopbillException.new(-99999999, "사업자등록번호가 올바르지 않습니다.") if corpNum.length != 10
    raise PopbillException.new(-99999999, "요청번호(requestNum)가 입력되지 않았습니다.") if requestNum.to_s == ''

    httpget("/KakaoTalk/Get/#{requestNum}", corpNum, userID)
  end

  def search(corpNum, sDate, eDate, state, item, reserveYN, senderYN, page, perPage, order, userID = '', queryString ='')
    raise PopbillException.new(-99999999, "사업자등록번호가 올바르지 않습니다.") if corpNum.length != 10
    raise PopbillException.new(-99999999, "시작일자가 입력되지 않았습니다.") if sDate.to_s == ''
    raise PopbillException.new(-99999999, "종료일자가 입력되지 않았습니다.") if eDate.to_s == ''

    uri = "/KakaoTalk/Search?SDate=#{sDate}&EDate=#{eDate}"
    uri += "&State=" + state.join(',') if state.to_s != ''
    uri += "&Item=" + item.join(',') if item.to_s != ''
    uri += "&ReserveYN=" + reserveYN
    uri += "&SenderYN=" + senderYN
    uri += "&Page=" + page.to_s
    uri += "&PerPage=" + perPage.to_s
    uri += "&Order=" + order

    if queryString.to_s != ''
      uri += "&QString=" + queryString
    end

    httpget(URI.escape(uri), corpNum, userID)
  end


  def getUnitCost(corpNum, msgType, userID = '')
    raise PopbillException.new(-99999999, "사업자등록번호가 올바르지 않습니다.") if corpNum.length != 10

    httpget("/KakaoTalk/UnitCost?Type=#{msgType}", corpNum, userID)
  end

  def getChargeInfo(corpNum, msgType, userID = '')
    raise PopbillException.new(-99999999, "사업자등록번호가 올바르지 않습니다.") if corpNum.length != 10

    httpget("/KakaoTalk/ChargeInfo?Type=#{msgType}", corpNum, userID)
  end

end


module KakaoMsgType
  ATS = "ATS"
  FTS = "FTS"
  FMS = "FMS"
end

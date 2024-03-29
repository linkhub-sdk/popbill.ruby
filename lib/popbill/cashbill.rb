# -*- coding: utf-8 -*-
require_relative '../popbill.rb'

# 팝빌 현금영수증 API Service Implementation
class CashbillService < BaseService
  class << self
    def instance(linkID, secretKey)
      super(linkID, secretKey)
      @instance ||= new
      @instance.addScope("140")
      return @instance
    end
    private :new
  end

  def getChargeInfo(corpNum, userID = '')
    if corpNum.length != 10
      raise PopbillException.new(-99999999, "사업자등록번호가 올바르지 않습니다.")
    end
    httpget('/Cashbill/ChargeInfo', corpNum, userID)
  end

  def getURL(corpNum, togo, userID = '')
    if corpNum.length != 10
      raise PopbillException.new(-99999999, "사업자등록번호가 올바르지 않습니다.")
    end
    httpget("/Cashbill?TG=#{togo}", corpNum, userID)['url']
  end

  def getUnitCost(corpNum, userID = '')
    if corpNum.length != 10
      raise PopbillException.new(-99999999, "사업자등록번호가 올바르지 않습니다.")
    end
    httpget("/Cashbill?cfg=UNITCOST", corpNum, userID)['unitCost']
  end

  def checkMgtKeyInUse(corpNum, mgtKey, userID = '')
    if corpNum.length != 10
      raise PopbillException.new(-99999999, "사업자등록번호가 올바르지 않습니다.")
    end
    if mgtKey.to_s == ''
      raise PopbillException.new(-99999999, "현금영수증 문서번호가 입력되지 않았습니다.")
    end

    begin
      response = httpget("/Cashbill/#{mgtKey}", corpNum)
      return response['itemKey'].length != 0
    rescue PopbillException => pe
      if pe.code == -14000003
        return false
      end
      raise PopbillException.new(pe.code, pe.message)
    end
  end


  def registIssue(corpNum, cashbill, memo = '', userID = '', emailSubject = '')
    if corpNum.length != 10
      raise PopbillException.new(-99999999, "사업자등록번호가 올바르지 않습니다.")
    end

    if memo.to_s != ''
      cashbill["memo"] = memo
    end

    if emailSubject.to_s != ''
      cashbill["emailSubject"] = emailSubject
    end

    postData = cashbill.to_json

    httppost("/Cashbill", corpNum, postData, "ISSUE", userID)
  end


  def register(corpNum, cashbill, userID = '')
    if corpNum.length != 10
      raise PopbillException.new(-99999999, "사업자등록번호가 올바르지 않습니다.")
    end

    postData = cashbill.to_json

    httppost("/Cashbill", corpNum, postData, "", userID)
  end

  # 취소현금영수증 즉시발행 추가. 2017/08/18
  def revokeRegistIssue(corpNum, mgtKey, orgConfirmNum, orgTradeDate, smssendYN = false, memo = "", userID = "",
    isPartCancel = false, cancelType = nil, supplyCost = nil, tax = nil, serviceFee = nil, totalAmount = nil)

    postData = {}
    postData["mgtKey"] = mgtKey
    postData["orgConfirmNum"] = orgConfirmNum
    postData["orgTradeDate"] = orgTradeDate
    postData["smssendYN"] = smssendYN
    postData["memo"] = memo
    postData["isPartCancel"] = isPartCancel
    postData["cancelType"] = cancelType
    postData["supplyCost"] = supplyCost
    postData["tax"] = tax
    postData["serviceFee"] = serviceFee
    postData["totalAmount"] = totalAmount

    postData = postData.to_json

    httppost("/Cashbill", corpNum, postData, "REVOKEISSUE", userID)
  end

  # 취소현금영수증 임시저장 추가. 2017/08/18
  def revokeRegister(corpNum, mgtKey, orgConfirmNum, orgTradeDate, smssendYN = false, userID = '',
    isPartCancel = false, cancelType = nil, supplyCost = nil, tax = nil, serviceFee = nil, totalAmount = nil)

    postData = {}
    postData["mgtKey"] = mgtKey
    postData["orgConfirmNum"] = orgConfirmNum
    postData["orgTradeDate"] = orgTradeDate
    postData["smssendYN"] = smssendYN
    postData["isPartCancel"] = isPartCancel
    postData["cancelType"] = cancelType
    postData["supplyCost"] = supplyCost
    postData["tax"] = tax
    postData["serviceFee"] = serviceFee
    postData["totalAmount"] = totalAmount

    postData = postData.to_json

    httppost("/Cashbill", corpNum, postData, "REVOKE", userID)
  end

  def update(corpNum, mgtKey, cashbill, userID = '')
    if corpNum.length != 10
      raise PopbillException.new(-99999999, "사업자등록번호가 올바르지 않습니다.")
    end

    postData = cashbill.to_json

    httppost("/Cashbill/#{mgtKey}", corpNum, postData, "PATCH", userID)
  end

  def issue(corpNum, mgtKey, memo = '', userID = '')
    if corpNum.length != 10
      raise PopbillException.new(-99999999, "사업자등록번호가 올바르지 않습니다.")
    end

    postData = {}

    if memo.to_s != ''
      postData["memo"] = memo
    end

    postData = postData.to_json

    httppost("/Cashbill/#{mgtKey}", corpNum, postData, "ISSUE", userID)
  end

  def cancelIssue(corpNum, mgtKey, memo = '', userID = '')
    if corpNum.length != 10
      raise PopbillException.new(-99999999, "사업자등록번호가 올바르지 않습니다.")
    end

    postData = {}

    if memo.to_s != ''
      postData["memo"] = memo
    end

    postData = postData.to_json

    httppost("/Cashbill/#{mgtKey}", corpNum, postData, "CANCELISSUE", userID)
  end

  def delete(corpNum, mgtKey, userID = '')
    if corpNum.length != 10
      raise PopbillException.new(-99999999, "사업자등록번호가 올바르지 않습니다.")
    end

    httppost("/Cashbill/#{mgtKey}", corpNum, "", "DELETE", userID)
  end

  def search(corpNum, dType, sDate, eDate, state, tradeType, tradeUsage,
    taxationType, page, perPage, order, queryString = '', userID = '', tradeOpt = '', franchiseTaxRegID = '')
    if corpNum.length != 10
      raise PopbillException.new('-99999999', '사업자등록번호가 올바르지 않습니다.')
    end
    if dType.to_s == ''
      raise PopbillException.new('-99999999', '검색일자유형이 입력되지 않았습니다.')
    end

    if sDate.to_s == ''
      raise PopbillException.new('-99999999', '시작일자가 입력되지 않았습니다.')
    end

    if eDate.to_s == ''
      raise PopbillException.new('-99999999', '종료일자가 입력되지 않았습니다.')
    end

    uri = "/Cashbill/Search?DType=#{dType}&SDate=#{sDate}&EDate=#{eDate}"
    uri += "&State=" + state.join(',')
    uri += "&TradeUsage=" + tradeUsage.join(',')
    uri += "&TradeType=" + tradeType.join(',')
    uri += "&TaxationType=" + taxationType.join(',')
    uri += "&Page=" + page.to_s
    uri += "&PerPage=" + perPage.to_s
    uri += "&Order=" + order

    if queryString.to_s != ''
      uri += "&QString=" + queryString
    end

    if tradeOpt.to_s != ''
      uri += "&TradeOpt=" + tradeOpt.join(',')
    end

    uri+="&FranchiseTaxRegID=" + franchiseTaxRegID

    httpget(URI.escape(uri), corpNum, userID)
  end

  def getInfo(corpNum, mgtKey, userID = '')
    if corpNum.length != 10
      raise PopbillException.new('-99999999', '사업자등록번호가 올바르지 않습니다.')
    end
    if mgtKey.to_s == ''
      raise PopbillException.new('-99999999', '관리번호가 입력되지 않았습니다.')
    end

    httpget("/Cashbill/#{mgtKey}", corpNum, userID)
  end


  def getInfos(corpNum, mgtKeyList, userID = '')
    if corpNum.length != 10
      raise PopbillException.new('-99999999', '사업자등록번호가 올바르지 않습니다.')
    end
    unless mgtKeyList.any?
      raise PopbillException.new('-99999999', '문서번호 배열이 올바르지 않습니다.')
    end

    postData = mgtKeyList.to_json

    httppost("/Cashbill/States", corpNum, postData, "", userID)
  end


  def getDetailInfo(corpNum, mgtKey, userID = '')
    if corpNum.length != 10
      raise PopbillException.new('-99999999', '사업자등록번호가 올바르지 않습니다.')
    end
    if mgtKey.to_s == ''
      raise PopbillException.new('-99999999', '관리번호가 입력되지 않았습니다.')
    end

    httpget("/Cashbill/#{mgtKey}?Detail", corpNum, userID)
  end

  def sendEmail(corpNum, mgtKey, receiverMail, userID = '')
    if corpNum.length != 10
      raise PopbillException.new('-99999999', '사업자등록번호가 올바르지 않습니다.')
    end
    if mgtKey.to_s == ''
      raise PopbillException.new('-99999999', '문서번호가 올바르지 않습니다.')
    end

    postData = {}

    if receiverMail.to_s != ''
      postData["receiver"] = receiverMail
    end

    postData = postData.to_json

    httppost("/Cashbill/#{mgtKey}", corpNum, postData, "EMAIL", userID)
  end


  def sendSMS(corpNum, mgtKey, senderNum, receiverNum, contents, userID = '')
    if corpNum.length != 10
      raise PopbillException.new('-99999999', '사업자등록번호가 올바르지 않습니다.')
    end
    if mgtKey.to_s == ''
      raise PopbillException.new('-99999999', '문서번호가 올바르지 않습니다.')
    end

    if senderNum.to_s == ''
      raise PopbillException.new('-99999999', '발신번호가 입력되지 않았습니다.')
    end

    if receiverNum.to_s == ''
      raise PopbillException.new('-99999999', '수신번호가 입력되지 않았습니다.')
    end

    if contents.to_s == ''
      raise PopbillException.new('-99999999', '문자 메시지 내용이 입력되지 않았습니다.')
    end

    postData = {}
    postData["sender"] = senderNum
    postData["receiver"] = receiverNum
    postData["contents"] = contents

    postData = postData.to_json

    httppost("/Cashbill/#{mgtKey}", corpNum, postData, "SMS", userID)
  end


  def sendFax(corpNum, mgtKey, senderNum, receiverNum, userID = '')
    if corpNum.length != 10
      raise PopbillException.new('-99999999', '사업자등록번호가 올바르지 않습니다.')
    end
    if mgtKey.to_s == ''
      raise PopbillException.new('-99999999', '문서번호가 올바르지 않습니다.')
    end

    if senderNum.to_s == ''
      raise PopbillException.new('-99999999', '발신번호가 입력되지 않았습니다.')
    end

    if receiverNum.to_s == ''
      raise PopbillException.new('-99999999', '수신번호가 입력되지 않았습니다.')
    end

    postData = {}
    postData["sender"] = senderNum
    postData["receiver"] = receiverNum

    postData = postData.to_json

    httppost("/Cashbill/#{mgtKey}", corpNum, postData, "FAX", userID)

  end


  def getLogs(corpNum, mgtKey, userID = '')
    if corpNum.length != 10
      raise PopbillException.new('-99999999', '사업자등록번호가 올바르지 않습니다.')
    end
    if mgtKey.to_s == ''
      raise PopbillException.new('-99999999', '문서번호가 올바르지 않습니다.')
    end
    httpget("/Cashbill/#{mgtKey}/Logs", corpNum, userID)
  end


  def getPopUpURL(corpNum, mgtKey, userID = '')
    if corpNum.length != 10
      raise PopbillException.new('-99999999', '사업자등록번호가 올바르지 않습니다.')
    end
    if mgtKey.to_s == ''
      raise PopbillException.new('-99999999', '문서번호가 올바르지 않습니다.')
    end

    httpget("/Cashbill/#{mgtKey}?TG=POPUP", corpNum, userID)['url']
  end

  def getViewURL(corpNum, mgtKey, userID = '')
    if corpNum.length != 10
      raise PopbillException.new('-99999999', '사업자등록번호가 올바르지 않습니다.')
    end
    if mgtKey.to_s == ''
      raise PopbillException.new('-99999999', '문서번호가 올바르지 않습니다.')
    end

    httpget("/Cashbill/#{mgtKey}?TG=VIEW", corpNum, userID)['url']
  end

  def getPDFURL(corpNum, mgtKey, userID = '')
    if corpNum.length != 10
      raise PopbillException.new('-99999999', '사업자등록번호가 올바르지 않습니다.')
    end
    if mgtKey.to_s == ''
      raise PopbillException.new('-99999999', '문서번호가 올바르지 않습니다.')
    end

    httpget("/Cashbill/#{mgtKey}?TG=PDF", corpNum, userID)['url']
  end

  def getPrintURL(corpNum, mgtKey, userID = '')
    if corpNum.length != 10
      raise PopbillException.new('-99999999', '사업자등록번호가 올바르지 않습니다.')
    end
    if mgtKey.to_s == ''
      raise PopbillException.new('-99999999', '문서번호가 올바르지 않습니다.')
    end

    httpget("/Cashbill/#{mgtKey}?TG=PRINT", corpNum, userID)['url']
  end

  def getMailURL(corpNum, mgtKey, userID = '')
    if corpNum.length != 10
      raise PopbillException.new('-99999999', '사업자등록번호가 올바르지 않습니다.')
    end
    if mgtKey.to_s == ''
      raise PopbillException.new('-99999999', '문서번호가 올바르지 않습니다.')
    end

    httpget("/Cashbill/#{mgtKey}?TG=MAIL", corpNum, userID)['url']
  end


  def getEPrintURL(corpNum, mgtKey, userID = '')
    if corpNum.length != 10
      raise PopbillException.new('-99999999', '사업자등록번호가 올바르지 않습니다.')
    end
    if mgtKey.to_s == ''
      raise PopbillException.new('-99999999', '문서번호가 올바르지 않습니다.')
    end

    httpget("/Cashbill/#{mgtKey}?TG=EPRINT", corpNum, userID)['url']
  end


  def getMassPrintURL(corpNum, mgtKeyList, userID = '')
    if corpNum.length != 10
      raise PopbillException.new('-99999999', '사업자등록번호가 올바르지 않습니다.')
    end
    unless mgtKeyList.any?
      raise PopbillException.new('-99999999', '문서번호 배열이 올바르지 않습니다.')
    end

    postData = mgtKeyList.to_json

    httppost("/Cashbill/Prints", corpNum, postData, "", userID)['url']
  end


  def listEmailConfig(corpNum, userID ='')
    if corpNum.length != 10
      raise PopbillException.new('-99999999', '사업자등록번호가 올바르지 않습니다.')
    end

    httpget("/Cashbill/EmailSendConfig", corpNum, userID)
  end

  def updateEmailConfig(corpNum, emailType, sendYN, userID = '')
    if corpNum.length != 10
      raise PopbillException.new('-99999999', '사업자등록번호가 올바르지 않습니다.')
    end

    if emailType.to_s == ''
      raise PopbillException.new('-99999999', '메일전송 타입이 입력되지 않았습니다.')
    end

    if sendYN.to_s == ''
      raise PopbillException.new('-99999999', '메일전송 여부 항목이 입력되지 않았습니다.')
    end

    httppost("/Cashbill/EmailSendConfig?EmailType=#{emailType}&SendYN=#{sendYN}", corpNum, userID)
  end

  def assignMgtKey(corpNum, itemKey, mgtKey, userID = '')
    if corpNum.length != 10
      raise PopbillException.new('-99999999', '사업자등록번호가 올바르지 않습니다.')
    end
    if itemKey.to_s == ''
      raise PopbillException.new('-99999999', '아이템키가 입력되지 않았습니다.')
    end

    String postDate = "MgtKey=" + mgtKey

    httppost("/Cashbill/#{itemKey}", corpNum, postDate, "", userID, "application/x-www-form-urlencoded; charset=utf-8")
  end

end # end of CashbillService

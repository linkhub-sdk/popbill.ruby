# -*- coding: utf-8 -*-
require_relative '../popbill.rb'

# 팝빌 전자명세서 API Service Implementation
class StatementService < BaseService
  class << self
    def instance(linkID, secretKey)
      super(linkID, secretKey)
      @instance ||= new
      @instance.addScope("121")
      @instance.addScope("122")
      @instance.addScope("123")
      @instance.addScope("124")
      @instance.addScope("125")
      @instance.addScope("126")
      return @instance
    end
    private :new
  end

  def getChargeInfo(corpNum, itemCode, userID = '')
    if corpNum.length != 10
      raise PopbillException.new(-99999999, "사업자등록번호가 올바르지 않습니다.")
    end
    httpget("/Statement/ChargeInfo/#{itemCode}", corpNum, userID)
  end

  def getURL(corpNum, togo, userID = '')
    if corpNum.length != 10
      raise PopbillException.new(-99999999, "사업자등록번호가 올바르지 않습니다.")
    end
    httpget("/Statement?TG=#{togo}", corpNum, userID)['url']
  end

  def getUnitCost(corpNum, itemCode, userID = '')
    if corpNum.length != 10
      raise PopbillException.new(-99999999, "사업자등록번호가 올바르지 않습니다.")
    end
    httpget("/Statement/#{itemCode}?cfg=UNITCOST", corpNum, userID)['unitCost']
  end

  def checkMgtKeyInUse(corpNum, itemCode, mgtKey, userID = '')
    if corpNum.length != 10
      raise PopbillException.new(-99999999, "사업자등록번호가 올바르지 않습니다.")
    end
    if mgtKey.to_s == ''
      raise PopbillException.new(-99999999, "현금영수증 문서관리번호가 입력되지 않았습니다.")
    end

    begin
      response = httpget("/Statement/#{itemCode}/#{mgtKey}", corpNum)
      return response['itemKey'].length != 0
    rescue PopbillException => pe
      if pe.code == -12000004
        return false
      end
      raise PopbillException.new(pe.code, pe.message)
    end
  end

  def faxSend(corpNum, statement, sendNum, receiveNum, userID = '')
    if corpNum.length != 10
      raise PopbillException.new(-99999999, "사업자등록번호가 올바르지 않습니다.")
    end
    if sendNum.to_s == ''
      raise PopbillException.new(-99999999, "팩스 발신번호가 입력되지 않았습니다.")
    end
    if receiveNum.to_s == ''
      raise PopbillException.new(-99999999, "팩스 수신번호가 입력되지 않았습니다.")
    end

    statement["sendNum"] = sendNum
    statement["receiveNum"] = receiveNum

    postData = statement.to_json

    httppost("/Statement", corpNum, postData, "FAX", userID)['receiptNum']
  end


  def registIssue(corpNum, statement, memo = '', userID ='')
    if corpNum.length != 10
      raise PopbillException.new(-99999999, "사업자등록번호가 올바르지 않습니다.")
    end

    statement["memo"] = memo
    postData = statement.to_json
    httppost("/Statement", corpNum, postData, "ISSUE", userID)
  end


  def register(corpNum, statement, userID = '')
    if corpNum.length != 10
      raise PopbillException.new(-99999999, "사업자등록번호가 올바르지 않습니다.")
    end

    postData = statement.to_json
    httppost("/Statement", corpNum, postData, "", userID)
  end


  def update(corpNum, itemCode, mgtKey, statement, userID = '')
    if corpNum.length != 10
      raise PopbillException.new(-99999999, "사업자등록번호가 올바르지 않습니다.")
    end

    postData = statement.to_json

    httppost("/Statement/#{itemCode}/#{mgtKey}", corpNum, postData, "PATCH", userID)
  end


  def issue(corpNum, itemCode, mgtKey, memo ='', emailSubject = '', userID ='')
    if corpNum.length != 10
      raise PopbillException.new(-99999999, "사업자등록번호가 올바르지 않습니다.")
    end
    postData = {}
    postData["memo"] = memo
    postData["emailSubject"] = emailSubject
    postData = postData.to_json

    httppost("/Statement/#{itemCode}/#{mgtKey}", corpNum, postData, "ISSUE", userID)
  end

  def cancel(corpNum, itemCode, mgtKey, memo = '', userID = '')
    if corpNum.length != 10
      raise PopbillException.new(-99999999, "사업자등록번호가 올바르지 않습니다.")
    end
    postData = {}
    postData["memo"] = memo
    postData = postData.to_json

    httppost("/Statement/#{itemCode}/#{mgtKey}", corpNum, postData, "CANCEL", userID)
  end


  def delete(corpNum, itemCode, mgtKey, userID = '')
    if corpNum.length != 10
      raise PopbillException.new(-99999999, "사업자등록번호가 올바르지 않습니다.")
    end

    httppost("/Statement/#{itemCode}/#{mgtKey}", corpNum, "", "DELETE", userID)
  end


  def search(corpNum, dType, sDate, eDate, state, itemCode, page, perPage, order,
    qstring= '', userID ='')
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

    uri = "/Statement/Search?DType=#{dType}&SDate=#{sDate}&EDate=#{eDate}"
    uri += "&State=" + state.join(',')
    uri += "&ItemCode=" + itemCode.join(',')
    uri += "&Page=" + page.to_s
    uri += "&PerPage=" + perPage.to_s
    uri += "&Order=" + order
    uri += "&QString=" + qstring

    httpget(URI.escape(uri), corpNum, userID)

  end


  def getInfo(corpNum, itemCode, mgtKey, userID = '')
    if corpNum.length != 10
      raise PopbillException.new('-99999999', '사업자등록번호가 올바르지 않습니다.')
    end
    if mgtKey.to_s == ''
      raise PopbillException.new('-99999999', '문서관리번호 입력되지 않았습니다.')
    end

    httpget("/Statement/#{itemCode}/#{mgtKey}", corpNum, userID)
  end


  def getInfos(corpNum, itemCode, mgtKeyList, userID = '')
    if corpNum.length != 10
      raise PopbillException.new('-99999999', '사업자등록번호가 올바르지 않습니다.')
    end
    unless mgtKeyList.any?
      raise PopbillException.new('-99999999', '문서관리번호 배열이 올바르지 않습니다.')
    end

    postData = mgtKeyList.to_json

    httppost("/Statement/#{itemCode}", corpNum, postData, "", userID)
  end


  def getDetailInfo(corpNum, itemCode, mgtKey, userID = '')
    if corpNum.length != 10
      raise PopbillException.new('-99999999', '사업자등록번호가 올바르지 않습니다.')
    end
    if mgtKey.to_s == ''
      raise PopbillException.new('-99999999', '문서관리번호 올바르지 않습니다.')
    end

    httpget("/Statement/#{itemCode}/#{mgtKey}?Detail", corpNum, userID)
  end

  def sendEmail(corpNum, itemCode, mgtKey, receiverMail, userID = '')
    if corpNum.length != 10
      raise PopbillException.new('-99999999', '사업자등록번호가 올바르지 않습니다.')
    end
    if mgtKey.to_s == ''
      raise PopbillException.new('-99999999', '문서관리번호 올바르지 않습니다.')
    end
    if receiverMail.to_s == ''
      raise PopbillException.new('-99999999', '수신자 메일주소가 올바르지 않습니다.')
    end

    postData = {}
    postData["receiver"] = receiverMail
    postData = postData.to_json

    httppost("/Statement/#{itemCode}/#{mgtKey}", corpNum, postData, "EMAIL", userID)
  end


  def sendSMS(corpNum, itemCode, mgtKey, senderNum, receiverNum, contents, userID = '')
    if corpNum.length != 10
      raise PopbillException.new('-99999999', '사업자등록번호가 올바르지 않습니다.')
    end
    if mgtKey.to_s == ''
      raise PopbillException.new('-99999999', '문서관리번호 올바르지 않습니다.')
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

    httppost("/Statement/#{itemCode}/#{mgtKey}", corpNum, postData, "SMS", userID)
  end


  def sendFax(corpNum, itemCode, mgtKey, senderNum, receiverNum, userID = '')
    if corpNum.length != 10
      raise PopbillException.new('-99999999', '사업자등록번호가 올바르지 않습니다.')
    end
    if mgtKey.to_s == ''
      raise PopbillException.new('-99999999', '문서관리번호 올바르지 않습니다.')
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
    httppost("/Statement/#{itemCode}/#{mgtKey}", corpNum, postData, "FAX", userID)
  end


  def getLogs(corpNum, itemCode, mgtKey, userID = '')
    if corpNum.length != 10
      raise PopbillException.new('-99999999', '사업자등록번호가 올바르지 않습니다.')
    end
    if mgtKey.to_s == ''
      raise PopbillException.new('-99999999', '문서관리번호 올바르지 않습니다.')
    end

    httpget("/Statement/#{itemCode}/#{mgtKey}/Logs", corpNum, userID)
  end

  def attachFile(corpNum, itemCode, mgtKey, filePath, userID ='')
    if corpNum.length != 10
      raise PopbillException.new('-99999999', '사업자등록번호가 올바르지 않습니다.')
    end
    if mgtKey.to_s == ''
      raise PopbillException.new('-99999999', '문서관리번호 올바르지 않습니다.')
    end

    httppostfiles("/Statement/#{itemCode}/#{mgtKey}/Files", corpNum, '', [filePath], userID)
  end

  def getFiles(corpNum, itemCode, mgtKey, userID = '')
    if corpNum.length != 10
      raise PopbillException.new('-99999999', '사업자등록번호가 올바르지 않습니다.')
    end
    if mgtKey.to_s == ''
      raise PopbillException.new('-99999999', '문서관리번호 올바르지 않습니다.')
    end

    httpget("/Statement/#{itemCode}/#{mgtKey}/Files", corpNum)
  end


  def deleteFile(corpNum, itemCode, mgtKey, fileID, userID = '')
    if corpNum.length != 10
      raise PopbillException.new('-99999999', '사업자등록번호가 올바르지 않습니다.')
    end
    if mgtKey.to_s == ''
      raise PopbillException.new('-99999999', '문서관리번호 올바르지 않습니다.')
    end
    if fileID.to_s == ''
      raise PopbillException.new('-99999999', '파일아이디가 입력되지 않았습니다.')
    end

    httppost("/Statement/#{itemCode}/#{mgtKey}/Files/#{fileID}", corpNum, '', "DELETE", userID)
  end

  def getPopUpURL(corpNum, itemCode, mgtKey, userID = '')
    if corpNum.length != 10
      raise PopbillException.new('-99999999', '사업자등록번호가 올바르지 않습니다.')
    end
    if mgtKey.to_s == ''
      raise PopbillException.new('-99999999', '문서관리번호 올바르지 않습니다.')
    end

    httpget("/Statement/#{itemCode}/#{mgtKey}?TG=POPUP", corpNum, userID)['url']
  end


  def getPrintURL(corpNum, itemCode, mgtKey, userID = '')
    if corpNum.length != 10
      raise PopbillException.new('-99999999', '사업자등록번호가 올바르지 않습니다.')
    end
    if mgtKey.to_s == ''
      raise PopbillException.new('-99999999', '문서관리번호 올바르지 않습니다.')
    end

    httpget("/Statement/#{itemCode}/#{mgtKey}?TG=PRINT", corpNum, userID)['url']
  end

  def getEPrintURL(corpNum, itemCode, mgtKey, userID = '')
    if corpNum.length != 10
      raise PopbillException.new('-99999999', '사업자등록번호가 올바르지 않습니다.')
    end
    if mgtKey.to_s == ''
      raise PopbillException.new('-99999999', '문서관리번호 올바르지 않습니다.')
    end

    httpget("/Statement/#{itemCode}/#{mgtKey}?TG=EPRINT", corpNum, userID)['url']
  end

  def getMailURL(corpNum, itemCode, mgtKey, userID = '')
    if corpNum.length != 10
      raise PopbillException.new('-99999999', '사업자등록번호가 올바르지 않습니다.')
    end
    if mgtKey.to_s == ''
      raise PopbillException.new('-99999999', '문서관리번호 올바르지 않습니다.')
    end

    httpget("/Statement/#{itemCode}/#{mgtKey}?TG=MAIL", corpNum, userID)['url']
  end


  def getMassPrintURL(corpNum, itemCode, mgtKeyList, userID = '')
    if corpNum.length != 10
      raise PopbillException.new('-99999999', '사업자등록번호가 올바르지 않습니다.')
    end
    unless mgtKeyList.any?
      raise PopbillException.new('-99999999', '문서관리번호 배열이 올바르지 않습니다.')
    end

    postData = mgtKeyList.to_json
    httppost("/Statement/#{itemCode}?Print", corpNum, postData, "", userID)['url']
  end


  def attachStatement(corpNum, itemCode, mgtKey, subItemCode, subMgtKey, userID = '')
    if corpNum.length != 10
      raise PopbillException.new('-99999999', '사업자등록번호가 올바르지 않습니다.')
    end
    if mgtKey.to_s == ''
      raise PopbillException.new('-99999999', '문서관리번호가 입력되지 않았습니다.')
    end
    if itemCode.to_s == ''
      raise PopbillException.new('-99999999', '전자명세서 종류코드가 입력되지 않았습니다.')
    end
    if subItemCode.to_s == ''
      raise PopbillException.new('-99999999', '전자명세서 종류코드가 입력되지 않았습니다.')
    end
    if subMgtKey.to_s == ''
      raise PopbillException.new('-99999999', '전자명세서 문서관리번호가 입력되지 않았습니다.')
    end

    postData = {}
    postData["ItemCode"] = subItemCode
    postData["MgtKey"] = subMgtKey
    postData = postData.to_json

    httppost("/Statement/#{itemCode}/#{mgtKey}/AttachStmt", corpNum, postData, "", userID)
  end

  def detachStatement(corpNum, itemCode, mgtKey, subItemCode, subMgtKey, userID = '')
    if corpNum.length != 10
      raise PopbillException.new('-99999999', '사업자등록번호가 올바르지 않습니다.')
    end
    if mgtKey.to_s == ''
      raise PopbillException.new('-99999999', '문서관리번호가 입력되지 않았습니다.')
    end
    if itemCode.to_s == ''
      raise PopbillException.new('-99999999', '전자명세서 종류코드가 입력되지 않았습니다.')
    end
    if subItemCode.to_s == ''
      raise PopbillException.new('-99999999', '전자명세서 종류코드가 입력되지 않았습니다.')
    end
    if subMgtKey.to_s == ''
      raise PopbillException.new('-99999999', '전자명세서 문서관리번호가 입력되지 않았습니다.')
    end

    postData = {}
    postData["ItemCode"] = subItemCode
    postData["MgtKey"] = subMgtKey
    postData = postData.to_json

    httppost("/Statement/#{itemCode}/#{mgtKey}/DetachStmt", corpNum, postData, "", userID)
  end

  def listEmailConfig(corpNum, userID ='')
    if corpNum.length != 10
      raise PopbillException.new('-99999999', '사업자등록번호가 올바르지 않습니다.')
    end

    httpget("/Statement/EmailSendConfig", corpNum, userID)
  end

  def updateEmailConfig(corpNum, emailType, sendYN, userID = '')
    if corpNum.length != 10
      raise PopbillException.new('-99999999', '사업자등록번호가 올바르지 않습니다.')
    end

    httppost("/Statement/EmailSendConfig?EmailType=#{emailType}&SendYN=#{sendYN}", corpNum, userID)
  end

end # end of CashbillService

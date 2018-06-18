# -*- coding: utf-8 -*-
require_relative '../popbill.rb'

# 팝빌 세금계산서 API Service Implementation
class TaxinvoiceService < BaseService
  class << self
    def instance(linkID, secretKey)
      super(linkID, secretKey)
      @instance ||= new
      @instance.addScope("110")
      return @instance
    end
    private :new
  end

  def getChargeInfo(corpNum, userID = "")
    if corpNum.length != 10
      raise PopbillException.new('-99999999', '사업자등록번호가 올바르지 않습니다.')
    end
    httpget("/Taxinvoice/ChargeInfo", corpNum, userID)
  end

  def getURL(corpNum, togo, userID = "")
    if corpNum.length != 10
      raise PopbillException.new('-99999999', '사업자등록번호가 올바르지 않습니다.')
    end
    httpget("/Taxinvoice/?TG=" + togo, corpNum, userID)['url']
  end

  def getUnitCost(corpNum)
    if corpNum.length != 10
      raise PopbillException.new('-99999999', '사업자등록번호가 올바르지 않습니다.')
    end
    httpget("/Taxinvoice?cfg=UNITCOST", corpNum)['unitCost']
  end

  def getCertificateExpireDate(corpNum)
    if corpNum.length != 10
      raise PopbillException.new('-99999999', '사업자등록번호가 올바르지 않습니다.')
    end
    httpget("/Taxinvoice?cfg=CERT", corpNum)['certificateExpiration']
  end

  def getEmailPublicKeys(corpNum)
    if corpNum.length != 10
      raise PopbillException.new('-99999999', '사업자등록번호가 올바르지 않습니다.')
    end
    httpget("/Taxinvoice/EmailPublicKeys", corpNum)
  end

  def checkMgtKeyInUse(corpNum, mgtKeyType, mgtKey)
    if corpNum.length != 10
      raise PopbillException.new('-99999999', '사업자등록번호가 올바르지 않습니다.')
    end
    if mgtKey.to_s == ''
      raise PopbillException.new('-99999999', '문서관리번호 올바르지 않습니다.')
    end

    begin
      response = httpget("/Taxinvoice/#{mgtKeyType}/#{mgtKey}", corpNum)
      return response['itemKey'].length != 0
    rescue PopbillException => pe
      if pe.code == -11000005
        return false
      end
      raise PopbillException.new(pe.code, pe.message)
    end
  end

  def register(corpNum, taxinvoice, writeSpecification = false, userID = '')
    if corpNum.length != 10
      raise PopbillException.new('-99999999', '사업자등록번호가 올바르지 않습니다.')
    end
    if writeSpecification
      taxinvoice["writeSpecification"] = true
    end

    postData = taxinvoice.to_json
    httppost("/Taxinvoice", corpNum, postData, "", userID)
  end

  def registIssue(corpNum, taxinvoice, writeSpecification = false, forceIssue = false, dealInvoiceMgtKey = '', memo = '', emailSubject = '', userID = '')
    if corpNum.length != 10
      raise PopbillException.new('-99999999', '사업자등록번호가 올바르지 않습니다.')
    end
    if writeSpecification
      taxinvoice["writeSpecification"] = true
    end

    if forceIssue
      taxinvoice["forceIssue"] = true
    end

    if dealInvoiceMgtKey.to_s != ''
      taxinvoice["dealInvoiceMgtKey"] = dealInvoiceMgtKey
    end

    if memo.to_s != ''
      taxinvoice["memo"] = memo
    end

    if emailSubject.to_s != ''
      taxinvoice["emailSubject"] = emailSubject
    end

    postData = taxinvoice.to_json

    httppost("/Taxinvoice", corpNum, postData, "ISSUE", userID)

  end


  def update(corpNum, mgtKeyType, mgtKey, taxinvoice, userID = '')
    if corpNum.length != 10
      raise PopbillException.new('-99999999', '사업자등록번호가 올바르지 않습니다.')
    end
    if mgtKey.to_s == ''
      raise PopbillException.new('-99999999', '문서관리번호 올바르지 않습니다.')
    end
    postData = taxinvoice.to_json

    httppost("/Taxinvoice/#{mgtKeyType}/#{mgtKey}", corpNum, postData, "PATCH", userID)
  end


  def getInfo(corpNum, mgtKeyType, mgtKey, userID = '')
    if corpNum.length != 10
      raise PopbillException.new('-99999999', '사업자등록번호가 올바르지 않습니다.')
    end
    if mgtKey.to_s == ''
      raise PopbillException.new('-99999999', '문서관리번호 올바르지 않습니다.')
    end

    httpget("/Taxinvoice/#{mgtKeyType}/#{mgtKey}", corpNum, userID)
  end

  def getInfos(corpNum, mgtKeyType, mgtKeyList, userID = '')
    if corpNum.length != 10
      raise PopbillException.new('-99999999', '사업자등록번호가 올바르지 않습니다.')
    end
    unless mgtKeyList.any?
      raise PopbillException.new('-99999999', '문서관리번호 배열이 올바르지 않습니다.')
    end

    postData = mgtKeyList.to_json

    httppost("/Taxinvoice/#{mgtKeyType}", corpNum, postData, "",  userID)
  end


  def getDetailInfo(corpNum, mgtKeyType, mgtKey, userID = '')
    if corpNum.length != 10
      raise PopbillException.new('-99999999', '사업자등록번호가 올바르지 않습니다.')
    end
    if mgtKey.to_s == ''
      raise PopbillException.new('-99999999', '문서관리번호 올바르지 않습니다.')
    end

    httpget("/Taxinvoice/#{mgtKeyType}/#{mgtKey}?Detail", corpNum, userID)
  end


  def delete(corpNum, mgtKeyType, mgtKey, userID = '')
    if corpNum.length != 10
      raise PopbillException.new('-99999999', '사업자등록번호가 올바르지 않습니다.')
    end
    if mgtKey.to_s == ''
      raise PopbillException.new('-99999999', '문서관리번호 입력되지 않았습니다.')
    end

    httppost("/Taxinvoice/#{mgtKeyType}/#{mgtKey}", corpNum, '', 'DELETE', userID)
  end


  def send(corpNum, mgtKeyType, mgtKey, memo = '', emailSubject = '', userID ='')
    if corpNum.length != 10
      raise PopbillException.new('-99999999', '사업자등록번호가 올바르지 않습니다.')
    end
    if mgtKey.to_s == ''
      raise PopbillException.new('-99999999', '문서관리번호 올바르지 않습니다.')
    end

    postData = {}

    if memo.to_s != ''
      postData["memo"] = memo
    end

    if emailSubject.to_s != ''
      postData["emailSubject"] = emailSubject
    end

    postData = postData.to_json

    httppost("/Taxinvoice/#{mgtKeyType}/#{mgtKey}", corpNum, postData, "SEND", userID)
  end

  def cancelSend(corpNum, mgtKeyType, mgtKey, memo = '', userID = '')
    if corpNum.length != 10
      raise PopbillException.new('-99999999', '사업자등록번호가 올바르지 않습니다.')
    end
    if mgtKey.to_s == ''
      raise PopbillException.new('-99999999', '문서관리번호 올바르지 않습니다.')
    end

    postData = {}

    if memo.to_s != ''
      postData["memo"] = memo
    end

    postData = postData.to_json

    httppost("/Taxinvoice/#{mgtKeyType}/#{mgtKey}", corpNum, postData, "CANCELSEND", userID)
  end

  def accept(corpNum, mgtKeyType, mgtKey, memo = '', userID ='')
    if corpNum.length != 10
      raise PopbillException.new('-99999999', '사업자등록번호가 올바르지 않습니다.')
    end
    if mgtKey.to_s == ''
      raise PopbillException.new('-99999999', '문서관리번호 올바르지 않습니다.')
    end

    postData = {}

    if memo.to_s != ''
      postData["memo"] = memo
    end

    postData = postData.to_json

    httppost("/Taxinvoice/#{mgtKeyType}/#{mgtKey}", corpNum, postData, "ACCEPT", userID)
  end

  def deny(corpNum, mgtKeyType, mgtKey, memo = '', userID = '')
    if corpNum.length != 10
      raise PopbillException.new('-99999999', '사업자등록번호가 올바르지 않습니다.')
    end
    if mgtKey.to_s == ''
      raise PopbillException.new('-99999999', '문서관리번호 올바르지 않습니다.')
    end

    postData = {}

    if memo.to_s != ''
      postData["memo"] = memo
    end

    postData = postData.to_json

    httppost("/Taxinvoice/#{mgtKeyType}/#{mgtKey}", corpNum, postData, "DENY", userID)
  end

  def issue(corpNum, mgtKeyType, mgtKey, forceIssue = false, memo = '', emailSubject ='', userID)
    if corpNum.length != 10
      raise PopbillException.new('-99999999', '사업자등록번호가 올바르지 않습니다.')
    end
    if mgtKey.to_s == ''
      raise PopbillException.new('-99999999', '문서관리번호 올바르지 않습니다.')
    end

    postData = {}

    if forceIssue
      postData["forceIssue"] = true
    end

    if memo.to_s != ''
      postData["memo"] = memo
    end

    if emailSubject.to_s != ''
      postData["emailSubject"] = emailSubject
    end

    postData = postData.to_json

    httppost("/Taxinvoice/#{mgtKeyType}/#{mgtKey}", corpNum, postData, "ISSUE", userID)

  end

  def cancelIssue(corpNum, mgtKeyType, mgtKey, memo = '', userID = '')
    if corpNum.length != 10
      raise PopbillException.new('-99999999', '사업자등록번호가 올바르지 않습니다.')
    end
    if mgtKey.to_s == ''
      raise PopbillException.new('-99999999', '문서관리번호 올바르지 않습니다.')
    end

    postData = {}

    if memo.to_s != ''
      postData["memo"] = memo
    end

    postData = postData.to_json

    httppost("/Taxinvoice/#{mgtKeyType}/#{mgtKey}", corpNum, postData, "CANCELISSUE", userID)
  end

  def request(corpNum, mgtKeyType, mgtKey, memo = '', userID = '')
    if corpNum.length != 10
      raise PopbillException.new('-99999999', '사업자등록번호가 올바르지 않습니다.')
    end
    if mgtKey.to_s == ''
      raise PopbillException.new('-99999999', '문서관리번호 올바르지 않습니다.')
    end

    postData = {}

    if memo.to_s != ''
      postData["memo"] = memo
    end

    postData = postData.to_json

    httppost("/Taxinvoice/#{mgtKeyType}/#{mgtKey}", corpNum, postData, "REQUEST", userID)
  end

  def refuse(corpNum, mgtKeyType, mgtKey, memo = '', userID = '')
    if corpNum.length != 10
      raise PopbillException.new('-99999999', '사업자등록번호가 올바르지 않습니다.')
    end
    if mgtKey.to_s == ''
      raise PopbillException.new('-99999999', '문서관리번호 올바르지 않습니다.')
    end

    postData = {}

    if memo.to_s != ''
      postData["memo"] = memo
    end

    postData = postData.to_json

    httppost("/Taxinvoice/#{mgtKeyType}/#{mgtKey}", corpNum, postData, "REFUSE", userID)
  end

  def cancelRequest(corpNum, mgtKeyType, mgtKey, memo = '', userID = '')
    if corpNum.length != 10
      raise PopbillException.new('-99999999', '사업자등록번호가 올바르지 않습니다.')
    end
    if mgtKey.to_s == ''
      raise PopbillException.new('-99999999', '문서관리번호 올바르지 않습니다.')
    end

    postData = {}

    if memo.to_s != ''
      postData["memo"] = memo
    end

    postData = postData.to_json

    httppost("/Taxinvoice/#{mgtKeyType}/#{mgtKey}", corpNum, postData, "CANCELREQUEST", userID)
  end


  def sendToNTS(corpNum, mgtKeyType, mgtKey, userID = '')
    if corpNum.length != 10
      raise PopbillException.new('-99999999', '사업자등록번호가 올바르지 않습니다.')
    end
    if mgtKey.to_s == ''
      raise PopbillException.new('-99999999', '문서관리번호 올바르지 않습니다.')
    end

    httppost("/Taxinvoice/#{mgtKeyType}/#{mgtKey}", corpNum, '', "NTS", userID)
  end


  def sendEmail(corpNum, mgtKeyType, mgtKey, receiverMail, userID = '')
    if corpNum.length != 10
      raise PopbillException.new('-99999999', '사업자등록번호가 올바르지 않습니다.')
    end
    if mgtKey.to_s == ''
      raise PopbillException.new('-99999999', '문서관리번호 올바르지 않습니다.')
    end

    postData = {}

    if receiverMail.to_s != ''
      postData["receiver"] = receiverMail
    end

    postData = postData.to_json

    httppost("/Taxinvoice/#{mgtKeyType}/#{mgtKey}", corpNum, postData, "EMAIL", userID)
  end

  def sendSMS(corpNum, mgtKeyType, mgtKey, senderNum, receiverNum, contents, userID = '')
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

    httppost("/Taxinvoice/#{mgtKeyType}/#{mgtKey}", corpNum, postData, "SMS", userID)
  end


  def sendFax(corpNum, mgtKeyType, mgtKey, senderNum, receiverNum, userID = '')
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

    httppost("/Taxinvoice/#{mgtKeyType}/#{mgtKey}", corpNum, postData, "FAX", userID)

  end

  def getLogs(corpNum, mgtKeyType, mgtKey, userID = '')
    if corpNum.length != 10
      raise PopbillException.new('-99999999', '사업자등록번호가 올바르지 않습니다.')
    end
    if mgtKey.to_s == ''
      raise PopbillException.new('-99999999', '문서관리번호 올바르지 않습니다.')
    end

    httpget("/Taxinvoice/#{mgtKeyType}/#{mgtKey}/Logs", corpNum, userID)
  end


  def attachFile(corpNum, mgtKeyType, mgtKey, filePath, userID ='')
    if corpNum.length != 10
      raise PopbillException.new('-99999999', '사업자등록번호가 올바르지 않습니다.')
    end
    if mgtKey.to_s == ''
      raise PopbillException.new('-99999999', '문서관리번호 올바르지 않습니다.')
    end

    httppostfiles("/Taxinvoice/#{mgtKeyType}/#{mgtKey}/Files", corpNum, '', [filePath], userID)
  end


  def getFiles(corpNum, mgtKeyType, mgtKey, userID = '')
    if corpNum.length != 10
      raise PopbillException.new('-99999999', '사업자등록번호가 올바르지 않습니다.')
    end
    if mgtKey.to_s == ''
      raise PopbillException.new('-99999999', '문서관리번호 올바르지 않습니다.')
    end

    httpget("/Taxinvoice/#{mgtKeyType}/#{mgtKey}/Files", corpNum)
  end


  def deleteFile(corpNum, mgtKeyType, mgtKey, fileID, userID = '')
    if corpNum.length != 10
      raise PopbillException.new('-99999999', '사업자등록번호가 올바르지 않습니다.')
    end
    if mgtKey.to_s == ''
      raise PopbillException.new('-99999999', '문서관리번호 올바르지 않습니다.')
    end
    if fileID.to_s == ''
      raise PopbillException.new('-99999999', '파일아이디가 입력되지 않았습니다.')
    end

    httppost("/Taxinvoice/#{mgtKeyType}/#{mgtKey}/Files/#{fileID}", corpNum, '', "DELETE", userID)
  end

  def getPopUpURL(corpNum, mgtKeyType, mgtKey, userID = '')
    if corpNum.length != 10
      raise PopbillException.new('-99999999', '사업자등록번호가 올바르지 않습니다.')
    end
    if mgtKey.to_s == ''
      raise PopbillException.new('-99999999', '문서관리번호 올바르지 않습니다.')
    end

    httpget("/Taxinvoice/#{mgtKeyType}/#{mgtKey}?TG=POPUP", corpNum, userID)['url']
  end

  def getPrintURL(corpNum, mgtKeyType, mgtKey, userID = '')
    if corpNum.length != 10
      raise PopbillException.new('-99999999', '사업자등록번호가 올바르지 않습니다.')
    end
    if mgtKey.to_s == ''
      raise PopbillException.new('-99999999', '문서관리번호 올바르지 않습니다.')
    end

    httpget("/Taxinvoice/#{mgtKeyType}/#{mgtKey}?TG=PRINT", corpNum, userID)['url']
  end

  def getEPrintURL(corpNum, mgtKeyType, mgtKey, userID = '')
    if corpNum.length != 10
      raise PopbillException.new('-99999999', '사업자등록번호가 올바르지 않습니다.')
    end
    if mgtKey.to_s == ''
      raise PopbillException.new('-99999999', '문서관리번호 올바르지 않습니다.')
    end

    httpget("/Taxinvoice/#{mgtKeyType}/#{mgtKey}?TG=EPRINT", corpNum, userID)['url']
  end

  def getMailURL(corpNum, mgtKeyType, mgtKey, userID = '')
    if corpNum.length != 10
      raise PopbillException.new('-99999999', '사업자등록번호가 올바르지 않습니다.')
    end
    if mgtKey.to_s == ''
      raise PopbillException.new('-99999999', '문서관리번호 올바르지 않습니다.')
    end

    httpget("/Taxinvoice/#{mgtKeyType}/#{mgtKey}?TG=MAIL", corpNum, userID)['url']
  end

  def getMassPrintURL(corpNum, mgtKeyType, mgtKeyList, userID = '')
    if corpNum.length != 10
      raise PopbillException.new('-99999999', '사업자등록번호가 올바르지 않습니다.')
    end
    unless mgtKeyList.any?
      raise PopbillException.new('-99999999', '문서관리번호 배열이 올바르지 않습니다.')
    end

    postData = mgtKeyList.to_json
    httppost("/Taxinvoice/#{mgtKeyType}?Print", corpNum, postData, "", userID)['url']
  end


  def search(corpNum, mgtKeyType, dType, sDate, eDate, state, type, taxType, lateOnly,
    taxRegIDYN, taxRegIDType, taxRegID, page, perPage, order, queryString, userID = '', interOPYN = '', issueType = [])
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

    uri = "/Taxinvoice/#{mgtKeyType}?DType=#{dType}&SDate=#{sDate}&EDate=#{eDate}"
    uri += "&State=" + state.join(',')
    uri += "&Type=" + type.join(',')
    uri += "&TaxType=" + taxType.join(',')
    uri += "&TaxRegIDType=" + taxRegIDType
    uri += "&TaxRegID=" + taxRegID
    uri += "&Page=" + page.to_s
    uri += "&PerPage=" + perPage.to_s
    uri += "&Order=" + order
    uri += "&InterOPYN=" + interOPYN.to_s

    if issueType.length > 0
      uri += "&IssueType=" + issueType.join(',')
    end

    if lateOnly.to_s != ''
      uri += "&LateOnly=" + lateOnly
    end

    if taxRegIDYN.to_s != ''
      uri += "&TaxRegIDYN=" + taxRegIDYN
    end

    if queryString.to_s != ''
      uri += "&QString=" + queryString
    end

    httpget(URI.escape(uri), corpNum, userID)

  end


  def attachStatement(corpNum, mgtKeyType, mgtKey, itemCode, stmtMgtKey, userID = '')
    if corpNum.length != 10
      raise PopbillException.new('-99999999', '사업자등록번호가 올바르지 않습니다.')
    end
    if mgtKey.to_s == ''
      raise PopbillException.new('-99999999', '문서관리번호가 입력되지 않았습니다.')
    end
    if itemCode.to_s == ''
      raise PopbillException.new('-99999999', '전자명세서 종류코드가 입력되지 않았습니다.')
    end
    if stmtMgtKey.to_s == ''
      raise PopbillException.new('-99999999', '전자명세서 문서관리번호가 입력되지 않았습니다.')
    end

    postData = {}
    postData["ItemCode"] = itemCode
    postData["MgtKey"] = stmtMgtKey
    postData = postData.to_json

    httppost("/Taxinvoice/#{mgtKeyType}/#{mgtKey}/AttachStmt", corpNum, postData, "", userID)
  end

  def detachStatement(corpNum, mgtKeyType, mgtKey, itemCode, stmtMgtKey, userID = '')
    if corpNum.length != 10
      raise PopbillException.new('-99999999', '사업자등록번호가 올바르지 않습니다.')
    end
    if mgtKey.to_s == ''
      raise PopbillException.new('-99999999', '문서관리번호가 입력되지 않았습니다.')
    end
    if itemCode.to_s == ''
      raise PopbillException.new('-99999999', '전자명세서 종류코드가 입력되지 않았습니다.')
    end
    if stmtMgtKey.to_s == ''
      raise PopbillException.new('-99999999', '전자명세서 문서관리번호가 입력되지 않았습니다.')
    end

    postData = {}
    postData["ItemCode"] = itemCode
    postData["MgtKey"] = stmtMgtKey
    postData = postData.to_json

    httppost("/Taxinvoice/#{mgtKeyType}/#{mgtKey}/DetachStmt", corpNum, postData, "", userID)
  end

  def assignMgtKey(corpNum, mgtKeyType, itemKey, mgtKey, userID = '')
    if corpNum.length != 10
      raise PopbillException.new('-99999999', '사업자등록번호가 올바르지 않습니다.')
    end
    if itemKey.to_s == ''
      raise PopbillException.new('-99999999', '해당문서의 아이템키가 입력되지 않았습니다.')
    end

    String postDate = "MgtKey="+mgtKey

    httppost("/Taxinvoice/#{itemKey}/#{mgtKeyType}", corpNum, postDate, "", userID, "application/x-www-form-urlencoded; charset=utf-8")
  end

end # end of TaxinvoiceService

module MgtKeyType
  SELL = "SELL"
  BUY = "BUY"
  TRUSTEE = "TRUSTEE"
end

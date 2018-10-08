# -*- coding: utf-8 -*-
require_relative '../popbill.rb'

# 팝빌 홈택스 현금영수증 연계 API Service Implementation
class HTCashbillService < BaseService
  class << self
    def instance(linkID, secretKey)
      super(linkID, secretKey)
      @instance ||= new
      @instance.addScope("141")
      return @instance
    end
    private :new
  end

  def getChargeInfo(corpNum, userID = "")
    if corpNum.length != 10
      raise PopbillException.new('-99999999', '사업자등록번호가 올바르지 않습니다.')
    end
    httpget("/HomeTax/Cashbill/ChargeInfo", corpNum, userID)
  end

  def requestJob(corpNum, type, sDate, eDate, userID = "")
    if corpNum.length != 10
      raise PopbillException.new('-99999999', '사업자등록번호가 올바르지 않습니다.')
    end
    if sDate.to_s == ''
      raise PopbillException.new('-99999999', '시작일자가 입력되지 않았습니다.')
    end
    if eDate.to_s == ''
      raise PopbillException.new('-99999999', '종료일자가 입력되지 않았습니다.')
    end

    uri = "/HomeTax/Cashbill/#{type}?SDate=#{sDate}&EDate=#{eDate}"

    httppost(uri, corpNum, "", "", userID)['jobID']
  end

  def getJobState(corpNum, jobID, userID = "")
    if corpNum.length != 10
      raise PopbillException.new('-99999999', '사업자등록번호가 올바르지 않습니다.')
    end
    if jobID.to_s == ''
      raise PopbillException.new('-99999999', '작업아이디(jobID)가 입력되지 않았습니다.')
    end

    httpget("/HomeTax/Cashbill/#{jobID}/State", corpNum, userID)
  end

  def listActiveJob(corpNum, userID = "")
    if corpNum.length != 10
      raise PopbillException.new('-99999999', '사업자등록번호가 올바르지 않습니다.')
    end

    httpget("/HomeTax/Cashbill/JobList", corpNum, userID)
  end

  def search(corpNum, jobID, tradeType, tradeUsage, page, perPage, order, userID = '')
    if corpNum.length != 10
      raise PopbillException.new('-99999999', '사업자등록번호가 올바르지 않습니다.')
    end
    if jobID.length != 18
      raise PopbillException.new('-99999999', '작업아이디(jobID)가 올바르지 않습니다.')
    end

    uri = "/HomeTax/Cashbill/#{jobID}"
    uri += "?TradeType=" + tradeType.join(',')
    uri += "&TradeUsage=" + tradeUsage.join(',')
    uri += "&Page=" + page.to_s
    uri += "&PerPage=" + perPage.to_s
    uri += "&Order=" + order

    httpget(URI.escape(uri), corpNum, userID)
  end

  def summary(corpNum, jobID, tradeType, tradeUsage, userID = '')
    if corpNum.length != 10
      raise PopbillException.new('-99999999', '사업자등록번호가 올바르지 않습니다.')
    end
    if jobID.length != 18
      raise PopbillException.new('-99999999', '작업아이디(jobID)가 올바르지 않습니다.')
    end

    uri = "/HomeTax/Cashbill/#{jobID}/Summary"
    uri += "?TradeType=" + tradeType.join(',')
    uri += "&TradeUsage=" + tradeUsage.join(',')

    httpget(URI.escape(uri), corpNum, userID)
  end

  def getFlatRatePopUpURL(corpNum, userID = "")
    if corpNum.length != 10
      raise PopbillException.new('-99999999', '사업자등록번호가 올바르지 않습니다.')
    end

    httpget("/HomeTax/Cashbill?TG=CHRG", corpNum, userID)['url']
  end

  def getCertificatePopUpURL(corpNum, userID = "")
    if corpNum.length != 10
      raise PopbillException.new('-99999999', '사업자등록번호가 올바르지 않습니다.')
    end

    httpget("/HomeTax/Cashbill?TG=CERT", corpNum, userID)['url']
  end

  def getFlatRateState(corpNum, userID = "")
    if corpNum.length != 10
      raise PopbillException.new('-99999999', '사업자등록번호가 올바르지 않습니다.')
    end

    httpget("/HomeTax/Cashbill/Contract", corpNum, userID)
  end

  def getCertificateExpireDate(corpNum, userID = "")
    if corpNum.length != 10
      raise PopbillException.new('-99999999', '사업자등록번호가 올바르지 않습니다.')
    end

    httpget("/HomeTax/Cashbill/CertInfo", corpNum, userID)['certificateExpiration']
  end

  def checkCertValidation(corpNum, userID = "")
    if corpNum.length != 10
      raise PopbillException.new('-99999999', '사업자등록번호가 올바르지 않습니다.')
    end

    httpget("/HomeTax/Cashbill/CertCheck", corpNum, userID)

  end

  def registDeptUser(corpNum, deptUserID, deptUserPWD, userID = "")
    if corpNum.length != 10
      raise PopbillException.new('-99999999', '사업자등록번호가 올바르지 않습니다.')
    end

    if deptUserID.length == 0
      raise PopbillException.new('-99999999', '홈택스 부서사용자 계정 아이디가 입력되지 않았습니다.')
    end

    if deptUserPWD.length == 0
      raise PopbillException.new('-99999999', '홈택스 부서사용자 계정 비밀번호가 입력되지 않았습니다.')
    end

    postData = {}
    postData["id"] = deptUserID
    postData["pwd"] = deptUserPWD

    postData = postData.to_json

    httppost("/HomeTax/Cashbill/DeptUser", corpNum, postData, "", userID)
  end

  def checkDeptUser(corpNum, userID = "")
    if corpNum.length != 10
      raise PopbillException.new('-99999999', '사업자등록번호가 올바르지 않습니다.')
    end

    httpget("/HomeTax/Cashbill/DeptUser", corpNum, userID)
  end

  def checkLoginDeptUser(corpNum, userID = "")
    if corpNum.length != 10
      raise PopbillException.new('-99999999', '사업자등록번호가 올바르지 않습니다.')
    end

    httpget("/HomeTax/Cashbill/DeptUser/Check", corpNum, userID)
  end

  def deleteDeptUser(corpNum, userID = "")
    if corpNum.length != 10
      raise PopbillException.new('-99999999', '사업자등록번호가 올바르지 않습니다.')
    end

    httppost("/HomeTax/Cashbill/DeptUser", corpNum, "", "DELETE", userID)
  end


end # end of HTCashbillService

# -*- coding: utf-8 -*-
require_relative '../popbill.rb'

# 팝빌 계좌조회 API Service Implementation
class EasyFinBankService < BaseService
  class << self
    def instance(linkID, secretKey)
      super(linkID, secretKey)
      @instance ||= new
      @instance.addScope("180")
      return @instance
    end
    private :new
  end

  def registBankAccount(corpNum, bankAccountInfo, userID = "")
    if corpNum.length != 10
      raise PopbillException.new('-99999999', '사업자등록번호가 올바르지 않습니다.')
    end

    if bankAccountInfo["BankCode"].to_s == ''
      raise PopbillException.new('-99999999', '기관코드가 입력되지 않았습니다.')
    end

    if bankAccountInfo["BankCode"].length != 4
      raise PopbillException.new('-99999999', '기관코드가 올바르지 않습니다.')
    end

    if bankAccountInfo["AccountNumber"].to_s == ''
      raise PopbillException.new('-99999999', '은행 계좌번호가 입력되지 않았습니다.')
    end

    uri = "/EasyFin/Bank/BankAccount/Regist"

    if bankAccountInfo["UsePeriod"].to_s != ''
      uri += "?UsePeriod=" + bankAccountInfo["UsePeriod"]
    end

    httppost(uri, corpNum, bankAccountInfo.to_json, "", userID)
  end

  def updateBankAccount(corpNum, bankAccountInfo, userID = "")
    if corpNum.length != 10
      raise PopbillException.new('-99999999', '사업자등록번호가 올바르지 않습니다.')
    end

    if bankAccountInfo["BankCode"].to_s == ''
      raise PopbillException.new('-99999999', '기관코드가 입력되지 않았습니다.')
    end

    if bankAccountInfo["BankCode"].length != 4
      raise PopbillException.new('-99999999', '기관코드가 올바르지 않습니다.')
    end

    if bankAccountInfo["AccountNumber"].to_s == ''
      raise PopbillException.new('-99999999', '은행 계좌번호가 입력되지 않았습니다.')
    end

    uri = "/EasyFin/Bank/BankAccount/#{bankAccountInfo["BankCode"]}/#{bankAccountInfo["AccountNumber"]}/Update"

    httppost(uri, corpNum, bankAccountInfo.to_json, "", userID)
  end

  def closeBankAccount(corpNum, bankCode, accountNumber, closeType, userID = "")
    if corpNum.length != 10
      raise PopbillException.new('-99999999', '사업자등록번호가 올바르지 않습니다.')
    end

    if bankCode.to_s == ''
      raise PopbillException.new('-99999999', '기관코드가 입력되지 않았습니다.')
    end

    if bankCode.length != 4
      raise PopbillException.new('-99999999', '기관코드가 올바르지 않습니다.')
    end

    if accountNumber.to_s == ''
      raise PopbillException.new('-99999999', '은행 계좌번호가 입력되지 않았습니다.')
    end

    if closeType.to_s == ''
      raise PopbillException.new('-99999999', '정액제 해지유형이 입력되지 않았습니다.')
    end

    uri = "/EasyFin/Bank/BankAccount/Close/?BankCode=#{bankCode}&AccountNumber=#{accountNumber}&CloseType=#{closeType}"

    httppost(URI.escape(uri), corpNum, "", "", userID)
  end

  def revokeCloseBankAccount(corpNum, bankCode, accountNumber, userID = "")
    if corpNum.length != 10
      raise PopbillException.new('-99999999', '사업자등록번호가 올바르지 않습니다.')
    end

    if bankCode.to_s == ''
      raise PopbillException.new('-99999999', '기관코드가 입력되지 않았습니다.')
    end

    if bankCode.length != 4
      raise PopbillException.new('-99999999', '기관코드가 올바르지 않습니다.')
    end

    if accountNumber.to_s == ''
      raise PopbillException.new('-99999999', '은행 계좌번호가 입력되지 않았습니다.')
    end

    uri = "/EasyFin/Bank/BankAccount/RevokeClose/?BankCode=#{bankCode}&AccountNumber=#{accountNumber}"

    httppost(uri, corpNum, "", "", userID)
  end

  def getBankAccountInfo(corpNum, bankCode, accountNumber, userID = "")
    if corpNum.length != 10
      raise PopbillException.new('-99999999', '사업자등록번호가 올바르지 않습니다.')
    end

    if bankCode.to_s == ''
      raise PopbillException.new('-99999999', '기관코드가 입력되지 않았습니다.')
    end

    if bankCode.length != 4
      raise PopbillException.new('-99999999', '기관코드가 올바르지 않습니다.')
    end

    if accountNumber.to_s == ''
      raise PopbillException.new('-99999999', '은행 계좌번호가 입력되지 않았습니다.')
    end

    uri = "/EasyFin/Bank/BankAccount/#{bankCode}/#{accountNumber}"

    httpget(uri, corpNum, userID)
  end


  def getChargeInfo(corpNum, userID = "")
    if corpNum.length != 10
      raise PopbillException.new('-99999999', '사업자등록번호가 올바르지 않습니다.')
    end
    httpget("/EasyFin/Bank/ChargeInfo", corpNum, userID)
  end

  def getBankAccountMgtURL(corpNum, userID = "")
    if corpNum.length != 10
      raise PopbillException.new('-99999999', '사업자등록번호가 올바르지 않습니다.')
    end

    httpget("/EasyFin/Bank?TG=BankAccount", corpNum, userID)['url']
  end

  def listBankAccount(corpNum, userID = "")
    if corpNum.length != 10
      raise PopbillException.new('-99999999', '사업자등록번호가 올바르지 않습니다.')
    end

    httpget("/EasyFin/Bank/ListBankAccount", corpNum, userID)
  end

  def requestJob(corpNum, bankCode, accountNumber, sDate, eDate, userID = "")
    if corpNum.length != 10
      raise PopbillException.new('-99999999', '사업자등록번호가 올바르지 않습니다.')
    end
    if bankCode.to_s == ''
      raise PopbillException.new('-99999999', '기관코드가 입력되지 않았습니다.')
    end
    if accountNumber.to_s == ''
      raise PopbillException.new('-99999999', '계좌번호가 입력되지 않았습니다.')
    end
    if sDate.to_s == ''
      raise PopbillException.new('-99999999', '시작일자가 입력되지 않았습니다.')
    end
    if eDate.to_s == ''
      raise PopbillException.new('-99999999', '종료일자가 입력되지 않았습니다.')
    end

    uri = "/EasyFin/Bank/BankAccount?BankCode=#{bankCode}&AccountNumber=#{accountNumber}&SDate=#{sDate}&EDate=#{eDate}"

    httppost(uri, corpNum, "", "", userID)['jobID']
  end

  def getJobState(corpNum, jobID, userID = "")
    if corpNum.length != 10
      raise PopbillException.new('-99999999', '사업자등록번호가 올바르지 않습니다.')
    end
    if jobID.to_s == ''
      raise PopbillException.new('-99999999', '작업아이디(jobID)가 입력되지 않았습니다.')
    end

    httpget("/EasyFin/Bank/#{jobID}/State", corpNum, userID)
  end

  def listActiveJob(corpNum, userID = "")
    if corpNum.length != 10
      raise PopbillException.new('-99999999', '사업자등록번호가 올바르지 않습니다.')
    end

    httpget("/EasyFin/Bank/JobList", corpNum, userID)
  end

  def search(corpNum, jobID, tradeType, searchString, page, perPage, order, userID = '')
    if corpNum.length != 10
      raise PopbillException.new('-99999999', '사업자등록번호가 올바르지 않습니다.')
    end
    if jobID.length != 18
      raise PopbillException.new('-99999999', '작업아이디(jobID)가 올바르지 않습니다.')
    end

    uri = "/EasyFin/Bank/#{jobID}"
    uri += "?TradeType=" + tradeType.join(',')
    uri += "&Page=" + page.to_s
    uri += "&PerPage=" + perPage.to_s
    uri += "&Order=" + order

    if searchString.to_s != ''
      uri += "&SearchString=" + searchString
    end

    httpget(URI.escape(uri), corpNum, userID)
  end

  def summary(corpNum, jobID, tradeType, searchString, userID = '')
    if corpNum.length != 10
      raise PopbillException.new('-99999999', '사업자등록번호가 올바르지 않습니다.')
    end
    if jobID.length != 18
      raise PopbillException.new('-99999999', '작업아이디(jobID)가 올바르지 않습니다.')
    end

    uri = "/EasyFin/Bank/#{jobID}/Summary"
    uri += "?TradeType=" + tradeType.join(',')

    if searchString.to_s != ''
      uri += "&SearchString=" + searchString
    end

    httpget(URI.escape(uri), corpNum, userID)
  end

  def saveMemo(corpNum, tid, memo, userID = "")
    if corpNum.length != 10
      raise PopbillException.new('-99999999', '사업자등록번호가 올바르지 않습니다.')
    end
    if tid.to_s == ''
      raise PopbillException.new('-99999999', '거래내역 아이디가 입력되지 않았습니다.')
    end


    uri = "/EasyFin/Bank/SaveMemo?TID=#{tid}&Memo=#{memo}"

    httppost(uri, corpNum, "", "", userID)
  end

  def getFlatRatePopUpURL(corpNum, userID = "")
    if corpNum.length != 10
      raise PopbillException.new('-99999999', '사업자등록번호가 올바르지 않습니다.')
    end

    httpget("/EasyFin/Bank?TG=CHRG", corpNum, userID)['url']
  end

  def getFlatRateState(corpNum, bankCode, accountNumber, userID = "")
    if corpNum.length != 10
      raise PopbillException.new('-99999999', '사업자등록번호가 올바르지 않습니다.')
    end

    if bankCode.to_s == ''
      raise PopbillException.new('-99999999', '기관코드가 입력되지 않았습니다.')
    end
    if accountNumber.to_s == ''
      raise PopbillException.new('-99999999', '계좌번호가 입력되지 않았습니다.')
    end

    httpget("/EasyFin/Bank/Contract/#{bankCode}/#{accountNumber}", corpNum, userID)
  end



end

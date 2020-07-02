# -*- coding: utf-8 -*-
require_relative '../popbill.rb'

# 팝빌 예금주조회 API Service Implementation
class AccountCheckService < BaseService
  class << self
    def instance(linkID, secretKey)
      super(linkID, secretKey)
      @instance ||= new
      @instance.addScope("182")
      return @instance
    end
    private :new
  end

  def getChargeInfo(corpNum, userID = '')
    if corpNum.length != 10
      raise PopbillException.new(-99999999, "사업자등록번호가 올바르지 않습니다.")
    end
    httpget("/EasyFin/AccountCheck/ChargeInfo", corpNum, userID)
  end

  def getUnitCost(corpNum, userID = '')
    if corpNum.length != 10
      raise PopbillException.new(-99999999, "사업자등록번호가 올바르지 않습니다.")
    end
    httpget("/EasyFin/AccountCheck/UnitCost", corpNum, userID)['unitCost']
  end

  def checkAccountInfo(corpNum, bankCode, accountNumber, userID = '')
    if corpNum.length != 10
      raise PopbillException.new(-99999999, "사업자등록번호가 올바르지 않습니다.")
    end
    if bankCode.to_s == ''
      raise PopbillException.new(-99999999, '기관코드가 입력되지 않았습니다.')
    end

    if accountNumber.to_s == ''
      raise PopbillException.new(-99999999, '계좌번호가 입력되지 않았습니다.')
    end

    uri = "/EasyFin/AccountCheck?c=#{bankCode}&n=#{accountNumber}"

    httppost(uri, corpNum, "", "", userID)
  end


end # end of FaxService

# -*- coding: utf-8 -*-
require_relative '../popbill.rb'

# 팝빌 예금주조회 API Service Implementation
class AccountCheckService < BaseService
  class << self
    def instance(linkID, secretKey)
      super(linkID, secretKey)
      @instance ||= new
      @instance.addScope("182")
      @instance.addScope("183")
      return @instance
    end
    private :new
  end

  def getChargeInfo(corpNum, userID = '', serviceType = '')
    if corpNum.length != 10
      raise PopbillException.new(-99999999, "사업자등록번호가 올바르지 않습니다.")
    end

    uri = "/EasyFin/AccountCheck/ChargeInfo?serviceType=" + serviceType
    escapeURI = URI.escape(uri)

    httpget(escapeURI, corpNum, userID)
  end

  def getUnitCost(corpNum, userID = '', serviceType = '')
    if corpNum.length != 10
      raise PopbillException.new(-99999999, "사업자등록번호가 올바르지 않습니다.")
    end

    uri = "/EasyFin/AccountCheck/UnitCost?serviceType=" + serviceType
    escapeURI = URI.escape(uri)

    httpget(escapeURI, corpNum, userID)['unitCost']
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

  def checkDepositorInfo(corpNum, bankCode, accountNumber, identityNumType, identityNum, userID = '')
    if corpNum.length != 10
      raise PopbillException.new(-99999999, "사업자등록번호가 올바르지 않습니다.")
    end
    if bankCode.to_s == ''
      raise PopbillException.new(-99999999, '기관코드가 입력되지 않았습니다.')
    end
    if accountNumber.to_s == ''
      raise PopbillException.new(-99999999, '계좌번호가 입력되지 않았습니다.')
    end
    if identityNumType == ''
      raise PopbillException.new(-99999999, '등록번호 유형이 입력되지 않았습니다.')
    end
    if not identityNumType.match('^[PB]$')
      raise PopbillException.new(-99999999,"등록번호 유형이 유효하지 않습니다.")
    end
    if identityNum == ''
      raise PopbillException.new(-99999999,"등록번호가 입력되지 않았습니다.")
    end
    if not identityNum.match('^\d+$')
      raise PopbillException.new(-99999999,"등록번호는 숫자만 입력할 수 있습니다.")
    end

    uri = "/EasyFin/DepositorCheck"
    uri += "?c="+bankCode
    uri += "&n="+accountNumber
    uri += "&t="+identityNumType
    uri += "&p="+identityNum

    httppost(uri, corpNum, "", "", userID)
  end



end # end of AccountCheckService

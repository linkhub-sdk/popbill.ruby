# -*- coding: utf-8 -*-
require_relative '../popbill.rb'

# 팝빌 기업정보조회 API Service Implementation
class BizInfoCheckService < BaseService
  class << self
    def instance(linkID, secretKey)
      super(linkID, secretKey)
      @instance ||= new
      @instance.addScope("171")
      return @instance
    end
    private :new
  end

  def getChargeInfo(corpNum, userID = '')
    if corpNum.length != 10
      raise PopbillException.new(-99999999, "사업자등록번호가 올바르지 않습니다.")
    end
    httpget("/BizInfo/ChargeInfo", corpNum, userID)
  end

  def getUnitCost(corpNum, userID = '')
    if corpNum.length != 10
      raise PopbillException.new(-99999999, "사업자등록번호가 올바르지 않습니다.")
    end
    httpget("/BizInfo/UnitCost", corpNum, userID)['unitCost']
  end

  def checkBizInfo(corpNum, checkCorpNum, userID = '')
    if corpNum.length != 10
      raise PopbillException.new(-99999999, "사업자등록번호가 올바르지 않습니다.")
    end

    if checkCorpNum.to_s == ''
      raise PopbillException.new(-99999999, "조회할 사업자등록번호가 입력되지 않았습니다.")
    end

    httpget("/BizInfo/Check?CN=#{checkCorpNum}", corpNum, userID)
  end

end # end of BizInfoCheckService

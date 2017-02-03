# -*- coding: utf-8 -*-
require_relative './popbill.rb'

# 팝빌 휴폐업조회 API Service Implementation
class ClosedownService < BaseService
  class << self
    def instance(linkID, secretKey)
      super(linkID, secretKey)
      @instance ||= new
      @instance.addScope("170")
      return @instance
    end
    private :new
  end

  def getChargeInfo(corpNum, userID = '')
    if corpNum.length != 10
      raise PopbillException.new(-99999999, "사업자등록번호가 올바르지 않습니다.")
    end
    httpget("/CloseDown/ChargeInfo", corpNum, userID)
  end

  def getUnitCost(corpNum, userID = '')
    if corpNum.length != 10
      raise PopbillException.new(-99999999, "사업자등록번호가 올바르지 않습니다.")
    end
    httpget("/CloseDown/UnitCost", corpNum, userID)['unitCost']
  end

  def checkCorpNum(corpNum, checkCorpNum, userID = '')
    if corpNum.length != 10
      raise PopbillException.new(-99999999, "사업자등록번호가 올바르지 않습니다.")
    end

    if checkCorpNum.to_s == ''
      raise PopbillException.new(-99999999, "조회할 사업자등록번호가 입력되지 않았습니다.")
    end

    httpget("/CloseDown?CN=#{checkCorpNum}", corpNum, userID)
  end

  def checkCorpNums(corpNum, checkCorpNums, userID = '')
    if corpNum.length != 10
      raise PopbillException.new(-99999999, "사업자등록번호가 올바르지 않습니다.")
    end
    if checkCorpNums.length == 0
      raise PopbillException.new(-99999999, "조회할 사업자등록번호 배열이 입력되지 않았습니다.")
    end

    httppost("/CloseDown", corpNum, checkCorpNums.to_json)
  end



end # end of FaxService

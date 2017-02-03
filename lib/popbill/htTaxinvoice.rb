# -*- coding: utf-8 -*-
require_relative './popbill.rb'

# 팝빌 홈택스 세금계산서 연계 API Service Implementation
class HTTaxinvoiceService < BaseService
  class << self
    def instance(linkID, secretKey)
      super(linkID, secretKey)
      @instance ||= new
      @instance.addScope("111")
      return @instance
    end
    private :new
  end

  def getChargeInfo(corpNum, userID = "")
    if corpNum.length != 10
      raise PopbillException.new('-99999999', '사업자등록번호가 올바르지 않습니다.')
    end
    httpget("/HomeTax/Taxinvoice/ChargeInfo", corpNum, userID)
  end

  def requestJob(corpNum, type, dType, sDate, eDate, userID = "")
    if corpNum.length != 10
      raise PopbillException.new('-99999999', '사업자등록번호가 올바르지 않습니다.')
    end
    if dType.to_s == ''
      raise PopbillException.new('-99999999', '검색일자 유형이 입력되지 않았습니다.')
    end
    if sDate.to_s == ''
      raise PopbillException.new('-99999999', '시작일자가 입력되지 않았습니다.')
    end
    if eDate.to_s == ''
      raise PopbillException.new('-99999999', '종료일자가 입력되지 않았습니다.')
    end

    uri = "/HomeTax/Taxinvoice/#{type}?DType=#{dType}&SDate=#{sDate}&EDate=#{eDate}"

    httppost(uri, corpNum, "", "", userID)['jobID']
  end

  def getJobState(corpNum, jobID, userID = "")
    if corpNum.length != 10
      raise PopbillException.new('-99999999', '사업자등록번호가 올바르지 않습니다.')
    end
    if jobID.to_s == ''
      raise PopbillException.new('-99999999', '작업아이디(jobID)가 입력되지 않았습니다.')
    end

    httpget("/HomeTax/Taxinvoice/#{jobID}/State", corpNum, userID)
  end

  def listActiveJob(corpNum, userID = "")
    if corpNum.length != 10
      raise PopbillException.new('-99999999', '사업자등록번호가 올바르지 않습니다.')
    end

    httpget("/HomeTax/Taxinvoice/JobList", corpNum, userID)
  end

  def search(corpNum, jobID, type, taxType, purposeType, taxRegIDType, taxRegIDYN,
    taxRegID, page, perPage, order, userID = '')
    if corpNum.length != 10
      raise PopbillException.new('-99999999', '사업자등록번호가 올바르지 않습니다.')
    end
    if jobID.length != 18
      raise PopbillException.new('-99999999', '작업아이디(jobID)가 올바르지 않습니다.')
    end

    uri = "/HomeTax/Taxinvoice/#{jobID}"
    uri += "?Type=" + type.join(',')
    uri += "&TaxType=" + taxType.join(',')
    uri += "&PurposeType=" + purposeType.join(',')
    uri += "&TaxRegIDType=" + taxRegIDType
    uri += "&TaxRegID=" + taxRegID
    uri += "&Page=" + page.to_s
    uri += "&PerPage=" + perPage.to_s
    uri += "&Order=" + order

    if taxRegIDYN.to_s != ''
      uri += "&TaxRegIDYN=" + taxRegIDYN
    end

    httpget(URI.escape(uri), corpNum, userID)
  end

  def summary(corpNum, jobID, type, taxType, purposeType, taxRegIDType, taxRegIDYN,
    taxRegID, userID = '')
    if corpNum.length != 10
      raise PopbillException.new('-99999999', '사업자등록번호가 올바르지 않습니다.')
    end
    if jobID.length != 18
      raise PopbillException.new('-99999999', '작업아이디(jobID)가 올바르지 않습니다.')
    end

    uri = "/HomeTax/Taxinvoice/#{jobID}/Summary"
    uri += "?Type=" + type.join(',')
    uri += "&TaxType=" + taxType.join(',')
    uri += "&PurposeType=" + purposeType.join(',')
    uri += "&TaxRegIDType=" + taxRegIDType
    uri += "&TaxRegID=" + taxRegID

    if taxRegIDYN.to_s != ''
      uri += "&TaxRegIDYN=" + taxRegIDYN
    end

    httpget(URI.escape(uri), corpNum, userID)
  end

  def getTaxinvoice(corpNum, ntsConfirmNum, userID = "")
    if corpNum.length != 10
      raise PopbillException.new('-99999999', '사업자등록번호가 올바르지 않습니다.')
    end
    if ntsConfirmNum.length != 24
      raise PopbillException.new('-99999999', '전자세금계산서 국세청승인번호가 올바르지 않습니다.')
    end

    httpget("/HomeTax/Taxinvoice/#{ntsConfirmNum}", corpNum, userID)
  end

  def getXML(corpNum, ntsConfirmNum, userID = "")
    if corpNum.length != 10
      raise PopbillException.new('-99999999', '사업자등록번호가 올바르지 않습니다.')
    end
    if ntsConfirmNum.length != 24
      raise PopbillException.new('-99999999', '전자세금계산서 국세청승인번호가 올바르지 않습니다.')
    end

    httpget("/HomeTax/Taxinvoice/#{ntsConfirmNum}?T=xml", corpNum, userID)
  end

  def getFlatRatePopUpURL(corpNum, userID = "")
    if corpNum.length != 10
      raise PopbillException.new('-99999999', '사업자등록번호가 올바르지 않습니다.')
    end

    httpget("/HomeTax/Taxinvoice?TG=CHRG", corpNum, userID)['url']
  end

  def getCertificatePopUpURL(corpNum, userID = "")
    if corpNum.length != 10
      raise PopbillException.new('-99999999', '사업자등록번호가 올바르지 않습니다.')
    end

    httpget("/HomeTax/Taxinvoice?TG=CERT", corpNum, userID)['url']
  end

  def getFlatRateState(corpNum, userID = "")
    if corpNum.length != 10
      raise PopbillException.new('-99999999', '사업자등록번호가 올바르지 않습니다.')
    end

    httpget("/HomeTax/Taxinvoice/Contract", corpNum, userID)
  end

  def getCertificateExpireDate(corpNum, userID = "")
    if corpNum.length != 10
      raise PopbillException.new('-99999999', '사업자등록번호가 올바르지 않습니다.')
    end

    httpget("/HomeTax/Taxinvoice/CertInfo", corpNum, userID)['certificateExpiration']
  end

end # end of HTTaxinvoiceService

module KeyType
  SELL = "SELL"
  BUY = "BUY"
  TRUSTEE = "TRUSTEE"
end

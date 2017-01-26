# -*- coding: utf-8 -*-
require_relative './popbill.rb'

# 팝빌 팩스 API Service Implementation
class FaxService < BaseService
  class << self
    def instance(linkID, secretKey)
      super(linkID, secretKey)
      @instance ||= new
      @instance.addScope("160")
      return @instance
    end
    private :new
  end

  def getChargeInfo(corpNum, userID = '')
    if corpNum.length != 10
      raise PopbillException.new(-99999999, "사업자등록번호가 올바르지 않습니다.")
    end
    httpget("/FAX/ChargeInfo", corpNum, userID)
  end

  def getURL(corpNum, togo, userID = '')
    if corpNum.length != 10
      raise PopbillException.new(-99999999, "사업자등록번호가 올바르지 않습니다.")
    end
    httpget("/FAX/?TG=#{togo}", corpNum, userID)['url']
  end

  def getUnitCost(corpNum, userID = '')
    if corpNum.length != 10
      raise PopbillException.new(-99999999, "사업자등록번호가 올바르지 않습니다.")
    end
    httpget("/FAX/UnitCost", corpNum, userID)['unitCost']
  end

  def search(corpNum, sDate, eDate, state, reserveYN, senderOnly, page, perPage,
    order, userID = '')
    if corpNum.length != 10
          raise PopbillException.new('-99999999', '사업자등록번호가 올바르지 않습니다.')
    end
    if sDate.to_s == ''
      raise PopbillException.new('-99999999', '시작일자가 입력되지 않았습니다.')
    end
    if eDate.to_s == ''
      raise PopbillException.new('-99999999', '종료일자가 입력되지 않았습니다.')
    end

    uri = "/FAX/Search?SDate=#{sDate}&EDate=#{eDate}"
    uri += "&State=" + state.join(',')
    uri += "&ReserveYN=" + reserveYN
    uri += "&SenderOnly=" + senderOnly
    uri += "&Page=" + page.to_s
    uri += "&PerPage=" + perPage.to_s
    uri += "&Order=" + order

    httpget(URI.escape(uri), corpNum, userID)
  end

  def sendFax(corpNum, senderNum, senderName, receiverNum, receiverName, filePath,
    reserveDT = '', userID = '')
    if corpNum.length != 10
      raise PopbillException.new(-99999999, "사업자등록번호가 올바르지 않습니다.")
    end

    receiver = [
      {
        "rcv" => receiverNum,
        "rcvnm" => receiverName,
      }
    ]

    sendFax_multi(corpNum, senderNum, senderName, receiver, filePath, reserveDT, userID)
  end

  def sendFax_multi(corpNum, senderNum, senderName, receivers, filePaths,
    reserveDT = '', userID = '')
    if corpNum.length != 10
      raise PopbillException.new(-99999999, "사업자등록번호가 올바르지 않습니다.")
    end

    postData = {}
    postData["snd"] = senderNum
    postData["sndnm"] = senderName
    postData["fCnt"] = filePaths.length
    postData["sndDT"] = reserveDT
    postData["rcvs"] = receivers

    httppostfile("/FAX", corpNum, postData, filePaths, userID)['receiptNum']
  end

  def getFaxDetail(corpNum, receiptNum, userID = '')
    if corpNum.length != 10
      raise PopbillException.new(-99999999, "사업자등록번호가 올바르지 않습니다.")
    end

    httpget("/FAX/#{receiptNum}", corpNum, userID)
  end

  def cancelReserve(corpNum, receiptNum, userID = '')
    if corpNum.length != 10
      raise PopbillException.new(-99999999, "사업자등록번호가 올바르지 않습니다.")
    end

    httpget("/FAX/#{receiptNum}/Cancel", corpNum, userID)
  end



end # end of FaxService

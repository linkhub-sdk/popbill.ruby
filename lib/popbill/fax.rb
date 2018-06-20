# -*- coding: utf-8 -*-
require_relative '../popbill.rb'

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

  def getSenderNumberList(corpNum, userID = '')
    if corpNum.length != 10
      raise PopbillException.new(-99999999, "사업자등록번호가 올바르지 않습니다.")
    end
    httpget("/FAX/SenderNumber", corpNum, userID)
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
      raise PopbillException.new(-99999999, '사업자등록번호가 올바르지 않습니다.')
    end
    if sDate.to_s == ''
      raise PopbillException.new(-99999999, '시작일자가 입력되지 않았습니다.')
    end
    if eDate.to_s == ''
      raise PopbillException.new(-99999999, '종료일자가 입력되지 않았습니다.')
    end

    uri = "/FAX/Search?SDate=#{sDate}&EDate=#{eDate}"
    uri += "&State=" + state.join(',') if state.to_s != ''
    uri += "&ReserveYN=" + reserveYN
    uri += "&SenderOnly=" + senderOnly
    uri += "&Page=" + page.to_s
    uri += "&PerPage=" + perPage.to_s
    uri += "&Order=" + order

    httpget(URI.escape(uri), corpNum, userID)
  end

  def sendFax(corpNum, senderNum, senderName, receiverNum, receiverName, filePath,
              reserveDT = '', userID = '', adsYN = false, title = '', requestNum = '')
    if corpNum.length != 10
      raise PopbillException.new(-99999999, "사업자등록번호가 올바르지 않습니다.")
    end

    receiver = [
        {
            "rcv" => receiverNum,
            "rcvnm" => receiverName,
        }
    ]

    sendFax_multi(corpNum, senderNum, senderName, receiver, filePath, reserveDT, userID, adsYN, title, requestNum)
  end

  def sendFax_multi(corpNum, senderNum, senderName, receivers, filePaths,
                    reserveDT = '', userID = '', adsYN = false, title = '', requestNum = '')
    if corpNum.length != 10
      raise PopbillException.new(-99999999, "사업자등록번호가 올바르지 않습니다.")
    end

    postData = {}
    postData["snd"] = senderNum
    postData["sndnm"] = senderName
    postData["fCnt"] = filePaths.length
    postData["sndDT"] = reserveDT
    postData["rcvs"] = receivers
    postData["title"] = title
    postData["requestNum"] = requestNum

    if adsYN
      postData["adsYN"] = adsYN
    end

    httppostfile("/FAX", corpNum, postData, filePaths, userID)['receiptNum']
  end

  def resendFax(corpNum, receiptNum, senderNum, senderName, receiveNum, receiveName,
                reserveDT = '', userID = '', title = '', requestNum = '')
    if receiptNum.to_s == ''
      raise PopbillException.new('-99999999', '팩스접수번호(receiptNum)가 입력되지 않았습니다.')
    end

    receiver = nil
    if receiveNum.to_s != '' || receiveName.to_s != ''
      receiver = [
          {
              "rcv" => receiveNum,
              "rcvnm" => receiveName,
          }
      ]
    end

    resendFax_multi(corpNum, receiptNum, senderNum, senderName, receiver, reserveDT, userID, title, requestNum)
  end

  def resendFax_multi(corpNum, receiptNum, senderNum = '', senderName = '', receivers = nil,
                      reserveDT = '', userID = '', title = '', requestNum = '')
    if corpNum.length != 10
      raise PopbillException.new(-99999999, "사업자등록번호가 올바르지 않습니다.")
    end

    postData = {}
    postData["snd"] = senderNum
    postData["sndnm"] = senderName
    postData["sndDT"] = reserveDT
    postData["rcvs"] = receivers
    postData["title"] = title
    postData["requestNum"] = requestNum

    postData = postData.to_json

    httppost("/FAX/#{receiptNum}", corpNum, postData, "", userID)['receiptNum']
  end

  def resendFAXRN(corpNum, orgRequestNum, senderNum, senderName, receiveNum, receiveName,
                  reserveDT = '', userID = '', title = '', requestNum = '')

    receiver = nil

    if receiveNum.to_s != '' || receiveName.to_s != ''
      receiver = [
          {
              "rcv" => receiveNum,
              "rcvnm" => receiveName,
          }
      ]
    end

    resendFAXRN_multi(corpNum, orgRequestNum, senderNum, senderName, receiver, reserveDT, userID, title, requestNum)
  end

  def resendFAXRN_multi(corpNum, orgRequestNum, senderNum = '', senderName = '', receivers = nil,
                        reserveDT = '', userID = '', title = '', requestNum = '')
    if corpNum.length != 10
      raise PopbillException.new(-99999999, "사업자등록번호가 올바르지 않습니다.")
    end
    if orgRequestNum.to_s == ''
      raise PopbillException.new(-99999999, "원본 팩스 접수번호(orgRequestNum)가 입력되지 않았습니다.")
    end
    if requestNum.to_s == ''
      raise PopbillException.new(-99999999, "요청번호(requestNum)가 입력되지 않았습니다.")
    end

    postData = {}
    postData["snd"] = senderNum
    postData["sndnm"] = senderName
    postData["sndDT"] = reserveDT
    postData["rcvs"] = receivers
    postData["title"] = title
    postData["requestNum"] = requestNum

    postData = postData.to_json

    httppost("/FAX/Resend/#{orgRequestNum}", corpNum, postData, "", userID)['receiptNum']
  end

  def getFaxDetail(corpNum, receiptNum, userID = '')
    if corpNum.length != 10
      raise PopbillException.new(-99999999, "사업자등록번호가 올바르지 않습니다.")
    end
    if receiptNum.to_s == ''
      raise PopbillException.new(-99999999, "접수번호(receiptNum)가 입력되지 않았습니다.")
    end

    httpget("/FAX/#{receiptNum}", corpNum, userID)
  end

  def cancelReserve(corpNum, receiptNum, userID = '')
    if corpNum.length != 10
      raise PopbillException.new(-99999999, "사업자등록번호가 올바르지 않습니다.")
    end
    if receiptNum.to_s == ''
      raise PopbillException.new(-99999999, "접수번호(receiptNum)가 입력되지 않았습니다.")
    end

    httpget("/FAX/#{receiptNum}/Cancel", corpNum, userID)
  end


  def getFaxDetailRN(corpNum, requestNum, userID = '')
    if corpNum.length != 10
      raise PopbillException.new(-99999999, "사업자등록번호가 올바르지 않습니다.")
    end
    if requestNum.to_s == ''
      raise PopbillException.new(-99999999, "요청번호(requestNum)가 입력되지 않았습니다.")
    end

    httpget("/FAX/Get/#{requestNum}", corpNum, userID)
  end


  def cancelReserveRN(corpNum, requestNum, userID = '')
    if corpNum.length != 10
      raise PopbillException.new(-99999999, "사업자등록번호가 올바르지 않습니다.")
    end
    if requestNum.to_s == ''
      raise PopbillException.new(-99999999, "요청번호(requestNum)가 입력되지 않았습니다.")
    end

    httpget("/FAX/Cancel/#{requestNum}", corpNum, userID)
  end

end # end of FaxService

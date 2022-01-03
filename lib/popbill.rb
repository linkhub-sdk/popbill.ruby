# -*- coding: utf-8 -*-
require 'net/http'
require 'uri'
require 'json'
require 'date'
require 'linkhub'

# Popbill API BaseService class
class BaseService
  ServiceID_REAL = "POPBILL"
  ServiceID_TEST = "POPBILL_TEST"
  ServiceURL_REAL = "https://popbill.linkhub.co.kr"
  ServiceURL_TEST = "https://popbill-test.linkhub.co.kr"
  ServiceURL_Static_REAL = "https://static-popbill.linkhub.co.kr"
  ServiceURL_Static_TEST = "https://static-popbill-test.linkhub.co.kr"
  ServiceURL_GA_REAL = "https://ga-popbill.linkhub.co.kr"
  ServiceURL_GA_TEST = "https://ga-popbill-test.linkhub.co.kr"

  POPBILL_APIVersion = "1.0"
  BOUNDARY = "==POPBILL_RUBY_SDK=="

  attr_accessor :token_table, :scopes, :isTest, :linkhub, :ipRestrictOnOff, :useStaticIP, :useGAIP

  # Generate Linkhub Class Singleton Instance
  class << self
    def instance(linkID, secretKey)
      @instance ||= new
      @instance.token_table = {}
      @instance.linkhub = Linkhub.instance(linkID, secretKey)
      @instance.scopes = ["member"]
      @instance.ipRestrictOnOff = true
      @instance.useStaticIP = false
      @instance.useGAIP = false

      return @instance
    end

    private :new
  end


  # add Service Scope array
  def addScope(scopeValue)
    @scopes.push(scopeValue)
  end

  def setIsTest(testValue)
    @isTest = testValue
  end

  def setIpRestrictOnOff(value)
    @ipRestrictOnOff = value
  end

  def setUseStaticIP(value)
    @useStaticIP = value
  end

  def setUseGAIP(value)
    @useGAIP = value
  end

  def getServiceURL()
    if @useGAIP
        return @isTest ? BaseService::ServiceURL_GA_TEST : BaseService::ServiceURL_GA_REAL
    elsif @useStaticIP
      return @isTest ? BaseService::ServiceURL_Static_TEST : BaseService::ServiceURL_Static_REAL
    else
      return @isTest ? BaseService::ServiceURL_TEST : BaseService::ServiceURL_REAL
    end

  end

  def getServiceID()
    return @isTest ? BaseService::ServiceID_TEST : BaseService::ServiceID_REAL
  end

  # Get Session Token by checking token-cached hash or token Request
  def getSession_Token(corpNum)
    targetToken = nil
    refresh = false

    # check already cached CorpNum's SessionToken
    if @token_table.key?(corpNum.to_sym)
      targetToken = @token_table[corpNum.to_sym]
    end

    if targetToken.nil?
      refresh = true
    else
      # Token's expireTime must use parse() because time format is hh:mm:ss.SSSZ
      expireTime = DateTime.parse(targetToken['expiration'])
      serverUTCTime = DateTime.strptime(@linkhub.getTime(@useStaticIP, @useGAIP))
      refresh = expireTime < serverUTCTime
    end

    if refresh
      begin
        # getSessionToken from Linkhub
        targetToken = @linkhub.getSessionToken(
            @isTest ? ServiceID_TEST : ServiceID_REAL, corpNum, @scopes, @ipRestrictOnOff ? "" : "*", @useStaticIP, @useGAIP)

      rescue LinkhubException => le
        raise PopbillException.new(le.code, le.message)
      end
      # append token to cache hash
      @token_table[corpNum.to_sym] = targetToken
    end

    targetToken['session_token']
  end

  # end of getSession_Token

  def gzip_parse (target)
    sio = StringIO.new(target)
    gz = Zlib::GzipReader.new(sio)
    gz.read()
  end

  # Popbill API http Get Request Func
  def httpget(url, corpNum, userID = '')
    headers = {
        "x-pb-version" => BaseService::POPBILL_APIVersion,
        "Accept-Encoding" => "gzip,deflate",
    }

    if corpNum.to_s != ''
      headers["Authorization"] = "Bearer " + getSession_Token(corpNum)
    end

    if userID.to_s != ''
      headers["x-pb-userid"] = userID
    end

    uri = URI(getServiceURL() + url)

    request = Net::HTTP.new(uri.host, 443)
    request.use_ssl = true

    Net::HTTP::Get.new(uri)

    res = request.get(uri.request_uri, headers)

    if res.code == "200"
      if res.header['Content-Encoding'].eql?('gzip')
        JSON.parse(gzip_parse(res.body))
      else
        JSON.parse(res.body)
      end
    else
      raise PopbillException.new(JSON.parse(res.body)["code"],
                                 JSON.parse(res.body)["message"])
    end
  end

  #end of httpget

  # Request HTTP Post
  def httppost(url, corpNum, postData, action = '', userID = '', contentsType = '')

    headers = {
        "x-pb-version" => BaseService::POPBILL_APIVersion,
        "Accept-Encoding" => "gzip,deflate",
    }

    if contentsType == ''
      headers["Content-Type"] = "application/json; charset=utf8"
    else
      headers["Content-Type"] = contentsType
    end

    if corpNum.to_s != ''
      headers["Authorization"] = "Bearer " + getSession_Token(corpNum)
    end

    if userID.to_s != ''
      headers["x-pb-userid"] = userID
    end

    if action.to_s != ''
      headers["X-HTTP-Method-Override"] = action
    end

    uri = URI(getServiceURL() + url)

    https = Net::HTTP.new(uri.host, 443)
    https.use_ssl = true
    Net::HTTP::Post.new(uri)

    res = https.post(uri.request_uri, postData, headers)

    if res.code == "200"
      if res.header['Content-Encoding'].eql?('gzip')
        JSON.parse(gzip_parse(res.body))
      else
        JSON.parse(res.body)
      end
    else
      raise PopbillException.new(JSON.parse(res.body)["code"],
                                 JSON.parse(res.body)["message"])
    end
  end

  #end of httppost

  def httppostbulk(url, corpNum, postData, submitID, action = '', userID = '')
    headers = {
        "x-pb-version" => BaseService::POPBILL_APIVersion,
        "Accept-Encoding" => "gzip,deflate",
    }

    headers["Content-Type"] = "application/json; charset=utf8"
    headers["x-pb-message-digest"] = Base64.strict_encode64(Digest::SHA1.digest(postData))
    headers["x-pb-submit-id"] = submitID

    if corpNum.to_s != ''
      headers["Authorization"] = "Bearer " + getSession_Token(corpNum)
    end

    if userID.to_s != ''
      headers["x-pb-userid"] = userID
    end

    if action.to_s != ''
      headers["X-HTTP-Method-Override"] = action
    end

    uri = URI(getServiceURL() + url)

    https = Net::HTTP.new(uri.host, 443)
    https.use_ssl = true
    Net::HTTP::Post.new(uri)

    res = https.post(uri.request_uri, postData, headers)

    if res.code == "200"
      if res.header['Content-Encoding'].eql?('gzip')
        JSON.parse(gzip_parse(res.body))
      else
        JSON.parse(res.body)
      end
    else
      raise PopbillException.new(JSON.parse(res.body)["code"],
                                 JSON.parse(res.body)["message"])
    end
  end

  # Request HTTP Post File
  def httppostfile(url, corpNum, form, files, userID)
    headers = {
        "x-pb-version" => BaseService::POPBILL_APIVersion,
        "Content-Type" => "multipart/form-data;boundary=" + BaseService::BOUNDARY,
        "Accept-Encoding" => "gzip,deflate",
        "Connection" => "Keep-Alive"
    }

    if corpNum.to_s != ''
      headers["Authorization"] = "Bearer " + getSession_Token(corpNum)
    end

    if userID.to_s != ''
      headers["x-pb-userid"] = userID
    end

    post_body = []

    if form.to_s != ''
      post_body << "--#{BaseService::BOUNDARY}\r\n"
      post_body << "Content-Disposition: form-data; name=\"form\"\r\n"
      post_body << "Content-Type: Application/json;\r\n\r\n"
      post_body << form.to_json + "\r\n"
    end

    files.each do |filePath|
      begin
        fileName = File.basename(filePath)
        post_body << "--#{BaseService::BOUNDARY}\r\n"
        post_body << "Content-Disposition: form-data; name=\"file\"; filename=\"#{fileName}\"\r\n"
        post_body << "Content-Type: Application/octet-stream\r\n\r\n"
        post_body << File.read(filePath)
      rescue
        raise PopbillException.new(-99999999, "Failed to reading filedata from filepath")
      end
    end

    post_body << "\r\n\r\n--#{BaseService::BOUNDARY}--\r\n"

    # Add the file Data

    uri = URI(getServiceURL() + url)

    https = Net::HTTP.new(uri.host, 443)
    https.use_ssl = true
    Net::HTTP::Post.new(uri)

    res = https.post(uri.request_uri, post_body.join.encode("UTF-8"), headers)

    if res.code == "200"
      if res.header['Content-Encoding'].eql?('gzip')
        JSON.parse(gzip_parse(res.body))
      else
        JSON.parse(res.body)
      end
    else
      raise PopbillException.new(JSON.parse(res.body)["code"],
                                 JSON.parse(res.body)["message"])
    end

  end

  def httppostfiles(url, corpNum, form, files, userID)
    headers = {
        "x-pb-version" => BaseService::POPBILL_APIVersion,
        "Content-Type" => "multipart/form-data;boundary=" + BaseService::BOUNDARY,
        "Accept-Encoding" => "gzip,deflate",
        "Connection" => "Keep-Alive"
    }

    if corpNum.to_s != ''
      headers["Authorization"] = "Bearer " + getSession_Token(corpNum)
    end

    if userID.to_s != ''
      headers["x-pb-userid"] = userID
    end

    post_body = []

    if form.to_s != ''
      post_body << "--#{BaseService::BOUNDARY}\r\n"
      post_body << "Content-Disposition: form-data; name=\"form\"\r\n"
      post_body << "Content-Type: Application/json; charset=euc-kr\r\n\r\n"
      post_body << form.to_json
    end

    files.each do |filePath|
      begin
        fileName = File.basename(filePath)
        post_body << "--#{BaseService::BOUNDARY}\r\n"
        post_body << "Content-Disposition: form-data; name=\"Filedata\"; filename=\"#{fileName}\"\r\n"
        post_body << "Content-Type: Application/octet-stream\r\n\r\n"
        post_body << File.read(filePath)
      rescue
        raise PopbillException.new(-99999999, "Failed to reading filedata from filepath")
      end
    end

    post_body << "\r\n\r\n--#{BaseService::BOUNDARY}--\r\n"
    # Add the file Data

    uri = URI(getServiceURL() + url)

    https = Net::HTTP.new(uri.host, 443)
    https.use_ssl = true
    Net::HTTP::Post.new(uri)

    res = https.post(uri.request_uri, post_body.join.encode("UTF-8"), headers)

    if res.code == "200"
      if res.header['Content-Encoding'].eql?('gzip')
        JSON.parse(gzip_parse(res.body))
      else
        JSON.parse(res.body)
      end
    else
      raise PopbillException.new(JSON.parse(res.body)["code"],
                                 JSON.parse(res.body)["message"])
    end

  end

  # Get Popbill Member's Remain Point
  def getBalance(corpNum)
    if corpNum.length != 10
      raise PopbillException.new('-99999999', '사업자등록번호가 올바르지 않습니다.')
    end

    begin
      @linkhub.getBalance(getSession_Token(corpNum), getServiceID(), @useStaticIP, @useGAIP)
    rescue LinkhubException => le
      raise PopbillException.new(le.code, le.message)
    end
  end

  # Get Linkhub Partner's Remain Point
  def getPartnerBalance(corpNum)
    if corpNum.length != 10
      raise PopbillException.new('-99999999', '사업자등록번호가 올바르지 않습니다.')
    end

    begin
      @linkhub.getPartnerBalance(getSession_Token(corpNum), getServiceID(), @useStaticIP, @useGAIP)
    rescue LinkhubException => le
      raise PopbillException.new(le.code, le.message)
    end
  end

  # 파트너 포인트 충전 URL - 2017/08/29 추가
  def getPartnerURL(corpNum, togo)
    if corpNum.length != 10
      raise PopbillException.new('-99999999', '사업자등록번호가 올바르지 않습니다.')
    end

    begin
      @linkhub.getPartnerURL(getSession_Token(corpNum), getServiceID(), togo, @useStaticIP, @useGAIP)
    rescue LinkhubException => le
      raise PopbillException.new(le.code, le.message)
    end
  end

  # Join Popbill Member
  def joinMember(joinInfo)
    httppost("/Join", "", joinInfo.to_json, "", "")
  end

  # check Popbill Member ID
  def checkID(idValue)
    http_response = httpget("/IDCheck?ID=" + idValue, "", "")
  end

  # Get Pobill SSO URL
  def getPopbillURL(corpNum, togo, userID = "")
    if corpNum.length != 10
      raise PopbillException.new('-99999999', '사업자등록번호가 올바르지 않습니다.')
    end

    response = httpget("/?TG=" + togo, corpNum, userID)
    response['url']
  end

  # 연동회원 포인트 결제내역 팝업 URL
  def getPaymentURL(corpNum, userID = "")
    if corpNum.length != 10
      raise PopbillException.new('-99999999', '사업자등록번호가 올바르지 않습니다.')
    end
    response = httpget("/?TG=PAYMENT", corpNum, userID)
    response['url']
  end

  # 연동회원 포인트 사용내역 팝업 URL
  def getUseHistoryURL(corpNum, userID = "")
    if corpNum.length != 10
      raise PopbillException.new('-99999999', '사업자등록번호가 올바르지 않습니다.')
    end
    response = httpget("/?TG=USEHISTORY", corpNum, userID)
    response['url']
  end

  # 팝빌 로그인 URL
  def getAccessURL(corpNum, userID)
    if corpNum.length != 10
      raise PopbillException.new('-99999999', '사업자등록번호가 올바르지 않습니다.')
    end

    response = httpget("/?TG=LOGIN", corpNum, userID)
    response['url']
  end

  # 팝빌 연동회원 포인트 충전 URL
  def getChargeURL(corpNum, userID)
    if corpNum.length != 10
      raise PopbillException.new('-99999999', '사업자등록번호가 올바르지 않습니다.')
    end

    response = httpget("/?TG=CHRG", corpNum, userID)
    response['url']
  end

  # Check is Partner's Popbill Member
  def checkIsMember(corpNum, linkID)
    if corpNum.length != 10
      raise PopbillException.new('-99999999', '사업자등록번호가 올바르지 않습니다.')
    end
    http_response = httpget("/Join?CorpNum=" + corpNum + "&LID=" + linkID, "", "")
  end

  def getContactInfo(corpNum, contactID, userID  = "")
    if corpNum.length != 10
      raise PopbillException.new('-99999999', '사업자등록번호가 올바르지 않습니다.')
    end
    postData = {}
    postData["id"] = contactID

    httppost("/Contact", corpNum, postData.to_json, "", userID)
  end

  # Get list Corp Contact
  def listContact(corpNum, userID = "")
    if corpNum.length != 10
      raise PopbillException.new('-99999999', '사업자등록번호가 올바르지 않습니다.')
    end
    httpget("/IDs", corpNum, userID)
  end

  # Update Contact Info
  def updateContact(corpNum, contactInfo, userID = "")
    if corpNum.length != 10
      raise PopbillException.new('-99999999', '사업자등록번호가 올바르지 않습니다.')
    end

    httppost("/IDs", corpNum, contactInfo.to_json, "", userID)
  end

  # Regist Contact
  def registContact(corpNum, contactInfo, userID = "")
    if corpNum.length != 10
      raise PopbillException.new('-99999999', '사업자등록번호가 올바르지 않습니다.')
    end
    httppost("/IDs/New", corpNum, contactInfo.to_json, "", userID)
  end

  # Get Corp Info
  def getCorpInfo(corpNum, userID = "")
    if corpNum.length != 10
      raise PopbillException.new('-99999999', '사업자등록번호가 올바르지 않습니다.')
    end
    httpget("/CorpInfo", corpNum, userID)
  end

  # Update Corp Info
  def updateCorpInfo(corpNum, corpInfo, userID = "")
    if corpNum.length != 10
      raise PopbillException.new('-99999999', '사업자등록번호가 올바르지 않습니다.')
    end
    httppost("/CorpInfo", corpNum, corpInfo.to_json, "", userID)
  end
end # end of BaseService class

# Popbill API Exception Handler class
class PopbillException < StandardError
  attr_reader :code, :message

  def initialize(code, message)
    @code = code
    @message = message
  end
end

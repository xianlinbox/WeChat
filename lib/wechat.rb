# encoding: utf-8
require 'digest/sha1'
require 'logger'
require File.dirname(__FILE__)+'/wechat_request'

class WeChat
  include WeChatHelper
  attr_reader :url

  def initialize(url, token)
    @url = url
    @token = token
    @logger = Logger.new(STDOUT);
  end


  def validate(params)
    if generate_signature(@token, params[:timestamp], params[:nonce]) == params[:signature]
      return params[:echoStr]
    end
    logger.error("Validate failed, Please check your configuration!")
  end

  def receive(request)
    WeChatRequest.new(request);
  end

  def response(weChat_response)
    weChat_response.to_xml
  end
end

module WeChatHelper
  def generate_signature(token, timestamp, nonce)
    key = [token.to_s, timestamp.to_s, nonce.to_s].sort!.join
    Digest::SHA1.hexdigest(key)
  end
end
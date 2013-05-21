# encoding: utf-8
require File.dirname(__FILE__)+ '/../lib/wechat_request'
require File.dirname(__FILE__)+ '/raw_message_builder'

include RawMessageBuilder

def assertCommonFields(request)
  request.to_user.should eql "toUser"
  request.from_user.should eql "fromUser"
  request.create_time.should eql "1348831860"
  request.message_id.should eql "1234567890123456"
end

describe 'wechat_request initialization' do
  it 'should initialize Text type Message normally' do
    txt_message = <<-EOF
      <MsgType><![CDATA[text]]></MsgType>
      <Content><![CDATA[this is a test]]></Content>
    EOF
    request = WeChatRequest.new(raw_message_builder { txt_message })
    assertCommonFields(request)
    request.message_type.should eql "text"
    request.content.should eql "this is a test"
  end

  it 'should initialize image type Message normally' do
    image_message = <<-EOF
      <MsgType><![CDATA[image]]></MsgType>
      <PicUrl><![CDATA[this is a url]]></PicUrl>
    EOF
    request = WeChatRequest.new(raw_message_builder { image_message })
    assertCommonFields(request)
    request.message_type.should eql "image"
    request.pic_url.should eql "this is a url"
  end

  it 'should initialize location type Message normally' do
    location_message = <<-EOF
      <MsgType><![CDATA[location]]></MsgType>
      <Location_X>23.134521</Location_X>
      <Location_Y>113.358803</Location_Y>
      <Scale>20</Scale>
      <Label><![CDATA[位置信息]]></Label>
    EOF
    request = WeChatRequest.new(raw_message_builder { location_message })
    assertCommonFields(request)
    request.message_type.should eql "location"
    request.location_x.should eql "23.134521"
    request.location_y.should eql "113.358803"
    request.scale.should eql "20"
    request.label.should eql "位置信息"
  end

  it 'should initialize link type Message normally' do
    link_message = <<-EOF
      <MsgType><![CDATA[link]]></MsgType>
      <Title><![CDATA[公众平台官网链接]]></Title>
      <Description><![CDATA[公众平台官网链接]]></Description>
      <Url><![CDATA[url]]></Url>
    EOF
    request = WeChatRequest.new(raw_message_builder { link_message })
    assertCommonFields(request)
    request.message_type.should eql "link"
    request.title.should eql "公众平台官网链接"
    request.description.should eql "公众平台官网链接"
    request.url.should eql "url"
  end

  it 'should initialize event type Message normally' do
    event_message = <<-EOF
      <MsgType><![CDATA[event]]></MsgType>
      <Event><![CDATA[EVENT]]></Event>
      <EventKey><![CDATA[EVENTKEY]]></EventKey>
    EOF
    request = WeChatRequest.new(raw_message_builder { event_message })
    assertCommonFields(request)
    request.message_type.should eql "event"
    request.event.should eql "EVENT"
    request.event_key.should eql 'EVENTKEY'
  end

  it 'should throw TypeError when the message type is unexpected' do
    error_type_message = <<-EOF
      <MsgType><![CDATA[unknown]]></MsgType>
    EOF
    expect {
      request = WeChatRequest.new(raw_message_builder { error_type_message })
    }.to raise_error(TypeError)
  end

  it 'should can distinguish the event type' do
    event_message = <<-EOF
      <MsgType><![CDATA[event]]></MsgType>
      <Event><![CDATA[subscribe]]></Event>
      <EventKey><![CDATA[EVENTKEY]]></EventKey>
    EOF
    request = WeChatRequest.new(raw_message_builder { event_message })
    assertCommonFields(request)
    request.is_subscribe_event?.should be_true
    request.is_unsubscribe_event?.should be_false
  end
end
module RawMessageBuilder

  def raw_message_builder
    message_prefix = <<-EOF
      <xml>
       <ToUserName><![CDATA[toUser]]></ToUserName>
       <FromUserName><![CDATA[fromUser]]></FromUserName>
       <CreateTime>1348831860</CreateTime>
    EOF

    message_suffix = <<-EOF
      <MsgId>1234567890123456</MsgId>
      </xml>
    EOF
    message_prefix + yield + message_suffix
  end
end

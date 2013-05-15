class WeChatResponse
  attr_accessor :to_user,
                :from_user,
                :create_time,
                :message_type,
                :content,
                :music,
                :articles,
                :func_flag

  def to_xml
    xml = "<xml>"
    xml += "<ToUserName><![CDATA[#{@to_user}]]></ToUserName>" if @to_user
    xml += "<FromUserName><![CDATA[#{@from_user}]]></FromUserName>" if @from_user
    xml += "<CreateTime>#{@create_time}</CreateTime>" if @create_time
    xml += "<MsgType><![CDATA[#{@message_type}]]></MsgType>" if @message_type
    xml += text_message if is_type_of?("text")
    xml += music_message if is_type_of?("music")
    xml += news_message if is_type_of?("news")
    xml += "<FuncFlag>#{@func_flag}</FuncFlag>" if @func_flag
    xml += "</xml>"
  end

  define_method :is_type_of? do |args|
    raise RuntimeError, "#{__LINE__} #{@message_type} is unexpected message type" if @message_type.nil?
    @message_type == args
  end

  def text_message
    raise RuntimeError, "#{__LINE__} #{@content} not defined" if @content.nil?
    "<Content><![CDATA[#{@content}]]></Content>"
  end

  def music_message
    raise RuntimeError, "#{__LINE__} #{@music} not defined" if @music.nil?
    xml = "<Music>"
    xml += "<Title><![CDATA[#{@music[:title]}]]></Title>"
    xml += "<Description><![CDATA[#{@music[:description]}]]></Description>"
    xml += "<MusicUrl><![CDATA[#{@music[:url]}]]></MusicUrl>"
    xml += "<HQMusicUrl><![CDATA[#{@music[:hq_url]}]]></HQMusicUrl>"
    xml += "</Music>"
  end

  def news_message
    raise RuntimeError, "#{__LINE__} #{@news} not defined" if @articles.nil?
    xml = "<ArticleCount>#{@articles.length}</ArticleCount>"
    xml += "<Articles>"
    @articles.each do |article|
      xml += "<item>"
      xml += "<Title><![CDATA[#{article[:title]}]]></Title>"
      xml += "<Description><![CDATA[#{article[:description]}]]></Description>"
      xml += "<PicUrl><![CDATA[#{article[:pic_url]}]]></PicUrl>"
      xml += "<Url><![CDATA[#{article[:url]}]]></Url>"
      xml += "</item>"
    end
    xml += "</Articles>"
  end

end
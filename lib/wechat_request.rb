class WeChatRequest
  attr_reader :to_user,
              :from_user,
              :create_time,
              :message_type,
              :content,
              :pic_url,
              :location_x, :location_y, :scale, :label,
              :title, :description, :url,
              :event, :event_key,
              :message_id

  def initialize(raw_message)
    if raw_message.instance_of?(StringIO)
      @raw_message = raw_message.string
    else
      @raw_message = raw_message.to_str
    end
    @to_user = element_string_content("ToUserName")
    @from_user = element_string_content('FromUserName')
    @create_time = element_number_content('CreateTime')
    @message_type = element_string_content('MsgType')
    if is_type_of?("text")
      @content = element_string_content('Content')
    elsif is_type_of?('image')
      @pic_url = element_string_content('PicUrl')
    elsif is_type_of?('location')
      @location_x = element_content('Location_X')
      @location_y = element_content('Location_Y')
      @scale = element_number_content('Scale')
      @label = element_string_content('Label')
    elsif is_type_of?('link')
      @title = element_string_content('Title')
      @description = element_string_content('Description')
      @url = element_string_content('Url')
    elsif is_type_of?('event')
      @event = element_string_content('Event')
      @event_key = element_string_content('EventKey')
    else
      raise TypeError
    end
    @message_id = element_number_content('MsgId')
  end

  define_method :is_type_of? do |args|
    @message_type == args
  end

  define_method :element_string_content do |args|
    @raw_message.scan(/<#{args}><!\[CDATA\[(.*)\]\]><\/#{args}>/).flatten.join
  end

  define_method :element_number_content do |args|
    @raw_message.scan(/<#{args}>(\d+)<\/#{args}>/).flatten.join
  end

  define_method :element_content do |args|
    @raw_message.scan(/<#{args}>(.*)<\/#{args}>/).flatten.join
  end

  def method_missing(name, *args)
    event_type = name.to_s.scan(/is_(.*)_event?/).flatten.join
    if event_type != nil
      return is_type_of?('event') && @event == event_type
    end
    super.method_missing(name, *args)
  end
end
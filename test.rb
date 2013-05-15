class MyClass
  message = <<-EOF
     <PicUrl><![CDATA[this is a url]]></PicUrl>
  EOF

  define_method :element_string_content do |args|
    puts message
    message.scan(/<#{args}><!\[CDATA\[(.*)\]\]><\/#{args}>/).flatten.join
  end

end

puts MyClass.new.element_string_content 'PicUrl'

# encoding: utf-8
require File.dirname(__FILE__)+ '/../lib/wechat_response'

def assertCommonFields(request)
  request.to_user.should eql "toUser"
  request.from_user.should eql "fromUser"
  request.create_time.should eql "1348831860"
  request.message_id.should eql "1234567890123456"
end

describe 'wechat_response initialization' do
  it 'should create text response based on information given' do
    response = WeChatResponse.new
    response.to_user='xianlinbox'
    response.from_user='IT_wiki'
    response.create_time=12345678
    response.message_type='text'
    response.content='welcome'
    response.func_flag=0

    expect = "<xml><ToUserName><![CDATA[xianlinbox]]></ToUserName><FromUserName><![CDATA[IT_wiki]]></FromUserName><CreateTime>12345678</CreateTime><MsgType><![CDATA[text]]></MsgType><Content><![CDATA[welcome]]></Content><FuncFlag>0</FuncFlag></xml>"
    response.to_xml.should eql expect
  end

  it 'should create music response based on information given' do
    response = WeChatResponse.new
    response.to_user='xianlinbox'
    response.from_user='IT_wiki'
    response.create_time=12345678
    response.message_type='music'
    response.music={
        title: 'TITLE',
        description: 'DESCRIPTION',
        url: 'MUSIC_Url',
        hq_url: 'HQ_MUSIC_Url'
    }
    response.func_flag=0

    expect = "<xml>"
    expect +="<ToUserName><![CDATA[xianlinbox]]></ToUserName>"
    expect +="<FromUserName><![CDATA[IT_wiki]]></FromUserName>"
    expect +="<CreateTime>12345678</CreateTime>"
    expect +="<MsgType><![CDATA[music]]></MsgType>"
    expect +="<Music>"
    expect +="<Title><![CDATA[TITLE]]></Title>"
    expect +="<Description><![CDATA[DESCRIPTION]]></Description>"
    expect +="<MusicUrl><![CDATA[MUSIC_Url]]></MusicUrl>"
    expect +="<HQMusicUrl><![CDATA[HQ_MUSIC_Url]]></HQMusicUrl>"
    expect +="</Music>"
    expect +="<FuncFlag>0</FuncFlag>"
    expect +="</xml>"

    response.to_xml.should eql expect
  end

  it 'should create news response based on information given' do
    response = WeChatResponse.new
    response.to_user='xianlinbox'
    response.from_user='IT_wiki'
    response.create_time=12345678
    response.message_type='news'
    response.articles=[
        {
            title: 'title1',
            description: 'description1',
            pic_url: 'picurl',
            url: 'url'
        }, {
            title: 'title',
            description: 'description',
            pic_url: 'picurl',
            url: 'url'
        }
    ]
    response.func_flag=0

    expect = "<xml>"
    expect +="<ToUserName><![CDATA[xianlinbox]]></ToUserName>"
    expect +="<FromUserName><![CDATA[IT_wiki]]></FromUserName>"
    expect +="<CreateTime>12345678</CreateTime>"
    expect +="<MsgType><![CDATA[news]]></MsgType>"
    expect +="<ArticleCount>2</ArticleCount>"
    expect +="<Articles>"
    expect +="<item>"
    expect +="<Title><![CDATA[title1]]></Title>"
    expect +="<Description><![CDATA[description1]]></Description>"
    expect +="<PicUrl><![CDATA[picurl]]></PicUrl>"
    expect +="<Url><![CDATA[url]]></Url>"
    expect +="</item>"
    expect +="<item>"
    expect +="<Title><![CDATA[title]]></Title>"
    expect +="<Description><![CDATA[description]]></Description>"
    expect +="<PicUrl><![CDATA[picurl]]></PicUrl>"
    expect +="<Url><![CDATA[url]]></Url>"
    expect +="</item>"
    expect +="</Articles>"
    expect +="<FuncFlag>0</FuncFlag>"
    expect +="</xml>"

    response.to_xml.should eql expect
  end
end
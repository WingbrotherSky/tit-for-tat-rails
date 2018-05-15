class Api::V1::LoginController < Api::V1::BaseController
  URL = "https://api.weixin.qq.com/sns/jscode2session".freeze

  def login
    @user = User.find_or_create_by(openid: wechat_user.fetch('openid'))
    render json: {
      userId: @user.id
    }
  end

  private

  def wechat_params
    {
      appid: ENV['appId'],
      secret: ENV['appSecret'],
      js_code: params[:code],
      grant_type: 'authorization_code'
    }
  end

  def wechat_user
    p 'calling tencent'
    @wechat_response ||= RestClient.post(URL, wechat_params)
    @wechat_user ||= JSON.parse(@wechat_response.body)
  end
end
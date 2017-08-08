class ShopifyApi

  def self.get_client(shop_url, api_creds)
    self.new(shop_url, api_creds)
  end

  def initialize(shop_url, api_creds)
    set_api_url(shop_url, api_creds)
  end

  def get_data(data)
    url = @api_url + "/#{data}.json"
    res = RestClient.get url
    JSON(res.body)[data]
  end

  private
  def set_api_url(shop_url, api_creds)
    api_url = URI(shop_url)
    api_url.userinfo = "#{api_creds[:api_key]}:#{api_creds[:password]}"
    api_url.path = '/admin'
    @api_url = api_url.to_s
  end
end
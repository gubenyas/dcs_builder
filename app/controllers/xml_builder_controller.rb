class XmlBuilderController < ApplicationController
  def index
  end

  def build
    # todo: move this to some config yml file
    shop_url = 'https://finger-in-the-heaven.myshopify.com'

    api_credentials = ShopifyCredScraper.get_api_credentials(shop_url)
    @xml = XmlBuilder.build_xml(shop_url, api_credentials).to_xml
    byebug
  end
end

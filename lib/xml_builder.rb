class XmlBuilder
  def self.build_xml(shop_url, api_credentials)
    new.build_xml(shop_url, api_credentials)
  end

  def build_xml(shop_url, api_credentials)
    @api_client = ShopifyApi.get_client(shop_url, api_credentials)

    generate_feed
  end

  def generate_feed
    products = @api_client.get_data('products')
    builder = Nokogiri::XML::Builder.new do |xml|
      xml.items {
        products.each do |p|
          xml.item {
            add_product_description(p, xml)
            add_product_categorisation(p, xml)
            add_product_attributes(p, xml)
          }
        end
      }
    end
  end

  def add_product_description(product, xml)
    xml.sku         product['id']
    xml.product     product['title']
    xml.description product['body_html']
    xml.image_url   image_url(product)
    xml.url         "/products/#{product['handle']}"
    xml.price       product_price(product)
  end

  def image_url(product)
    product['images'].first&.fetch('src')
  end

  def product_price(product)
    # first variant price is taken -- that could be wrong but idk how it should work in real world
    product['variants'].first['price']
  end

  def add_product_categorisation(product, xml)
    @products_collections ||= get_products_collections
    collection = find_product_collection(@products_collections, product)
    xml.first_category("url_value" => collection['handle']) {
      xml.text collection['title']
    }
  end

  def get_products_collections
    collects = @api_client.get_data('collects')
    collections = {}
    collects.each do |c|
      coll_id = c['collection_id']
      # there's no need to get collection few times
      collection = get_collection(coll_id) unless collections[coll_id]
      collection['products'] << c['product_id']
      collections[coll_id] = collection
    end
    collections.values
  end

  def get_collection(coll_id)
    @collections ||= @api_client.get_data('custom_collections')
    collection = @collections.select { |c| c['id'] == coll_id }.first
    collection['products'] = []
    collection
  end

  def find_product_collection(collections, product)
    collections.select { |coll| coll['products'].include? product['id'] }.first
  end

  def add_product_attributes(product, xml)
    # what url_value should be used here?
    xml.brand           product['vendor']
    # what url_value should be used here?
    # hm.. don't see condition in API doc; set to 'New' as field is required
    xml.condition       "New"
    xml.stock_available product_availability(product)
  end

  def product_availability(product)
    # first variant availability is checked -- that could be wrong but idk how it should work in real world
    quantity = product['variants'].first['inventory_quantity'].to_i
    quantity.positive?
  end
end

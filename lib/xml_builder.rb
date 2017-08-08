require 'capybara/rails'

class XmlBuilder
  include Capybara::DSL

  def self.build_xml
    new.build_xml
  end

  def build_xml
    api_creds = get_api_credentials
    # TODO: get all products. It's possible that some additional requests for catalogs will be needed as well
    # TODO: build xml
  end

  def get_api_credentials
      # TODO: it makes sense to move this logic to some other class due to its specific nature
      # TODO: try to use headless browser here
      Capybara.current_driver = :selenium

      visit 'https://www.shopify.com/login'

      # TODO: use env. vars here
      fill_in('Email', with: '***')
      fill_in('Password', with: '***')
      click_button('Log in')

      # TODO: that works only for me, try to use redirect url after login
      visit 'https://finger-in-the-heaven.myshopify.com/admin/apps/private'
      
      table_row = page.all("#apps-private tr").last
      api_key = table_row.all('td')[1].text
      password = table_row.all('td')[2].text

      {api_key: api_key, password: password}
  end
end

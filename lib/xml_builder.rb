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

      Capybara.current_driver = :selenium

      visit 'https://www.shopify.com/login'

      fill_in('Email', with: '***')
      fill_in('Password', with: '***')
      click_button('Log in')

      visit 'https://finger-in-the-heaven.myshopify.com/admin/apps/private'
      
      table_row = page.all("#apps-private tr").last
      api_key = table_row.all('td')[1].text
      password = table_row.all('td')[2].text

      {api_key: api_key, password: password}
  end
end

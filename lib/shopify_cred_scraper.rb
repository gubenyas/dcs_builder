require 'capybara/rails'

# getting api credentials using capybara: I have a doubts if it should be done in that way but that wasn't specified in the requirements
class ShopifyCredScraper
  extend Capybara::DSL
  def self.get_api_credentials(shop_url)
      # TODO: try to use headless browser here
      Capybara.current_driver = :selenium
      visit('https://www.shopify.com/login')

      # TODO: use env. vars here or move it to some yml
      fill_in('Email', with: 'redacted_string')
      fill_in('Password', with: 'redacted_string')
      click_button('Log in')

      visit "#{shop_url}/admin/apps/private"

      table_row = page.all("#apps-private tr").last
      api_key = table_row.all('td')[1].text
      password = table_row.all('td')[2].text

      {api_key: api_key, password: password}
  end
end

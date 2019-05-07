# require 'capybara/poltergeist'
require_relative 'scraper/get_cases'
require 'capybara'

class Scraper
  def initialize(username, password, debug: false)
    @username = username
    @password = password
    @debug = debug
    @data = []
    initialize_walker
  end

  def login
    puts 'Logging in...'
    @walker.visit login_path
    wait_until{ @walker.has_css?('#username') }
    @walker.fill_in 'username', with: @username
    @walker.fill_in 'password', with: @password
    @walker.click_button 'Login'
    wait_until{ @walker.has_css?('.demo-navigation') }
    puts 'Login successful.'
  end

  private

  def wait_until
    while yield == false
      sleep 0.3
    end
  end

  def login_path
    "#{ENV.fetch('ORTRAX_WEB_URL')}/login"
  end

  def initialize_walker
    initialize_capybara
    @walker = Capybara::Session.new(:selenium_headless)
  end

  def initialize_capybara
    Capybara.register_driver :selenium do |app|
      chrome_options = Selenium::WebDriver::Chrome::Options.new.tap do |o|
        o.add_argument '--headless'
        o.add_argument '--no-sandbox'
      end
      Capybara::Selenium::Driver.new(app, browser: :chrome, options: chrome_options)
    end

    Capybara.default_driver = :selenium
  end
end

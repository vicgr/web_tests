def set_driver
  C_Support.driver= true
  if ENV['chrome'] or ENV['gc']
    chromedriver_path = File.join(File.absolute_path('../../..', File.dirname(__FILE__)),"chromedriver.exe")
    Selenium::WebDriver::Chrome.driver_path = chromedriver_path
    Capybara.default_driver = :chrome
    Capybara.register_driver :chrome do |app|
      options = {
        :js_errors => false,
        :timeout => 360,
        :debug => false,
        :inspector => false,
        }
        Capybara::Selenium::Driver.new(app, :browser => :chrome)
      end

    elsif ENV['ie']
      ie_path = File.join(File.absolute_path('../../..', File.dirname(__FILE__)),"IEDriverServer.exe")
      Selenium::WebDriver::IE.driver_path = ie_path
      Capybara.default_driver = :ie
      Capybara.register_driver :ie do |app|
        options = {
          :js_errors => false,
          :timeout => 360,
          :debug => false,
          :inspector => false,
          }
          Capybara::Selenium::Driver.new(app, :browser => :ie)
        end
    elsif ENV['firefox'] or ENV['ff']
      Capybara.default_driver = :selenium

    "elsif ENV['safari']
      Capybara.default_driver = :safari
      Capybara.register_driver :safari do |app|
        options = {
          :js_errors => false,
          :timeout => 360,
          :debug => false,
          :inspector => false,
        }
        Capybara::Selenium::Driver.new(app, :browser => :safari)
      end
    elsif ENV['opera']
      Capybara.default_driver = :opera
      Capybara.register_driver :opera do |app|
        options = {
          :js_errors => false,
          :timeout => 360,
          :debug => false,
          :inspector => false,
        }
        Capybara::Selenium::Driver.new(app, :browser => :opera)
      end"
    elsif
      Capybara.default_driver= :poltergeist
      C_Support.driver = false
    end
  end
